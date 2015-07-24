<cfset categoryList = []>
<cfset categoryList.append('VarScoper')>
<cfset categoryList.append('QueryParamScanner')>
<cfset categoryList.append('Maintenance')>
<cfset categoryList.append('Standards')>
<cfset categoryList.append('Performance')>
<cfset categoryList.append('Security')>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/Product">
	<head>
		<title>CodeChecker</title>
		<link rel="stylesheet" type="text/css" href="css/_tables.css" />
	</head>
	<body>
		<cfoutput>
			<h3>Code Checker Form</h3>
			<form id="frmCodeChecker" name="frmCodeChecker" method="post" action="../model/act_codechecker.cfm">
				
				<div>
					<h4><label>Categories:</label></h4>
					<div>
						<cfloop array="#categoryList#" index="i">
							<input type="checkbox" id="categories_#i#" name="categories" value="#i#" <cfif structKeyExists(session,"formdata") and structKeyExists(session.formdata,"categories") and ListFind( session.formdata.categories, i )>checked="yes"</cfif>><label for="categories_#i#">#i#</label><br>
						</cfloop>	
					</div>
				</div>
				
				<div>
					<h4><label for="txaCheckFiles">Files (separate by a carriage return):</label></h4>
					<div>
						<textarea id="txaCheckFiles" name="txaCheckFiles" style="width:600px;height:200px;"><cfif structKeyExists(session,"formdata") and structKeyExists(session.formdata,"txaCheckFiles") and len(trim(session.formdata.txaCheckFiles))>#session.formdata.txaCheckFiles#</cfif></textarea>
					</div>
				</div>
				<div style="margin-top:20px;">
					<input type="button" id="btnSubmit" name="btnSubmit" value="Submit" onclick="this.form.submit();" />
				</div>
			</form>
		</cfoutput>
	</body>
</html>