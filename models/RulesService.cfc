/**
* I set the rules for the code checker.
*/
component accessors="true" {

	property name="categories" type="array" required="true" getter="true";
	property name="rules" type="array" required="true" getter="true";

	this.name = "Rules";
	this.setCategories([]);
	this.setRules([]);
	
	/**
	* @hint I initialize the component.
	* @rulesDirPath I am the directory path containing the rules.
	*/
	RulesService function init( string rulesDirPath = expandPath('/includes/resources/rules') ){

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
			// merge array
			this.getRules().addAll(deserializeJSON(fileRead(local.ruleFile)));
		}

		for( local.rule in this.getRules() ) {
			if ( NOT arrayFind(this.getCategories(), local.rule.category) ) {
				arrayAppend(this.getCategories(), local.rule.category);
			}
		}

		return this;
		
	}

}
