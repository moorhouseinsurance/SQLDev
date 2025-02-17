USE [MI]
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create date: 24 Oct 2024
-- Description:	SME XBroker NB KPI Scorecard dataset from overnight saved data (Qlikview replacement)
-- =============================================

-- Date			Who						Change
-- 14/02/2025	Jeremai Smith			Added DuplicateQuoteInMonth field (Monday.com ticket 8370817954)


ALTER PROCEDURE [dbo].[uspReportXBrokerNBKPIScorecard]
	 @DateType varchar(25)
	,@StartDate datetime
	,@EndDate datetime
AS

/*

DECLARE @DateType varchar(25) = 'Effective Date' -- 'Action Date'
DECLARE @StartDate datetime = '01 Oct 2024'
DECLARE @EndDate datetime = '31 Oct 2024'

EXEC [dbo].[uspReportXBrokerNBKPIScorecard] @DateType, @StartDate, @EndDate

*/


IF CONVERT(VARCHAR(12), @EndDate, 114) = '00:00:00:000'
	SET @EndDate = DATEADD(DAY, 1, @EndDate);

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


-- Create table variable to hold data:

DECLARE @Data TABLE (
	 [POLICY_DETAILS_ID] char(32)
	,[HISTORY_ID] int
	,[HistoryOrGroupingID] int
	,[PolicyNumber] varchar(30)
	,[PolicyStatus] varchar(30)
	,[POLICY_STATUS_DEBUG] varchar(50)
	,[ClientReference] varchar(25)
	,[AGENT_ID] char(32)
	,[AgentName] varchar(255)
	,[Team] varchar(40)
	,[Tier] varchar(25)
	,[SaleAgent] varchar(255)
	,[SubAgent] varchar(255)
	,[Booked_Business_NB/REN/CANX/MTA] varchar(10)
	,[XBroker_NB/REN] varchar(10)
	,[Insurer] varchar(255)
	,[ClientSource] varchar(50)
	,[TransactionType] varchar(18)
	,[OriginalActionDateMonthYear] varchar(10)
	,[PolicyEffectiveDate] datetime
	,[FirstQuotedDate] datetime
	,[PrimaryTrade] varchar(255)
	,[IncomeBand] varchar(25)	
	,[Product] varchar(255)
	,[PPCKeyword] varchar(255)
	,[Lead] int
	,[Quotes] int
	,[DuplicateQuote] int
	,[LeadConversionPC] decimal(18,2)
	,[GrossSales] int
	,[Core_Addon] varchar(10)
	,[CoreSales] int
	,[AddOnSales] int
	,[GWP] money
	,[CoreGWP] money
	,[AddOnGWP] money
	,[Income] money
	,[CoreIncome] money
	,[AddOnIncome] money
	,[Fee] money
	,[Commission] money
	,[Discount] money
	,[BrokerCommission] money
	,[QuoteConversionPC] decimal(18,2)
	,[PenetrationPC] decimal(18,2)
	,[AvgClientGWP] money
	,[AvgClientIncome] money
	,[AvgClientCommission] money
	,[AvgClientFee] money
	,[AvgPolicyGWPCore] money
	,[AvgPolicyGWPAddOn] money
	,[AvgPolicyIncomeCore] money
	,[AvgPolicyIncomeAddOn] money
	,[AgentCommission] money
)
;


INSERT INTO @Data (
	 [POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[HistoryOrGroupingID]
	,[PolicyNumber]
	,[PolicyStatus]
	,[POLICY_STATUS_DEBUG]
	,[ClientReference]
	,[AGENT_ID]
	,[AgentName]
	,[Team]
	,[Tier]
	,[SaleAgent]
	,[SubAgent]
	,[Booked_Business_NB/REN/CANX/MTA]
	,[XBroker_NB/REN]
	,[Insurer]
	,[ClientSource]
	,[TransactionType]
	,[OriginalActionDateMonthYear]
	,[PolicyEffectiveDate]
	,[FirstQuotedDate]
	,[PrimaryTrade]
	,[IncomeBand]
	,[Product]
	,[PPCKeyword]
	,[Lead]
	,[Quotes]
	,[DuplicateQuote]
	,[GrossSales]	
	,[Core_Addon]
	,[CoreSales]
	,[AddOnSales]
)
SELECT
	 [QVCD].[POLICY_DETAILS_ID]																					AS [POLICY_DETAILS_ID]
	,[QVCD].[HISTORY_ID]																						AS [HISTORY_ID]
	,[QVCD].[HistoryOrGroupingID]																				AS [HistoryOrGroupingID]
	,[QVCD].[POLICYNUMBER]																						AS [PolicyNumber]
	,[QVCD].[PolicyStatus]																						AS [PolicyStatus]
	,[QVCD].[POLICY_STATUS_DEBUG]																				AS [POLICY_STATUS_DEBUG]
	,RTRIM([QVCD].[ClientReference])																			AS [ClientReference]
	,[QVCD].[AGENT_ID]																							AS [AGENT_ID]
	,[QVCD].[AgentName]																							AS [AgentName]
	,ISNULL([TEAM].[Team], 'Others')																			AS [Team]
	,[QVCD].[Tier]																								AS [Tier]
	,CASE
		WHEN [QVCD].[QuoteSale] LIKE 'xb%' THEN 'Web Application'
		ELSE [U].[Forename] + ' ' + [U].[Surname]
	 END																										AS [SaleAgent]
	,[QVCD].[SubAgentName]																						AS [SubAgent]
	,[QVCD].[Booked_Business_NB/REN/CANX/MTA]																	AS [Booked_Business_NB/REN/CANX/MTA]
	,[QVCD].[XBroker_NB/REN]																					AS [XBroker_NB/REN]
	,[QVCD].[InsurerName]																						AS [Insurer]
	,[QVCD].[Client_Source]																						AS [ClientSource]
	,[QVCD].[Action]																							AS [TransactionType]
	,LEFT(DATENAME(MONTH,[QVCD].[Quotedate]),3) + '-' + CAST(YEAR([QVCD].[Quotedate]) AS varchar)				AS [OriginalActionDateMonthYear]
	,CASE WHEN [QVCD].[ACTIONTYPE] = 3 THEN [QVCD].[MTASTARTDATE] ELSE [QVCD].[POLICYSTARTDATE] END				AS [PolicyEffectiveDate]
	,[QVCD].[FirstQuotedDate]																					AS [FirstQuotedDate]
	,[QVCD].[PrimaryTrade]																						AS [PrimaryTrade]
	,NULL																										AS [IncomeBand]
	,[QVCD].[ProductName]																						AS [Product]
	,[QVCD].[PPCKeyword]																						AS [PPCKeyword]
	,CASE WHEN [QVCD].[Action] IN ('New Business Quote', 'Renewal Quote') THEN 1 ELSE 0 END	+ [QVCD].[IncompleteCount]	AS [Lead]
	,CASE WHEN [QVCD].[Action] IN ('New Business Quote', 'Renewal Quote') THEN 1 ELSE 0 END						AS [Quotes]
	,CASE WHEN [QVCD].[Action] = 'New Business Quote' THEN [QVCD].[DuplicateQuoteInMonth] ELSE 0 END			AS [DuplicateQuote]
	,CASE
		WHEN [QVCD].[XBroker_NB/REN] = 'NB' AND [QVCD].[Action] IN ('Renewal', 'New Business')
			THEN 1
		ELSE 0 END 																								AS [GrossSales]
	,[QVCD].[Core_Addon]																						AS [Core_Addon]
	,CASE
		WHEN [QVCD].[Core_Addon] = 'Core'
			AND [QVCD].[XBroker_NB/REN] = 'NB'
			AND [QVCD].[Action] IN ('Renewal', 'New Business')
			THEN 1
		ELSE 0
	 END																										 AS [CoreSales]
	,CASE
		WHEN [QVCD].[Core_Addon] = 'Add-on'
			AND [QVCD].[XBroker_NB/REN] = 'NB'
			AND [QVCD].[Action] IN ('Renewal', 'New Business')
			THEN 1
		ELSE 0
	 END																										 AS [AddOnSales]
FROM
	[dbo].[QVCustomerDetails] AS [QVCD]
		LEFT JOIN [dbo].[User] AS [U] ON [QVCD].[QuoteSale]	= [U].[TGSLLogin] -- Synonym pointing to CRM database
			OUTER APPLY (SELECT TOP 1 [VATT].[Team] FROM [dbo].[QVAgentTeamTargetNBREN] AS [VATT] -- Synonym pointing to CRM database; select TOP 1 to prevent duplication where Van agents with targets for separate branches have quoted / sold SME
						 WHERE [U].[ID] = [VATT].[UserID]
						 AND DATEFROMPARTS(YEAR([QVCD].[POLICYSTARTDATE]), MONTH([QVCD].[POLICYSTARTDATE]), 1) = [VATT].[HierarchyMonthID]
						 AND [QVCD].[Booked_Business_NB/REN] = [VATT].[NB/REN]
						 ) AS [TEAM]
WHERE
	((@DateType = 'Effective Date' AND [QVCD].[ACTIONTYPE] IN (1,2,5,9,42,43) AND [QVCD].[POLICYSTARTDATE] >= @StartDate AND [QVCD].[POLICYSTARTDATE] < @EndDate) -- Quote,Policy, Renewal, Reinstatement, ManualDebitCredit, ClientContact. Note, for ManualDebitCredit the source value in the QVCD table is RAL.POLICYSTARTDATE instead of CPD.POLICYSTARTDATE as the date on the RAL appears to be the effective date the agent enters when keying the ManualDebitCredit, which can apply to a CPD record with a start date much earlier.
	  OR (@DateType = 'Effective Date' AND [QVCD].[ACTIONTYPE] = 3 AND [QVCD].[MTASTARTDATE] >= @StartDate AND [QVCD].[MTASTARTDATE] < @EndDate) -- MTA
	  OR (@DateType = 'Action Date' AND [QVCD].[ACTIONDATE] >= @StartDate AND [QVCD].[ACTIONDATE]  < @EndDate)
	 )
	AND [QVCD].[XBroker_NB/REN] = 'NB'
	AND [QVCD].[Action] IN ('Renewal', 'New Business', 'Reinstatement', 'New Business Quote', 'Lead', 'NBMTA', 'Renewal Quote')
	AND ([QVCD].[PolicyStatus] IS NULL
		 OR [PolicyStatus] IN ('Policy','Renewed','Lapsed','LapsedRenewed', 'Quote')
		 OR ([PolicyStatus] = 'Cancelled' AND [QVCD].[POLICY_STATUS_DEBUG] = 'History File' AND [QVCD].[InMonthCancellation] <> 1)
		 OR ([PolicyStatus] = 'Invited' AND [QVCD].[POLICY_STATUS_DEBUG] IN ('Policy', 'History File'))
		 OR [QVCD].[Action] IN ('New Business Quote', 'Lead') -- i.e. ignore the policy status and return all of these
		 )
ORDER BY
	[QVCD].[POLICYNUMBER]
;


-- Update financials:
-- (For some reason this works much faster as an update compared to joining to PolicyFinancials in the insert statement above)

UPDATE [Data]
SET	 [GWP] = [FIN].[GWP]
	,[CoreGWP] = CASE WHEN [Data].[Core_Addon] = 'Core' THEN [FIN].[GWP] ELSE 0 END
	,[AddOnGWP] = CASE WHEN [Data].[Core_Addon] = 'Add-on' THEN [FIN].[GWP] ELSE 0 END
	,[Income] = CASE WHEN [Data].[TransactionType] = 'Renewal' AND [PolicyStatus] = 'Cancelled' THEN 0 ELSE [FIN].[Income] END -- For some reason Qlikview shows GWP for cancelled renewals but not income; not sure if this is correct
	,[CoreIncome] = CASE
						WHEN [Data].[Core_Addon] = 'Core'
							THEN CASE WHEN [Data].[TransactionType] = 'Renewal' AND [PolicyStatus] = 'Cancelled' THEN 0 ELSE [FIN].[Income] END
					END
	,[AddOnIncome] = CASE
						WHEN [Data].[Core_Addon] = 'Add-on'
							THEN CASE WHEN [Data].[TransactionType] = 'Renewal' AND [PolicyStatus] = 'Cancelled' THEN 0 ELSE [FIN].[Income] END
					END
	,[Fee] = CASE WHEN [Data].[TransactionType] = 'Renewal' AND [PolicyStatus] = 'Cancelled' THEN 0 ELSE [FIN].[Fee] END
	,[Commission] = CASE WHEN [Data].[TransactionType] = 'Renewal' AND [PolicyStatus] = 'Cancelled' THEN 0 ELSE [FIN].[BrokerTotalCommissionAndDiscount] + [FIN].[SubAgentTotalCommissionAndDiscount] END
	,[Discount] = CASE WHEN [Data].[TransactionType] = 'Renewal' AND [PolicyStatus] = 'Cancelled' THEN 0 ELSE [FIN].[TotalDiscount] END
	,[BrokerCommission] = CASE WHEN [Data].[TransactionType] = 'Renewal' AND [PolicyStatus] = 'Cancelled' THEN 0 ELSE [FIN].[BrokerCommissionFlatRate] END
	,[AgentCommission] = CASE WHEN [Data].[TransactionType] = 'Renewal' AND [PolicyStatus] = 'Cancelled' THEN 0 ELSE [FIN].[AgentCommission] END
FROM
	@Data AS [Data]
	INNER JOIN [dbo].[PolicyFinancials] AS [FIN] ON [Data].[POLICY_DETAILS_ID] = [FIN].[POLICY_DETAILS_ID] AND [Data].[HistoryOrGroupingID] = [FIN].[HistoryOrGroupingID]
WHERE
	[Lead] = 0
;


-- Delete sales rows with no financials (keep leads):

DELETE FROM @Data
WHERE [GWP] IS NULL AND [Commission] IS NULL AND [Discount] IS NULL AND [Fee] IS NULL AND [Income] IS NULL
AND [Lead] = 0
;


-- [XBroker_NB/REN] = 'NB' can include renewals that have transferred from a previous insurer to Toledo (which is classed as XBroker), but being renewals they don't have a lead or quote.
-- This inflates the lead/quote to sales percentage and can cause it to be over 100%! Therefore, add the sale count:

UPDATE @Data
SET  [Lead] = [Lead] + [GrossSales]
	,[Quotes] = [Quotes] + [GrossSales]
WHERE [Booked_Business_NB/REN/CANX/MTA] = 'REN'
;


-- Udpate summary fields based on fields populated above:

UPDATE [Data]
SET  [IncomeBand] = CASE
						WHEN [Income] >= 0 AND [Income] < 10 THEN '£0 - £9'
						WHEN [Income] >= 10 AND [Income] < 100 THEN '£10 - £99'
						WHEN [Income] >= 100 AND [Income] < 250 THEN '£100 - £249'
						WHEN [Income] >= 250 AND [Income] < 500 THEN '£250 - £499'
						WHEN [Income] >= 500 AND [Income] < 750 THEN '£500 - £749'
						WHEN [Income] >= 750 AND [Income] < 1000 THEN '£750 - £999'
						WHEN [Income] >= 1000 AND [Income] < 2000 THEN '£1000 - £1999'
						WHEN [Income] >= 2000 AND [Income] < 3000 THEN '£2000 - £2999'
						WHEN [Income] >= 3000 AND [Income] < 5000 THEN '£3000 - £4999'
						WHEN [Income] > 5000 THEN '£5000+'
					END
	,[LeadConversionPC] = CASE WHEN [Lead] > 0 THEN [Quotes] / [Lead] END
	,[QuoteConversionPC] = CASE WHEN [Quotes] > 0 THEN [GrossSales] / [Quotes] END
	,[PenetrationPC] = CASE WHEN [CoreSales] > 0 THEN [AddOnSales] / [CoreSales] END
	,[AvgClientGWP] = CASE WHEN [CoreSales] > 0 THEN [GWP] / [CoreSales] END
	,[AvgClientIncome] = CASE WHEN [CoreSales] > 0 THEN [Income] / [CoreSales] END
	,[AvgClientCommission] = CASE WHEN [CoreSales] > 0 THEN [Commission] / [CoreSales] END
	,[AvgClientFee] = CASE WHEN [CoreSales] > 0 THEN [Fee] / [CoreSales] END
	,[AvgPolicyGWPCore] = CASE WHEN [CoreSales] > 0 THEN [CoreGWP] / [CoreSales] END
	,[AvgPolicyGWPAddOn] = CASE WHEN [AddOnSales] > 0 THEN [AddOnGWP] / [AddOnSales] END
	,[AvgPolicyIncomeCore] = CASE WHEN [CoreSales] > 0 THEN [CoreIncome] / [CoreSales] END
	,[AvgPolicyIncomeAddOn] = CASE WHEN [AddOnSales] > 0 THEN [AddOnIncome] / [AddOnSales] END
FROM @Data AS [Data]
;


-- Return data to the report, grouped to match Qlikview:

SELECT
	 [POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[PolicyNumber]
	,[ClientReference]
	,[AGENT_ID]
	,[AgentName]
	,[Team]
	,[Tier]
	,[SaleAgent]
	,[SubAgent]
	,[Booked_Business_NB/REN/CANX/MTA]
	,[XBroker_NB/REN]
	,[Insurer]
	,[ClientSource]
	,[TransactionType]
	,[OriginalActionDateMonthYear]
	,[PolicyEffectiveDate]
	,[FirstQuotedDate]
	,[PrimaryTrade]
	,[IncomeBand]
	,[Product]
	,[PPCKeyword]
	,SUM(ISNULL([Lead],0)) AS [Lead]
	,SUM(ISNULL([Quotes],0)) AS [Quotes]
	,SUM(ISNULL([DuplicateQuote],0)) AS [DuplicateQuote]
	,SUM(ISNULL([LeadConversionPC],0)) AS [LeadConversionPC]
	,SUM(ISNULL([GrossSales],0)) AS [GrossSales]
	,SUM(ISNULL([CoreSales],0)) AS [CoreSales]
	,SUM(ISNULL([AddOnSales],0)) AS [AddOnSales]
	,SUM(ISNULL([GWP],0)) AS [GWP]
	,SUM(ISNULL([CoreGWP],0)) AS [CoreGWP]
	,SUM(ISNULL([AddOnGWP],0)) AS [AddOnGWP]
	,SUM(ISNULL([Income],0)) AS [Income]
	,SUM(ISNULL([CoreIncome],0)) AS [CoreIncome]
	,SUM(ISNULL([AddOnIncome],0)) AS [AddOnIncome]
	,SUM(ISNULL([Fee],0)) AS [Fee]
	,SUM(ISNULL([Commission],0)) AS [Commission]
	,SUM(ISNULL([Discount],0)) AS [Discount]
	,SUM(ISNULL([BrokerCommission],0)) AS [BrokerCommission]
	,SUM(ISNULL([QuoteConversionPC],0)) AS [QuoteConversionPC]
	,SUM(ISNULL([PenetrationPC],0)) AS [PenetrationPC]
	,SUM(ISNULL([AvgClientGWP],0)) AS [AvgClientGWP]
	,SUM(ISNULL([AvgClientIncome],0)) AS [AvgClientIncome]
	,SUM(ISNULL([AvgClientCommission],0)) AS [AvgClientCommission]
	,SUM(ISNULL([AvgClientFee],0)) AS [AvgClientFee]
	,SUM(ISNULL([AvgPolicyGWPCore],0)) AS [AvgPolicyGWPCore]
	,SUM(ISNULL([AvgPolicyGWPAddOn],0)) AS [AvgPolicyGWPAddOn]
	,SUM(ISNULL([AvgPolicyIncomeCore],0)) AS [AvgPolicyIncomeCore]
	,SUM(ISNULL([AvgPolicyIncomeAddOn],0)) AS [AvgPolicyIncomeAddOn]
	,SUM(ISNULL([AgentCommission],0)) AS [AgentCommission]
FROM
	@Data
GROUP BY
	 [POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[PolicyNumber]
	,[ClientReference]
	,[AGENT_ID]
	,[AgentName]
	,[Team]
	,[Tier]
	,[SaleAgent]
	,[SubAgent]
	,[Booked_Business_NB/REN/CANX/MTA]
	,[XBroker_NB/REN]
	,[Insurer]
	,[ClientSource]
	,[TransactionType]
	,[OriginalActionDateMonthYear]
	,[PolicyEffectiveDate]
	,[FirstQuotedDate]
	,[PrimaryTrade]
	,[IncomeBand]
	,[Product]
	,[PPCKeyword]
ORDER BY [PolicyNumber]
;

GO