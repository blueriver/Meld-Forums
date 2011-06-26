<!---
This file is part of the Meld Forums application.

Meld Forums is licensed under the GPL 2.0 license
Copyright (C) 2010 2011 Meld Solutions Inc. http://www.meldsolutions.com/

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation, version 2 of that license..

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

--->
<cfsilent>
	<!--- headers --->
	<cfset local.sStr = "" />
	<cfinclude template="../../includes/headers/editor.cfm">
	<cfinclude template="../../includes/headers/edit.cfm">
</cfsilent><cfoutput>
<!--- begin content --->
<div id="meld-body">
	<!-- CONTENT HERE -->
	<cfif local.rc.errors.hasErrors()>
		<cfset local.sStr = "" />
		<cfset local.event = rc.mmEvents.createEvent( rc.$ ) />
		<cfset local.event.setValue('errors',rc.errors) />
		<cfset local.sStr = rc.mmEvents.renderEvent( rc.$,"onMeldForumsErrorsRender",local.event ) />
		<cfif len(local.sStr)>
			#local.sStr#
		<cfelse>
			#view("global/inc_errors")#
		</cfif>
	</cfif>
	<cfsilent>
	<cfset local.event = rc.mmEvents.createEvent( rc.$ ) />
	<cfset local.event.setValue('userBean',rc.userBean) />
	<cfset local.event.setValue('userID',rc.userID) />
	<cfset local.sStr = rc.mmEvents.renderEvent( rc.$,"onMeldForumsProfilePanelLoginRender",local.event ) />
	</cfsilent>
	<cfif len(local.sStr)>
		#local.sStr#
	<cfelse>
		<div class="notice">#rc.mmRBF.key('pleaselogin')#</div>
		<div class="clearfix">
		<a href="#rc.MFBean.getLogInUrl()#&returnURL=#rc.MFBean.getProfileLink()#" class='submit'>#rc.mmRBF.key('login')#</a>
		</div>
	</cfif>
</div>	
<!--- end content --->
</cfoutput>