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
					<label for="txaCheckFiles">Files (separate by a carriage return):</label>
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