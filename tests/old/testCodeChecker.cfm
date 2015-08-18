<cfscript>
	isDefined("variables.test");
</cfscript>
<cfabort>
<cfscript>
	abort;
</cfscript>
<cfdump var="#server#">
<cfscript>
	writeDump(server);
</cfscript>
<cflog text="">
<cfscript>
	writeLog();
</cfscript>
<cfscript>
	console.log();
</cfscript>
<cfquery name="qry" datasource="#arguments.dsn#">
</cfquery>
<cfscript>
	evaluate();
</cfscript>
<cfscript>
	de();
</cfscript>
<cfscript>
	iif();
</cfscript>
<cfscript>
	structfind();
</cfscript>
<cfscript>
	decrementvalue();
</cfscript>
<cfscript>
	incrementvalue();
</cfscript>
<cfif x is "test">
</cfif>
<cfif x is 'test'>
</cfif>
<cfif x is ''>
</cfif>
<cfif x is "">
</cfif>
<cfif x eq ''>
</cfif>
<cfif x eq "">
</cfif>
<cfif x is not ''>
</cfif>
<cfif x is not "">
</cfif>
<cfif x neq ''>
</cfif>
<cfif x neq "">
</cfif>
<cfset client.test = "">
<cfif x is true>
</cfif>
<cfif x is not true>
</cfif>
<cfif x is false>
</cfif>
<cfif x is not false>
</cfif>
<cfif x is 0>
</cfif>
<cfif x is not 0>
</cfif>
<cfif x eq "a">
</cfif>
<cfif x eq "0">
</cfif>
<cfif x neq "a">
</cfif>
<cfif x neq "0">
</cfif>
<cfset x = x + "0">
<cfset x = x - "0">
<cfset x = x * "0">
<cfset x = x / "0">
<cfset x = x % "0">
<cfset x = x & 0>
<cffile type="upload" action="upload" destination="#getTempDirectory()#">
</cffile>
<cfset variables.dsnname = "">
<cflock scope="session" type="exclusive" timeout="15">
	<cflock scope="session" type="exclusive" timeout="15">
	</cflock>
</cflock>
<cflocation url="">
<cfset newArray = ArrayNew()>
<cfset newArray1 = ArrayNew(1)>
<cfscript>
	parameterExists(variables.test);
</cfscript>
<cfscript>
	setVariable(variables.test, "this is just a test");
</cfscript>