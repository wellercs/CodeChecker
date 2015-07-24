<cfcomponent name="CodeChecker" displayname="Code Checker" output="false" hint="I provide functions for checking code quality.">

	<cfset this.name = "CodeChecker" />

	<cffunction name="init" access="public" output="false" returntype="any" hint="I initialize the component.">
		<cfargument name="categories" default="_ALL" type="string" hint="I am a comma separated list of categories, _ALL for all categories" />
		<cfscript>
			variables.results = [];
			variables.objRules = new Rules( categories=ARGUMENTS.categories );
			variables.rules = variables.objRules.get();
			variables.categories = ARGUMENTS.categories;
			return this;
		</cfscript>
	</cffunction>

    <cffunction name="checkCode" access="public" returntype="boolean" output="false" hint="I return whether the code check passed or failed.">
		<cfargument name="line" type="string" required="true" hint="I am the line of code for which to check." />
		<cfargument name="passonmatch" type="boolean" required="true" hint="I determine whether to pass or fail if the pattern is matched." />
		<cfargument name="pattern" type="string" required="true" hint="I am the pattern of code for which to check." />

		<cfif ( REFindNoCase(arguments.pattern, arguments.line) AND NOT arguments.passonmatch ) OR ( NOT REFindNoCase(arguments.pattern, arguments.line) AND arguments.passonmatch )>
			<cfreturn false />
		</cfif>

		<cfreturn true />
    </cffunction>

    <cffunction name="startCodeReview" access="public" returntype="array" output="false" hint="I return the banner placement options.">
		<cfargument name="filepath" type="string" required="true" hint="I am the directory or file path for which to review." />
		<cfargument name="recurse" type="boolean" required="false" default="true" hint="I determine whether or not to review recursively." />

		<cfset var local = {} />

		<cfif DirectoryExists(arguments.filepath)>
			<cfdirectory name="local.qryFiles" action="list" directory="#arguments.filepath#" recurse="#arguments.recurse#" type="file" />
			<cfloop query="local.qryFiles">
				<cfset local.filePath = "#local.qryFiles.directory#/#local.qryFiles.name#">

				<cfset readFile(filepath=local.filePath)>

				<cfif ListFind( variables.categories, 'QueryParamScanner')>
					<cfset runQueryParamScanner(filepath=local.filePath)>
				</cfif>	
				<cfif ListFind( variables.categories, 'VarScoper')>
					<cfset runVarScoper(filepath=local.filePath)>
				</cfif>
			</cfloop>
		<cfelseif FileExists(arguments.filepath)>
			<cfset local.filePath = arguments.filepath>

			<cfset readFile(filepath=local.filePath)>

			<cfif ListFind( variables.categories, 'QueryParamScanner')>
				<cfset runQueryParamScanner(filepath=local.filePath)>
			</cfif>	
			<cfif ListFind( variables.categories, 'VarScoper')>
				<cfset runVarScoper(filepath=local.filePath)>
			</cfif>
		</cfif>

		<cfreturn variables.results />
    </cffunction>

    <cffunction name="readFile" access="public" returntype="void" output="false" hint="I record the result of the code review.">
		<cfargument name="filepath" type="string" required="true" hint="I am the file path for which to review." />

		<cfset var local = {} />

    	<cfset local.dataFile = fileOpen( arguments.filepath, "read" ) />

		<cfset local.lineNumber = 0>
		<cfloop condition="!fileIsEOF( local.dataFile )">
			<cfset local.lineNumber++ />

			<cfset local.line = fileReadLine( local.dataFile ) />

			<!--- run rules on each line --->
			<cfset runRules(filepath=arguments.filepath, line=local.line, linenumber=local.lineNumber) />

			<cfif fileIsEOF( local.dataFile )>
				<!--- run rules on whole file. useful for rules where you are just testing the existence of something. --->
				<cfset runRules(filepath=arguments.filepath) />
			</cfif>
		</cfloop>

		<cfset fileClose( local.dataFile ) />
	</cffunction>

	<cffunction name="runRules" access="public" returntype="void" output="false" hint="I run the code review rules for the line of code.">
		<cfargument name="filepath" type="string" required="true" default="" hint="I am the file path for which to review." />
		<cfargument name="line" type="string" required="false" hint="I am the line of code for which to review." />
		<cfargument name="linenumber" type="numeric" required="false" hint="I am the line number of the code for which to review." />

		<cfset var local = {} />

		<cfset local.standardizedfilepath = Replace(arguments.filepath, "\", "/", "all")>
		<cfset local.file = ListLast(local.standardizedfilepath, "/")>
		<cfset local.directory = Replace(local.standardizedfilepath, local.file, "")>
		<cfset local.fileextension = ListLast(local.file, ".")>

		<cfloop array="#variables.rules#" index="local.ruleitem">
			<cfif NOT ListFindNoCase(local.ruleitem.extensions, local.fileextension, ",")>
				<cfcontinue />
			</cfif>
			<cfif StructKeyExists(arguments,"line") AND NOT local.ruleitem.bulkcheck AND NOT ListLen(local.ruleitem.tagname,"|")>
				<cfinvoke component="#local.ruleitem.componentname#" method="#local.ruleitem.functionname#" line="#arguments.line#" passonmatch="#local.ruleitem.passonmatch#" pattern="#local.ruleitem.pattern#" returnvariable="local.codeCheckerReturn" />
				<cfif NOT local.codeCheckerReturn>
					<cfset recordResult(directory=local.directory, file=local.file, rule=local.ruleitem.name, message=local.ruleitem.message, linenumber=arguments.linenumber, category=local.ruleitem.category, severity=local.ruleitem.severity)>
				</cfif>
			<cfelseif StructKeyExists(arguments,"line") AND NOT local.ruleitem.bulkcheck AND ListLen(local.ruleitem.tagname,"|")>
				<cfif REFindNoCase("<#Replace(local.ruleitem.tagname,'|','|<')#", arguments.line)>
					<cfinvoke component="#local.ruleitem.componentname#" method="#local.ruleitem.functionname#" line="#arguments.line#" passonmatch="#local.ruleitem.passonmatch#" pattern="#local.ruleitem.pattern#" returnvariable="local.codeCheckerReturn" />
					<cfif NOT local.codeCheckerReturn>
						<cfset recordResult(directory=local.directory, file=local.file, rule=local.ruleitem.name, message=local.ruleitem.message, linenumber=arguments.linenumber, category=local.ruleitem.category, severity=local.ruleitem.severity)>
					</cfif>
				</cfif>
			<cfelseif NOT StructKeyExists(arguments,"line") AND local.ruleitem.bulkcheck>
				<!--- TODO: support dynamic path to jre-utils component --->
				<cfset local.objJREUtils = createObject("component","services.QueryParamScanner.jre-utils").init()>
				<cfset local.dataFile = FileRead(arguments.filepath)>
				<cfset local.matches = local.objJREUtils.get( local.dataFile , local.ruleitem.pattern )/>
				<cfif ( local.ruleitem.passonmatch AND NOT ArrayLen(local.matches) ) OR ( ArrayLen(local.matches) AND NOT local.ruleitem.passonmatch )>
					<!--- TODO: report actual line number --->
					<cfset recordResult(directory=local.directory, file=local.file, rule=local.ruleitem.name, message=local.ruleitem.message, linenumber=-1, category=local.ruleitem.category, severity=local.ruleitem.severity)>
				</cfif>
			<cfelse>
				<cfcontinue />
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="runQueryParamScanner" access="public" returntype="void" output="false" hint="I run the varScoper component.">
		<cfargument name="filepath" type="string" required="true" default="" hint="I am the file path for which to review." />

		<cfset var local = {}>

		<cfset local.standardizedfilepath = Replace(arguments.filepath, "\", "/", "all")>
		<cfset local.file = ListLast(local.standardizedfilepath, "/")>
		<cfset local.directory = Replace(local.standardizedfilepath, local.file, "")>
		<cfset local.fileextension = ListLast(local.file, ".")>

		<cfif ListFindNoCase("cfm,cfc",local.fileextension)>
			<!--- TODO: support dynamic path to jre-utils component --->
			<cfset local.objJREUtils = createObject("component","services.QueryParamScanner.jre-utils").init()>
			<!--- TODO: support dynamic path to qpscanner component --->
			<cfset local.objQueryParamScanner = new services.QueryParamScanner.qpscanner(jre=local.objJREUtils, StartingDir=arguments.filepath, OutputFormat="wddx", RequestTimeout=-1)>

			<cfset local.qpScannerResult = local.objQueryParamScanner.go()>

			<cfloop query="local.qpScannerResult.data">
				<cfset recordResult(directory=local.directory, file=local.file, rule="Missing cfqueryparam", message="All query variables should utilize cfqueryparam. This helps prevent sql injection. It also increases query performance by caching the execution plan.", linenumber=local.qpScannerResult.data.querystartline, category="QueryParamScanner", severity="5")>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="runVarScoper" access="public" returntype="void" output="false" hint="I run the varScoper component.">
		<cfargument name="filepath" type="string" required="true" default="" hint="I am the file path for which to review." />

		<cfset var local = {}>

		<cfset local.standardizedfilepath = Replace(arguments.filepath, "\", "/", "all")>
		<cfset local.file = ListLast(local.standardizedfilepath, "/")>
		<cfset local.directory = Replace(local.standardizedfilepath, local.file, "")>
		<cfset local.fileextension = ListLast(local.file, ".")>

		<cfif local.fileextension IS "cfc">
			<cfset arguments.fileParseText = FileRead(arguments.filepath)>

			<!--- TODO: support dynamic path to varScoper component --->
			<cfset local.objVarScoper = new services.VarScoper.varScoper(fileParseText=arguments.fileParseText)>

			<cfset local.objVarScoper.runVarscoper() />

			<cfset local.varScoperResult = local.objVarScoper.getResultsArray()>

			<cfloop array="#local.varScoperResult#" index="local.resultitem">
				<cfloop array="#local.resultitem.unscopedarray#" index="local.unscopedstruct">
					<cfset recordResult(directory=local.directory, file=local.file, rule="Unscoped CFC variable", message="All CFC variables should be scoped in order to prevent memory leaks.", linenumber=local.unscopedstruct.linenumber, category="VarScoper", severity="5")>
				</cfloop>
			</cfloop>
		</cfif>
	</cffunction>

    <cffunction name="recordResult" access="public" returntype="void" output="false" hint="I record the result of the code review.">
		<cfset ArrayAppend(variables.results, arguments)>
	</cffunction>

	<cffunction name="getResults" access="public" output="false" returntype="any" hint="I return the results.">
		<cfreturn variables.results />
	</cffunction>

	<cffunction name="onMissingMethod" hint="I catch it if someone passes in a bad method name.">
		<cfargument name="missingMethodName" type="string">
	    <cfargument name="missingMethodArguments" type="struct">

	</cffunction>
</cfcomponent>