<!---||MELDFORUMSLICENSE||--->
<cfcomponent displayname="ForumGateway" output="false" extends="MeldForums.com.meldsolutions.core.MeldGateway">
<!---^^GENERATEDSTART^^--->
	<cffunction name="init" access="public" output="false" returntype="ForumGateway">
		<cfargument name="dsn" type="string" required="true">
		<cfargument name="dsnusername" type="string" required="true">
		<cfargument name="dsnpassword" type="string" required="true">
		<cfargument name="dsnprefix" type="string" required="true">
		<cfargument name="dsntype" type="string" required="true">

		<cfset variables.dsn = arguments.dsn>
		<cfset variables.dsnusername = arguments.dsnusername>
		<cfset variables.dsnpassword = arguments.dsnpassword>
		<cfset variables.dsnprefix = arguments.dsnprefix>
		<cfset variables.dsntype = arguments.dsntype>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="getByAttributesQuery" access="public" output="false" returntype="query">
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
		<cfargument name="orderby" type="string" required="false" default="name,orderno" />
		<cfargument name="idList" type="string" required="false" />
		<cfargument name="isCount" type="any" required="false" default="false" />

		<cfset var qList = "" />		

		<cfquery name="qList" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			SELECT
			<!--- if this is a MS SQL db, we want to return the top start + count --->	
			<cfif variables.dsntype eq "mssql" AND structKeyExists(arguments,"pageBean")> 	
				TOP  #( Ceiling(Val(arguments.pageBean.getPos())) + Ceiling(Val(arguments.pageBean.getSize())) )#
			</cfif>
			<cfif arguments.isCount>
				COUNT(thr.forumID) AS total
			<cfelse>
				frm.*,1 AS BeanExists,
				cnf.configurationID AS parentConfigurationID
			</cfif>
			FROM  #variables.dsnprefix#mf_forum frm  
			<cfif not arguments.isCount>
			JOIN
				#variables.dsnprefix#mf_conference cnf
				ON
				(frm.conferenceID = cnf.conferenceID)
			</cfif>
			WHERE	0=0

			<cfif structKeyExists(arguments,"idList") and len(arguments.idList)>
				AND frm.ForumID IN (<cfqueryparam value="#IDList#" CFSQLType="cf_sql_char" list="true" maxlength="35" />)
			<cfelseif structKeyExists(arguments,"ForumID") and len(arguments.ForumID)>
				AND frm.ForumID = <cfqueryparam value="#arguments.ForumID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments,"ConferenceID") and len(arguments.ConferenceID)>
				AND frm.ConferenceID = <cfqueryparam value="#arguments.ConferenceID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments,"ConfigurationID") and len(arguments.ConfigurationID)>
				AND frm.ConfigurationID = <cfqueryparam value="#arguments.ConfigurationID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments,"SiteID") and len(arguments.SiteID)>
				AND frm.SiteID = <cfqueryparam value="#arguments.SiteID#" CFSQLType="cf_sql_varchar" maxlength="25" />
			</cfif>
			
			<cfif structKeyExists(arguments,"Name") and len(arguments.Name)>
				AND frm.Name = <cfqueryparam value="#arguments.Name#" CFSQLType="cf_sql_varchar" maxlength="150" />
			</cfif>
			
			<cfif structKeyExists(arguments,"Title") and len(arguments.Title)>
				AND frm.Title = <cfqueryparam value="#arguments.Title#" CFSQLType="cf_sql_varchar" maxlength="150" />
			</cfif>
			
			<cfif structKeyExists(arguments,"Description") and len(arguments.Description)>
				AND frm.Description = <cfqueryparam value="#arguments.Description#" CFSQLType="cf_sql_longvarchar" />
			</cfif>
			
			<cfif structKeyExists(arguments,"FriendlyName") and len(arguments.FriendlyName)>
				AND frm.FriendlyName = <cfqueryparam value="#arguments.FriendlyName#" CFSQLType="cf_sql_varchar" maxlength="200" />
			</cfif>
			
			<cfif structKeyExists(arguments,"IsActive") and len(arguments.IsActive)>
				AND frm.IsActive = <cfqueryparam value="#arguments.IsActive#" CFSQLType="cf_sql_tinyint" />
			</cfif>
			
			<cfif structKeyExists(arguments,"AdminID") and len(arguments.AdminID)>
				AND frm.AdminID = <cfqueryparam value="#arguments.AdminID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments,"OrderNo") and len(arguments.OrderNo)>
				AND frm.OrderNo = <cfqueryparam value="#arguments.OrderNo#" CFSQLType="cf_sql_integer" />
			</cfif>
			
			<cfif structKeyExists(arguments,"ThreadCounter") and len(arguments.ThreadCounter)>
				AND frm.ThreadCounter = <cfqueryparam value="#arguments.ThreadCounter#" CFSQLType="cf_sql_integer" />
			</cfif>
			
			<cfif structKeyExists(arguments,"LastPostID") and len(arguments.LastPostID)>
				AND frm.LastPostID = <cfqueryparam value="#arguments.LastPostID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments,"RemoteID") and len(arguments.RemoteID)>
				AND frm.RemoteID = <cfqueryparam value="#arguments.RemoteID#" CFSQLType="cf_sql_varchar" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments,"DateCreate") and len(arguments.DateCreate)>
				AND frm.DateCreate = <cfqueryparam value="#arguments.DateCreate#" CFSQLType="cf_sql_timestamp" />
			</cfif>
			
			<cfif structKeyExists(arguments,"DateLastUpdate") and len(arguments.DateLastUpdate)>
				AND frm.DateLastUpdate = <cfqueryparam value="#arguments.DateLastUpdate#" CFSQLType="cf_sql_timestamp" />
			</cfif>
			<!---^^VALUES-END^^--->
		<cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)>
			ORDER BY #arguments.orderby#
		</cfif>
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

	<cffunction name="getByAttributes" access="public" output="false" returntype="array">
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
		<cfargument name="orderby" type="string" required="false" default="name,orderno" />
		<cfargument name="idList" type="string" required="false" />
		<cfargument name="mode" type="string" required="false" default="array" />

		<cfset var qList	= getByAttributesQuery(argumentCollection=arguments) />		
		<cfset var qStats	= "" />		

		<cfset var arrObjects = arrayNew(1) />
		<cfset var strObjects = structNew() />
		<cfset var tmpObj = "" />
		<cfset var sArgs = StructNew() />
		
		<cfif qList.recordCount>
			<cfset sArgs.idList = ValueList( qList.forumID ) />
			<cfset qStats = getAggregate( argumentCollection=sArgs ) />
		</cfif>
		
		<cfloop from="1" to="#qList.recordCount#" index="i">
			<cfquery name="qSubStats" dbtype="query">
				SELECT
					*
				FROM
					qStats
				WHERE
					forumID = <cfqueryparam value="#qList.forumID[i]#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfquery>
		
			<cfset tmpObj = createObject("component","ForumBean").init(argumentCollection=queryRowToStruct(qList,i)) />
			<cfset tmpObj.setViewCount( qSubStats.viewcount ) />
			<cfset tmpObj.setPostCount( qSubStats.postcount ) />
			<cfset tmpObj.setDateLastThread( qSubStats.dateLastThread ) />
			<cfset tmpObj.setForumService( getForumService() ) />

			<cfif arguments.mode eq "array">
				<cfset arrayAppend(arrObjects,tmpObj) />
			<cfelse>
				<cfset strObjects[tmpObj.getForumID()] = tmpObj />
			</cfif>
		</cfloop>

		<cfif arguments.mode eq "array">
			<cfreturn arrObjects />
		<cfelse>
			<cfreturn QueryNew('null') />
		</cfif>
				
		<cfreturn arrObjects />
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
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = getByAttributesQuery(argumentCollection=arguments) />		
		<cfset var arrObjects = arrayNew(1) />
		<cfset var tmpObj = "" />
		<cfset var iiX = "" />

		<cfif qList.recordCount gt 1>
			<cfset tmpObj = createObject("component","ForumBean").init(argumentCollection=queryRowToStruct(qList))>
			<cfset tmpObj.setForumService( getForumService() ) />
			<cfreturn tmpObj />
		<cfelseif qList.recordCount>
			<cfset tmpObj = createObject("component","ForumBean").init(argumentCollection=queryRowToStruct(qList)) />
			<cfset tmpObj.setForumService( getForumService() ) />
			<cfreturn tmpObj />
		<cfelse>
			<cfset tmpObj = createObject("component","ForumBean").init()>
			<cfset tmpObj.setForumService( getForumService() ) />
			<cfreturn tmpObj />
		</cfif>
	</cffunction>

	<cffunction name="getByArray" access="public" output="false" returntype="Query" >
		<cfargument name="idArray" type="array" required="true" />
		
		<cfset var qList			= "" />		
		<cfset var strObjects		= StructNew() />
		<cfset var tmpObj			= "" />
		<cfset var IDList			= "" />
		<cfset var iiX 				= "" />

		<cfif not arrayLen(arguments.idArray)>
			<cfreturn QueryNew('null') />
		</cfif>

		<cfset IDList = ArrayToList(arguments.idArray) />

		<cfquery name="qList" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			SELECT
				*
			FROM
				#variables.dsnprefix#mf_forum
			WHERE
				0=0
		
			AND
			ForumID IN (<cfqueryparam value="#IDList#" CFSQLType="cf_sql_char" list="true" maxlength="35" />)
		
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

	<cffunction name="search" access="public" output="false" returntype="any">
		<cfargument name="criteria" type="struct" required="true" />
		<cfargument name="fieldList" type="string" required="true" />
		<cfargument name="start" type="numeric" required="false" default="0"/>
		<cfargument name="size" type="numeric" required="false" default="30"/>
		<cfargument name="orderby" type="string" required="false" default=""/>
		<cfargument name="isCount" type="boolean" required="false" default="false"/>
		
		<cfset var arrObjects		= ArrayNew(1)>
		<cfset var qList			= "" />
		<cfset var qExclude			= "" />
		<cfset var qKeep			= "" />
		<cfset var iiX				= "" />
		<cfset var returnFields		= rereplace(arguments.fieldList,";.*","") />
		<cfset var returnOrder		= rereplace(arguments.orderby,";.*","") />

		<cfquery name="qList" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			SELECT
				<cfif not arguments.isCount and arguments.size gt 0 AND variables.dsntype eq "mssql"> 	
					TOP #Ceiling(Val(arguments.start+arguments.size))#
				</cfif>
				<cfif arguments.isCount>
					COUNT(*) AS total
				<cfelse>
					#returnFields#
				</cfif>
				<cfif not arguments.isCount>,
					COALESCE(frm.configurationID, cnf.configurationID, '00000000-0000-0000-0000000000000001') as parentConfigurationID,
					<cfif variables.dsntype eq "mysql">
						COALESCE(SUM(thr.postCounter),0) AS postCount,
						COALESCE(SUM(vws.views),0) AS viewCount,
						MAX(thr.dateLastPost) as dateLastThread
					<cfelseif variables.dsntype eq "mssql">
						COALESCE(SUM(CONVERT(FLOAT, thr.postCounter)), 0) AS postCount,
						COALESCE(SUM(CONVERT(FLOAT, vws.viewCounter)), 0) AS viewCount,
						(SELECT MAX(dateLastPost) FROM  #variables.dsnprefix#mf_thread thr  ) as dateLastThread
					</cfif>
				</cfif>
					FROM	#variables.dsnprefix#mf_forum frm
				<cfif not arguments.isCount>
					INNER JOIN
						#variables.dsnprefix#mf_conference cnf
						ON
						(frm.conferenceID  = cnf.conferenceID)  
					LEFT JOIN
						#variables.dsnprefix#mf_thread thr
						ON
						(frm.forumID  = thr.forumID)  
					LEFT JOIN
						#variables.dsnprefix#mf_viewcounter vws
						ON
						(thr.threadID  = vws.threadID)
				</cfif>
			WHERE
				0=0

			<cfif structKeyExists(arguments.criteria,"ForumID") and len(arguments.criteria.ForumID)>
			AND frm.ForumID = <cfqueryparam value="#arguments.criteria.ForumID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"ConferenceID") and len(arguments.criteria.ConferenceID)>
			AND frm.ConferenceID = <cfqueryparam value="#arguments.criteria.ConferenceID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"ConfigurationID") and len(arguments.criteria.ConfigurationID)>
			AND frm.ConfigurationID = <cfqueryparam value="#arguments.criteria.ConfigurationID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"SiteID") and len(arguments.criteria.SiteID)>
			AND frm.SiteID LIKE <cfqueryparam value="%#arguments.criteria.SiteID#%" CFSQLType="cf_sql_varchar" maxlength="25" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"Name") and len(arguments.criteria.Name)>
			AND frm.Name LIKE <cfqueryparam value="%#arguments.criteria.Name#%" CFSQLType="cf_sql_varchar" maxlength="150" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"Title") and len(arguments.criteria.Title)>
			AND frm.Title LIKE <cfqueryparam value="%#arguments.criteria.Title#%" CFSQLType="cf_sql_varchar" maxlength="150" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"Description") and len(arguments.criteria.Description)>
			AND frm.Description LIKE <cfqueryparam value="%#arguments.criteria.Description#%" CFSQLType="cf_sql_longvarchar" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"FriendlyName") and len(arguments.criteria.FriendlyName)>
			AND frm.FriendlyName LIKE <cfqueryparam value="%#arguments.criteria.FriendlyName#%" CFSQLType="cf_sql_varchar" maxlength="200" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"IsActive") and len(arguments.criteria.IsActive)>
				AND	frm.isActive = <cfqueryparam value="#arguments.criteria.isActive#" CFSQLType="cf_sql_tinyint" />
			<cfelse> 
				AND	frm.isActive = <cfqueryparam value="1" CFSQLType="cf_sql_tinyint" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"AdminID") and len(arguments.criteria.AdminID)>
			AND frm.AdminID = <cfqueryparam value="#arguments.criteria.AdminID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"OrderNo") and len(arguments.criteria.OrderNo)>
			AND frm.OrderNo = <cfqueryparam value="#arguments.criteria.OrderNo#" CFSQLType="cf_sql_integer" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"ThreadCounter") and len(arguments.criteria.ThreadCounter)>
			AND frm.ThreadCounter = <cfqueryparam value="#arguments.criteria.ThreadCounter#" CFSQLType="cf_sql_integer" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"LastPostID") and len(arguments.criteria.LastPostID)>
			AND frm.LastPostID = <cfqueryparam value="#arguments.criteria.LastPostID#" CFSQLType="cf_sql_char" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"RemoteID") and len(arguments.criteria.RemoteID)>
			AND frm.RemoteID LIKE <cfqueryparam value="%#arguments.criteria.RemoteID#%" CFSQLType="cf_sql_varchar" maxlength="35" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"DateCreate") and len(arguments.criteria.DateCreate)>
			AND frm.DateCreate LIKE <cfqueryparam value="%#arguments.criteria.DateCreate#%" CFSQLType="cf_sql_timestamp" />
			</cfif>
			
			<cfif structKeyExists(arguments.criteria,"DateLastUpdate") and len(arguments.criteria.DateLastUpdate)>
			AND frm.DateLastUpdate LIKE <cfqueryparam value="%#arguments.criteria.DateLastUpdate#%" CFSQLType="cf_sql_timestamp" />
			</cfif>
			<cfif not arguments.isCount>
			GROUP BY
				<cfif variables.dsntype eq "mssql">
				#returnFields#
				<cfelse>
				frm.forumID
				</cfif>
			</cfif>
			<!---^^SEARCH-END^^--->						
			<cfif not arguments.isCount AND len( arguments.orderBy )>
				ORDER BY #returnOrder#
			</cfif>
			<cfif not arguments.isCount and arguments.size gt 0 AND variables.dsntype eq "mysql">
				LIMIT <cfqueryparam value="#arguments.start#" CFSQLType="cf_sql_integer" />,<cfqueryparam value="#arguments.size#" CFSQLType="cf_sql_integer" />
			</cfif>
		</cfquery>

		<cfif not arguments.isCount AND variables.dsntype eq "mssql" AND arguments.start gt 0>
			<cfquery name="qExclude" dbtype="query" maxrows="#arguments.start#" >  
	        	SELECT
				
					ForumID
				FROM
					qList    
			</cfquery>
			
			<cfquery name="qKeep" dbtype="query" maxrows="#arguments.count#">  
				SELECT
					*  
				FROM  
					qList  
				WHERE  
					0=0
					(
					AND
					ForumID NOT IN (<cfqueryparam value="#valueList(qExclude.ForumID)#" list="true" CFSQLType="cf_sql_char" maxlength="35" />)
					)  
				
			</cfquery> 

			<cfset qList = qKeep> 
		</cfif>

		<cfif arguments.isCount>
			<cfreturn qList.total >
		<cfelse>
			<cfloop from="1" to="#qList.recordCount#" index="iiX">
				<cfset tmpObj = queryRowToStruct(qList,iiX) />
				<cfset arrayAppend(arrObjects,tmpObj) />
			</cfloop>
		</cfif>
		<cfreturn arrObjects />
	</cffunction>

<!---^^GENERATEDEND^^--->
<!---^^CUSTOMSTART^^--->

	<cffunction name="getForumCountsForConference" access="public" output="false" returntype="query">
		<cfargument name="qConferences" type="query" required="true" />
		
		<cfset var qList	= "" />
		<cfset var qCount	= "" />

		<cfquery name="qList" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			SELECT
				conferenceID,SUM(threadCounter) as threadCount,COUNT(forumID) AS forumCount
			FROM  #variables.dsnprefix#mf_forum frm  
			WHERE
				conferenceID IN (<cfqueryparam value="#valueList(qConferences.conferenceID)#" CFSQLType="cf_sql_char" list="true" maxlength="35" />)
			GROUP BY
				conferenceID				
		</cfquery>

		<cfloop query="qConferences">
			<cfquery name="qCount" dbtype="query">
				SELECT
					*
				FROM
					qList
				WHERE
					conferenceID = <cfqueryparam value="#qConferences.ConferenceID#" CFSQLType="cf_sql_char" maxlength="35" /> 
			</cfquery>
			
			<cfif qCount.recordCount>
				<cfset qConferences.threadCount[currentRow] = qCount.threadcount />			
				<cfset qConferences.forumCount[currentRow] = qCount.forumCount />
			</cfif>			
		</cfloop>

		<cfreturn qConferences />
	</cffunction>	

	<cffunction name="getAggregate" access="public" output="false" returntype="query">
		<cfargument name="idList" type="string" required="false" />
		
		<cfset var qList = "" />
		
		<cfquery name="qList" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			SELECT
				frm.forumID,
				<cfif variables.dsntype eq "mysql">
					COALESCE(SUM(thr.postCounter),0) AS postCount,
					COALESCE(SUM(vws.views),0) AS viewCount,
					MAX(thr.dateLastPost) as dateLastThread
				<cfelseif variables.dsntype eq "mssql">
					COALESCE(SUM(CONVERT(FLOAT, thr.postCounter)), 0) AS postCount,
					COALESCE(SUM(CONVERT(FLOAT, vws.views)), 0) AS viewCount,
					(SELECT MAX(dateLastPost) FROM  #variables.dsnprefix#mf_thread) as dateLastThread
				</cfif>
			FROM  #variables.dsnprefix#mf_forum frm  
				INNER JOIN #variables.dsnprefix#mf_conference cnf
					ON frm.conferenceID  = cnf.conferenceID  
				LEFT JOIN #variables.dsnprefix#mf_thread thr
					ON (frm.forumID  = thr.forumID)  
				LEFT JOIN #variables.dsnprefix#mf_viewcounter vws
					ON (thr.threadID  = vws.threadID)  
			WHERE
				frm.ForumID IN (<cfqueryparam value="#arguments.idList#" CFSQLType="cf_sql_char" list="true" maxlength="35" />)
			GROUP BY
				frm.forumID,frm.configurationID,cnf.configurationID
		</cfquery>

		<cfreturn qList />
	</cffunction>

	<cffunction name="getThreadCounter" access="public" output="false" returntype="numeric">
		<cfargument name="forumID" type="uuid" required="true" />
		<cfargument name="doUpdate" type="boolean" required="false" default="false" />

		<cfset var qCount = "">
		<cfset var qList = "">

		<cfif arguments.doUpdate>
			<cfquery name="qCount" datasource="#variables.dsn#" username="#variables.dsnusername#"  password="#variables.dsnpassword#">
				SELECT
					count(threadID) as threadCount
				FROM
					#variables.dsnprefix#mf_thread
				WHERE
					forumID = <cfqueryparam value="#arguments.forumID#" CFSQLType="cf_sql_char" />
			</cfquery>
		
			<cfquery name="qList" datasource="#variables.dsn#" username="#variables.dsnusername#"  password="#variables.dsnpassword#">
				UPDATE
					#variables.dsnprefix#mf_forum
				SET
					threadCounter = <cfqueryparam value="#qCount.threadCount#" CFSQLType="cf_sql_numeric" />
				WHERE
					forumID = <cfqueryparam value="#arguments.forumID#" CFSQLType="cf_sql_char" />
			</cfquery>
			
			<cfreturn qCount.threadCount>
		<cfelse>
			<cfquery name="qCount" datasource="#variables.dsn#" username="#variables.dsnusername#"  password="#variables.dsnpassword#">
				SELECT
					threadCounter
				FROM
					#variables.dsnprefix#mf_forum
				WHERE
					forumID = <cfqueryparam value="#arguments.forumID#" CFSQLType="cf_sql_char" />
			</cfquery>

			<cfreturn qCount.threadCounter>
		</cfif>
	</cffunction>

	<cffunction name="setLastPost" access="public" output="false" returntype="void">
		<cfargument name="forumID" type="uuid" required="true" />
		<cfargument name="postID" type="uuid" required="true" />

		<cfquery name="qList" datasource="#variables.dsn#" username="#variables.dsnusername#"  password="#variables.dsnpassword#">
			UPDATE
				#variables.dsnprefix#mf_forum
			SET
				lastPostID = <cfqueryparam value="#arguments.postID#" CFSQLType="cf_sql_char" />
			WHERE
				forumID = <cfqueryparam value="#arguments.forumID#" CFSQLType="cf_sql_char" />
		</cfquery>
	</cffunction>


<!---^^CUSTOMEND^^--->


	<cffunction name="setForumService" access="public" returntype="void" output="false">
		<cfargument name="ForumService" type="any" required="true" />
		<cfset variables['forumService'] = arguments.ForumService />
	</cffunction>
	<cffunction name="getForumService" access="public" returntype="any" output="false">
		<cfreturn variables.ForumService />
	</cffunction>
</cfcomponent>	


