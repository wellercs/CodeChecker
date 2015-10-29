/**
* I am a new handler
*/
component{

	// DI
	property name='codeCheckerService' 	inject='codeCheckerService';
	property name='rulesService' 		inject='rulesService';
	
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

	function index(event,rc,prc){
		event.paramPrivateValue( "errors", [] );
		prc.categoryList = rulesService.getCategories();
		event.setView("main/index");
	}

	function results(event,rc,prc){
		event.setView("main/results");
	}
	
	function print(event,rc,prc){
		prc.categoryList = rulesService.getCategories();
		event.setView("main/print");
	}


	function run(event,rc,prc){
		// increase timeout for checking
		cfsetting( requestTimeout=5000 );
		var sTime = getTickCount();
		// param incoming data
		param name="rc.categories" default="";
		prc.errors = [];

		// verify categories
		if ( NOT structKeyExists( rc, "categories" ) ) {
			arrayAppend(
				prc.errors,
				{
					field 	= "categories",
					message = "You must select at least one category."
				}
			);
		}

		// Verify checked files
		if ( NOT len( trim( rc.txaCheckFiles ) ) ) {
			arrayAppend(
				prc.errors,
				{
					field 	= "txaCheckFiles",
					message = "You must provide at least one file path or directory."
				}
			);
		}

		// Check for errors
		if ( arrayLen( prc.errors ) ) {
			return index( argumentCollection=arguments );
		}
		else {
			prc.checkFiles 		= listToArray( rc.txaCheckFiles, "#chr(10)#, #chr(13)#" );
			prc.checkedFiles 	= [];
			prc.failedFiles 	= [];
			prc.results 		= [];

			// setup categories
			codeCheckerService.setCategories( rc.categories );

			for ( var originalCheckFile in prc.checkFiles ) {
				if ( directoryExists( originalCheckFile ) or fileExists( originalCheckFile ) ) {
					var resultsCodeChecker = codeCheckerService.startCodeReview( filepath=originalCheckFile );
					arrayAppend( prc.checkedFiles, originalCheckFile);
				} else {
					arrayAppend( prc.failedFiles, originalCheckFile );
				}
			}

			prc.results = codeCheckerService.getResults();
			session.results = prc.results;
			session.categories = rc.categories;
			prc.executionTime = getTickCount() - stime;
			event.setView( "main/results" );
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

	function onException(event,rc,prc){
		//Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		//Place exception handler below:

	}

}
