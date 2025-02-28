-- =====================================
-- Monthly teams and targets load script
-- =====================================

-- Date			Who					Changes
-- 07/03/2022	Jeremai Smith		Initial version created from month end documentation, with changes to allow multiple teams per agent
-- 04/04/2022	Martin Clements		Added [NB/REN] to the XO insert section as it was missing
-- 30/05/2022	Jeremai Smith		Added SELECT statments to verify team changes before running the update statements. Added final check step at end of script
-- 28/09/2022	Jeremai Smith		Added 'Van NB Val' team code (Monday ticket 3284433473)
-- 22/03/2023	Jeremai Smith		Hyphens appeared in the 'M NB' and 'M RNL' teams in the targets spreadsheet, so adjusted case statements
-- 12/09/2023	Jeremai Smith		Added table back up step 
-- 14/03/2024	Jeremai Smith		Amended XBroker target process as now included in monthly spreadsheet
-- 02/10/2024	Jeremai Smith		Changes for new 'Specialist Risks' user
-- 29/10/2024   Linga               Added new line in the case statement for 'Specialist Risks'- 'Van - EB/SME RNL' 

-- *****************************************************************************************************************************************************************
-- WARNING: DO NOT EXECUTE THIS SCRIPT IN ITS ENTIRETY! STEP THROUGH THE SCRIPT, RUNNING THE SELECT STATEMENTS TO CHECK THE DATA BEFORE INSERTING INTO THE DATABASE.
-- *****************************************************************************************************************************************************************


-- 1. Load the targets spreadsheet into the staging table
-- ------------------------------------------------------

-- This script assumes that targets spreadsheet received from the contact centre has been checked, any errors corrected, and loaded into [MHGSQL01\TGSL].
-- [StagingTables].[dbo].[AgentMapWithTargets]. For instructions see Z:\Admin\Documentation\Month end\Qlikview Month End Processes.docx.


-- 2. Back up the existing tables
-- ------------------------------

-- The work is done directly in the live CRM database on MHGSQL01\TGSL as UAT can be many months out of date and won't have new users in Transactor_Live.
-- New users added in the Noetica dialler should have been automatically copied to the User table in live CRM, and matched to their TGSL user record (if
-- applicable, and if the name is the same).
-- Therefore we need to back up the live tables before inserting / updating so we have a copy to restore from if anything goes wrong:

USE [CRM]
GO

IF OBJECT_ID(N'dbo.BCK_User') IS NOT NULL DROP TABLE [dbo].[BCK_User];
SELECT * INTO [dbo].[BCK_User] FROM [dbo].[User];

IF OBJECT_ID(N'BCK_UserTarget') IS NOT NULL DROP TABLE [dbo].[BCK_UserTarget];
SELECT * INTO [dbo].[BCK_UserTarget] FROM [dbo].[UserTarget];

IF OBJECT_ID(N'BCK_UserTeamHistory') IS NOT NULL DROP TABLE [BCK_UserTeamHistory];
SELECT * INTO [dbo].[BCK_UserTeamHistory] FROM [dbo].[UserTeamHistory];

IF OBJECT_ID(N'dbo.BCK_UserTeamQVHistory') IS NOT NULL DROP TABLE [dbo].[BCK_UserTeamQVHistory];
SELECT * INTO [dbo].[BCK_UserTeamQVHistory] FROM [dbo].[UserTeamQVHistory];


-- 3. Check users exist in CRM database
-- ------------------------------------

-- Run the following query to check that all users in the spreadsheet can be matched to a user ID in the CRM database:
SELECT
	 [AM].[TGSLName]
	,[U].[ID]
	,[AM].[MonthlyTarget] 
	,[AM].[UnitTarget]
FROM
	[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	LEFT JOIN [CRM].[dbo].[User] AS [U] ON [U].[Forename] + ' ' + [U].[Surname] = CASE
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'XBroker' AND LTRIM(RTRIM([AM].[Team])) = 'XB - NB'
																						THEN 'XBroker NB'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'XBroker' AND LTRIM(RTRIM([AM].[Team])) = 'XB - RNL'
																						THEN 'XBroker Renewals'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'SME NB - Tier 1'
																						THEN 'Specialist Risks NB'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'Van - EB/SME RNL'
																						THEN 'Specialist Risks Renewals'
																					ELSE LTRIM(RTRIM([AM].[TGSLName]))
																				  END
										AND ISNULL([U].[Obsolete], 0) <> 1
WHERE
	[U].[ID] IS NULL
;


-- New users added in the Noetica dialler should have been automatically copied to the User table in CRM. If the query above returns any rows, they should
-- be investigated. It may be that there's a typo or formatting difference between the targets spreadsheet and the database user.
--
-- If the user definitely doesn't exist in the User table then manually insert a record into the User table. Use the following query to check if a TGSL
-- user record exists (the user may have been added to TGSL but not the dialler), and if so, copy the PROFILE_ID and LOGINNAME:
/*
SELECT * FROM [Transactor_Live].[dbo].[SYSTEM_SECURITY_PROFILE] WHERE FULLNAME LIKE '%jamil%'
*/

-- Then uncomment the following INSERT, fill in the relevant details, and insert the user:

/*
INSERT INTO [dbo].[User] (
	 [Forename]
	,[Surname]
	,[NoeticaID]
	,[NoeticaLogin]
	,[TGSLID]
	,[TGSLLogin]
	,[InsertDateTime]
	,[Obsolete]
)
SELECT
	 '' AS [Forename]
	,'' AS [Surname]
	,NULL AS [NoeticaID]
	,NULL AS [NoeticaLogin]
	,'' AS [TGSLID] -- This is the PROFILE_ID from SYSTEM_SECURITY_PROFILE
	,'' AS [TGSLLogin] -- This is the LOGINNAME from SYSTEM_SECURITY_PROFILE
	,GETDATE() [InsertDateTime]
	,NULL AS [Obsolete]
GO
*/

-- 4. Check no duplicate users exist
-- ---------------------------------

-- In very rare cases, a row in the spreadsheet may match to two User records. This can hapen if a new user has the same name as a previous user that
-- was never marked as obsolete, or if an existing user has had a new TGSL or Noetica logic created for some reason.

SELECT
	 [AM].[TGSLName]
FROM
	[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	LEFT JOIN [CRM].[dbo].[User] AS [U] ON LTRIM(RTRIM([AM].[TGSLName])) = [U].[Forename] + ' ' + [U].[Surname]
										AND ISNULL([U].[Obsolete], 0) <> 1
GROUP BY 
	[AM].[TGSLName]
HAVING
	COUNT(DISTINCT [U].[ID]) > 1;

-- If any records are returned, change the name in the following query and run it to view the duplciate records:
/*
SELECT * FROM [CRM].[dbo].[User] WHERE [Forename] + ' ' + [Surname] = 'name'
*/

-- If a true duplicate has been created (TGSL and Noetica logins are the same), then delete the latest record. If the logins are different, set the
-- Obsolete field to 1 on the older record.


-- 5. Check teams for Qlikview exist in CRM database
-- -------------------------------------------------

-- Run the following query to check that all teams in the spreadsheet can be matched to a team ID in the CRM database:

SELECT
	 [AM].*
FROM
	[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	LEFT JOIN [CRM].[dbo].[TeamQV] AS [T] ON CASE
												WHEN [AM].[Team] LIKE '%Van - EB' THEN 'Van - EB' -- Spreadsheet had 'FirstVan - EB' and 'FirstVan - NB' in July 2022. Sarah confirmed no need to display these as separate teams. Would require development to work properly with Qlikview.
												WHEN [AM].[Team] LIKE '%Van - NB' THEN 'Van - NB'
												WHEN [AM].[Team] LIKE '%Van NB%Validation' THEN 'Van - NB Validation'
												WHEN [AM].[Team] IN ('M RNL', 'M - RNL', 'M NB', 'M - NB') THEN 'M' -- M Renewals and NB combined into single M department
												WHEN [AM].[Team] IN ('XB - NB', 'XB - RNL') THEN 'XBroker' -- XBroker Renewals and NB combined into single XBroker department
												WHEN [AM].[Team] = 'Van - EB/SME RNL' THEN 'SME RNL' 
												ELSE [AM].[Team]
											 END = [T].[TeamName]
WHERE
	[T].[ID] IS NULL;

-- If the query returns any names that don’t match, check that they are not typos in the spreadsheet. If there is a genuinely new team then this will need
-- clarification and discussion with the MI team as there will be impacts on existing reports.
-- If the new team is correct then insert it into [CRM].[dbo].[TeamQV]


-- 6. Insert into UserTarget
-- -------------------------

-- Run the following to insert targets into the UserTarget table:
INSERT INTO [CRM].[dbo].[UserTarget] (
	 [UserID]
	,[SubTeamID]
	,[NB/REN]
    ,[TargetMonthDate]
   	,[TargetAmount]
	,[UnitTarget]
)
SELECT
	 [U].[ID] AS [UserID]
	,[AM].[Branch] AS [SubTeamID]
	,CASE
		WHEN [AM].[Dept] = 'New Business' THEN 'NB'
		WHEN [AM].[Dept] = 'Existing Business' THEN 'REN'
		WHEN [AM].[Team] LIKE '%NB%' THEN 'NB'
		WHEN [AM].[Team] LIKE '%RNL%s' THEN 'REN'
	 END AS [NB/REN]
	,[AM].[HierarchyMonthID] AS [TargetMonthDate]
	,[AM].[MonthlyTarget] AS [TargetAmount]
	,[AM].[UnitTarget]
FROM
	[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	INNER JOIN [CRM].[dbo].[User] AS [U] ON [U].[Forename] + ' ' + [U].[Surname] = CASE
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'XBroker' AND LTRIM(RTRIM([AM].[Team])) = 'XB - NB'
																						THEN 'XBroker NB'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'XBroker' AND LTRIM(RTRIM([AM].[Team])) = 'XB - RNL'
																						THEN 'XBroker Renewals'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'SME NB - Tier 1'
																						THEN 'Specialist Risks NB'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'Van - EB/SME RNL'
																						THEN 'Specialist Risks Renewals'
																					ELSE LTRIM(RTRIM([AM].[TGSLName]))
																				   END
										 AND ISNULL([U].[Obsolete], 0) <> 1
	LEFT JOIN [CRM].[dbo].[UserTarget] AS [UT] ON [U].[ID] = [UT].[UserID]
											   AND ISNULL([AM].[Branch], '') = ISNULL([UT].[SubTeamID], '')
											   AND [UT].[NB/REN] = CASE
																	WHEN [AM].[Dept] = 'New Business' THEN 'NB'
																	WHEN [AM].[Dept] = 'Existing Business' THEN 'REN'
																	WHEN [AM].[Team] LIKE '%NB%' THEN 'NB'
																	WHEN [AM].[Team] LIKE '%RNL%s' THEN 'REN'
																   END
											   AND [AM].[HierarchyMonthID] = [UT].[TargetMonthDate]
WHERE
	[UT].[ID] IS NULL -- Don't insert if target already exists for this User / Branch / Team / Month combination. This prevents accidental duplication.
					  -- Also prevents XBroker targets from being re-inserted from spreadsheet if already loaded up in advance (if the amount has changed
					  -- it will be updated at the end of this script).
;


-- 7. Insert into / update UserTeamQVHistory
-- -----------------------------------------

-- Run the following to select to identify new Qlikview teams to be inserted into UserTeamQVHistory. These may be new users, or existing users who have changed team.
-- There may be zero rows inserted if nothing has changed this month. Check that the changes make sense against the spreadsheet:

SELECT
	 [U].[Forename]
	,[U].[Surname]
	,[T].[TeamName]
	,[AM].[HierarchyMonthID] AS [StartDate]
	,NULL AS [EndDate]
	,[AM].[Branch] AS [SubTeamID] -- Branch number is currently the same as SubTeamID; this may change in future
FROM
	[MHGSQL01\TGSL].[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	LEFT JOIN [CRM].[dbo].[User] AS [U] ON [U].[Forename] + ' ' + [U].[Surname] = CASE
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'SME NB - Tier 1'
																						THEN 'Specialist Risks NB'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'Van - EB/SME RNL'
																						THEN 'Specialist Risks Renewals'
																					ELSE LTRIM(RTRIM([AM].[TGSLName]))
																				   END
										AND ISNULL([U].[Obsolete], 0) <> 1
	LEFT JOIN [CRM].[dbo].[TeamQV] AS [T] ON CASE
												WHEN [AM].[Team] IN ('M RNL', 'M - RNL', 'M NB', 'M - NB') THEN 'M' -- M Renewals and NB combined into single M department
												WHEN [AM].[Team] LIKE '%Van - EB' THEN 'Van - EB'
												WHEN [AM].[Team] = 'Van - EB/SME RNL' THEN 'SME RNL'
												WHEN [AM].[Team] LIKE '%Van - NB' THEN 'Van - NB'
												WHEN [AM].[Team] LIKE '%Van NB%Validation' THEN 'Van - NB Validation'
												WHEN [AM].[Team] IN ('XB - NB', 'XB - RNL') THEN 'XBroker' -- XBroker Renewals and NB combined into single XBroker department
												ELSE [AM].[Team]
											 END = [T].[TeamName]
	LEFT JOIN [CRM].[dbo].[UserTeamQVHistory] AS [H] ON [U].[ID] = [H].[UserID]
													AND [T].[ID] = [H].[TeamQVID]
													AND [H].[EndDate] IS NULL
WHERE
	[AM].[TGSLName] NOT LIKE 'Xbroker%' -- XBroker is a department, not a User, and therefore does not have Team records
	AND [H].[ID] IS NULL -- User / Team combination doesn't currently exist as active
;


-- If happy with the above, run the following to insert new Qlikview teams into UserTeamQVHistory:

INSERT INTO [CRM].[dbo].[UserTeamQVHistory] (
	 [UserID]
	,[TeamQVID]
	,[StartDate]
	,[EndDate]
	,[SubTeamID]
)
SELECT
	 [U].[ID] AS [UserID]
	,[T].[ID] AS [TeamQVID]
	,[AM].[HierarchyMonthID] AS [StartDate]
	,NULL AS [EndDate]
	,[AM].[Branch] AS [SubTeamID] -- Branch number is currently the same as SubTeamID; this may change in future
FROM
	[MHGSQL01\TGSL].[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	LEFT JOIN [CRM].[dbo].[User] AS [U] ON [U].[Forename] + ' ' + [U].[Surname] = CASE
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'SME NB - Tier 1'
																						THEN 'Specialist Risks NB'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'Van - EB/SME RNL'
																						THEN 'Specialist Risks Renewals'
																					ELSE LTRIM(RTRIM([AM].[TGSLName]))
																				   END
										AND ISNULL([U].[Obsolete], 0) <> 1
	LEFT JOIN [CRM].[dbo].[TeamQV] AS [T] ON CASE
												WHEN [AM].[Team] IN ('M RNL', 'M - RNL', 'M NB', 'M - NB') THEN 'M' -- M Renewals and NB combined into single M department
												WHEN [AM].[Team] LIKE '%Van - EB' THEN 'Van - EB'
												WHEN [AM].[Team] = 'Van - EB/SME RNL' THEN 'SME RNL'
												WHEN [AM].[Team] LIKE '%Van - NB' THEN 'Van - NB'
												WHEN [AM].[Team] LIKE '%Van NB%Validation' THEN 'Van - NB Validation'
												WHEN [AM].[Team] IN ('XB - NB', 'XB - RNL') THEN 'XBroker' -- XBroker Renewals and NB combined into single XBroker department
												ELSE [AM].[Team]
											 END = [T].[TeamName]
	LEFT JOIN [CRM].[dbo].[UserTeamQVHistory] AS [H] ON [U].[ID] = [H].[UserID]
													AND [T].[ID] = [H].[TeamQVID]
													AND [H].[EndDate] IS NULL
WHERE
	[AM].[TGSLName] NOT LIKE 'Xbroker%' -- XBroker is a department, not a User, and therefore does not have Team records
	AND [H].[ID] IS NULL -- User / Team combination doesn't currently exist as active
;


-- An SME agent may must only have one active team. A CV agent can have one active NB and one active REN team at most (they may only have one). Beyond this,
-- multiple teams for the same agent will cause duplication of financial values in the Qlikview scorecards and Daily COD Report.
-- Run the following SELECT to identify where an SME agent has two active teams, or a CV agent has two active teams with the same NB/REN value. There may
-- be zero rows returned. If values are returned, it means the user has changed team. Review the results and then run the UPDATE statement that follows to
-- expire the older row so long as everything looks OK.

SELECT
	 [H].[UserID]
	,[U].[Forename]
	,[U].[Surname]
	,[T].[NB/REN]
	,[T].[TeamName]
	,[H].[StartDate]
	,[H].[EndDate]
	,[T2].[NB/REN]
	,[T2].[TeamName]
	,[H2].[StartDate]
	,[H2].[EndDate]
FROM
	[CRM].[dbo].[UserTeamQVHistory] AS [H]
	INNER JOIN [CRM].[dbo].[User] AS [U] ON [H].[UserID] = [U].[ID]
	INNER JOIN [CRM].[dbo].[TeamQV] AS [T] ON [H].[TeamQVID] = [T].[ID]
	INNER JOIN [CRM].[dbo].[UserTeamQVHistory] AS [H2] ON [H].[UserID] = [H2].[UserID]
	INNER JOIN [CRM].[dbo].[TeamQV] AS [T2] ON [H2].[TeamQVID] = [T2].[ID]
WHERE
	([T].[BusinessAreaID] = 1 -- SME
	 OR ([T].[BusinessAreaID] = 2 AND [T].[NB/REN] = [T2].[NB/REN]) -- CV can allow concurrent NB and REN teams
	)
	AND [H2].[StartDate] > [H].[StartDate]
	AND [H].[EndDate] IS NULL
	AND [H2].[EndDate] IS NULL;

UPDATE [H]
SET [EndDate] = [H2].[StartDate]
FROM
	[CRM].[dbo].[UserTeamQVHistory] AS [H]
	INNER JOIN [CRM].[dbo].[TeamQV] AS [T] ON [H].[TeamQVID] = [T].[ID]
	INNER JOIN [CRM].[dbo].[UserTeamQVHistory] AS [H2] ON [H].[UserID] = [H2].[UserID]
	INNER JOIN [CRM].[dbo].[TeamQV] AS [T2] ON [H2].[TeamQVID] = [T2].[ID]
WHERE
	([T].[BusinessAreaID] = 1 -- SME
	 OR ([T].[BusinessAreaID] = 2 AND [T].[NB/REN] = [T2].[NB/REN]) -- CV can allow concurrent NB and REN teams
	)
	AND [H2].[StartDate] > [H].[StartDate]
	AND [H].[EndDate] IS NULL
	AND [H2].[EndDate] IS NULL;


-- 8. Check teams exist in CRM database
-- ------------------------------------

-- This and the following steps are similar to the previous steps, but a separate set of team names is maintained for the Agent Productivity Scorecard and other reports.
-- These team names exclude tier levels and branch names.

-- Run the following query to check that all teams in the spreadsheet can be matched to a team ID in the CRM database:

SELECT
	 [AM].*
FROM
	[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	LEFT JOIN [CRM].[dbo].[Team] AS [T] ON CASE
											WHEN [AM].[Team] IN ('M RNL', 'M - RNL', 'M NB', 'M - NB') THEN 'M' -- M Renewals and EB now combined into single M department
											WHEN [AM].[Team] = 'SME M (NB)' THEN 'SME NB' -- This is Daniel Veall. Leave as SME NB unless advised otherwise.
											WHEN [AM].[Team] LIKE 'SME NB%' THEN 'SME NB'
											WHEN [AM].[Team] LIKE 'SME RNL%' THEN 'SME EB'
											WHEN [AM].[Team] LIKE '%Van - EB' THEN 'Van EB'
											WHEN [AM].[Team] LIKE '%Van - NB' THEN 'Van NB'
											WHEN [AM].[Team] = 'Van - EB/SME RNL' THEN 'Van EB'
											WHEN [AM].[Team] LIKE '%Van NB%Validation' THEN 'Van NB Val'
											WHEN [AM].[Team] IN ('XB - NB', 'XB - RNL') THEN 'XBroker' -- XBroker Renewals and NB combined into single XBroker department
											ELSE [AM].[Team]
										   END = [T].[Code]
WHERE
	[AM].[TGSLName] NOT IN ('Auto Renewal', 'Web Application')
	AND [T].[ID] IS NULL;

-- If the query returns any names that don’t match, check that they are not typos in the spreadsheet. If there is a new team that cannot be matched to an
-- existing team in [CRM].[dbo].[Team] DO NOT INSERT it! These teams are hard coded into various reports such as the Daily COD Report. Discussion will be
-- required with the MI team as to how any new teams are to be added to existing MI.


-- 9. Insert into / update UserTeamHistory
-- ---------------------------------------

-- Run the following to identify new user teams to be inserted into UserTeamHistory. These may be new users, or existing users who have changed team. There may be zero
-- rows inserted if nothing has changed this month. Check that the changes make sense against the spreadsheet:

SELECT
	 [U].[Forename]
	,[U].[Surname]
	,[T].[TeamName]
	,[AM].[HierarchyMonthID] AS [StartDate]
	,NULL AS [EndDate]
FROM
	[MHGSQL01\TGSL].[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	LEFT JOIN [CRM].[dbo].[User] AS [U] ON [U].[Forename] + ' ' + [U].[Surname] = CASE
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'SME NB - Tier 1'
																						THEN 'Specialist Risks NB'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'Van - EB/SME RNL'
																						THEN 'Specialist Risks Renewals'
																					ELSE LTRIM(RTRIM([AM].[TGSLName]))
																				   END
										AND ISNULL([U].[Obsolete], 0) <> 1
	LEFT JOIN [CRM].[dbo].[Team] AS [T] ON CASE
											WHEN [AM].[Team] IN ('M RNL', 'M - RNL', 'M NB', 'M - NB') THEN 'M' -- M Renewals and EB now combined into single M department
											WHEN [AM].[Team] = 'SME M (NB)' THEN 'SME NB' -- This is Daniel Veall. Leave as SME NB unless advised otherwise.
											WHEN [AM].[Team] LIKE 'SME NB%' THEN 'SME NB'
											WHEN [AM].[Team] LIKE 'SME RNL%' THEN 'SME EB'
											WHEN [AM].[Team] LIKE '%Van - EB' THEN 'Van EB'
											WHEN [AM].[Team] = 'Van - EB/SME RNL' THEN 'Van EB'
											WHEN [AM].[Team] LIKE '%Van - NB' THEN 'Van NB'
											WHEN [AM].[Team] LIKE '%Van NB%Validation' THEN 'Van NB Val'
											ELSE [AM].[Team]
										   END = [T].[Code]
	LEFT JOIN [CRM].[dbo].[UserTeamHistory] AS [H] ON [U].[ID] = [H].[UserID]
													AND [T].[ID] = [H].[TeamID]
													AND [H].[EndDate] IS NULL
WHERE
	[AM].[TGSLName] NOT IN ('Auto Renewal', 'Web Application')
	AND [AM].[TGSLName] NOT LIKE 'Xbroker%' -- XBroker is a department, not a User, and therefore does not have Team records
	AND [H].[ID] IS NULL; -- User / Team combination doesn't currently exist as active


-- If happy with the above, run the following to insert new user teams into UserTeamHistory:

INSERT INTO [CRM].[dbo].[UserTeamHistory] (
	[UserID],
	[TeamID],
	[StartDate],
	[EndDate]
)
SELECT
	 [U].[ID] AS [UserID]
	,[T].[ID] AS [TeamID]
	,[AM].[HierarchyMonthID] AS [StartDate]
	,NULL AS [EndDate]
FROM
	[MHGSQL01\TGSL].[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	LEFT JOIN [CRM].[dbo].[User] AS [U] ON [U].[Forename] + ' ' + [U].[Surname] = CASE
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'SME NB - Tier 1'
																						THEN 'Specialist Risks NB'
																					WHEN LTRIM(RTRIM([AM].[TGSLName])) = 'Specialist Risks' AND LTRIM(RTRIM([AM].[Team])) = 'Van - EB/SME RNL'
																						THEN 'Specialist Risks Renewals'
																					ELSE LTRIM(RTRIM([AM].[TGSLName]))
																				   END
										AND ISNULL([U].[Obsolete], 0) <> 1
	LEFT JOIN [CRM].[dbo].[Team] AS [T] ON CASE
											WHEN [AM].[Team] IN ('M RNL', 'M - RNL', 'M NB', 'M - NB') THEN 'M' -- M Renewals and EB now combined into single M department
											WHEN [AM].[Team] = 'SME M (NB)' THEN 'SME NB' -- This is Daniel Veall. Leave as SME NB unless advised otherwise.
											WHEN [AM].[Team] LIKE 'SME NB%' THEN 'SME NB'
											WHEN [AM].[Team] LIKE 'SME RNL%' THEN 'SME EB'
											WHEN [AM].[Team] LIKE '%Van - EB' THEN 'Van EB'
											WHEN [AM].[Team] = 'Van - EB/SME RNL' THEN 'Van EB'
											WHEN [AM].[Team] LIKE '%Van - NB' THEN 'Van NB'
											WHEN [AM].[Team] LIKE '%Van NB%Validation' THEN 'Van NB Val'
											ELSE [AM].[Team]
										   END = [T].[Code]
	LEFT JOIN [CRM].[dbo].[UserTeamHistory] AS [H] ON [U].[ID] = [H].[UserID]
													AND [T].[ID] = [H].[TeamID]
													AND [H].[EndDate] IS NULL
WHERE
	[AM].[TGSLName] NOT IN ('Auto Renewal', 'Web Application')
	AND [AM].[TGSLName] NOT LIKE 'Xbroker%' -- XBroker is a department, not a User, and therefore does not have Team records
	AND [H].[ID] IS NULL; -- User / Team combination doesn't currently exist as active


-- An SME agent may must only have one active team. A CV agent can have one active NB and one active REN team at most (they may only have one). Beyond this,
-- multiple teams for the same agent will cause duplication of financial values in the Qlikview scorecards and Daily COD Report.
-- Run the following SELECT to identify where an SME agent has two active teams, or a CV agent has two active teams  with the same NB/REN value. There may
-- be zero rows returned. If values are returned, it means the user has changed team. Review the results and then run the UPDATE statement that follows to
-- expire the older row so long as everything looks OK.

SELECT
	 [H].[UserID]
	,[U].[Forename]
	,[U].[Surname]
	,[T].[NB/REN]
	,[T].[TeamName]
	,[H].[StartDate]
	,[H].[EndDate]
	,[T2].[NB/REN]
	,[T2].[TeamName]
	,[H2].[StartDate]
	,[H2].[EndDate]
FROM
	[CRM].[dbo].[UserTeamHistory] AS [H]
	INNER JOIN [CRM].[dbo].[User] AS [U] ON [H].[UserID] = [U].[ID]
	INNER JOIN [CRM].[dbo].[Team] AS [T] ON [H].[TeamID] = [T].[ID]
	INNER JOIN [CRM].[dbo].[UserTeamHistory] AS [H2] ON [H].[UserID] = [H2].[UserID]
	INNER JOIN [CRM].[dbo].[Team] AS [T2] ON [H2].[TeamID] = [T2].[ID]
WHERE
	([T].[BusinessAreaID] = 1 -- SME
	 OR ([T].[BusinessAreaID] = 2 AND [T].[NB/REN] = [T2].[NB/REN]) -- CV can allow concurrent NB and REN teams
	)
	AND [H2].[StartDate] > [H].[StartDate]
	AND [H].[EndDate] IS NULL
	AND [H2].[EndDate] IS NULL;

UPDATE [H]
SET [EndDate] = [H2].[StartDate]
FROM
	[CRM].[dbo].[UserTeamHistory] AS [H]
	INNER JOIN [CRM].[dbo].[Team] AS [T] ON [H].[TeamID] = [T].[ID]
	INNER JOIN [CRM].[dbo].[UserTeamHistory] AS [H2] ON [H].[UserID] = [H2].[UserID]
	INNER JOIN [CRM].[dbo].[Team] AS [T2] ON [H2].[TeamID] = [T2].[ID]
WHERE
	([T].[BusinessAreaID] = 1 -- SME
	 OR ([T].[BusinessAreaID] = 2 AND [T].[NB/REN] = [T2].[NB/REN]) -- CV can allow concurrent NB and REN teams
	)
	AND [H2].[StartDate] > [H].[StartDate]
	AND [H].[EndDate] IS NULL
	AND [H2].[EndDate] IS NULL;


-- 10. XBroker targets
-- ------------------

-- XBroker targets are a special case as they are deparment targets (used in the Daily COD Report). There are separate New Business and Renewal targets and so
-- two users have been created in the CRM User table to store these against, although they are not technically users.

-- Previously, XBroker targets were loaded up a year in advance. However, as of March 2024 they are included in the monthly targets spreadsheet. If an XBroker
-- target did not already exist for the new month it will have been loaded by the process above.

-- However, the spreadsheet may contain an updated target for a month that was previously loaded. Run the following to update the target from the spreadsheet:

UPDATE [UT]
	SET [TargetAmount] = [AM].[MonthlyTarget]
FROM
	[StagingTables].[dbo].[AgentMapWithTargets] AS [AM]
	INNER JOIN [CRM].[dbo].[User] AS [U] ON [U].[Forename] + ' ' + [U].[Surname] = CASE
																					WHEN LTRIM(RTRIM([AM].[Team])) = 'XB - NB' THEN 'XBroker NB'
																					WHEN LTRIM(RTRIM([AM].[Team])) = 'XB - RNL' THEN 'XBroker Renewals'
																				   END
										 AND ISNULL([U].[Obsolete], 0) <> 1
	LEFT JOIN [CRM].[dbo].[UserTarget] AS [UT] ON [U].[ID] = [UT].[UserID]
											   AND [UT].[NB/REN] = CASE
																	WHEN [AM].[Dept] = 'New Business' THEN 'NB'
																	WHEN [AM].[Dept] = 'Existing Business' THEN 'REN'
																	WHEN [AM].[Team] LIKE '%NB%' THEN 'NB'
																	WHEN [AM].[Team] LIKE '%RNL%s' THEN 'REN'
																   END
											   AND [AM].[HierarchyMonthID] = [UT].[TargetMonthDate]
WHERE
	[AM].[TGSLName] LIKE 'XBroker%'
	AND [UT].[TargetAmount] <> [AM].[MonthlyTarget]
;


-- If future XBroker targets need to be loaded in advance again, the following script can be uncommented and the dates amended:
/*
INSERT INTO [dbo].[UserTarget] (
	 [UserID]
	,[SubTeamID]
	,[NB/REN]
	,[TargetMonthDate]
	,[TargetAmount]
	,[UnitTarget]
)
SELECT
	 [U].[ID]
	,0
	,'NB'
	,'1 Jun 2021' -- Change to the target month being loaded
	,25000 -- Change the NB target amount
	,NULL
FROM
	[dbo].[User] AS [U]
WHERE
	[U].[Forename] = 'XBroker NB'

UNION ALL

SELECT
	  [U].[ID]
	 ,0
	 ,'REN'
	 ,'1 Jun 2021' -- Change to the target month being loaded
	 ,16952 -- Change the EB target amount
	 ,NULL
FROM
	[dbo].[User] AS [U]
WHERE
	[U].[Forename] = 'XBroker Renewals';
*/


-- 11. Check the results
-- --------------------

-- Finally, check the teams and targets that have been loaded into the database for the month that has just been loaded (change the date below). Cross
-- reference against the spreadsheet and ensure all teams and targets match.

SELECT *
FROM [CRM].[dbo].[QVAgentTeamTargetNBREN]
WHERE HierarchyMonthID = '01 Jan 2025' -- CHANGE DATE HERE
AND MonthlyTarget > 0
ORDER BY 2;