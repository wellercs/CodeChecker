<cfscript>
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
	ArrayAppend(variables.rules,variables.temprulestruct);
	
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
	ArrayAppend(variables.rules,variables.temprulestruct);

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
	ArrayAppend(variables.rules,variables.temprulestruct);

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
	ArrayAppend(variables.rules,variables.temprulestruct);
</cfscript>