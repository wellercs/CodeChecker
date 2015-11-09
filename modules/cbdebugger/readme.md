#WELCOME TO THE COLDBOX DEBUGGER MODULE
This module will enhance your application with debugger capabilities, a nice debugging panel and much more to make your ColdBox application development nicer, funer and greater! Yes, funer is a word!

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS
- https://github.com/ColdBox/cbox-debugger
- http://www.coldbox.org/forgebox/view/cbdebugger

##SYSTEM REQUIREMENTS
- Lucee 4.5+
- Railo 4+
- ColdFusion 9+

#INSTRUCTIONS

Just drop into your **modules** folder or use CommandBox to install

`box install cbdebugger`

This will activate the debugger in your application and render out at the end of a request.  

## Settings
This will also allow you to use several settings in your parent application or you can modify the settings in the `ModuleConfig` if desired. We recommend placing your debugger settings in your main `ColdBox.cfc` configuration file under a `debugger` struct.

```js
// Debugger Settings
debugger = {
    // Activate debugger for everybody
    debugMode = true,
    // Setup a password for the panel
    debugPassword = "",
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
```

## WireBox Mappings
The module will also register two model objects for you:

* `debuggerService@cbdebugger`
* `timer@cbdebugger`

The `DebuggerService` can be used a-la-carte for your debugging purposes.
The `Timer` object will allow you to time code execution and send the results to the debugger panel.

## Mixins

This module will also register a few methods in all your handlers/interceptors/layouts and views:

```js
/**
* Method to turn on the rendering of the debug panel on a reqquest
*/
any function showDebugger()

/**
* Method to turn off the rendering of the debug panel on a reqquest
*/
any function hideDebugger()

/**
* See if the debugger will be rendering or not
*/
boolean function isDebuggerRendering()
```


## LogBox Appender

This module also comes with a LogBox appender called `cbdebugger.includes.appenders.ColdBoxTracerAppender` so your application can log to the debugger's tracer.  You won't be able to configure the appender in your main LogBox configuration since modules aren't loaded until after LogBox is already created.  What you can do though is add the appender programmatically to LogBox using the `afterConfigurationLoad` interception point.  Here's an example of what that might look like:


```js
// This appender is part of a module, so we need to register it after the modules have been loaded.
function afterConfigurationLoad() {
    var logBox = controller.getLogBox();
    logBox.registerAppender( 'tracer', 'cbdebugger.includes.appenders.ColdBoxTracerAppender' );
    var appenders = logBox.getAppendersMap( 'tracer' );
    
    // Register the appender with the root loggger, and turn the logger on.
    var root = logBox.getRootLogger();
    root.addAppender( appenders['tracer'] );
    root.setLevelMax( 4 );
    root.setLevelMin( 0 );
}
```



********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
####HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12