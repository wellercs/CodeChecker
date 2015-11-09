/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component {

	// Module Properties
	this.title 				= "ColdBox Debugger";
	this.author 			= "Curt Gratz";
	this.webURL 			= "http://www.coldbox.org";
	this.description 		= "The ColdBox Debugger Module";
	this.version			= "1.1.0+00028";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbdebugger";
	// CF Mapping
	this.cfMapping			= "cbdebugger";
	// Model Namespace
	this.modelNamespace		= "cbdebugger";
	// Auto Map Models Directory
	this.autoMapModels		= true;

	/**
	* Module Registration
	*/
	function configure(){
		// Mixin our own methods on handlers, interceptors and views via the ColdBox UDF Library File setting
		arrayAppend( controller.getSetting( "ApplicationHelper" ), "#moduleMapping#/models/Mixins.cfm" );
	}

	/**
	* Load the module
	*/
	function onLoad(){
		var settings = controller.getConfigSettings();
		// parse parent settings
		parseParentSettings();

		//default the password to something so we are secure by default
		if( settings.debugger.debugPassword eq "cb:null" ){
			settings.debugger.debugPassword = hash( getCurrentTemplatePath() );
		} else if ( len( settings.debugger.debugPassword ) ) {
			// hash the password into memory
			settings.debugger.debugPassword = hash( settings.debugger.debugPassword );
		}

		// set debug mode?
		wirebox.getInstance( "debuggerService@cbDebugger" )
			.setDebugMode( settings.debugger.debugMode );

		// Register the interceptor, it has to be here due to loading of configuration files.
		controller.getInterceptorService()
			.registerInterceptor( 
			interceptorClass="#moduleMapping#.interceptors.Debugger",
			interceptorName="debugger@cbdebugger"
		);
	}

	/**
	* Unloading
	*/
	function onUnload(){
		// unregister interceptor
		controller.getInterceptorService().unregister( interceptorName="debugger@cbdebugger" );
		
		// Remove application helper
		var appHelperArray 	= controller.getSetting( "ApplicationHelper" );
		var mixinToRemove 	= "#moduleMapping#/models/Mixins.cfm";
		var mixinIndex 		= arrayFindNoCase( appHelperArray, mixinToRemove );
		
		// If the mixin is in the array
		if( mixinIndex ) {
			// Remove it
			arrayDeleteAt( appHelperArray, mixinIndex );
			// Arrays passed by value in Adobe CF
			controller.setSetting( "ApplicationHelper", appHelperArray );
		}
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var debuggerDSL 	= oConfig.getPropertyMixin( "debugger", "variables", structnew() );

		//defaults
		configStruct.debugger = {
			debugMode = false,
			debugPassword = "cb:null",
			enableDumpVar = true,
			persistentRequestProfiler = true,
			maxPersistentRequestProfilers = 10,
			maxRCPanelQueryRows = 50,
			showTracerPanel = true,
			expandedTracerPanel = true,
			showInfoPanel = true,
			expandedInfoPanel = true,
			showCachePanel = true,
			expandedCachePanel = false,
			showRCPanel = true,
			expandedRCPanel = false,
			showModulesPanel = true,
			expandedModulesPanel = false,
			showRCSnapshots = false,
			wireboxCreationProfiler=false
		};

		// incorporate settings
		structAppend( configStruct.debugger, debuggerDSL, true );
	}
}
