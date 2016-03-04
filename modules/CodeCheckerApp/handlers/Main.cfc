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
		prc.resultsCacheKey 	= "results_" & rc.key;
		prc.categoriesCacheKey	= "categories_" & rc.key;
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
			prc.uuid 				= createUUID();
			prc.checkFiles 			= listToArray( rc.txaCheckFiles, "#chr(10)#, #chr(13)#" );
			prc.checkedFiles 		= [];
			prc.failedFiles 		= [];
			prc.results 			= [];
			prc.resultsCacheKey 	= "results_" & prc.uuid;
			prc.categoriesCacheKey	= "categories_" & prc.uuid;

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
			cachebox.getCache("default").set(prc.resultsCacheKey, prc.results, 60, 20); // set in cache with 60 minute timeout and 20 minute idle timeout
			cachebox.getCache("default").set(prc.categoriesCacheKey, rc.categories, 60, 20); // set in cache with 60 minute timeout and 20 minute idle timeout
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
		// Log the exception via LogBox
		log.error( prc.exception.getMessage() & prc.exception.getDetail(), prc.exception.getMemento() );

		// Flash where the exception occurred
		flash.put("exceptionURL", event.getCurrentRoutedURL() );

		// Relocate to fail page
		// setNextEvent("main.fail");
	}

}
