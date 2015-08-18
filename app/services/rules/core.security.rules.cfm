<cfscript>
	
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
	ArrayAppend(variables.rules,variables.temprulestruct);
	
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
	ArrayAppend(variables.rules,variables.temprulestruct);
	
</cfscript>