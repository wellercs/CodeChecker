<cffunction name="safeVariable">
	<cfargument name="inputval" default="">
	
	<cfreturn REReplace(ARGUMENTS.inputval,"[^0-9A-Za-z]","","all")>
</cffunction>	

<cfscript>
result=queryNew("directory,file,rule,message,linenumber,category,severity");
for(var i=1; i<=ArrayLen(cachebox.getCache("default").get(prc.resultsCacheKey));i=(i+1)){
queryAddRow(result);
querySetCell(result,"directory",cachebox.getCache("default").get(prc.resultsCacheKey)[i].directory);
querySetCell(result,"file",cachebox.getCache("default").get(prc.resultsCacheKey)[i].file);
querySetCell(result,"rule",cachebox.getCache("default").get(prc.resultsCacheKey)[i].rule);
querySetCell(result,"message",cachebox.getCache("default").get(prc.resultsCacheKey)[i].message);
querySetCell(result,"linenumber",cachebox.getCache("default").get(prc.resultsCacheKey)[i].linenumber);
querySetCell(result,"category",cachebox.getCache("default").get(prc.resultsCacheKey)[i].category);
querySetCell(result,"severity",cachebox.getCache("default").get(prc.resultsCacheKey)[i].severity);
}
</cfscript>

<!---This returns a distinct list of comma seperated categories--->
<cfset vCategories = listToArray(cachebox.getCache("default").get(prc.categoriesCacheKey))>

<!--- Queries are created named from the categories --->
<cfloop index="k" array="#vCategories#">
	<cfquery name="#safeVariable(k)#" dbtype="query">
		select directory,file,rule,message,linenumber,category,severity from result where category= <cfqueryparam cfsqltype="cf_sql_varchar" value="#k#" /> order by category
	</cfquery>
</cfloop>

<!--- Spreadsheet gets dynamically created --->
<cfscript>
		counter = 0;
		spreadsheet = createObject('component','models.SpreadSheet.Spreadsheet').init();
		writeDump( spreadsheet );
		//spreadsheet = New spreadsheet();
		workbook = spreadsheet.new();
for(i=1;i<=arrayLen(vCategories);i++){
		counter = counter + 1;
		value = safeVariable(vCategories[i]);
		rc = value & '.recordcount';
		if(rc gt 0); {
		data = 'data' & counter;
		data = Evaluate(value);
		spreadsheet.createSheet( workbook,#left(LCase(value),30)#);
		spreadsheet.setActiveSheet(workbook,#left(LCase(value),30)#);
		spreadsheet.addRow(workbook=workbook, data="directory,file,rule,message,linenumber,category,severity,Developer-Assigned,Status", autoSizeColumns=1);
		spreadsheet.addRows(workbook,data);
		}
}

		spreadsheet.removesheet(workbook,"Sheet1");
		spreadsheet.setActiveSheetNumber(workbook,1);
		//path = "checker.xls";
		//overwrite="yes";
		//spreadsheet.write( workbook,path,overwrite );
		binary=spreadsheet.readBinary(workbook);
</cfscript>
<cfheader name="Content-Disposition" value="inline;filename=#dateformat(now(),"yyyymmdd")##timeformat(now(),"hhmm")#_codechecker.xls">
<cfcontent type="application/vnd.ms-excel" variable="#binary#">








