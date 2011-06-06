<!---||MELDFORUMSLICENSE||--->
<cfcomponent name="ForumService" output="false" extends="MeldForums.com.meldsolutions.core.MeldService">
<!---^^GENERATEDSTART^^--->
	<cffunction name="init" access="public" output="false" returntype="ForumService">
		<cfreturn this/>
	</cffunction>

	<cffunction name="createForum" access="public" output="false" returntype="any">
		<!---^^ATTRIBUTES-START^^--->
		<cfargument name="ForumID" type="uuid" required="false" />
		<cfargument name="ConferenceID" type="string" required="false" />
		<cfargument name="ConfigurationID" type="string" required="false" />
		<cfargument name="SiteID" type="string" required="false" />
		<cfargument name="Name" type="string" required="false" />
		<cfargument name="Title" type="string" required="false" />
		<cfargument name="Description" type="string" required="false" />
		<cfargument name="FriendlyName" type="string" required="false" />
		<cfargument name="IsActive" type="boolean" required="false" />
		<cfargument name="AdminID" type="string" required="false" />
		<cfargument name="OrderNo" type="numeric" required="false" />
		<cfargument name="ThreadCounter" type="numeric" required="false" />
		<cfargument name="LastPostID" type="string" required="false" />
		<cfargument name="RemoteID" type="string" required="false" />
		<cfargument name="DateCreate" type="string" required="false" />
		<cfargument name="DateLastUpdate" type="string" required="false" />
		<cfargument name="Idx" type="numeric" required="false" />
		<!---^^ATTRIBUTES-END^^--->
				
		<cfset var tmpObj = createObject("component","ForumBean").init(argumentCollection=arguments) />
		<cfset tmpObj.setForumService( this ) />
		<cfreturn tmpObj />
	</cffunction>

	<cffunction name="getForum" access="public" output="false" returntype="any">
		<!---^^PRIMARY-START^^--->
		<cfargument name="ForumID" type="uuid" required="true" />
		<!---^^PRIMARY-END^^--->
		
		<cfset var ForumBean = createForum(argumentCollection=arguments) />
		<cfset getForumDAO().read(ForumBean) />
		<cfreturn ForumBean />
	</cffunction>

	<cffunction name="getForums" access="public" output="false" returntype="array">
		<!---^^ATTRIBUTES-START^^--->
		<cfargument name="ForumID" type="uuid" required="false" />
		<cfargument name="ConferenceID" type="string" required="false" />
		<cfargument name="ConfigurationID" type="string" required="false" />
		<cfargument name="SiteID" type="string" required="false" />
		<cfargument name="Name" type="string" required="false" />
		<cfargument name="Title" type="string" required="false" />
		<cfargument name="Description" type="string" required="false" />
		<cfargument name="FriendlyName" type="string" required="false" />
		<cfargument name="IsActive" type="boolean" required="false" />
		<cfargument name="AdminID" type="string" required="false" />
		<cfargument name="OrderNo" type="numeric" required="false" />
		<cfargument name="ThreadCounter" type="numeric" required="false" />
		<cfargument name="LastPostID" type="string" required="false" />
		<cfargument name="RemoteID" type="string" required="false" />
		<cfargument name="DateCreate" type="string" required="false" />
		<cfargument name="DateLastUpdate" type="string" required="false" />
		<cfargument name="Idx" type="numeric" required="false" />
		<!---^^ATTRIBUTES-END^^--->
		<cfargument name="doLastPost" type="boolean" required="false" default="true" />
		
		<cfset var aForums 		= getForumGateway().getByAttributes(argumentCollection=arguments) />
		<cfset var sArgs		= StructNew() />
		<cfset var idArrays		= ArrayNew(1) />
		<cfset var sPosts		= StructNew() />
		
		<cfif arguments.doLastPost>
			<cfloop from="1" to="#ArrayLen(aForums)#" index="iiX">
				<cfif len( aForums[iiX].getLastPostID() )>
					<cfset arrayAppend(idArrays,aForums[iiX].getLastPostID()) />
				</cfif>
			</cfloop>
			
			<cfif ArrayLen( idArrays )>
				<cfset sPosts = getPostService().getByArray( idArrays ) />
				
				<cfloop from="1" to="#ArrayLen(aForums)#" index="iiX">
					<cfif len( aForums[iiX].getLastPostID() ) and StructKeyExists(sPosts,aForums[iiX].getLastPostID() )>
						<cfset aForums[iiX].setLastPost( sPosts[ aForums[iiX].getLastPostID() ] )>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>

		<cfreturn aForums />
	</cffunction>

	<cffunction name="getBeanByAttributes" access="public" output="false" returntype="any">
		<!---^^ATTRIBUTES-START^^--->
		<cfargument name="ForumID" type="uuid" required="false" />
		<cfargument name="ConferenceID" type="string" required="false" />
		<cfargument name="ConfigurationID" type="string" required="false" />
		<cfargument name="SiteID" type="string" required="false" />
		<cfargument name="Name" type="string" required="false" />
		<cfargument name="Title" type="string" required="false" />
		<cfargument name="Description" type="string" required="false" />
		<cfargument name="FriendlyName" type="string" required="false" />
		<cfargument name="IsActive" type="boolean" required="false" />
		<cfargument name="AdminID" type="string" required="false" />
		<cfargument name="OrderNo" type="numeric" required="false" />
		<cfargument name="ThreadCounter" type="numeric" required="false" />
		<cfargument name="LastPostID" type="string" required="false" />
		<cfargument name="RemoteID" type="string" required="false" />
		<cfargument name="DateCreate" type="string" required="false" />
		<cfargument name="DateLastUpdate" type="string" required="false" />
		<cfargument name="Idx" type="numeric" required="false" />
		<!---^^ATTRIBUTES-END^^--->

		<cfreturn getForumGateway().getBeanByAttributes(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="getByArray" access="public" output="false" returntype="Query" >
		<cfargument name="idArray" type="array" required="true" />

		<cfreturn getForumGateway().getByArray(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="search" access="public" output="false" returntype="struct">
		<cfargument name="criteria" type="struct" required="true" />
		<cfargument name="fieldList" type="string" required="false" default="frm.name,frm.forumID,frm.threadCounter,frm.ConferenceID,frm.orderNo,frm.isActive,cnf.name AS ConferenceName" />
		<cfargument name="start" type="numeric" required="false" default="0"/>
		<cfargument name="size" type="numeric" required="false" default="10"/>
		<cfargument name="count" type="numeric" required="false" default="0"/>
		<cfargument name="isPaged" type="numeric" required="false" default="true" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var arrObjects		= ArrayNew(1)>
		<cfset var iiX				= "" >
		<cfset var isValid			= false >
		<cfset var sReturn			= StructNew()>
		
		<cfif arguments.isPaged and not arguments.count>
			<cfset arguments.isCount = true>
			<cfset sReturn.count = getForumGateway().search(argumentCollection=arguments) />
			<cfset arguments.isCount = false>
		<cfelse>
			<cfset sReturn.count = arguments.count />
		</cfif>
		
		<cfset arrObjects = getForumGateway().search(argumentCollection=arguments) />

		<cfset sReturn.start		= arguments.start />
		<cfset sReturn.size			= arguments.size />
		<cfset sReturn.itemarray	= arrObjects />

		<cfreturn sReturn />
	</cffunction>

	<cffunction name="saveForum" access="public" output="false" returntype="boolean">
		<cfargument name="ForumBean" type="any" required="true" />

		<cfset var fName = "" />

		<cfif not len( ForumBean.getTitle() )>
			<cfset ForumBean.setTitle( ForumBean.getName() ) />
		</cfif>

		<cfif not len( ForumBean.getFriendlyName() )>
			<cfset fName = getmmUtility().friendlyName( ForumBean.getTitle() ) />
			<cfset ForumBean.setFriendlyName( fName ) />
		<cfelse>
			<cfset fName = getmmUtility().friendlyName( ForumBean.getFriendlyName() ) />
			<cfset ForumBean.setFriendlyName( fName ) />
		</cfif>

		<cfreturn getForumDAO().save(ForumBean) />
	</cffunction>
	
	<cffunction name="updateForum" access="public" output="false" returntype="boolean">
		<cfargument name="ForumBean" type="any" required="true" />

		<cfset var fName = "" />

		<cfif not len( ForumBean.getTitle() )>
			<cfset ForumBean.setTitle( ForumBean.getName() ) />
		</cfif>

		<cfif not len( ForumBean.getFriendlyName() )>
			<cfset fName = getmmUtility().friendlyName( ForumBean.getTitle() ) />
			<cfset ForumBean.setFriendlyName( fName ) />
		<cfelse>
			<cfset fName = getmmUtility().friendlyName( ForumBean.getFriendlyName() ) />
			<cfset ForumBean.setFriendlyName( fName ) />
		</cfif>

		<cfreturn getForumDAO().update(ForumBean) />
	</cffunction>

	<cffunction name="deleteForum" access="public" output="false" returntype="boolean">
		<!---^^PRIMARY-START^^--->
		<cfargument name="ForumID" type="uuid" required="true" />
		<!---^^PRIMARY-END^^--->
		<cfargument name="inTransaction" type="boolean" required="false" default="true" />
		
		<cfset var ForumBean = createForum(argumentCollection=arguments) />
	
		<cfif arguments.inTransaction>
			<cfset getThreadService().deleteThreads( argumentCollection=arguments ) />		
			<cfreturn getForumDAO().delete(ForumBean) />
		<cfelse>
			<cftransaction>
				<cfset getThreadService().deleteThreads( argumentCollection=arguments ) />		
				<cfreturn getForumDAO().delete(ForumBean) />
			</cftransaction>
		</cfif>
				
		<cfreturn true />
	</cffunction>

	<cffunction name="deleteForums" access="public" output="false" returntype="boolean">
		<cfargument name="ConferenceID" type="uuid" required="true" />
		<cfargument name="inTransaction" type="boolean" required="false" default="true" />

		<cfset var aForums	= ArrayNew(1) />
		
		<cfset aForums	= getForums( argumentCollection=arguments ) />

		<cfif arguments.inTransaction>
			<cfloop from="1" to="#ArrayLen(aForums)#" index="iiX">
				<cfreturn deleteForum( aForums[iiX].getForumID(),true ) />
			</cfloop>
		<cfelse>
			<cftransaction>
				<cfloop from="1" to="#ArrayLen(aForums)#" index="iiX">
					<cfreturn deleteForum( aForums[iiX].getForumID(),true ) />
				</cfloop>
			</cftransaction>
		</cfif>
	</cffunction>

	<cffunction name="setForumGateway" access="public" returntype="void" output="false">
		<cfargument name="ForumGateway" type="any" required="true" />
		<cfset variables['forumGateway'] = arguments.ForumGateway />
	</cffunction>
	<cffunction name="getForumGateway" access="public" returntype="any" output="false">
		<cfreturn ForumGateway />
	</cffunction>

	<cffunction name="setForumDAO" access="public" returntype="void" output="false">
		<cfargument name="ForumDAO" type="any" required="true" />
		<cfset variables['forumDAO'] = arguments.ForumDAO />
	</cffunction>
	<cffunction name="getForumDAO" access="public" returntype="any" output="false">
		<cfreturn variables.ForumDAO />
	</cffunction>

<!---^^GENERATEDEND^^--->
<!---^^CUSTOMSTART^^--->
	<cffunction name="setLastPostID" access="public" output="false" returntype="void">
		<cfargument name="forumID" type="uuid" required="true" />
		<cfargument name="postID" type="uuid" required="true" />
		<cfset getForumGateway().setLastPost(arguments.forumID,arguments.postID) />
	</cffunction>

	<cffunction name="updateThreadCounter" access="public" output="false" returntype="numeric">
		<cfargument name="forumID" type="uuid" required="true" />
		<cfreturn getThreadCounter(arguments.forumID,true)>
	</cffunction>

	<cffunction name="getThreadCounter" access="public" output="false" returntype="numeric">
		<cfargument name="forumID" type="uuid" required="true" />
		<cfargument name="doUpdate" type="boolean" required="false" default="false" />
		
		<cfreturn getForumGateway().getThreadCounter(arguments.forumID,arguments.doUpdate) />
	</cffunction>

	<cffunction name="getForumIDsByConferenceID" access="public" output="false" returntype="array">
		<cfargument name="conferenceID" type="string" required="false" />
		
		<cfreturn getForumGateway().getForumIDsByConferenceID(arguments.conferenceID) />
	</cffunction>

	<cffunction name="getForumWithThreads" access="public" output="false" returntype="any">
		<cfargument name="ForumID" type="uuid" required="false" />
		<cfargument name="idx" type="numeric" required="false" />
		<cfargument name="pageBean" type="any" required="false" />
		
		<cfset var iiX			= 0>
		<cfset var sArgs		= StructNew() />
		<cfset var forumBean	= " /">
		<cfset var aThreads		= ArrayNew(1) />

		<cfif not StructKeyExists(arguments,"forumID") and not StructKeyExists(arguments,"idx")>
			<cfreturn createForum()/>
		</cfif>

		<cfset forumBean		= getBeanByAttributes( argumentCollection=arguments )>

		<cfif not forumBean.beanExists()>
			<cfreturn createForum()/>
		</cfif>
				
		<cfset sArgs				= StructNew() >
		<cfset sArgs.forumID		= forumBean.getForumID()>
		<cfset sArgs.isActive		= 1>
		<cfset sArgs.isAnnouncement = 1>

		<cfset aAnnouncements = getThreadService().getThreadsWithLastPost( argumentCollection=sArgs )>
	
		<cfset forumBean.setAnnouncements( aAnnouncements )>
		
		<cfset sArgs				= StructNew() >
		<cfset sArgs.forumID		= forumBean.getForumID()>
		<cfset sArgs.isActive		= 1>
		<cfset sArgs.pageBean 		= arguments.pageBean>
		<cfset sArgs.isAnnouncement = 0>
		<cfset aThreads = getThreadService().getThreadsWithLastPost( argumentCollection=sArgs )>
				
		<cfset forumBean.setThreads( aThreads )>
		
		<cfreturn forumBean />
	</cffunction>

	<cffunction name="getCount" access="public" output="false" returntype="number">
		<cfargument name="conferenceID" type="uuid" required="false" />

		<cfset var sArgs				= StructNew() >
		<cfset var qCount				= "">

		<cfset sArgs.conferenceID		= arguments.conferenceID>
		<cfset sArgs.isActive			= 1>
		<cfset sArgs.isCount			= true>
		
		<cfset qCount = getForumGateway().getByAttributesQuery( argumentCollection=sArgs ) /> 
		
		<cfreturn qCount.total />
	</cffunction>


<!---^^CUSTOMEND^^--->

	<cffunction name="setThreadService" access="public" returntype="any" output="false">
		<cfargument name="ThreadService" type="any" required="true">
		<cfset variables.ThreadService = arguments.ThreadService>
	</cffunction>
	<cffunction name="getThreadService" access="public" returntype="any" output="false">
		<cfreturn variables.ThreadService>
	</cffunction>

	<cffunction name="setPostService" access="public" returntype="any" output="false">
		<cfargument name="PostService" type="any" required="true">
		<cfset variables.PostService = arguments.PostService>
	</cffunction>
	<cffunction name="getPostService" access="public" returntype="any" output="false">
		<cfreturn variables.PostService>
	</cffunction>
</cfcomponent>









