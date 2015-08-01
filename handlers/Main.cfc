/**
* I am a new handler
*/
component{
	property name='codeCheckerService' inject='codeCheckerService';
	property name='rulesService' inject='rulesService';
	
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};
	
	function preHandler( event, rc, prc, action, eventArguments ){
		event.setValue( name='pageTitle', value='Code Checker Form', private=true );
	}

	function postHandler( event, rc, prc, action, eventArguments ){

	}

	function aroundHandler( event, rc, prc, targetAction, eventArguments ){
		// executed targeted action
		arguments.targetAction( argumentCollection=arguments );
	}
		
	function index(event,rc,prc){
		rc.formdata = flash.get("formdata", {});
		prc.categoryList = rulesService.getCategories();
		prc.errors = flash.get("errors", []);
		event.setView("main/index");
	}

	function results(event,rc,prc){
		event.setView("main/results");
	}

	function run(event,rc,prc){
		cfsetting( requestTimeout=5000 );
		param name="rc.categories" default="";

		rc.formdata = duplicate(form);
		prc.errors = [];

		if ( NOT structKeyExists(rc.formdata, "categories") ) {
			arrayAppend(
							prc.errors,
							{
								field = "categories",
								message = "You must select at least one category."
							}
						);
		}

		if ( NOT len(trim(rc.formdata.txaCheckFiles)) ) {
			arrayAppend(
							prc.errors,
							{
								field = "txaCheckFiles",
								message = "You must provide at least one file path or directory."
							}
						);
		}

		if ( arrayLen(prc.errors) ) {
			flash.put(name="formdata", value=rc.formdata);
			flash.put(name="errors", value=prc.errors);
			setNextEvent(event:"main.index");
		}
		else {
			prc.checkFiles = listToArray(rc.formdata.txaCheckFiles,"#chr(10)#,#chr(13)#");
			prc.checkedFiles = [];
			prc.failedFiles = [];
			prc.results = [];

			codeCheckerService.setCategories(rc.categories);

			for ( local.originalCheckFile in prc.checkFiles ) {
				if ( directoryExists(local.originalCheckFile) or fileExists(local.originalCheckFile) ) {
					local.resultsCodeChecker = codeCheckerService.startCodeReview(filepath=local.originalCheckFile);
					arrayAppend(prc.checkedFiles, local.originalCheckFile);
				}
				else {
					arrayAppend(prc.failedFiles, local.originalCheckFile);
				}
			}

			prc.results = codeCheckerService.getResults();

			event.setView("main/results");
		}
	}	

	/************************************** IMPLICIT ACTIONS *********************************************/

	function onAppInit(event,rc,prc){

	}

	function onRequestStart(event,rc,prc){

	}

	function onRequestEnd(event,rc,prc){

	}

	function onSessionStart(event,rc,prc){

	}

	function onSessionEnd(event,rc,prc){
		var sessionScope = event.getValue("sessionReference");
		var applicationScope = event.getValue("applicationReference");
	}

	function onError( event, rc, prc, faultAction, exception, eventArguments ){
		writedump(arguments);
		abort;
	}

	function onException(event,rc,prc){
		//Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		//Place exception handler below:

	}

	function onMissingAction( event, rc, prc, missingAction, eventArguments ){

	}

	function onMissingTemplate(event,rc,prc){
		//Grab missingTemplate From request collection, placed by ColdBox
		var missingTemplate = event.getValue("missingTemplate");

	}
	
}
