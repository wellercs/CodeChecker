<cfcomponent output="false">


	<cffunction name="init" returntype="any" output="false" access="public">
		<cfargument name="jre"             type="jre-utils"/>
		<cfargument name="ConfigDirectory" type="String"/>

		<cfset Variables.jre = Arguments.jre/>

		<cfset This.ConfigDirectory = Arguments.ConfigDirectory/>

		<cfreturn This/>
	</cffunction>


	<cffunction name="read" returntype="any" output="false" access="public">
		<cfargument name="ConfigId" type="String"/>
		<cfargument name="Format"   type="String" default="default" />
		<cfset var Setting = QueryNew("id,label,type,options,value,hint")/>
		<cfset var Sections = -1/>
		<cfset var SectionList = -1/>
		<cfset var CurSection = -1/>
		<cfset var CurSetting = -1/>
		<cfset var X = -1/>
		<cfset var Result = -1/>
		<cfset var RootConfigFile = This.ConfigDirectory&'/../config.ini' />
		<cfset var ThisConfigFile = lcase( REreplace( Arguments.ConfigId , '\W+' , '' , 'all' ) ) />
		<cfset ThisConfigFile = This.ConfigDirectory & '/#Arguments.ConfigId#.ini'/>

		<cfif FileExists( ThisConfigFile )>

			<cfset Sections = getProfileSections( RootConfigFile )/>
			<cfset SectionList = getProfileString( RootConfigFile ,'Config' , 'keys' )/>

			<cfloop index="CurSection" list="#SectionList#">
				<cfset X = QueryAddRow(Setting)/>
				<cfset Setting['Id'][X] = CurSection />
				<cfloop index="CurSetting" list="#Sections[CurSection]#">
					<cfset Setting[CurSetting][X] = getProfileString( RootConfigFile , CurSection , CurSetting )/>
				</cfloop>
			</cfloop>

			<cfloop query="Setting">
				<cfset Setting['Value'][CurrentRow] = getProfileString( ThisConfigFile , 'Settings' , Id )/>
			</cfloop>


			<cfswitch expression="#Arguments.Format#">
				<cfcase value="Struct">
					<cfset Result = StructNew()/>
					<cfloop query="Setting">
						<cfset Result[Id] = Value />
					</cfloop>
					<cfreturn Result/>
				</cfcase>
				<cfdefaultcase>
					<cfreturn Setting/>
				</cfdefaultcase>
			</cfswitch>
		<cfelse>
			<cfthrow
				message="Invalid Value '#Arguments.ConfigId#' for Argument ConfigId."
				detail="Cannot find configuration file at '#ConfigFile#'."
				type="qpscanner.Settings.Read.InvalidArgument.ConfigId"
			/>
		</cfif>
	</cffunction>



	<cffunction name="findHomeDirectory" returntype="String" output="false">
		<cfset var Result = ""/>
		<cfset var CurDir = -1/>
		<cfset var DirList = "{home-directory},/,."/>
		<cfset var jre = Variables.jre/>

		<cfloop index="CurDir" list="#DirList#">
			<cfif DirectoryExists( expandPath(CurDir) )>
				<cfset Result = expandPath( CurDir )/>
				<cfbreak/>
			</cfif>
		</cfloop>

		<cfset Result = jre.replace( Result , '[\\/]+' , '/' , 'all' )/>
		<cfset Result = jre.replace( Result , '(<!(:))/$' , '' )/>

		<cfreturn Result/>
	</cffunction>


</cfcomponent>