<cfparam name="form.categories" default="_ALL">
<cfset variables.arrCheckFiles = []>
<cfset variables.arrCheckFiles = ListToArray(form.txaCheckFiles,"#chr(10)#,#chr(13)#")>

<cfset variables.objCodeChecker = new services.CodeChecker( categories=form.categories )>

<cfset session.formdata = Duplicate(form)>
<cfset session.results = []>
<cfset session.checkedfiles = []>
<cfset session.failedfiles = []>

<cfloop array="#variables.arrCheckFiles#" index="variables.originalCheckFile">
	<cfif DirectoryExists(variables.originalCheckFile) OR FileExists(variables.originalCheckFile)>
		<cfset variables.resultsCodeChecker = variables.objCodeChecker.startCodeReview(filepath=variables.originalCheckFile)>
		<cfset ArrayAppend(session.checkedfiles,variables.originalCheckFile)>
	<cfelse>
		<cfset ArrayAppend(session.failedfiles,variables.originalCheckFile)>
	</cfif>
</cfloop>

<cfset session.results = variables.objCodeChecker.getResults()>

<cflocation url="../view/dsp_codechecker.cfm">