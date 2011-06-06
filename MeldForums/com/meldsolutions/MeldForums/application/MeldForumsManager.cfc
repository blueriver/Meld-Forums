﻿<!---
||MELDForumsLICENSE||
--->
<cfcomponent displayname="MeldForumsManager" output="false">

	<cfset variables.instance = StructNew()>

	<cffunction name="init" returntype="MeldForumsManager" access="public" output="false">
		<cfset variables.settings = StructNew() />
		
		<cfreturn this>
	</cffunction>

	<cffunction name="getMeldBean" returntype="any" access="public" output="false">
		<cfreturn createObject("component","MeldForums.com.meldsolutions.core.MeldBean")>
	</cffunction>

	<cffunction name="hasForums" returntype="boolean" access="public" output="false">
		<cfargument name="$" />
		<cfargument name="moduleID" />
		<cfargument name="contentHistID" />

		<cfset var qHasForums = "" />

		<cfset var pluginEvent 		= getMeldForumsEventManager().createEvent($) />
		<cfset var ident			= "" />

		<cfset pluginEvent.setValue("siteID", $.event().getValue('siteID') ) />
		<cfset pluginEvent.setValue("moduleID", arguments.moduleID ) />
		<cfset pluginEvent.setValue("contentHistID", arguments.contentHistID ) />
		<cfset pluginEvent.setValue("hasForums", "" ) />

		<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsGetHasForums",pluginEvent)>

		<cfif isBoolean( pluginEvent.getValue( "hasForums" ) )>
			<cfreturn pluginEvent.getValue( "hasForums" ) >
		</cfif>		

		<cfquery name="qHasForums" datasource="#$.globalConfig().getDatasource()#" username="#$.globalConfig().getDBUsername()#" password="#$.globalConfig().getDBPassword()#">
			SELECT
				tco.contentID
			FROM
				tcontentobjects tco
			JOIN
				tplugindisplayobjects tpdo
			ON
				(tco.objectID = tpdo.objectID)
			WHERE
				tpdo.moduleID = <cfqueryparam value="#arguments.moduleID#" CFSQLType="cf_sql_char" maxlength="35" />
			AND
				tco.contentHistID = <cfqueryparam value="#arguments.contentHistID#" CFSQLType="cf_sql_char" maxlength="35" />
		</cfquery>
	
		<cfif qHasForums.recordCount>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="processIntercept" returntype="any" access="public" output="false">
		<cfargument name="$" />
		<cfargument name="aIntercept" type="array" required="true" />

		<cfset var pluginEvent 		= getMeldForumsEventManager().createEvent($) />
		<cfset var ident			= "" />

		<cfif not ArrayLen( aIntercept )>
			<cfreturn />
		</cfif>

		<cfset MeldForumsBean	= getMeldForumsRequestManager().getMeldForumsBean($,true) />
		<cfset MeldForumsBean.setIntercept( aIntercept ) />

		<cfset pluginEvent.setValue("siteID", $.event().getValue('siteID') ) />

		<cfswitch expression="#aIntercept[1]#">
			<cfcase value="profile">
				<cfset url.action = "profile" />
				<cfif ArrayLen(aIntercept) gt 0>
					<cfset url.action = "profile.#aIntercept[2]#" />
				</cfif>

				<cfset pluginEvent.setValue("intercept",aIntercept) />
				<cfset pluginEvent.setValue("action",url.action) />
				<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsProfileRequest",pluginEvent)>
				<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
			</cfcase>
			<cfcase value="thread">
				<cfset url.action = "thread" />
				<cfif len(aIntercept[2]) neq 35>
					<cfset pluginEvent.setValue("action",url.action & "." & aIntercept[2]) />
				<cfelse>
					<cfset pluginEvent.setValue("action",url.action) />
				</cfif>
				<cfset pluginEvent.setValue("intercept",aIntercept) />
				<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsThreadRequest",pluginEvent)>
				<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
			</cfcase>
			<cfcase value="post">
				<cfset url.action = "post" />
				<cfset pluginEvent.setValue("intercept",aIntercept) />
				<cfif len(aIntercept[2]) neq 35>
					<cfset pluginEvent.setValue("action",url.action & "." & aIntercept[2]) />
				<cfelse>
					<cfset pluginEvent.setValue("action",url.action) />
				</cfif>
				
				<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsPostRequest",pluginEvent)>
				<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
			</cfcase>
			<cfcase value="forum">
				<cfset url.action = "forum" />

				<cfset pluginEvent.setValue("intercept",aIntercept) />
				<cfset pluginEvent.setValue("action",url.action) />
				<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsForumRequest",pluginEvent)>
				<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
			</cfcase>
			<cfcase value="conference">
				<cfset url.action = "conference" />
				<cfset pluginEvent.setValue("intercept",aIntercept) />
				<cfset pluginEvent.setValue("action",url.action) />
				<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsConferenceRequest",pluginEvent)>
				<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
			</cfcase>
			<cfcase value="do">
				<cfset url.action = "do" />
				<cfif ArrayLen(aIntercept) gt 0>
					<cfset pluginEvent.setValue("call",aIntercept[2]) />
				</cfif>
				<cfset pluginEvent.setValue("intercept",aIntercept) />
				<cfset pluginEvent.setValue("action",url.action) />
				<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsDoRequest",pluginEvent)>
				<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
			</cfcase>
			<cfcase value="ext">
				<cfset url.action = "ext" />
				<cfset pluginEvent.setValue("intercept",aIntercept) />
				<cfset pluginEvent.setValue("package",aIntercept[1]) />
				<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsExtensionRequest",pluginEvent)>
			</cfcase>
			<cfdefaultcase>
				<cfset ident = rereplacenocase( aIntercept[1],"([c|f|t|p]\d{1,})\-.*","\1" ) />

				<cfif len( ident )>

					<cfset MeldForumsBean.setIdent( ident ) />

					<cfset pluginEvent.setValue("ident",ident) />
					<cfset pluginEvent.setValue("idx", rereplace(ident,"[^\d]","","all") ) />
					<cfset pluginEvent.setValue("intercept",aIntercept) />
					<cfif left(ident,1) eq "c">
						<cfset url.action = "conference" />
						<cfset MeldForumsBean.setAction( url.action ) />
						<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsConferenceRequest",pluginEvent)>
						<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
					<cfelseif left(ident,1) eq "f">
						<cfset url.action = "forum" />
						<cfset MeldForumsBean.setAction( url.action ) />
						<cfset pluginEvent.setValue("action",url.action) />
						<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsForumRequest",pluginEvent)>
						<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
					<cfelseif left(ident,1) eq "t">
						<cfset url.action = "thread" />
						<cfset MeldForumsBean.setAction( url.action ) />
						<cfset pluginEvent.setValue("action",url.action) />
						<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsThreadRequest",pluginEvent)>
						<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
					<cfelse>
						<cfset url.action = "post" />
						<cfset MeldForumsBean.setAction( url.action ) />
						<cfset pluginEvent.setValue("action",url.action) />
						<cfset getMeldForumsEventManager().announceEvent($,"onMeldForumsPostRequest",pluginEvent)>
						<cfset MeldForumsBean.setAction( pluginEvent.getValue('action') ) />
					</cfif>
				</cfif>
			</cfdefaultcase>			
		</cfswitch>
	</cffunction>

	<cffunction name="getSiteSettings" returntype="any" access="public" output="false">
		<cfargument name="siteID" type="string" required="true">

		<cfset var settingService	= getBeanFactory().getBean("settingService") />
		<cfset var settingBean		= "" />

		<cfif not structKeyExists( variables.settings,siteID ) >
			<cfset variables.settings[siteID] = settingService.getBeanByAttributes( siteID=arguments.siteID ) />
			
			<cfif not variables.settings[siteID].beanExists()>
				<cfset variables.settings[siteID] = settingService.createBaseSiteSettings( arguments.siteID ) />
			</cfif>
		</cfif>

		<cfreturn variables.settings[siteID] >
	</cffunction>

	<cffunction name="clearSiteSettings" returntype="void" access="public" output="false">
		<cfset variables.settings = StructNew() />
	</cffunction>

	<cffunction name="setPluginConfig" access="public" returntype="any" output="false">
		<cfargument name="PluginConfig" type="any" required="true">
		<cfset variables.PluginConfig = arguments.PluginConfig>
	</cffunction>
	<cffunction name="getPluginConfig" access="public" returntype="any" output="false">
		<cfreturn variables.PluginConfig>
	</cffunction>

	<cffunction name="setBeanFactory" access="public" returntype="any" output="false">
		<cfargument name="BeanFactory" type="any" required="true">
		<cfset variables.BeanFactory = arguments.BeanFactory>
	</cffunction>
	<cffunction name="getBeanFactory" access="public" returntype="any" output="false">
		<cfreturn variables.BeanFactory>
	</cffunction>

	<cffunction name="setMeldForumsEventManager" access="public" returntype="any" output="false">
		<cfargument name="MeldForumsEventManager" type="any" required="true">
		<cfset variables.MeldForumsEventManager = arguments.MeldForumsEventManager>
	</cffunction>
	<cffunction name="getMeldForumsEventManager" access="public" returntype="any" output="false">
		<cfreturn variables.MeldForumsEventManager>
	</cffunction>

	<cffunction name="setMeldForumsRequestManager" access="public" returntype="any" output="false">
		<cfargument name="MeldForumsRequestManager" type="any" required="true">
		<cfset variables.MeldForumsRequestManager = arguments.MeldForumsRequestManager>
	</cffunction>
	<cffunction name="getMeldForumsRequestManager" access="public" returntype="any" output="false">
		<cfreturn variables.MeldForumsRequestManager>
	</cffunction>
</cfcomponent>