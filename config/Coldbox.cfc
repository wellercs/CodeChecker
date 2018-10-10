component{

	function configure(){

		coldbox = {
		};

		settings = {
			appName 		= "CodeChecker",
			appDescription	= "A package for checking code quality.",
			appAuthor		= "Chris Weller"
		};

		environments = {
			development = "localhost,127\.0\.0\.1"
		};

		logBox = {
			// Define Appenders
			appenders = {
				coldboxTracer = { class="coldbox.system.logging.appenders.ConsoleAppender" }
			},
			// Root Logger
			root = { levelmax="INFO", appenders="*" },
			// Implicit Level Categories
			info = [ "coldbox.system" ]
		};

		interceptors = [
			{ class="codechecker.interceptors.GlobalPreProcessor" }
		];

	}

	function development(){
		coldbox.handlersIndexAutoReload = true;
		coldbox.handlerCaching = false;
		coldbox.reinitPassword = "";
		coldbox.customErrorTemplate = "/coldbox/system/includes/BugReport.cfm";
	}

}