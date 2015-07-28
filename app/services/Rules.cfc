<cfcomponent name="Rules" displayname="Code Check Rules" output="false" hint="I set the rules for the code checker.">
	<cfset this.name ="Rules">

	<cffunction name="init" access="public" output="false" returntype="any" hint="I initialize the component.">
		<cfscript>
			variables.rules = [];

			//TODO: support cfscript patterns
			//TODO: support multiline
			//TODO: unscoped variables in cfm pages
			//TODO: unnecessary use of pound signs
			//TODO: reserved words/functions
			//TODO: deprecated functions
			//TODO: require return statement for return types other than void
			var ruleFiles = directoryList( path="#GetDirectoryFromPath( GetCurrentTemplatePath() )#rules", recurse="true", filter="*.rules.cfm", listInfo="name" );
			for ( file in ruleFiles ) {
				include "rules/#file#";	
			}
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="get" access="public" output="false" returntype="array" hint="I return the array of rules.">
		<cfreturn variables.rules />
	</cffunction>
	
	<cffunction name="getCategories" access="public" output="false" returntype="array" hint="I return the array of rules.">
		<cfset var result = []>
		<cfset arrayAppend( result, "VarScoper")>
		<cfset arrayAppend( result, "QueryParamScanner")>
		<cfloop array="#variables.rules#" index="rule" >
			<cfif ArrayContains( result, rule.category) eq false>
				<cfset arrayAppend( result, rule.category)>
			</cfif>	
		</cfloop>	
		<cfreturn result />
	</cffunction>
	

	<cffunction name="onMissingMethod" hint="I catch it if someone passes in a bad method name">
		<cfargument name="missingMethodName" type="string">
	   	<cfargument name="missingMethodArguments" type="struct">

	</cffunction>
</cfcomponent>