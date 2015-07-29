<cfcomponent name="Rules" displayname="Code Check Rules" output="false" hint="I set the rules for the code checker." accessors="true">
	<cfproperty name="categories" type="array" required="true" getter="true" />
	<cfproperty name="rules" type="array" required="true" getter="true" />

	<cfset this.name = "Rules">
	<cfset this.setCategories([])>
	<cfset this.setRules([])>

	<cffunction name="init" access="public" output="false" returntype="any" hint="I initialize the component.">
		<cfargument name="filepath" type="string" required="true" default="#expandPath('/resources')#/rules.json" hint="I am the file path defining the rules." />
		<cfscript>
			//TODO: support cfscript patterns
			//TODO: support multiline
			//TODO: unscoped variables in cfm pages
			//TODO: unnecessary use of pound signs
			//TODO: reserved words/functions
			//TODO: deprecated functions
			//TODO: require return statement for return types other than void

			this.setRules(deserializeJSON(fileRead(arguments.filepath)));

			for( local.rule in this.getRules() ) {
				if ( NOT arrayFind(this.getCategories(), local.rule.category) ) {
					arrayAppend(this.getCategories(), local.rule.category);
				}
			}

			return this;
		</cfscript>
	</cffunction>

	<cffunction name="onMissingMethod" hint="I catch it if someone passes in a bad method name">
		<cfargument name="missingMethodName" type="string">
	   	<cfargument name="missingMethodArguments" type="struct">

	</cffunction>
</cfcomponent>