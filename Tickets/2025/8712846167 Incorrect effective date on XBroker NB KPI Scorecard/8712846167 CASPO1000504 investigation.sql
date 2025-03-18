-- Policy, RAL and transaction history:
-- ------------------------------------

DECLARE @POLICY_DETAILS_ID TABLE ([POLICY_DETAILS_ID] char(32)) 
INSERT INTO @POLICY_DETAILS_ID SELECT DISTINCT [POLICY_DETAILS_ID] FROM [CUSTOMER_POLICY_DETAILS] WHERE [POLICYNUMBER] = 'CASPO1000504'
 
SELECT [CIP].[SURNAME], [LPS].[POLICY_STATUS_DEBUG], [CPD].[POLICYSTARTDATE], [CPD].[POLICYENDDATE], [CPD].MTASTARTDATE, * FROM [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD]
INNER JOIN [dbo].[LIST_POLICY_STATUS] AS [LPS] ON [CPD].[POLICY_STATUS_ID] = [LPS].[POLICY_STATUS_ID]
LEFT JOIN [dbo].[CUSTOMER_POLICY_LINK] AS [CPL] ON [CPD].[POLICY_DETAILS_ID] = [CPL].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CPL].[POLICY_DETAILS_HISTORY_ID]
LEFT JOIN [dbo].[CUSTOMER_INSURED_PARTY] AS [CIP] ON [CPL].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND [CPL].[INSURED_PARTY_HISTORY_ID] = [CIP].[HISTORY_ID]
WHERE [CPD].[POLICY_DETAILS_ID] IN (SELECT [POLICY_DETAILS_ID] FROM @POLICY_DETAILS_ID)
ORDER BY [CPD].[HISTORY_ID]
 
SELECT [LAT].[ACTION_LOG_TYPE_DEBUG], [RAL].*, [TVFNBREN].* FROM [dbo].[REPORT_ACTION_LOG] AS [RAL]
INNER JOIN [dbo].[LIST_ACTION_LOG_TYPE] AS [LAT] ON [RAL].[ACTIONTYPE] = [LAT].[ACTION_LOG_TYPE_ID]
OUTER APPLY [dbo].[tvfClassifyRAL_NB_REN] ([RAL].[ACTION_LOG_ID]) AS [TVFNBREN]
WHERE [RAL].[POLICY_DETAILS_ID] IN (SELECT [POLICY_DETAILS_ID] FROM @POLICY_DETAILS_ID)
AND [RAL].[ACTIONTYPE] NOT IN (6, 43) -- Amend, ClientContact
ORDER BY [RAL].[ACTIONDATE]
 

 -- Logic from report procedure uspReportXBrokerNBKPIScorecard:
 -- -----------------------------------------------------------

 DECLARE @DateType varchar(25) = 'Action Date' -- 'Action Date'
DECLARE @StartDate datetime = '28 Feb 2025'
DECLARE @EndDate datetime = '17 mar 2025'

SELECT
	 [QVCD].[POLICY_DETAILS_ID]																					AS [POLICY_DETAILS_ID]
	,[QVCD].[HISTORY_ID]																						AS [HISTORY_ID]
--	,[QVCD].[HistoryOrGroupingID]																				AS [HistoryOrGroupingID]
	,[QVCD].[POLICYNUMBER]																						AS [PolicyNumber]
	,[QVCD].[PolicyStatus]																						AS [PolicyStatus]
	--,[QVCD].[POLICY_STATUS_DEBUG]																				AS [POLICY_STATUS_DEBUG]
	--,RTRIM([QVCD].[ClientReference])																			AS [ClientReference]
	--,[QVCD].[AGENT_ID]																							AS [AGENT_ID]
	--,[QVCD].[AgentName]																							AS [AgentName]
	--,ISNULL([TEAM].[Team], 'Others')																			AS [Team]
	--,[QVCD].[Tier]																								AS [Tier]
	--,CASE
	--	WHEN [QVCD].[QuoteSale] LIKE 'xb%' THEN 'Web Application'
	--	ELSE [U].[Forename] + ' ' + [U].[Surname]
	-- END																										AS [SaleAgent]
	--,[QVCD].[SubAgentName]																						AS [SubAgent]
	--,[QVCD].[Booked_Business_NB/REN/CANX/MTA]																	AS [Booked_Business_NB/REN/CANX/MTA]
	--,[QVCD].[XBroker_NB/REN]																					AS [XBroker_NB/REN]
	--,[QVCD].[InsurerName]																						AS [Insurer]
	--,[QVCD].[Client_Source]																						AS [ClientSource]
	--,[QVCD].[Action]																							AS [TransactionType]
	,[QVCD].[POLICYSTARTDATE]
	,[QVCD].[MTASTARTDATE] 
	,LEFT(DATENAME(MONTH,[QVCD].[Quotedate]),3) + '-' + CAST(YEAR([QVCD].[Quotedate]) AS varchar)				AS [OriginalActionDateMonthYear]
	,CASE WHEN [QVCD].[ACTIONTYPE] = 3 THEN [QVCD].[MTASTARTDATE] ELSE [QVCD].[POLICYSTARTDATE] END				AS [PolicyEffectiveDate]
	,[QVCD].[FirstQuotedDate]																					AS [FirstQuotedDate]
	--,[QVCD].[PrimaryTrade]																						AS [PrimaryTrade]
	--,NULL																										AS [IncomeBand]
	--,[QVCD].[ProductName]																						AS [Product]
	--,[QVCD].[PPCKeyword]																						AS [PPCKeyword]
	--,CASE WHEN [QVCD].[Action] IN ('New Business Quote', 'Renewal Quote') THEN 1 ELSE 0 END	+ [QVCD].[IncompleteCount]	AS [Lead]
	--,CASE WHEN [QVCD].[Action] IN ('New Business Quote', 'Renewal Quote') THEN 1 ELSE 0 END						AS [Quotes]
	--,CASE WHEN [QVCD].[Action] = 'New Business Quote' THEN [QVCD].[DuplicateQuoteInMonth] ELSE 0 END			AS [DuplicateQuote]
	--,CASE
	--	WHEN [QVCD].[XBroker_NB/REN] = 'NB' AND [QVCD].[Action] IN ('Renewal', 'New Business')
	--		THEN 1
	--	ELSE 0 END 																								AS [GrossSales]
	--,[QVCD].[Core_Addon]																						AS [Core_Addon]
	--,CASE
	--	WHEN [QVCD].[Core_Addon] = 'Core'
	--		AND [QVCD].[XBroker_NB/REN] = 'NB'
	--		AND [QVCD].[Action] IN ('Renewal', 'New Business')
	--		THEN 1
	--	ELSE 0
	-- END																										 AS [CoreSales]
	--,CASE
	--	WHEN [QVCD].[Core_Addon] = 'Add-on'
	--		AND [QVCD].[XBroker_NB/REN] = 'NB'
	--		AND [QVCD].[Action] IN ('Renewal', 'New Business')
	--		THEN 1
	--	ELSE 0
	-- END																										 AS [AddOnSales]
FROM
	[dbo].[QVCustomerDetails] AS [QVCD]
		LEFT JOIN [dbo].[User] AS [U] ON [QVCD].[QuoteSale]	= [U].[TGSLLogin] -- Synonym pointing to CRM database
			OUTER APPLY (SELECT TOP 1 [VATT].[Team] FROM [dbo].[QVAgentTeamTargetNBREN] AS [VATT] -- Synonym pointing to CRM database; select TOP 1 to prevent duplication where Van agents with targets for separate branches have quoted / sold SME
						 WHERE [U].[ID] = [VATT].[UserID]
						 AND DATEFROMPARTS(YEAR([QVCD].[POLICYSTARTDATE]), MONTH([QVCD].[POLICYSTARTDATE]), 1) = [VATT].[HierarchyMonthID]
						 AND [QVCD].[Booked_Business_NB/REN] = [VATT].[NB/REN]
						 ) AS [TEAM]
WHERE
[QVCD].[POLICYNUMBER] = 'CASPO1000504' and
	((@DateType = 'Effective Date' AND [QVCD].[ACTIONTYPE] IN (1,2,5,9,42,43) AND [QVCD].[POLICYSTARTDATE] >= @StartDate AND [QVCD].[POLICYSTARTDATE] < @EndDate) -- Quote,Policy, Renewal, Reinstatement, ManualDebitCredit, ClientContact. Note, for ManualDebitCredit the source value in the QVCD table is RAL.POLICYSTARTDATE instead of CPD.POLICYSTARTDATE as the date on the RAL appears to be the effective date the agent enters when keying the ManualDebitCredit, which can apply to a CPD record with a start date much earlier.
	  OR (@DateType = 'Effective Date' AND [QVCD].[ACTIONTYPE] = 3 AND [QVCD].[MTASTARTDATE] >= @StartDate AND [QVCD].[MTASTARTDATE] < @EndDate) -- MTA
	  OR (@DateType = 'Action Date' AND [QVCD].[ACTIONDATE] >= @StartDate AND [QVCD].[ACTIONDATE]  < @EndDate)
	 )
	AND [QVCD].[XBroker_NB/REN] = 'NB'
	AND [QVCD].[Action] IN ('Renewal', 'New Business', 'Reinstatement', 'New Business Quote', 'Lead', 'NBMTA', 'Renewal Quote')
	AND ([QVCD].[PolicyStatus] IS NULL
		 OR [PolicyStatus] IN ('Policy','Renewed','Lapsed','LapsedRenewed', 'Quote')
		 OR ([PolicyStatus] = 'Cancelled' AND [QVCD].[POLICY_STATUS_DEBUG] = 'History File' AND [QVCD].[InMonthCancellation] <> 1 AND [QVCD].[Action] IN ('Renewal', 'New Business'))
		 OR ([PolicyStatus] = 'Invited' AND [QVCD].[POLICY_STATUS_DEBUG] IN ('Policy', 'History File'))
		 OR [QVCD].[Action] IN ('New Business Quote', 'Lead') -- i.e. ignore the policy status and return all of these
		 )
ORDER BY
	[QVCD].[POLICYNUMBER]