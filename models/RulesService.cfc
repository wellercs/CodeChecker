/**
* I set the rules for the code checker.
*/
component accessors="true" {

	property name="categories" 	type="array";
	property name="rules" 		type="array";

	/**
	* @hint I initialize the component.
	* @rulesDirPath I am the directory path containing the rules.
	*/
	RulesService function init( string rulesDirPath = expandPath( '/codechecker/config/rules' ) ){

		variables.categories 	= [];
		variables.rules 		= [];

		//TODO: support cfscript patterns
		//TODO: support multiline
		//TODO: unscoped variables in cfm pages
		//TODO: unnecessary use of pound signs
		//TODO: reserved words/functions
		//TODO: deprecated functions
		//TODO: require return statement for return types other than void

		// path, recurse, listInfo, filter, sort
		local.rulesFilePaths = directoryList(
			arguments.rulesDirPath,
			true,
			"path",
			"*.json",
			"asc"
		);

		for ( local.ruleFile in local.rulesFilePaths ) {
			// merge array of config data
			variables.rules.addAll( deserializeJSON( fileRead( local.ruleFile ) ) );
		}

		for( local.rule in variables.rules ) {
			if ( NOT arrayFind( variables.categories, local.rule.category ) ) {
				arrayAppend( variables.categories, local.rule.category);
			}
		}

		return this;
	}

}
