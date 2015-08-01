component {

	function preProcess( event ) {
		// using structAppend for ACF9 support
		structAppend(
			event.getCollection( private=true ),
			{
				"appName" = getSetting( 'appName' ),
				"pageTitle" = getSetting( 'appName' ),
				"pageDescription" = getSetting( 'appDescription' ),
				"pageAuthor" = getSetting( 'appAuthor' )
			}
		);
	}

}