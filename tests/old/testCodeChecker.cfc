<cfcomponent name="test" displayname="" output=true hint="hi">
	<cfset this.name ="test">
	<cffunction name="init" access="public" output="false" returntype="any" hint="I initialize the component">
		<cfargument name="datasource" type="string" required="true" hint="Required parameter. Default datasource name for the queries.">

		<cfset variables.datasource = arguments.datasource>

		<cfset var q = "">

		<cftry>
			<cfquery name="q" datasource="#variables.datasource#">
	
			</cfquery>
			<cfcatch>
				
			</cfcatch>
		</cftry>

		<cfreturn this />
	</cffunction>

	<cffunction name="testFunction1" access="public" returntype="any" output="true" hint="">
		<cfset var local = {}>
		<cftry>
			<cfset local.test = "test">
			<cfcatch type="any">
				<cflog text="" />
			</cfcatch>
		</cftry>   
		<cfreturn "">   
    </cffunction>
    
	<cffunction name="testFunction2" access="public" returntype="any" output="true">
		<cfset var local = {}>
		<cftry>
			<cfset local.test = "test">
			<cfcatch type="any">
				<cflog text="" />
			</cfcatch>
		</cftry>   
		<cfreturn "">   
    </cffunction>

	<cffunction name="onMissingMethod" hint="I catch it if someone passes in a bad method name">


		<cflog text="" />
	</cffunction>
</cfcomponent>