<cfoutput>
<section>
	<cfif ArrayLen(prc.failedFiles)>
		<h3>Files Not Found</h3>
		<cfdump var="#prc.failedFiles#">
		<hr />
	</cfif>

	<div class="pull-right margin10">
		<a href="#event.buildLink( linkto='main.print', queryString='key=#prc.uuid#' )#" class="btn btn-default">
			Export
		</a>
		
		<a href="#event.buildLink( 'main.index' )#" class="btn btn-default">
			Back to Code Checker Form
		</a>
	</div>

	<table class="table table-striped table-bordered table-hover table-condensed">
		<caption>
			Code Review Results ( Check Time: #prc.executionTime#ms )
		</caption>
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
			<cfloop array="#prc.results#" index="variables.result">
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
</section>
</cfoutput>