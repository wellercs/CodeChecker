component extends="coldbox.system.ioc.config.Binder"{
	
	function configure(){
		
		// Map Models Automatically with aliases
		mapDirectory( packagePath="codechecker.models" );
	}	

}