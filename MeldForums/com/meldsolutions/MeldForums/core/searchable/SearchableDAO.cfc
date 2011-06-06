<!---||MELDFORUMSLICENSE||--->
<cfcomponent displayname="SearchableDAO" output="false" extends="MeldForums.com.meldsolutions.core.MeldDAO">
<!---^^GENERATEDSTART^^--->
	<cffunction name="init" access="public" output="false" returntype="SearchableDAO">
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
	
	<cffunction name="save" access="public" output="false" returntype="boolean">
		<cfargument name="SearchableBean" type="any" required="true" />

		<cfset var qCreate = "" />
		<cfquery name="qCreate" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			INSERT INTO
				#variables.dsnprefix#mf_searchable
				(
				<!---^^SAVECOLUMNS-START^^--->
				ThreadID,
				PostID,
				Searchblock,
				DateLastUpdate,
				SiteID,
				ForumID
				<!---^^SAVECOLUMNS-END^^--->
				)
			VALUES
				(
				<!---^^SAVEVALUES-START^^--->
				<cfqueryparam value="#arguments.SearchableBean.getThreadID()#" CFSQLType="cf_sql_char" maxlength="35" />,
				<cfqueryparam value="#arguments.SearchableBean.getPostID()#" CFSQLType="cf_sql_char" maxlength="35" />,
				<cfqueryparam value="#arguments.SearchableBean.getSearchblock()#" CFSQLType="cf_sql_longvarchar" />,
				<cfqueryparam value="#CreateODBCDateTime(now())#" CFSQLType="cf_sql_timestamp" />,
				<cfqueryparam value="#arguments.SearchableBean.getSiteID()#" CFSQLType="cf_sql_varchar" maxlength="25" />,
				<cfqueryparam value="#arguments.SearchableBean.getForumID()#" CFSQLType="cf_sql_char" maxlength="35" />
				<!---^^SAVEVALUES-END^^--->
				)
		</cfquery>
		
		<cfset arguments.SearchableBean.setBeanExists( 1 ) />
		<cfset arguments.SearchableBean.setDateCreate( CreateODBCDateTime(now()) ) />
		<cfset arguments.SearchableBean.setDateLastUpdate( CreateODBCDateTime(now()) ) />

		<cfreturn true />
	</cffunction>

	<cffunction name="read" access="public" output="false" returntype="void">
		<cfargument name="SearchableBean" type="any" required="true" />

		<cfset var qRead = "" />
		<cfset var strReturn = structNew() />
		<cfquery name="qRead" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			SELECT
				*,true AS BeanExists
			FROM
				#variables.dsnprefix#mf_searchable
			WHERE
			0=0
			<!---^^PRIMARYKEYS-START^^--->
				AND ThreadID = <cfqueryparam value="#arguments.SearchableBean.getThreadID()#" CFSQLType="cf_sql_char" maxlength="35" />
			AND PostID = <cfqueryparam value="#arguments.SearchableBean.getPostID()#" CFSQLType="cf_sql_char" maxlength="35" />
			<!---^^PRIMARYKEYS-END^^--->
		</cfquery>

		<cfif qRead.recordCount>
			<cfset strReturn = queryRowToStruct(qRead)>
			<cfset arguments.SearchableBean.init(argumentCollection=strReturn)>
		</cfif>
	</cffunction>

	<cffunction name="update" access="public" output="false" returntype="boolean">
		<cfargument name="SearchableBean" type="any" required="true" />

		<cfset var qUpdate = "" />
		<cfquery name="qUpdate" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			UPDATE
				#variables.dsnprefix#mf_searchable
			SET
				<!---^^UPDATEVALUES-START^^--->
				Searchblock = <cfqueryparam value="#arguments.SearchableBean.getSearchblock()#" CFSQLType="cf_sql_longvarchar" />,
				DateLastUpdate = <cfqueryparam value="#CreateODBCDateTime(now())#" CFSQLType="cf_sql_timestamp" />,
				SiteID = <cfqueryparam value="#arguments.SearchableBean.getSiteID()#" CFSQLType="cf_sql_varchar" maxlength="25" />,
				ForumID = <cfqueryparam value="#arguments.SearchableBean.getForumID()#" CFSQLType="cf_sql_char" maxlength="35" />
				<!---^^UPDATEVALUES-END^^--->
		WHERE
			0=0
			<!---^^PRIMARYKEYS-START^^--->
				AND ThreadID = <cfqueryparam value="#arguments.SearchableBean.getThreadID()#" CFSQLType="cf_sql_char" maxlength="35" />
			AND PostID = <cfqueryparam value="#arguments.SearchableBean.getPostID()#" CFSQLType="cf_sql_char" maxlength="35" />
			<!---^^PRIMARYKEYS-END^^--->
		</cfquery>

		<cfset arguments.SearchableBean.setDateLastUpdate( CreateODBCDateTime(now()) ) />

		<cfreturn true />
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="boolean">
		<cfargument name="SearchableBean" type="any" required="true" />

		<cfset var qDelete = "">
		<cfquery name="qDelete" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			DELETE FROM
					#variables.dsnprefix#mf_searchable
			WHERE
				0=0
			<!---^^PRIMARYKEYS-START^^--->
				AND ThreadID = <cfqueryparam value="#arguments.SearchableBean.getThreadID()#" CFSQLType="cf_sql_char" maxlength="35" />
			AND PostID = <cfqueryparam value="#arguments.SearchableBean.getPostID()#" CFSQLType="cf_sql_char" maxlength="35" />
			<!---^^PRIMARYKEYS-END^^--->
		</cfquery>

		<cfset arguments.SearchableBean.setBeanExists( 0 ) />

		<cfreturn true />
	</cffunction>

	<cffunction name="exists" access="public" output="false" returntype="boolean">
		<cfargument name="SearchableBean" type="any" required="true" />

		<cfset var qExists = "">
		<cfquery name="qExists" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			SELECT
				count(1) as idexists
			FROM
				#variables.dsnprefix#mf_searchable
			WHERE
				0=0
			<!---^^PRIMARYKEYS-START^^--->
				AND ThreadID = <cfqueryparam value="#arguments.SearchableBean.getThreadID()#" CFSQLType="cf_sql_char" maxlength="35" />
			AND PostID = <cfqueryparam value="#arguments.SearchableBean.getPostID()#" CFSQLType="cf_sql_char" maxlength="35" />
			<!---^^PRIMARYKEYS-END^^--->
		</cfquery>

		<cfif qExists.idexists>
			<cfset arguments.SearchableBean.setBeanExists( 1 ) />
			<cfreturn true />
		<cfelse>
			<cfset arguments.SearchableBean.setBeanExists( 0 ) />
			<cfreturn false />
		</cfif>
	</cffunction>

<!---^^GENERATEDEND^^--->
<!---^^CUSTOMSTART^^--->
<!---^^CUSTOMEND^^--->
</cfcomponent>	




