<cfoutput>
	<h3>Code Checker Form</h3>
	<cfif arrayLen(prc.errors)>
		<div class="alert alert-danger" role="alert">
			<cfloop array="#prc.errors#" index="variables.error">
				<div>
					<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
					<span class="sr-only">Error:</span>
					#variables.error.message#
				</div>
			</cfloop>
		</div>
	</cfif>
	<form id="frmCodeChecker" name="frmCodeChecker" method="post" action="#event.buildLink( 'main.run' )#">
		<div>
			<label for="categories">Categories:</label>
			<div>
				<input type="checkbox" id="categories_ALL" name="categories" value="_ALL" <cfif structKeyExists(rc, "formdata") and structKeyExists(rc.formdata, "categories") and listFind(rc.formdata.categories, "_ALL")>checked="checked"</cfif> /><label for="categories_ALL">ALL</label>
			</div>
			<cfloop array="#prc.categoryList#" index="variables.categoryIndex">
				<div>
					<input type="checkbox" id="categories_#variables.categoryIndex#" name="categories" value="#variables.categoryIndex#" <cfif structKeyExists(rc, "formdata") and structKeyExists(rc.formdata, "categories") and listFind(rc.formdata.categories, variables.categoryIndex)>checked="checked"</cfif> /><label for="categories_#variables.categoryIndex#">#variables.categoryIndex#</label>
				</div>
			</cfloop>
			<br />
		</div>
		<div>
			<label for="txaCheckFiles">Files (separate by a carriage return):</label>
			<br />
			<textarea id="txaCheckFiles" name="txaCheckFiles" style="width:600px;height:200px;"><cfif structKeyExists(rc,"formdata") and structKeyExists(rc.formdata,"txaCheckFiles") and len(trim(rc.formdata.txaCheckFiles))>#rc.formdata.txaCheckFiles#</cfif></textarea>
			<br />
		</div>
		<div>
			<br />
			<input type="button" class="btn btn-primary" id="btnSubmit" name="btnSubmit" value="Submit" onclick="this.form.submit();" />
			<br />
		</div>
	</form>
</cfoutput>