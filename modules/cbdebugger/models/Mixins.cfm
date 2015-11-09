<cfscript>
	/**
	* Method to turn on the rendering of the debug panel on a reqquest
	*/
	any function showDebugger(){
		getRequestContext().setValue( name="cbox_debugger_show", value=true, private=true );
		return this;
	}

	/**
	* Method to turn off the rendering of the debug panel on a reqquest
	*/
	any function hideDebugger(){
		getRequestContext().setValue( name="cbox_debugger_show", value=false, private=true );
		return this;
	}

	/**
	* See if the debugger will be rendering or not
	*/
	boolean function isDebuggerRendering(){
		return getRequestContext().getValue( name="cbox_debugger_show", private=true, defaultValue=true );
	}
</cfscript>