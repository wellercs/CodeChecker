/**
* I provide functions for checking code quality.
*/
component accessors="true"{

	// properties
	property name="categories" 	type="string";
	property name="results" 	type="array";
	property name="rules" 		type="array";

	/**
	* I initialize the component.
	* @rulesService I am the Rules service object.
	* @utilService I am the Utility service object.
	* @wirebox Instance of WireBox
	* @categories I am a comma separated list of categories, _ALL for all categories.
	*/
	CodeCheckerService function init( 
		required any rulesService inject="RulesService", 
		required any utilService inject="UtilService",
		required any wireBox inject="wirebox",
		string categories = "" 
	){
		// init properties
		variables.results 		= [];
		// Init DI
		variables.rulesService 	= arguments.rulesService;
		variables.wirebox 		= arguments.wirebox;
		variables.utilService 	= arguments.utilService;
		variables.categories 	= arguments.categories;
		variables.rules 		= arguments.rulesService.getRules();

		return this;
	}

	/**
	* I return whether the code check passed or failed.
	* @line I am the line of code for which to check.
	* @passonmatch I determine whether to pass or fail if the pattern is matched.
	* @pattern I am the pattern of code for which to check.
	*/
	public boolean function checkCode( required string line, required boolean passonmatch, required string pattern ) {
		if ( ( REFindNoCase( arguments.pattern, arguments.line ) AND NOT arguments.passonmatch ) OR ( NOT REFindNoCase( arguments.pattern, arguments.line ) AND arguments.passonmatch ) ) {
			return false;
		}
		return true;
	}

	/**
	* I start the code review.
	* @filepath I am the directory or file path for which to review.
	* @recurse I determine whether or not to review recursively.
	*/
	public array function startCodeReview( required string filepath, boolean recurse = true ) {
		if ( DirectoryExists(arguments.filepath) ) {
			// path, recurse, listInfo, filter, sort
			// TODO: DirectoryList() should filter on type=file
			local.qryFiles = DirectoryList(arguments.filepath, arguments.recurse, "query");
			for ( local.row = 1; local.row LTE local.qryFiles.recordcount; local.row++ ) {
				if ( local.qryFiles.type[local.row] IS "File" ) {
					local.filePath = "#local.qryFiles.directory[local.row]#/#local.qryFiles.name[local.row]#";
					readFile(filepath=local.filePath);
					if ( variables.categories IS "_ALL" OR ListFind( variables.categories, 'QueryParamScanner') ) {
						runQueryParamScanner(filepath=local.filePath);
					}
					if ( variables.categories IS "_ALL" OR ListFind( variables.categories, 'VarScoper') ) {
						runVarScoper(filepath=local.filePath)
					}
				}
			}
		}
		else if ( FileExists(arguments.filepath) ) {
			local.filePath = arguments.filepath;
			readFile(filepath=local.filePath);
			if ( variables.categories IS "_ALL" OR ListFind( variables.categories, 'QueryParamScanner') ) {
				runQueryParamScanner(filepath=local.filePath);
			}
			if ( variables.categories IS "_ALL" OR ListFind( variables.categories, 'VarScoper') ) {
				runVarScoper(filepath=local.filePath)
			}
		}
		return variables.results;
	}

	/**
	* I read the file and run the rules against the file.
	* @filepath I am the file path for which to review.
	*/
	public void function readFile( required string filepath ) {
		local.dataFile = fileOpen( arguments.filepath, "read" );
		local.lineNumber = 0;
		while ( !fileIsEOF( local.dataFile ) ) {
			local.lineNumber++;
			local.line = fileReadLine( local.dataFile );
			// run rules on each line
			runRules(filepath=arguments.filepath, line=local.line, linenumber=local.lineNumber, categories=variables.categories);
			if ( fileIsEOF( local.dataFile ) ) {
				// run rules on whole file. useful for rules where you are just testing the existence of something.
				runRules(filepath=arguments.filepath);
			}
		}
		fileClose( local.dataFile );		
	}

	/**
	* I run the code review rules for the line of code.
	* @filepath I am the file path for which to review.
	* @line I am the line of code for which to review.
	* @linenumber I am the line number of the code for which to review.
	* @categories I am a comma separated list of categories, _ALL for all categories.
	*/
	public void function runRules( required string filepath, string line, numeric linenumber, string categories = "" ) {
		local.standardizedfilepath = Replace(arguments.filepath, "\", "/", "all");
		local.file = ListLast(local.standardizedfilepath, "/");
		local.directory = Replace(local.standardizedfilepath, local.file, "");
		local.fileextension = ListLast(local.file, ".");
		for ( local.ruleitem in variables.rules ) {
			// backwards compat support for v1
			if ( local.ruleitem.componentname IS "CodeChecker" ) {
				local.ruleitem.componentname = "CodeCheckerService";
			}	
			if ( arguments.categories IS "_ALL" OR ListFind( arguments.categories, local.ruleitem["category"] ) ) {
				if ( NOT ListFindNoCase(local.ruleitem.extensions, local.fileextension, ",") ) {
					continue;
				}
				if ( StructKeyExists(arguments,"line") AND NOT local.ruleitem.bulkcheck AND NOT ListLen(local.ruleitem.tagname,"|") ) {
					local.codeCheckerReturn = variables.utilService._invoke(
																	obj = local.ruleitem.componentname,
																	fn = local.ruleitem.functionname,
																	args = {
																		line = arguments.line,
																		passonmatch = local.ruleitem.passonmatch,
																		pattern = local.ruleitem.pattern
																	}
																);
					if ( NOT local.codeCheckerReturn ) {
						recordResult(directory=local.directory, file=local.file, rule=local.ruleitem.name, message=local.ruleitem.message, linenumber=arguments.linenumber, category=local.ruleitem.category, severity=local.ruleitem.severity);
					}
				}
				else if ( StructKeyExists(arguments,"line") AND NOT local.ruleitem.bulkcheck AND ListLen(local.ruleitem.tagname,"|") ) {
					if ( REFindNoCase("<#Replace(local.ruleitem.tagname,'|','|<')#", arguments.line) ) {
						local.codeCheckerReturn = variables.utilService._invoke(
																		obj = local.ruleitem.componentname,
																		fn = local.ruleitem.functionname,
																		args = {
																			line = arguments.line,
																			passonmatch = local.ruleitem.passonmatch,
																			pattern = local.ruleitem.pattern
																		}
																	);
						if ( NOT local.codeCheckerReturn ) {
							recordResult(directory=local.directory, file=local.file, rule=local.ruleitem.name, message=local.ruleitem.message, linenumber=arguments.linenumber, category=local.ruleitem.category, severity=local.ruleitem.severity);
						}
					}
				}
				else if ( NOT StructKeyExists(arguments,"line") AND local.ruleitem.bulkcheck ) {
					local.objJREUtils = wirebox.getInstance( "jre-utils" );
					local.dataFile = FileRead( arguments.filepath );
					local.matches = local.objJREUtils.get( local.dataFile , local.ruleitem.pattern );
					if ( ( local.ruleitem.passonmatch AND NOT ArrayLen(local.matches) ) OR ( ArrayLen(local.matches) AND NOT local.ruleitem.passonmatch ) ) {
						// TODO: report actual line number
						recordResult(directory=local.directory, file=local.file, rule=local.ruleitem.name, message=local.ruleitem.message, linenumber=-1, category=local.ruleitem.category, severity=local.ruleitem.severity);
					}
				}
				else {
					continue;
				}
			}
		}
	}

	/**
	* I run the qpscanner component.
	* @filepath I am the file path for which to review.
	*/
	public void function runQueryParamScanner( required string filepath ) {
		local.standardizedfilepath = Replace(arguments.filepath, "\", "/", "all");
		local.file = ListLast(local.standardizedfilepath, "/");
		local.directory = Replace(local.standardizedfilepath, local.file, "");
		local.fileextension = ListLast(local.file, ".");
		if ( ListFindNoCase("cfm,cfc",local.fileextension) ) {
			
			local.objJREUtils = wirebox.getInstance( "jre-utils" ).init();

			local.objQueryParamScanner = wirebox.getInstance( 
				name 			= "qpscanner",
				initArguments 	= { 
					jre  			= local.objJREUtils, 
					StartingDir		= arguments.filepath, 
					OutputFormat 	= "wddx", 
					RequestTimeout 	= -1
				}
			);
			local.qpScannerResult = local.objQueryParamScanner.go();
			for ( local.row = 1; local.row LTE local.qpScannerResult.data.recordcount; local.row++ ) {
				recordResult(directory=local.directory, file=local.file, rule="Missing cfqueryparam", message="All query variables should utilize cfqueryparam. This helps prevent sql injection. It also increases query performance by caching the execution plan.", linenumber=local.qpScannerResult.data.querystartline[local.row], category="QueryParamScanner", severity="5");
			}
		}
	}

	/**
	* I run the varScoper component.
	* @filepath I am the file path for which to review.
	*/
	public void function runVarScoper( required string filepath ) {
		local.standardizedfilepath = Replace(arguments.filepath, "\", "/", "all");
		local.file = ListLast(local.standardizedfilepath, "/");
		local.directory = Replace(local.standardizedfilepath, local.file, "");
		local.fileextension = ListLast(local.file, ".");
		if ( local.fileextension IS "cfc" ) {
			local.objVarScoper = wirebox.getInstance( name="varScoper", initArguments={ fileParseText=FileRead( arguments.filepath ) } );
			local.objVarScoper.runVarscoper();
			local.varScoperResult = local.objVarScoper.getResultsArray();
			for ( local.resultitem in local.varScoperResult ) {
				for ( local.unscopedstruct in local.resultitem.unscopedarray ) {
					recordResult(directory=local.directory, file=local.file, rule="Unscoped CFC variable", message="All CFC variables should be scoped in order to prevent memory leaks.", linenumber=local.unscopedstruct.linenumber, category="VarScoper", severity="5");
				}
			}
		}
	}

	/**
	* I record the result of the code review.
	*/
	public void function recordResult() {
		ArrayAppend(variables.results, arguments);
	}

}
