<cfcomponent output="false" displayname="qpscanner v0.7">

	<cffunction name="Struct" returntype="Struct" access="private"><cfreturn Arguments/></cffunction>

	<cffunction name="init" returntype="any" output="false" access="public">
		<cfargument name="jre"                   type="jre-utils"/>
		<cfargument name="StartingDir"           type="String"                  hint="Directory to begin scanning the contents of."/>
		<cfargument name="OutputFormat"          type="String"  default="html"  hint="Format of scan results: [html,wddx]"/>
		<cfargument name="RequestTimeout"        type="Numeric" default="-1"    hint="Override Request Timeout, -1 to ignore"/>
		<cfargument name="recurse"               type="Boolean" default="false" hint="Also scan sub-directories?"/>
		<cfargument name="Exclusions"            type="String"  default=""      hint="Exclude files & directories matching this regex."/>
		<cfargument name="scanOrderBy"           type="Boolean" default="true"  hint="Include ORDER BY statements in scan results?"/>
		<cfargument name="scanQoQ"               type="Boolean" default="true"  hint="Include Query of Queries in scan results?"/>
		<cfargument name="scanBuiltInFunc"       type="Boolean" default="true"  hint="Include Built-in Functions in scan results?"/>
		<cfargument name="showScopeInfo"         type="Boolean" default="true"  hint="Show scope information in scan results?"/>
		<cfargument name="highlightClientScopes" type="Boolean" default="true"  hint="Highlight scopes with greater risk?"/>
		<cfargument name="ClientScopes"          type="String"  default="form,url,client,cookie" hint="Scopes considered client scopes."/>
		<cfargument name="NumericFunctions"      type="String"  default="val,year,month,day,hour,minute,second,asc,dayofweek,dayofyear,daysinyear,quarter,week,fix,int,round,ceiling,gettickcount,len,min,max,pi,arraylen,listlen,structcount,listvaluecount,listvaluecountnocase,rand,randrange"/>
		<cfargument name="BuiltInFunctions"      type="String"  default="now,#Arguments.NumericFunctions#"/>

		<cfset var Arg = -1/>
		<cfset var RegexList = ""/>
		<cfset var Rex = ""/>
		<cfset var cf = 'cf'/>

		<cfloop item="Arg" collection="#Arguments#">
			<cfset This[Arg] = Arguments[Arg]/>
		</cfloop>

		<cfset Variables.jre = Arguments.jre/>
		<cfset StructDelete(This,'jre')/>

		<cfset This.Totals = Struct
			( AlertCount: 0
			, QueryCount: 0
			, FileCount : 0
			, DirCount  : 0
			, Time      : 0
			)/>

		<cfset This.Timeout = false/>

		<cfset Variables.ResultFields = "FileId,FileName,QueryAlertCount,QueryTotalCount,QueryId,QueryName,QueryStartLine,QueryEndLine,ScopeList,ContainsClientScope,QueryCode"/>
		<cfset Variables.AlertData = QueryNew(Variables.ResultFields)/>

		<cfsavecontent variable="RegexList"><cfoutput>
			findQueries      |(?si)(<#cf#query[^p]).*?(?=</#cf#query>)
			findQueryTag     |(?si)(<#cf#query[^p][^>]{0,300}>)
			isQueryOfQuery   |(?si)dbtype\s*=\s*["']query["']
			killParams       |(?si)<#cf#queryparam[^>]+>
			killCfTag        |(?si)<#cf#[a-z]{2,}[^>]*> <!--- Deliberately excludes Custom Tags and CFX --->
			killOrderBy      |(?si)\bORDER BY\b.*?$
			killBuiltIn      |(?si)##(#ListChangeDelims(This.BuiltInFunctions,'|')#)\([^)]*\)##
			findScopes       |(?si)(?<=##([a-z]{1,20}\()?)[^\(##<]+?(?=\.[^##<]+?##)
			findName         |(?si)(?<=(<#cf#query[^>]{0,300}\bname=")).*?(?="[^>]{0,300}>)
			findClientScopes |(?i)\b(#ListChangeDelims(This.ClientScopes,'|')#)\b
			isCfmlFile       |(?i)\.cf(c|ml?)$
		</cfoutput></cfsavecontent>

		<cfloop index="Rex" list="#RegexList#" delimiters="#Chr(10)#">
			<cfif Len(Trim(Rex))>
				<cfset Variables.Regexes[ Trim(ListFirst(Rex,'|')) ] = Trim(ListRest(Rex,'|'))/>
			</cfif>
		</cfloop>

		<cfreturn This/>
	</cffunction>



	<cffunction name="go" returntype="any" output="false" access="public">
		<cfset var StartTime = getTickCount()/>

		<cfif This.RequestTimeout GT 0>
			<cfsetting requesttimeout="#This.RequestTimeout#"/>
		</cfif>

		<cftry>
			<cfset scan(This.StartingDir)/>

			<!--- TODO: MINOR: CHECK: Is this the best way to handle this? --->
			<!--- If timeout occurs, ignore error and proceed. --->
			<cfcatch>
				<cfif find('timeout',cfcatch.message)>
					<cfset This.Timeout = True/>
				<cfelse>
					<cfrethrow/>
				</cfif>
			</cfcatch>
		</cftry>

		<cfset This.Totals.Time = getTickCount() - StartTime/>
		<cfreturn Struct
			( Data : Variables.AlertData
			, Info : Struct
				( Totals  : This.Totals
				, Timeout : This.Timeout
				)
			)/>
	</cffunction>



	<cffunction name="scan" returntype="void" output="false" access="public">
		<cfargument name="DirName"           type="string"/>
		<cfset var qryDir     = -1/>
		<cfset var qryCurData = -1/>
		<cfset var CurrentTarget = -1/>
		<cfset var process = true/>
		<cfset var jre = Variables.jre/>

		<cfif DirectoryExists(Arguments.DirName)>

			<cfdirectory
				name="qryDir"
				directory="#Arguments.DirName#"
				sort="type ASC,name ASC"
			/>

			<cfloop query="qryDir">

				<cfset CurrentTarget = Arguments.DirName & '/' & Name />


				<cfset process = true/>
				<cfloop index="CurrentExclusion" list="#This.Exclusions#" delimiters=";">
					<cfif jre.matches( CurrentTarget , CurrentExclusion )>
						<cfset process = false/>
					</cfif>
				</cfloop>

				<cfif process>

					<cfif (Type EQ "dir") AND This.recurse >
						<cfset This.Totals.DirCount = This.Totals.DirCount + 1 />

						<cfset scan( CurrentTarget )/>

					<cfelseif jre.matches( CurrentTarget , Variables.Regexes.isCfmlFile )>
						<cfset This.Totals.FileCount = This.Totals.FileCount + 1 />

						<cfset qryCurData = hunt( CurrentTarget )/>

						<cfif qryCurData.RecordCount>
							<cfset Variables.AlertData = QueryAppend( Variables.AlertData , qryCurData )/>
						</cfif>

					</cfif>

				</cfif>
			</cfloop>

		<!--- This can only potentially trigger on first iteration, if This.StartingDir is a file. --->
		<cfelseif FileExists(Arguments.DirName)>
			<cfset This.Totals.FileCount = This.Totals.FileCount + 1 />

			<cfset qryCurData = hunt( This.StartingDir )/>

			<cfif qryCurData.RecordCount>
				<cfset Variables.AlertData = QueryAppend( Variables.AlertData , qryCurData )/>
			</cfif>
		</cfif>

	</cffunction>




	<cffunction name="hunt" returntype="Query" output="false">
		<cfargument name="FileName"    type="String"/>
		<cfset var FileData        = -1/>
		<cfset var Matches         = -1/>
		<cfset var i               = -1/>
		<cfset var info            = -1/>
		<cfset var rekCode         = -1/>
		<cfset var QueryCode       = -1/>
		<cfset var CurRow          = -1/>
		<cfset var CurFileId       = -1/>
		<cfset var StartLine       = -1/>
		<cfset var LineCount       = -1/>
		<cfset var BeforeQueryCode = -1/>
		<cfset var isRisk          = -1/>
		<cfset var UniqueToken = Chr(65536)/>
		<cfset var qryResult   = QueryNew(Variables.ResultFields)/>
		<cfset var REX = Variables.Regexes/>
		<cfset var jre = Variables.jre/>


		<cffile action="read" file="#Arguments.FileName#" variable="FileData"/>

		<cfset Matches = jre.get( FileData , REX.findQueries )/>
		<cfset This.Totals.QueryCount = This.Totals.QueryCount + ArrayLen(Matches) />

		<cfloop index="i" from="1" to="#ArrayLen(Matches)#">

			<cfset QueryCode = jre.replace( Matches[i] , REX.findQueryTag , '' , 'ALL' )/>
			<cfset rekCode = duplicate(QueryCode) />
			<cfset rekCode = jre.replace( rekCode    , REX.killParams , '' , 'ALL' )/>
			<cfset rekCode = jre.replace( rekCode    , REX.killCfTag  , '' , 'ALL' )/>

			<cfif NOT This.scanOrderBy>
				<cfset rekCode = jre.replace( rekCode , REX.killOrderBy , '' , 'ALL' )/>
			</cfif>
			<cfif NOT This.scanBuiltInFunc>
				<cfset rekCode = jre.replace( rekCode , REX.killBuiltIn , '' , 'ALL' )/>
			</cfif>

			<cfset isRisk = find( '##' , rekCode )/>


			<cfif (NOT This.scanQoQ) AND jre.matches( Matches[i] , REX.isQueryOfQuery )>
				<cfset isRisk = false/>
			</cfif>


			<cfif isRisk>
				<cfset CurRow = QueryAddRow(qryResult)/>

				<cfset qryResult.QueryCode[CurRow] = jre.replace( QueryCode , Chr(13) , Chr(10) , 'all' ) />
				<cfset qryResult.QueryCode[CurRow] = jre.replace( qryResult.QueryCode[CurRow] , Chr(10)&Chr(10) , Chr(10) , 'all' ) />
				<cfif This.showScopeInfo >
					<cfset qryResult.ScopeList[CurRow] = ArrayToList( ArrayUnique( jre.get( qryResult.QueryCode[CurRow] , REX.findScopes ) ) ) />

					<cfset qryResult.ContainsClientScope[CurRow] = false/>
					<cfif This.highlightClientScopes>
						<cfloop index="CurrentScope" list="#This.ClientScopes#">
							<cfif ListFind( qryResult.ScopeList[CurRow] , CurrentScope )>
								<cfset qryResult.ContainsClientScope[CurRow] = true/>
								<cfbreak/>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>

				<!--- CF8 doesn't support get()[1] so need to use two lines: --->
				<cfset QueryTagCode = jre.get( Matches[i] , REX.findQueryTag )/>
				<cfset QueryTagCode = QueryTagCode[1] />

				<cfset BeforeQueryCode = ListFirst ( replace ( ' '&FileData&' ' , Matches[i] , UniqueToken ) , UniqueToken )/>


				<cfset StartLine = 1+ArrayLen( jre.get( BeforeQueryCode , chr(10) ) )/>
				<cfset LineCount = ArrayLen( jre.get( Matches[i] , chr(10) ) )/>


				<cfset qryResult.QueryStartLine[CurRow] = StartLine/>
				<cfset qryResult.QueryEndLine[CurRow]   = StartLine + LineCount />
				<cfset qryResult.QueryName[CurRow]      = ArrayToList( jre.get( ListLast(QueryTagCode,chr(10)) , REX.findName ) )/>
				<cfset qryResult.QueryId[CurRow]        = createUuid() />
				<cfif NOT Len( qryResult.QueryName[CurRow] )>
					<cfset qryResult.QueryName[CurRow] = "[unknown]"/>
				</cfif>

			</cfif>

		</cfloop>

		<cfset CurFileId = createUUID()/>
		<cfloop query="qryResult">
			<cfset qryResult.FileId[qryResult.CurrentRow]          = CurFileId />
			<cfset qryResult.FileName[qryResult.CurrentRow]        = Arguments.FileName />
			<cfset qryResult.QueryTotalCount[qryResult.CurrentRow] = ArrayLen(Matches) />
			<cfset qryResult.QueryAlertCount[qryResult.CurrentRow] = qryResult.RecordCount />
		</cfloop>
		<cfset This.Totals.AlertCount = This.Totals.AlertCount + qryResult.RecordCount />

		<cfreturn qryResult/>
	</cffunction>








	<cffunction name="ArrayUnique" returntype="Array" output="false" access="private">
		<cfargument name="ArrayVar" type="Array"/>
		<cfset var UniqueToken = Chr(65536)/>
		<cfset var Result = duplicate(Arguments.ArrayVar)/>
		<cfset ArraySort(Result,'text')/>
		<cfset Result = ArrayToList( Result , UniqueToken )/>
		<!--- TODO: MINOR: FIX: Using \b works for the ScopeList, but is not good enough for general use - why not using UniqueToken? --->
		<cfset Result = REreplace( Result & UniqueToken , '(\b(.*?)\b)\1+' , '\1' , 'all' )/>
		<cfset Result = ListToArray( Result , UniqueToken )/>
		<!--- TODO: MINOR: Ideally, the original array order should be restored. --->
		<cfreturn Result/>
	</cffunction>



	<cffunction name="QueryAppend" returntype="Query" output="false" access="private">
		<cfargument name="QueryOne" type="Query"/>
		<cfargument name="QueryTwo" type="Query"/>
		<cfset var Result = -1/>
		<!--- Bug fix for CF8 --->
		<cfif NOT Arguments.QueryOne.RecordCount><cfreturn Arguments.QueryTwo /></cfif>
		<cfif NOT Arguments.QueryTwo.RecordCount><cfreturn Arguments.QueryOne /></cfif>
		<!--- / --->
		<cfquery name="Result" dbtype="Query">
			SELECT * FROM Arguments.QueryOne
			UNION SELECT * FROM Arguments.QueryTwo
		</cfquery>
		<cfreturn Result/>
	</cffunction>




</cfcomponent>