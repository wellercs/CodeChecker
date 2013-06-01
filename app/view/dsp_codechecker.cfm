<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/Product">
	<head>
		<title>CodeChecker</title>
		<link rel="stylesheet" type="text/css" href="../assets/css/_tables.css" />
	</head>
	<body>
		<cfoutput>
			<div style="float:right;">
				<a href="frm_codechecker.cfm">
					Back to Code Checker Form
				</a>
			</div>
			<cfif ArrayLen(session.failedfiles)>
				<h3>Files Not Found</h3>
				<cfdump var="#session.failedfiles#">
				<hr />
			</cfif>
			<h3>Code Review Results</h3>
			<table class="results">
				<thead>
					<tr>
						<th>Directory</th>
						<th>File</th>
						<th>Rule</th>
						<th>Message</th>
						<th>Line Number</th>
						<th>Category</th>
						<th>Severity</th>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#session.results#" index="variables.result">
						<tr>
							<td>#variables.result.directory#</td>
							<td>#variables.result.file#</td>
							<td>#variables.result.rule#</td>
							<td>#variables.result.message#</td>
							<td>#variables.result.linenumber#</td>
							<td>#variables.result.category#</td>
							<td>#variables.result.severity#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</cfoutput>
	</body>
</html>