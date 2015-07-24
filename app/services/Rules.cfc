<cfcomponent name="Rules" displayname="Code Check Rules" output="false" hint="I set the rules for the code checker.">
	<cfset this.name ="Rules">

	<cffunction name="init" access="public" output="false" returntype="any" hint="I initialize the component.">
		<cfargument name="categories" default="_ALL" type="string" hint="I am a comma separated list of categories, _ALL for all categories" />
		<cfscript>
			variables.rules = [];

			//TODO: support cfscript patterns
			//TODO: support multiline
			//TODO: unscoped variables in cfm pages
			//TODO: unnecessary use of pound signs
			//TODO: reserved words/functions
			//TODO: deprecated functions
			//TODO: require return statement for return types other than void

			/* SECURITY RULES */
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Security";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Avoid using client scoped variables from within a CFM. Use session instead.";
			variables.temprulestruct["name"] = "Don't use client scoped variables in a CFM";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "\b(client)(?=(\[|\.\w))";
			variables.temprulestruct["severity"] = 4;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Security";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Warning: Ensure that file uploads use accept attribute and check for valid file extension and MIME type. For image files, also use IsImage().";
			variables.temprulestruct["name"] = "File upload warning";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "<cffile|<input.*type=\042file\042";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			/* PERFORMANCE RULES */
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = true;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Avoid nesting cflock as it can lead to long-running code and can cause deadlocks.";
			variables.temprulestruct["name"] = "Don't nest cflock tags";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "<cflock[\w\W]+<cflock[\w\W]+</cflock";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Prefer StructKeyExists() over ParameterExists()";
			variables.temprulestruct["name"] = "Don't use ParameterExists";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "parameterExists\(";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Prefer StructKeyExists() over IsDefined()";
			variables.temprulestruct["name"] = "Don't use IsDefined";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "isDefined\(";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Avoid Evaluate().";
			variables.temprulestruct["name"] = "Don't use Evaluate method";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "Evaluate(?=\()";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Avoid DE().";
			variables.temprulestruct["name"] = "Don't use DE method";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "DE(?=\()";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Always use cfif/cfelse instead of iif(). It is significantly faster and more readable.";
			variables.temprulestruct["name"] = "Don't use iif method";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "iif(?=\()";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Always use struct.key or struct[key] instead of structFind(struct, key). They are significantly faster and more readable.";
			variables.temprulestruct["name"] = "Don't use StructFind method";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "StructFind(?=\()";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Always use x = x - 1 or x-- instead of x = decrementValue(x). It is more readable and slightly faster.";
			variables.temprulestruct["name"] = "Don't use DecrementValue method";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "DecrementValue(?=\()";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Always use x = x + 1 or x++ instead of x = incrementValue(x). It is more readable and slightly faster.";
			variables.temprulestruct["name"] = "Don't use IncrementValue method";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "IncrementValue(?=\()";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Always use len() instead of is "", eq "", is not "", neq """;
			variables.temprulestruct["name"] = "Use Len method";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "is\s+\042\042|eq\s+\042\042|is\s+not\s+\042\042|neq\s+\042\042|is\s+\047\047|eq\s+\047\047|is\s+not\s+\047\047|neq\s+\047\047";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Performance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Prefer set tag/script over SetVariable()";
			variables.temprulestruct["name"] = "Don't use SetVariable";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "setVariable\(";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			/* STANDARDS RULES */
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Remove inline query. Queries should be encapsulated in the model/service layer.";
			variables.temprulestruct["name"] = "Don't use cfquery in a cfm page";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "<cfquery\s+";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Avoid using shared scope variables from within a CFC as it breaks encapsulation.";
			variables.temprulestruct["name"] = "Don't use shared scope variables in a CFC";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "\b(form|application|url|session|cgi|client|request|cookie)(?=(\[|\.\w))";
			variables.temprulestruct["severity"] = 4;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Avoid using IS for boolean tests.";
			variables.temprulestruct["name"] = "Don't use IS or GT for boolean tests";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "is\s+true|is\s+not\s+true|is\s+false|is\s+not\s+false";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Use IS/IS NOT for string comparisons and EQ/NEQ for numeric comparisons.";
			variables.temprulestruct["name"] = "Illogical comparison operator";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "is\s+[0-9]+|is\s+not\s+[0-9]+|eq\s+\042[A-Za-z]+\042|eq\s+\042[0-9]+\042|neq\s+\042[A-Z][a-z]+\042|neq\s+\042[0-9]+\042";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Mathematical operators should be used with numbers instead of strings.";
			variables.temprulestruct["name"] = "Illogical mathematical operator";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "\+\s+\042[0-9]\042|\-\s+\042[0-9]\042|\*\s+\042[0-9]\042|\/\s+\042[0-9]\042|\%\s+\042[0-9]\042";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "The ampersand contcatenator should be used with strings instead of numbers.";
			variables.temprulestruct["name"] = "Illogical concatenation";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "\&\s+[0-9]";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = true;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Catch blocks should not be empty.";
			variables.temprulestruct["name"] = "Empty catch block";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "<cfcatch[\W]+[^\<cf][\W]+</cfcatch|<cfcatch></cfcatch>|<cfcatch>\W+</cfcatch>";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Output attribute of components and functions should be set to false.";
			variables.temprulestruct["name"] = "Avoid using output=true in cfcomponent and cffunction";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = ".*output=\042\s*true\s*\042|.*output=\s*true\s*";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "cfcomponent|cffunction";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = true;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Every CFC should have an init method.";
			variables.temprulestruct["name"] = "Use init method in CFC";
			variables.temprulestruct["passonmatch"] = true;
			variables.temprulestruct["pattern"] = "function init\(|<cffunction.*name=\042init\042";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = true;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Every CFC should have an onMissingMethod method.";
			variables.temprulestruct["name"] = "Use onMissingMethod method in CFC";
			variables.temprulestruct["passonmatch"] = true;
			variables.temprulestruct["pattern"] = "function onMissingMethod\(|<cffunction.*name=\042onMissingMethod\042";
			variables.temprulestruct["severity"] = 3;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
		
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Hints appear in the auto-generated CFC documentation and aid in documenting your code.";
			variables.temprulestruct["name"] = "Use hint attribute of cfcomponent, cffunction, cfargument";
			variables.temprulestruct["passonmatch"] = true;
			variables.temprulestruct["pattern"] = ".*hint=\042\w+.*\042";
			variables.temprulestruct["severity"] = 1;
			variables.temprulestruct["tagname"] = "cfcomponent|cffunction|cfargument";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Avoid ArrayNew(1). Simply use [].";
			variables.temprulestruct["name"] = "Don't use ArrayNew(1) function";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "ArrayNew\(1\)";
			variables.temprulestruct["severity"] = 1;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Standards";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Use variables-scoped datasource since the datasource should be set on object instantiation.";
			variables.temprulestruct["name"] = "Don't use arguments-scoped datasource";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "datasource=.*arguments";
			variables.temprulestruct["severity"] = 1;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			/* MAINTENANCE RULES */
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Maintenance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Remove cfabort";
			variables.temprulestruct["name"] = "Don't use Abort";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "<cfabort|abort;";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}
			
			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Maintenance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Remove cfdump";
			variables.temprulestruct["name"] = "Don't use Dump";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "<cfdump|writeDump\(";
			variables.temprulestruct["severity"] = 5;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Maintenance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,cfc";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Remove cflog";
			variables.temprulestruct["name"] = "Don't use Log";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "<cflog|writeLog\(";
			variables.temprulestruct["severity"] = 2;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			variables.temprulestruct = {};
			variables.temprulestruct["bulkcheck"] = false;
			variables.temprulestruct["category"] = "Maintenance";
			variables.temprulestruct["componentname"] = "CodeChecker";
			variables.temprulestruct["customcode"] = "";
			variables.temprulestruct["extensions"] = "cfm,js";
			variables.temprulestruct["functionname"] = "checkCode";
			variables.temprulestruct["message"] = "Remove console log";
			variables.temprulestruct["name"] = "Don't use Console Log";
			variables.temprulestruct["passonmatch"] = false;
			variables.temprulestruct["pattern"] = "console\.log\(";
			variables.temprulestruct["severity"] = 1;
			variables.temprulestruct["tagname"] = "";
			if ( ARGUMENTS.categories is "_ALL" || ListFind( ARGUMENTS.categories, variables.temprulestruct["category"] ) ){
				ArrayAppend(variables.rules,variables.temprulestruct);	
			}

			//writeDump( variables.rules );
			//abort;

			return this;
		</cfscript>
	</cffunction>

	<cffunction name="get" access="public" output="false" returntype="array" hint="I return the array of rules.">
		<cfreturn variables.rules />
	</cffunction>

	<cffunction name="onMissingMethod" hint="I catch it if someone passes in a bad method name">
		<cfargument name="missingMethodName" type="string">
	   	<cfargument name="missingMethodArguments" type="struct">

	</cffunction>
</cfcomponent>