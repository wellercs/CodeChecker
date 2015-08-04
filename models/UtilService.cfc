<cfcomponent singleton>

  <cfset this.name = "UtilService" />

  <cffunction name="init" access="public" output="false">
    <cfreturn this />
  </cffunction>

  <cffunction name="_invoke" access="public" returntype="any" output="false">
    <cfargument name="obj" type="any" required="true" hint="I am the component to call." />
    <cfargument name="fn" type="string" required="true" hint="I am the function to call." />
    <cfargument name="args" type="any" required="false" default="#structNew()#" hint="I am the argument collection to pass to the function." />
    
    <cfinvoke component="#arguments.obj#" method="#arguments.fn#" argumentcollection="#arguments.args#" returnvariable="local.return_variable" />

    <cfreturn local.return_variable />
  </cffunction>

</cfcomponent>