-------------------------------------------------------------------------------
qpScanner v0.7



INSTALLATION
============
	
Extract all files to a directory in your webroot, then access in a browser.

Everything required is contained within the zip file, and no mappings nor
datasources need to be setup. 



ECLIPSE PLUGIN INSTALLATION
===========================

There is an Eclipse plugin available for QueryParam Scanner.

To install the plugin, please add the update site to Eclipse:

	http://eclipse.hybridchill.com/

Please consult the documentation that comes with the Plugin for further 
details on the Plugin and how to use it.



USAGE
=====

After launching QueryParam Scanner, you should see a Quick Start form:

	Select Config
		This allows you to choose between "default" or "paranoid" configs.
		The default config should be fine for most people.

	Starting Directory
		Where you put the location of the project(s) you wish to scan.
		This can be either an absolute path or a mapping.
	
	Recursive
		Indicates if you want qpScanner to look inside directories, or remain 
		at the current directory level. 


Once these are set as appropriate, press Scan and qpScanner will get to work.

As it finds queries with CF variables (ie: #values_in_hashes#) that are not 
inside a <cfqueryparam/> tag, it will list that file. The positions of the
queries are displayed when clicking on a file, and clicking on each of those
reveals the actual contents of the query.

When complete, it will list how many were found out of how many total queries.



NOTE: QueryParam Scanner should be used *only* in your development environment, 
not on a live/public box. In addition to the security risks, it might have an 
adverse affect on performance.



KNOWN ISSUES
============

This is a development release of QueryParam Scanner, and this list of issues
may not be a complete one. Always ensure you have a recent backup of your code.

There is one known issue with this version of qpScanner:

1. Incorrect Line Numbers With Identical Queries
If you have a file with multiple identical queries (same name/attributes/SQL),
QueryParam Scanner will report line numbers correctly for only the first of 
the queries.



SUPPORT
=======

For help or support, please see the project page at Hybridchill:
http://www.hybridchill.com/projects/qpscanner.html




CREDITS
=======

QueryParam Scanner is a project created and maintained by Peter Boughton.

It makes use of three other open-source projects:
- Java Regex Utilities       http://www.hybridchill.com/projects/jre-utils.html
- jQuery JavaScript library  http://www.jquery.com
- Fusebox Framework          http://www.fuseboxframework.org




LICENSING & VERSIONS
====================

GPL license (see included gpl-license.txt for details)
- qpScanner v0.7.0
- jre-utils v0.6.0
- jQuery v1.2.6

Apache 2 license (see fusebox5/LICENSE.txt for details)
- Fusebox v5.5.1



-------------------------------------------------------------------------------