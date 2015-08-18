CodeChecker
============

INSTRUCTIONS
=============

Deploy this application to any web-accessible directory.

Rules may be added or modified in the app/services/Rules.cfc file.

Third party plugins are packaged in app/services/.

Visit <your-web-root>/CodeChecker/app/index.cfm to begin via the UI.

To specify directories and/or files to review/check, use the check files form (frm_codechecker.cfm) and separate entries by a carriage return.

Alternatively, only the services directory is required for running the application outside of the browser.

To run CodeChecker outside of the browser, call the following:
* Component: /services/CodeChecker
* Function: startCodeReview
* Parameters:
- filepath (required string): the directory or file path for which to review
- recurse (optional boolean): flag for whether or not to review recursively

Call getResults() to return an array of structs of the code check results.

DOCUMENTATION
=============

- APPLICATION STRUCTURE

This application uses a basic MVC structure.

The heart of the application resides in the "services" directory. This is where the code checker and rules engines can be found. Third party plugins also reside in services.

Resources such as css, javascript, images, etc. reside in the "assets" directory.

The "model" directory contains files "action" files for the view layer.

The "view" directory contains the UI for the results table and check files form (frm_codechecker.cfm).

If you only want to run CodeChecker without a web UI, you only need the services directory.

- SERVICES LAYER

CodeChecker.cfc is the object that checks and enforces the defined rules. The default check function uses REFindNoCase().

Rules.cfc is the object defining the code check rules.

Initial categories of rules are:
* Security
* Performance
* Standards
* Maintenance

Initial metadata for rules include:
* bulkcheck - boolean value of whether to check the entire file in one pass (true) or line-by-line (false)
* category - string value corresponding to one of the categories listed above or your own custom category
* componentname - string value of the check component name to call in the dynamic cfinvoke
* customcode - currently does not do anything but considering using this as an option to run custom code instead of always using the regular expression pattern
* extensions - comma-delimited list of file extensions of files to check
* functionname - string value of the check function name to call in the dynamic cfinvoke
* message - string value of the explanation of the rule
* name - string value of the title of the rule
* passonmatch - boolean value of whether to pass or fail if a match is found
* pattern - string value of the regular expression of the rule
* severity - value of the severity level of the broken rule (default values are 1-5)
* tagname - pipe delimited list of ColdFusion tags that directs the checker to run the rule only if the line contains one of the specified tags

Third party plugins are supported for additional rules.

Currently integrated third party plugins include:

* QueryParamScanner by Peter Boughton
* VarScoper by Mike Schierberl

These plugins are automatically ran by CodeChecker.

- VIEW LAYER

To specify directories and/or files to review/check, use the check files form (frm_codechecker.cfm) and separate entries by a carriage return.

The results of the code check are returned as an array of structs and will be displayed in a table (dsp_codechecker.cfm). The results page will show exceptions to the defined rules as well as display any failed files/directories that were not checked (i.e., missing files).

Results display the following exception data:
* Directory
* File
* Rule
* Message
* Line Number
* Category
* Severity

- TESTS

The "tests" directory contains test files containing intentionally broken rules.

MXUnit tests will be written in the future.

- CUSTOMIZATION

Any of the default rules can be modified or deleted.

To add a new rule, simply copy one of the "temprulestruct" blocks of code and paste it below another block.
Be sure to set temprulestruct to an empty structure to clear out the data for any previously defined rules.
Also ensure that the bottom of your block appends temprulestruct to the "rules" array.

CREDITS
=======

Steve Bryant for inspiring this project with his CodeCop application.
http://codecop.riaforge.org/

Peter Boughton for the QueryParamScanner cfc.
http://qpscanner.riaforge.org/

Mike Schierberl for the VarScoper cfc.
http://varscoper.riaforge.org/

RELEASE NOTES
=============

1.0 - 2013/06/01 - Initial release

1.0.1 - 2013/06/03 - modified "Use Len method" rule pattern (replaced double quotes with octal value 042 to eliminate false
positives; added octal 047 for single quote expressions); modified ArrayNew(1) rule message

