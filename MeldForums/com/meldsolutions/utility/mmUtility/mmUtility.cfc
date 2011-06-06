﻿<!---
||MELDMANAGERLICENSE||
--->
<cfcomponent displayname="mmUtility" output="false">

	<cffunction name="init" access="public" output="false" returntype="mmUtility">
		<cfreturn this/>
	</cffunction>

	<cffunction name="isUUID" access="public" output="false" returntype="string">
		<cfargument name="value" type="string" required="true" />
	
		<cfreturn REFindNoCase("^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{16}$", value) />
	</cffunction>

	<cffunction name="createUUIDFromString" access="public" output="false" returntype="string">
		<cfargument name="value" type="string" required="true" />
		
		<cfset var hashString	= hash( arguments.value ) />
		<cfset var newUUID		= left(hashString,8) & "-" & mid(hashString,9,4) & "-" & "3" & mid(hashString,13,3) & "-" & right(hashString,16) />

		<cfreturn newUUID />
	</cffunction>

	<cffunction name="structMerge" access="public" output="false" returntype="struct">
		<cfargument name="aStruct" type="struct" required="true" />
		<cfargument name="bStruct" type="struct" required="true" />
	
		<cfset var iiX = "" />
	
		<cfloop collection="#arguments.bStruct#" item="iiX">
			<cfset arguments.aStruct[iiX] = arguments.bStruct[iiX] />
		</cfloop>

		<cfreturn arguments.aStruct />
	</cffunction>

	<cffunction name="structCompare" access="public" output="false" returntype="boolean">
		<cfargument name="aStruct" type="struct" required="true" />
		<cfargument name="bStruct" type="struct" required="true" />
	
		<cfset var iiX = "" />
	
		<cfloop collection="#arguments.aStruct#" item="iiX">
			<cfif not structKeyExists( arguments.aStruct,iiX )
				or not structKeyExists( arguments.bStruct,iiX )
				or arguments.aStruct[iiX] neq arguments.bStruct[iiX]>
				<cfreturn false>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfreturn true />
	</cffunction>

	<cffunction name="friendlyName" access="public" output="false" returntype="string">
		<cfargument name="sValue" type="string" required="true">
		
		<cfset var nValue = lcase(rereplace(trim(sValue),"[^[:alnum:]|-]{1,}","-","all")) />
		
		<cfreturn nValue>				
	</cffunction>

	<cffunction name="lowerStruct" access="public" output="false" returntype="struct">
		<cfargument name="sValue" type="struct" required="true">
		
		<cfset var sObj		= StructNew() />
		<cfset var iiX		= "" />
		
		<cfloop collection="#arguments.sValue#" item="iiX">
			<cfset sObj[lcase(iiX)] = arguments.sValue[iiX] />		
		</cfloop>
		
		<cfreturn sObj>				
	</cffunction>

	<cffunction name="stripHTML" access="public" returntype="string" output="false">
		<cfargument name="value" type="string" required="true">
	
		<cfset var sReturn = rereplace(trim(value),"<.[^<>]*>","","all")>

		<cfreturn sReturn>
	</cffunction>

	<cffunction name="cleanHTML" access="public" returntype="string" output="false">
		<cfargument name="value" type="string" required="true">
	
		<cfset var sReturn = rereplace(trim(value),"<","&lt;","all")>
		<cfset sReturn = rereplace(sReturn,">","&gt;","all")>

		<cfreturn sReturn>
	</cffunction>
</cfcomponent>