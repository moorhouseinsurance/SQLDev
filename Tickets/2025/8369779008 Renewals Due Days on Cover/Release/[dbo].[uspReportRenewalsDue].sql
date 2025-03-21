USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspReportRenewalsDue]    Script Date: 23/01/2025 14:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create Date: 28 October 2022
-- Description: New version of Renewals Due report
-- =============================================

-- Date			Who						Change
-- 01/11/2022	Jeremai Smith			Fix for Lapsed By showing agent name when not lapsed (Monday.com ticket 3456256219)
-- 16/03/2022	Jeremai Smith			Add DOB field (Monday.com ticket 4153706285)
-- 09/06/2023	Jeremai Smith			Set status to Lapsed if no renewal found and expiry date is now past (Monday.com ticket 4562018721)
-- 07/08/2023	Jeremai Smith			Replaced Tokenised Card column with Continuous Authority (Monday.com. ticket 4867176225)
-- 07/05/2024	Simon Mackness-Pettit	Added five new columns (Monday.com. ticket 6593876023)
-- 04/09/2024	Jeremai Smith			Added agent and subagent commission and Blink agent flag columns, plus new 'XBroker including Blink and Direct Toledo'
--										option in Agent parameter. Also corrected ToolCover column logic (Monday.com ticket 7321738041).
-- 23/01/2025	Jeremai Smith			Add DaysOnCover column (needs enhancing to check for breaks in cover)


ALTER PROCEDURE [dbo].[uspReportRenewalsDue_test]
	 @DateFrom datetime
	,@DateTo datetime
	,@Agent varchar(MAX)
	,@Product varchar(MAX)						
	,@TransactionDate datetime
					
AS

/*

DECLARE @DateFrom datetime
DECLARE @DateTo datetime
DECLARE @Agent varchar(MAX)
DECLARE @Product varchar(MAX)
DECLARE @TransactionDate datetime

SET @DateFrom = '01 Aug 2024'
SET @DateTo = '31 Aug 2024'
SET @Agent = 'ALL' -- 'XBROKERPLUS'
SET @Product = 'ALL'
SET @TransactionDate = '31 Aug 2024'

EXEC [dbo].[uspReportRenewalsDue] @DateFrom, @DateTo, @Agent, @Product, @TransactionDate

*/

IF CONVERT(VARCHAR(12), @DateTo, 114) = '00:00:00:000'
	SET @DateTo = DATEADD(DAY, 1,DATEADD(MINUTE, -1, @DateTo));

IF CONVERT(VARCHAR(12), @DateFrom, 114) = '00:00:00:000' -- This sets @DateFrom back by one minute to 23:59 on the previous day so anything expiring 31st January at 23:59 for example will be reported as expiring 1st February instead
	SET @DateFrom = DATEADD(MINUTE, -1, @DateFrom);
	
IF CONVERT(VARCHAR(12), @TransactionDate, 114) = '00:00:00:000'
	SET @TransactionDate = DATEADD(DAY, 1, @TransactionDate);

IF OBJECT_ID(N'tempdb.dbo.#RenewalsDue') IS NOT NULL
	DROP TABLE [#RenewalsDue];

CREATE TABLE [#RenewalsDue] (
	 [Agent] varchar(255)
	,[SubAgent] varchar(255)
	,[MobileNo] varchar(20)
	,[Email] varchar(50)
	,[Client ID] varchar(25)
	,[Client Name] varchar(255)
	,[POLICY_DETAILS_ID] char(32)
	,[HISTORY_ID] int
	,[Policy Number] varchar(30)
	,[ORIGINALINCEPTIONDATE] datetime
	,[Effective Date] datetime
	,[End Date] datetime
	,[Renewal Date] datetime
	,[ContinuousCoverFromDate] datetime
	,[DaysOnCover] int
	,[Policy Status] varchar(255)
	,[PRODUCT_ID] char(32)
	,[Product] varchar(255)
	,[Insurer] varchar(255)
	,[Primary Trade] varchar(255)
	,[Secondary Trade] varchar(255)
	,[Premium] money
	,[Brokerage] money
	,[Agent Commission] money
	,[Subagent Commission] money
	,[Discount] money
	,[Fee] money
	,[Invited HISTORY_ID] int
	,[Invited By] varchar(50)
	,[Invited date] datetime
	,[New Policy Match Type] int
	,[New POLICY_DETAILS_ID] char(32)
	,[New HISTORY_ID] int
	,[New Policy Number] varchar(30)
	,[New Policy Effective Date] datetime
	,[New Policy End Date] datetime
	,[New Policy Insurer] varchar(255)
	,[New Policy Premium] float
	,[New Policy Brokerage] float
	,[New Policy Agent Commission] float
	,[New Policy Subagent Commission] float
	,[New Policy Discount] float
	,[New Policy Fee] float
	,[Status] varchar(255)
	,[Lapse Reason] varchar(255)
	,[Lapse Reason Freeform] varchar(max)
	,[Converted Date] datetime
	,[Cancellation Date] datetime
	,[Cancellation Effective Date] datetime
	,[Renewed By] varchar(50)
	,[Lapsed By] varchar(50)
	,[Payment Plan] varchar(255)
	,[Payment Option] varchar(15)
	,[Postcode] varchar(5)
	,[Country] varchar(100)
	,[Stopatrenewal] varchar(1)
	,[ClaimCount] int
	,[CC Expiry] datetime
	,[ContinuousAuthority] varchar(3)
	,[Tier] varchar(255)
	,[SecondaryNo] varchar(20)
	,[Insured Party ID] varchar(100)
	,[DOB] datetime
	,[PLLimit] int
	,[ManualEmp] int
	,[ToolCover] varchar(3)
	,[WorksCover] varchar(3)
	,[PersonalAccCover] varchar(3)
	,[BlinkFlag] varchar(3)
);

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- ===================
-- INSERT DUE POLICIES
-- ===================

-- Insert policies due to renew, with current financials

WITH [LatestNBRENByHistoryID] AS
(
	SELECT
		 ROW_NUMBER() OVER (PARTITION BY [POLICY_DETAILS_ID], [HISTORY_ID] ORDER BY [ACTIONDATE] DESC) AS [RowNum]
		,[POLICY_DETAILS_ID]
		,[HISTORY_ID]
		,[LOGINNAME]
		,[ACTIONTYPE]
	FROM
		[dbo].[REPORT_ACTION_LOG]
	WHERE
		[ACTIONTYPE] IN (2,5) -- Policy, Renewal
)
,[LatestNBRENByPolicyID] AS
(
	SELECT
		 ROW_NUMBER() OVER (PARTITION BY [POLICY_DETAILS_ID] ORDER BY [ACTIONDATE] DESC) AS [RowNum]
		,[POLICY_DETAILS_ID]
		,[HISTORY_ID]
		,[LOGINNAME]
		,[ACTIONTYPE]
	FROM
		[dbo].[REPORT_ACTION_LOG]
	WHERE
		[ACTIONTYPE] IN (2,5) -- Policy, Renewal
)
,[LatestPolicyStatusChangingRAL] AS
(
	SELECT
		 ROW_NUMBER() OVER (PARTITION BY [POLICY_DETAILS_ID] ORDER BY [ACTIONDATE] DESC) AS [RowNum]
		,[POLICY_DETAILS_ID]
		,[ACTIONTYPE]
	FROM [dbo].[REPORT_ACTION_LOG]
	WHERE
		[ACTIONTYPE] IN (2,3,4,5,8,9) -- Policy, MTA, Cancellation, Renewal, Lapse, Reinstatement
		AND [ACTIONDATE] <= @TransactionDate
		AND [ACTIONDATE] <= @DateFrom
)
,[UndoRenewal] AS
(
	SELECT
		 [POLICY_DETAILS_ID]
		,[HISTORY_ID]
	FROM
		[dbo].[REPORT_ACTION_LOG]
	WHERE
		[ACTIONTYPE] = 51 -- UndoRenewal
		AND [ACTIONDATE] <= @TransactionDate
		AND [ACTIONDATE] <= @DateFrom
)
,[PaymentOption] AS
(
	SELECT
		 ROW_NUMBER() OVER( PARTITION BY [ACTL].[POLICY_DETAILS_ID], [ACTL].[POLICY_DETAILS_HISTORY_ID] ORDER BY [AT].[PAYMENTDATE] DESC) AS [RowNum]
		,[ACTL].[POLICY_DETAILS_ID]
		,[ACTL].[POLICY_DETAILS_HISTORY_ID]
		,[LPM].[PAYMETHOD_DEBUG]
	FROM
		[dbo].[ACCOUNTS_TRANSACTION] AS [AT]
		INNER JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] ON [AT].[TRANSACTION_ID] = [ACTL].[TRANSACTION_ID]
		INNER JOIN [dbo].[LIST_PAYMETHOD] AS [LPM] ON [AT].[PAYMETHOD_ID] = [LPM].[PAYMETHOD_ID]
)
,[PaymentCard] AS
(
	SELECT
		 ROW_NUMBER() OVER( PARTITION BY [APCL].[POLICY_DETAILS_ID] ORDER BY CASE
																				WHEN [ACC].[EXPIRYDATE] >= @TransactionDate AND [APCL].[CONTINUOUS_AUTHORITY] = 1
																					THEN 1 -- Priorotise card with continuous authority if there a multiple cards with future expiry date (when compared to report picture date)
																				ELSE 0
																			 END DESC
																			 ,[ACC].[EXPIRYDATE]
																			) AS [RowNum]
		,[APCL].[POLICY_DETAILS_ID]
		,[ACC].[EXPIRYDATE]
		,[APCL].[CONTINUOUS_AUTHORITY]
	FROM 
		[dbo].[ACCOUNTS_POLICY_CARD_LINK] AS [APCL]
		INNER JOIN [dbo].[ACCOUNTS_CLIENT_CARD] AS [ACC] ON [APCL].[CARD_ID] = [ACC].[CARD_ID]
	WHERE
		[APCL].[ACTIVE] = 1
)
INSERT INTO [#RenewalsDue] (
	 [Agent]
	,[SubAgent]
	,[MobileNo]
	,[Email]
	,[Client ID]
	,[Client Name]
	,[POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[Policy Number]
	,[ORIGINALINCEPTIONDATE]
	,[Effective Date]
	,[End Date]
	,[Renewal Date]
	,[ContinuousCoverFromDate]
	,[DaysOnCover]
	,[Policy Status]
	,[PRODUCT_ID]
	,[Product]
	,[Insurer]
	,[Primary Trade]
	,[Secondary Trade]
	,[Premium]
	,[Brokerage]
	,[Agent Commission]
	,[Subagent Commission]
	,[Discount]
	,[Fee]
	,[Invited HISTORY_ID]
	,[Invited By]
	,[Invited date]
	,[New Policy Match Type]
	,[New POLICY_DETAILS_ID]
	,[New HISTORY_ID]
	,[New Policy Number]
	,[New Policy Effective Date]
	,[New Policy End Date]
	,[New Policy Insurer]
	,[New Policy Premium]
	,[New Policy Brokerage]
	,[New Policy Agent Commission]
	,[New Policy Subagent Commission]
	,[New Policy Discount]
	,[New Policy Fee]
	,[Status]
	,[Lapse Reason]
	,[Lapse Reason Freeform]
	,[Converted Date]
	,[Cancellation Date]
	,[Cancellation Effective Date]
	,[Renewed By]
	,[Lapsed By]
	,[Payment Plan]
	,[Payment Option]
	,[Postcode]
	,[Country]
	,[Stopatrenewal]
	,[ClaimCount]
	,[CC Expiry]
	,[ContinuousAuthority]
	,[Tier]
	,[SecondaryNo]
	,[Insured Party ID]
	,[DOB]
	,[PLLimit]
	,[ManualEmp]
	,[ToolCover]
	,[WorksCover]
	,[PersonalAccCover]
	,[BlinkFlag]
)
SELECT
	 [RMA].[NAME]																								AS [Agent]
	,ISNULL([RMS].[NAME],'')																					AS [SubAgent]
	,ISNULL((SELECT TOP 1 [TELEPHONENUMBER] FROM [dbo].[CUSTOMER_TELEPHONE]
			 WHERE [INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND [HISTORY_ID] = [CIP].[HISTORY_ID]
			 AND [TELEPHONENUMBER] LIKE '07%'), '') 															AS [MobileNo]
	,ISNULL([CIP].[EMAIL], '')																					AS [Email]
	,ISNULL(RTRIM([CIP].[CLIENT_REF_NO]), '')																	AS [Client ID]
	,LTRIM(ISNULL([CIP].[FORENAME], '') + ' ' + ISNULL([CIP].[INITIALS], ' ') + ISNULL([CIP].[SURNAME], ''))	AS [Client Name]
	,[CPD].[POLICY_DETAILS_ID]																					AS [POLICY_DETAILS_ID]
	,[CPD].[HISTORY_ID]																							AS [HISTORY_ID]
	,[CPD].[POLICYNUMBER]																						AS [Policy Number]
	,[CPD].[ORIGINALINCEPTIONDATE]																				AS [ORIGINALINCEPTIONDATE]
	,ISNULL([CPD].[POLICYSTARTDATE],NULL)																		AS [Effective Date]
	,ISNULL([CPD].[POLICYENDDATE],NULL)																			AS [End Date]
	,ISNULL(DATEADD(DAY,1,[CPD].[POLICYENDDATE]),NULL)															AS [Renewal Date]
	,NULL																										AS [ContinuousCoverFromDate] -- Update below
	,NULL																										AS [DaysOnCover] -- Update below
	,[LPS].[POLICY_STATUS_DEBUG]																				AS [Policy Status]
	,[CPD].[PRODUCT_ID]																							AS [PRODUCT_ID]
	,ISNULL([RMP].[NAME], '')																					AS [Product]
	,ISNULL([SI].[INSURER_DEBUG], '')																			AS [Insurer]
	,[RI].[PrimaryTrade]																						AS [Primary Trade]
	,[RI].[SecondaryTrade]																						AS [Secondary Trade]
	,ISNULL([TRANS].[Premium], 0)																				AS [Premium]
	,ISNULL([TRANS].[Brokerage], 0)																				AS [Brokerage]
	,ISNULL([TRANS].[Agent Commission], 0)																		AS [Agent Commission]
	,ISNULL([TRANS].[Subagent Commission], 0)																	AS [Subagent Commission]
	,ISNULL([TRANS].[Discount], 0)																				AS [Discount]
	,ISNULL([TRANS].[Fee], 0)																					AS [Fee]
	,NULL																										AS [Invited HISTORY_ID] -- Update below
	,NULL																										AS [Invited By] -- Update below
	,NULL																										AS [Invited date] -- Update below
	,NULL																										AS [New Policy Match Type] -- Update below
	,NULL																										AS [New POLICY_DETAILS_ID] -- Update below
	,NULL																										AS [New HISTORY_ID] -- Update below
	,NULL																										AS [New Policy Number] -- Update below
	,NULL																										AS [New Policy Effective Date] -- Update below
	,NULL																										AS [New Policy End Date] -- Update below
	,NULL																										AS [New Policy Insurer] -- Update below
	,NULL																										AS [New Policy Premium] -- Update below
	,NULL																										AS [New Policy Brokerage] -- Update below
	,NULL																										AS [New Policy Agent Commission] -- Update below
	,NULL																										AS [New Policy Subagent Commission] -- Update below
	,NULL																										AS [New Policy Discount] -- Update below
	,NULL																										AS [New Policy Fee] -- Update below
	,NULL																										AS [Status] -- Update below
	,NULL																										AS [Lapse Reason] -- Update below
	,NULL																										AS [Lapse Reason Freeform] -- Update below
	,NULL																										AS [Converted Date] -- Update below
	,NULL 																										AS [Cancellation Date] -- Update below
	,NULL 																										AS [Cancellation Effective Date] -- Update below
	,NULL																										AS [Renewed By] -- Update below
	,NULL																										AS [Lapsed By] -- Update below
	,[RPP].[NAME]																								AS [Payment Plan]
	,CASE
		WHEN [PO].[PAYMETHOD_DEBUG] = 'Finance' THEN 'Premium Finance'
		WHEN [RPP].[NAME] IN ('Direct to Insurer', 'Sub Agent Only') THEN 'Payment in Full'
		WHEN [RPP].[NAME] LIKE ('%full%') THEN 'Payment in Full'
		ELSE 'Premium Finance'
	 END																										AS [Payment Option]
	,[UKPC].[Postcode]																							AS [Postcode]
	,[UKPC].[Country]																							AS [Country]
	,CASE WHEN CPD.STOPATRENEWAL = 0 THEN 'N' ELSE 'Y' END														AS [Stopatrenewal]
	,(SELECT COUNT([CLAIM_ID]) FROM [dbo].[CLAIM_POLICY_LINK] WHERE [POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID]) AS [ClaimCount]
	,[PC].[EXPIRYDATE]																							AS [CC Expiry]
	,CASE
		WHEN [PC].[CONTINUOUS_AUTHORITY] = 1
		AND [PC].[EXPIRYDATE] > [CPD].[POLICYENDDATE]
		AND [PC].[EXPIRYDATE] > @TransactionDate
		THEN 'Yes'
	 END																										AS [ContinuousAuthority]
	,ISNULL([LCFV].[CLIENT_FILING_VALUE_DEBUG], '')																AS [Tier]
	,ISNULL((SELECT TOP 1 [TELEPHONENUMBER] FROM [dbo].[CUSTOMER_TELEPHONE]
			 WHERE [INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND [HISTORY_ID] = [CIP].[HISTORY_ID]
			 AND [TELEPHONENUMBER] NOT LIKE '07%'), '')															AS [SecondaryNo]
	,[CIP].[INSURED_PARTY_ID]																					AS [Insured Party ID]
	,CASE WHEN [CIP].[DOB]> '01 Jan 1900' THEN [CIP].[DOB] END													AS [DOB]
	,[RI].[CoverPLLimit]																						AS [PLLimit]
	,NULLIF([RI].[EmployeesManual], 0)																			AS [ManualEmp]
	,CASE WHEN [TL_CINFO].[ToolCover] = 1 THEN 'Yes' ELSE 'No' END												AS [ToolCover]
	,CASE WHEN [RI].[CoverCARContractWorks] IS NULL THEN 'No' ELSE 'Yes' END									AS [WorksCover]
	,CASE WHEN [RI].[CoverPersonalAccident] IS NULL THEN 'No' ELSE 'Yes' END									AS [PersonalAccCover]
	,CASE
		WHEN [CPD].[AGENT_ID] = '5343257BC7BB47C1B495C6AA026F8202' -- Blink Intermediary Solutions
		OR [RMS].[REFERENCE] LIKE 'BLINKXB%' THEN 'Yes' ELSE 'No'
	 END																										AS [BlinkFlag]
FROM
	[dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD]
		INNER JOIN [dbo].[CUSTOMER_POLICY_LINK] AS [CPL] ON [CPD].[POLICY_DETAILS_ID] = [CPL].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CPL].[POLICY_DETAILS_HISTORY_ID]
			INNER JOIN [dbo].[CUSTOMER_INSURED_PARTY] AS [CIP] ON [CPL].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND [CPL].[INSURED_PARTY_HISTORY_ID] = [CIP].[HISTORY_ID]
				INNER JOIN [dbo].[CUSTOMER_CLIENT_ADDRESS] AS [CCA] ON [CPL].[INSURED_PARTY_ID] = [CCA].[INSURED_PARTY_ID] AND [CPL].[INSURED_PARTY_HISTORY_ID] = [CCA].[HISTORY_ID]
				LEFT JOIN  [dbo].[CUSTOMER_CLIENT_FILING_CODES] AS [CCFC] ON [CIP].[INSURED_PARTY_ID] = [CCFC].[INSURED_PARTY_ID] AND [CIP].[HISTORY_ID] = [CCFC].[HISTORY_ID]
																		  AND [CCFC].[CLIENT_FILING_CODES_ID] = 'CAQTRT01' -- Tier Data Flag
					LEFT JOIN  [dbo].[LIST_CLIENT_FILING_VALUE] AS [LCFV] ON [CCFC].[CLIENT_FILING_VALUE_ID] = [LCFV].[CLIENT_FILING_VALUE_ID]
		INNER JOIN [LatestNBRENByHistoryID] AS [LNBR_HIST] ON [CPD].[POLICY_DETAILS_ID] = [LNBR_HIST].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [LNBR_HIST].[HISTORY_ID] -- Checks the Policy History version became a live policy at some point, regardless of current status
														   AND [LNBR_HIST].[RowNum] = 1
		LEFT JOIN [LatestNBRENByPolicyID] AS [LNBR_NEXT] ON [CPD].[POLICY_DETAILS_ID] = [LNBR_NEXT].[POLICY_DETAILS_ID] AND [LNBR_NEXT].[HISTORY_ID] > [LNBR_HIST].[HISTORY_ID] -- Checks if there is a subsequent renewal after the History ID that's due to expire. This is used for restricting transactions below.
														 AND [LNBR_NEXT].[RowNum] = 1
		LEFT JOIN [dbo].[CUSTOMER_PAY_PLAN] AS [CPP] ON [CPD].[POLICY_DETAILS_ID] = [CPP].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CPP].[HISTORY_ID]
			LEFT JOIN [dbo].[RM_PAYMENT_PLAN] AS [RPP] ON [CPP].[PAYMENT_PLAN_ID] = [RPP].[PAYMENT_PLAN_ID]
		LEFT JOIN [dbo].[LIST_POLICY_STATUS] AS [LPS] ON [CPD].[POLICY_STATUS_ID] = [LPS].[POLICY_STATUS_ID]
		LEFT JOIN [dbo].[RM_AGENT] AS [RMA] ON [CPD].[AGENT_ID] = [RMA].[AGENT_ID]
			LEFT JOIN [dbo].[RM_AGENT_MH_TYPE] AS [RMAMH] ON [RMA].[AGENT_ID] = [RMAMH].[AGENT_ID]
		LEFT JOIN [dbo].[RM_PRODUCT] AS [RMP] ON [CPD].[PRODUCT_ID] = [RMP].[PRODUCT_ID]
		LEFT JOIN [dbo].[RM_SUBAGENT] AS [RMS] ON [CPD].[SUBAGENT_ID] = [RMS].[SUBAGENT_ID]
		LEFT JOIN [dbo].[SYSTEM_INSURER] AS [SI] ON [CPD].[INSURER_ID] = [SI].[INSURER_ID]
		LEFT JOIN [dbo].[UK_POSTCODE] AS [UKPC] ON [UKPC].[Postcode] = [dbo].[svf_PostCodePart] (ISNULL([CCA].[POSTCODE],0) COLLATE DATABASE_DEFAULT,1)
		LEFT JOIN [MI].[dbo].[RiskInformation] AS [RI] ON [CPD].[POLICY_DETAILS_ID] = [RI].[PolicyDetailsID] AND [CPD].[HISTORY_ID] = [RI].[HistoryID]
		LEFT JOIN [dbo].[USER_MLIAB_CINFO] AS [TL_CINFO] ON [CPD].[POLICY_DETAILS_ID] = [TL_CINFO].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [TL_CINFO].[HISTORY_ID]
		LEFT JOIN [LatestPolicyStatusChangingRAL] AS [LCHG] ON [CPD].[POLICY_DETAILS_ID] = [LCHG].[POLICY_DETAILS_ID]
															AND [LCHG].[RowNum] = 1
		LEFT JOIN [UndoRenewal] AS [UR] ON [CPD].[POLICY_DETAILS_ID] = [UR].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [UR].[HISTORY_ID]
		LEFT JOIN [PaymentOption] AS [PO] ON [CPD].[POLICY_DETAILS_ID] = [PO].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [PO].[POLICY_DETAILS_HISTORY_ID]
										   AND [PO].[RowNum] = 1
		LEFT JOIN [PaymentCard] AS [PC] ON [CPD].[POLICY_DETAILS_ID] = [PC].[POLICY_DETAILS_ID]
										AND [PC].[RowNum] = 1
		OUTER APPLY (SELECT	
						 SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Premium]
						,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'BRKCOMM%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Brokerage]
						,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'BRKDISC%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Discount]
						,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'AGECOMM%' OR [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'AGEDISC%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Agent Commission]
						,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'SUBCOMM%' OR [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'SUBDISC%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Subagent Commission]
						,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'FEE' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Fee]
					 FROM
						[dbo].[ACCOUNTS_TRANSACTION] AS [AT]
						INNER JOIN [dbo].[ACCOUNTS_TRAN_BREAKDOWN] AS [ATB] ON [AT].[TRANSACTION_ID] = [ATB].[TRANSACTION_ID]
						INNER JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] ON [AT].[TRANSACTION_ID] = [ACTL].[TRANSACTION_ID]
						INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [TCPD] ON [ACTL].[POLICY_DETAILS_ID] = [TCPD].[POLICY_DETAILS_ID] AND [ACTL].[POLICY_DETAILS_HISTORY_ID] = [TCPD].[HISTORY_ID]
					 WHERE
						[TCPD].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] -- This will sum transactions for all Policy History IDs with POLICYSTARTDATE within the policy term, i.e. will pick up MTAs, etc
						AND [TCPD].[POLICYSTARTDATE] < [CPD].[POLICYENDDATE]
						AND [TCPD].[POLICYSTARTDATE] >= [CPD].[POLICYSTARTDATE]
						AND [ACTL].[POLICY_DETAILS_HISTORY_ID] < ISNULL([LNBR_NEXT].[HISTORY_ID], 9999) -- Exclude transactions for History IDs equal to or after the next renewal but where [TCPD].[POLICYSTARTDATE] is incorrectly set to the expiring year (rare scenario, see example ACTRM1009945 where the cancelled renewal has the start date of the previous year's policy)
						AND [AT].[TRANSACTION_CODE_ID] <> 'PAY'
					 ) AS [TRANS]
WHERE
	[CPD].[POLICYENDDATE] >= @DateFrom AND [CPD].[POLICYENDDATE] < @DateTo
	AND ([RMA].[AGENT_ID] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@Agent, ',')) 
		 OR 'ALL' IN (@Agent)
		 OR ('XBROKERPLUS' IN (@Agent) AND ([RMAMH].[XBroker] = 1 OR [CPD].[INSURER_ID] = 'TOLEDO'))
		 )
	AND ([RMP].[PRODUCT_ID] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@Product, ',')) OR 'ALL' IN (@Product))
	AND [LCHG].[ACTIONTYPE] <> 4 -- If the policy was cancelled before the renewal date and picture date then exclude it as not due for renewal
	AND [UR].[POLICY_DETAILS_ID] IS NULL -- If there was an UndoRenewal before the renewal date and picture date then exclude it as equivalent to a cancellation
;


-- Work out continuous cover from date and days on cover:

WITH [ContinuousCoverDates] AS
(
	SELECT
		 [POLICY_DETAILS_ID]
		,[ACTIONDATE]
		,[ACTIONTYPE]
		,LAG([ACTIONDATE]) OVER (PARTITION BY [POLICY_DETAILS_ID] ORDER BY [ACTIONDATE]) AS [PreviousACTIONDATE]
		,CASE
			WHEN [ACTIONTYPE] = 9 AND LAG([ACTIONTYPE]) OVER (PARTITION BY [POLICY_DETAILS_ID] ORDER BY [ACTIONDATE]) = 4 -- This is a reinstatement following a cancellation
				AND LAG([ACTIONDATE]) OVER (PARTITION BY [POLICY_DETAILS_ID] ORDER BY [ACTIONDATE]) < [ACTIONDATE] - 30 THEN 1
		 END AS [BreakInCover]
		,CASE
			WHEN [ACTIONTYPE] = 9 AND LAG([ACTIONTYPE]) OVER (PARTITION BY [POLICY_DETAILS_ID] ORDER BY [ACTIONDATE]) = 4 -- This is a reinstatement following a cancellation
				AND LAG([ACTIONDATE]) OVER (PARTITION BY [POLICY_DETAILS_ID] ORDER BY [ACTIONDATE]) < [ACTIONDATE] - 30 THEN [ACTIONDATE]
		 END AS [CoverRestartDate]
	FROM
		[dbo].[REPORT_ACTION_LOG]
	WHERE
		[ACTIONTYPE] IN (4,9) -- Cancellation, Reinstatement
		AND [POLICY_DETAILS_ID] IN (SELECT [POLICY_DETAILS_ID] FROM [dbo].[REPORT_ACTION_LOG]
									WHERE [ACTIONDATE] > '01 Jan 2025' AND [ACTIONTYPE] = 9 -- Reinstatement
									)
)
UPDATE [TMP]
	SET  [ContinuousCoverFromDate] = ISNULL([CC].[ContinuousCoverDate], [TMP].[ORIGINALINCEPTIONDATE])
		,[DaysOnCover] = DATEDIFF(dd
								 ,ISNULL([CC].[ContinuousCoverDate], [TMP].[ORIGINALINCEPTIONDATE])
								 ,CASE
									WHEN [TMP].[End Date] < @TransactionDate AND @TransactionDate < GETDATE() THEN [TMP].[End Date]
									WHEN @TransactionDate > GETDATE() THEN GETDATE()
									ELSE @TransactionDate
								  END
								 )	
FROM [#RenewalsDue] AS [TMP]
OUTER APPLY (SELECT MAX([CoverRestartDate]) AS [ContinuousCoverDate] FROM [ContinuousCoverDates]
			 WHERE [POLICY_DETAILS_ID] = [TMP].[POLICY_DETAILS_ID]
			 AND [ACTIONDATE] <= @TransactionDate
			) AS [CC]
;



-- =====================
-- MATCH TO NEW POLICIES
-- =====================

-- Creates a temp table and inserts all potential renewal matches before selecting the best match. This is to handle scenarios where multiple renewal or replacement
-- policies have been created and cancelled.

IF OBJECT_ID(N'tempdb.dbo.#MatchRenewals') IS NOT NULL
	DROP TABLE [#MatchRenewals];

CREATE TABLE [#MatchRenewals] (
	 [POLICY_DETAILS_ID] char(32)
	,[HISTORY_ID] int
	,[New Policy Match Type] int
	,[New POLICY_DETAILS_ID] char(32)
	,[New HISTORY_ID] int
	,[New Policy Effective Date] datetime
	,[New Policy End Date] datetime
	,[Outside of renewal window] bit
	,[Renewal replacement] bit
	,[Converted Date] datetime
	,[LOGINNAME] varchar(50)
	,[Status] varchar(255)
	,[Lapse Reason] varchar(255)
	,[Lapse Reason Freeform] varchar(MAX)
	,[Lapsed By] varchar(50)
	,[Cancellation Date] datetime
	,[Cancellation Effective Date] datetime
)

INSERT INTO [#MatchRenewals] (
	 [POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[New Policy Match Type]
	,[New POLICY_DETAILS_ID]
	,[New HISTORY_ID]
	,[New Policy Effective Date]
	,[New Policy End Date]
	,[Outside of renewal window]
	,[Converted Date]
	,[LOGINNAME]
)
-- 1. Renewed on same POLICY_DETAILS_ID:
SELECT
	 [TMP].[POLICY_DETAILS_ID]
	,[TMP].[HISTORY_ID]
	,1 AS [New Policy Match Type]
	,[NEW].[POLICY_DETAILS_ID] AS [New POLICY_DETAILS_ID]
	,[NEW].[HISTORY_ID] AS [New HISTORY_ID]
	,[NEW].[POLICYSTARTDATE] AS [New Policy Effective Date]
	,[NEW].[POLICYENDDATE] AS [New Policy End Date]
	,CASE WHEN [NEW].[POLICYSTARTDATE] > DATEADD(dd, 30, [TMP].[End Date]) THEN 1 ELSE 0 END AS [Outside of renewal window] -- If more than 30 days after the due policy it's not a renewal, unless cancelled and replaced (updated later)
	,[NEW].[ACTIONDATE] AS [Converted Date]
	,[NEW].[LOGINNAME]AS [Converted By]
FROM
	[#RenewalsDue] AS [TMP]
	CROSS APPLY (SELECT TOP 1
				  [RAL].[POLICY_DETAILS_ID]
				 ,[RAL].[HISTORY_ID]
				 ,[RAL].[ACTIONDATE]
				 ,[RAL].[LOGINNAME]
				 ,[CPD].[POLICYNUMBER]
				 ,[CPD].[POLICYSTARTDATE]
				 ,[CPD].[POLICYENDDATE]
				 FROM [dbo].[REPORT_ACTION_LOG] AS [RAL]
				 INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [RAL].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CPD].[HISTORY_ID]
				 WHERE [RAL].[POLICY_DETAILS_ID] = [TMP].[POLICY_DETAILS_ID]
				 AND [RAL].[POLICYSTARTDATE] > [TMP].[End Date]
				 AND [RAL].[POLICYSTARTDATE] < DATEADD(yy, 1, [TMP].[End Date])
				 AND [RAL].[ACTIONTYPE] IN (2,5) -- Policy, Renewal
				 AND [RAL].[ACTIONDATE] <= @TransactionDate
				 ORDER BY [RAL].[POLICYSTARTDATE]
				 ) AS [NEW]

-- 2. Renewed onto new POLICY_DETAILS_ID linked by PREVIOUS_POLICY_DETAILS_ID:

UNION ALL

SELECT
	 [TMP].[POLICY_DETAILS_ID]
	,[TMP].[HISTORY_ID]
	,2 AS [New Policy Match Type]
	,[NEW].[POLICY_DETAILS_ID] AS [New POLICY_DETAILS_ID]
	,[NEW].[HISTORY_ID] AS [New HISTORY_ID]
	,[NEW].[POLICYSTARTDATE] AS [New Policy Effective Date]
	,[NEW].[POLICYENDDATE] AS [New Policy End Date]
	,CASE WHEN [NEW].[POLICYSTARTDATE] > DATEADD(dd, 30, [TMP].[End Date]) THEN 1 ELSE 0 END AS [Outside of renewal window] -- If more than 30 days after the due policy it's not a renewal, unless cancelled and replaced (updated later)
	,[NEW].[ACTIONDATE] AS [Converted Date]
	,[NEW].[LOGINNAME]AS [Converted By]
FROM
	[#RenewalsDue] AS [TMP]
	INNER JOIN [dbo].[RM_PRODUCT_GROUPING_VIEW] AS [TMPPG] ON [TMP].[PRODUCT_ID] = [TMPPG].[PRODUCT_ID]  -- View that groups similar products together, e.g. Small Business, Tradesman Liability, and Turnover form a Liability Group, so a new policy with any of these types is considered a renewal
	CROSS APPLY (SELECT TOP 1
				  [RAL].[POLICY_DETAILS_ID]
				 ,[RAL].[HISTORY_ID]
				 ,[RAL].[ACTIONDATE]
				 ,[RAL].[LOGINNAME]
				 ,[CPD].[POLICYNUMBER]
				 ,[CPD].[POLICYSTARTDATE]
				 ,[CPD].[POLICYENDDATE]
				 FROM [dbo].[REPORT_ACTION_LOG] AS [RAL]
				 INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [RAL].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CPD].[HISTORY_ID]
				 INNER JOIN [dbo].[RM_PRODUCT_GROUPING_VIEW] AS [PG] ON [CPD].[PRODUCT_ID] = [PG].[PRODUCT_ID]
				 WHERE [CPD].[PREVIOUS_POLICY_DETAILS_ID] = [TMP].[POLICY_DETAILS_ID]
				 AND [RAL].[POLICYSTARTDATE] > [TMP].[End Date]
				 AND [RAL].[POLICYSTARTDATE] < DATEADD(yy, 1, [TMP].[End Date])
				 AND [RAL].[ACTIONTYPE] IN (2,5) -- Policy, Renewal
				 AND [RAL].[ACTIONDATE] <= @TransactionDate
				 AND [PG].[PRODUCT_GROUP_ID] = [TMPPG].[PRODUCT_GROUP_ID] -- Must be for same product or product grouping
				 ORDER BY [RAL].[POLICYSTARTDATE]
				 ) AS [NEW]

-- 3. New policy created, linked by CLIENT_REF_NO and product or product grouping:

UNION ALL

SELECT
	 [TMP].[POLICY_DETAILS_ID]
	,[TMP].[HISTORY_ID]
	,3 AS [New Policy Match Type]
	,[NEW].[POLICY_DETAILS_ID] AS [New POLICY_DETAILS_ID]
	,[NEW].[HISTORY_ID] AS [New HISTORY_ID]
	,[NEW].[POLICYSTARTDATE] AS [New Policy Effective Date]
	,[NEW].[POLICYENDDATE] AS [New Policy End Date]
	,CASE WHEN [NEW].[POLICYSTARTDATE] > DATEADD(dd, 30, [TMP].[End Date]) THEN 1 ELSE 0 END AS [Outside of renewal window] -- If more than 30 days after the due policy it's not a renewal, unless cancelled and replaced (updated later)
	,[NEW].[ACTIONDATE] AS [Converted Date]
	,[NEW].[LOGINNAME]AS [Converted By]
FROM
	[#RenewalsDue] AS [TMP]
	INNER JOIN [dbo].[RM_PRODUCT_GROUPING_VIEW] AS [TMPPG] ON [TMP].[PRODUCT_ID] = [TMPPG].[PRODUCT_ID]  -- View that groups similar products together, e.g. Small Business, Tradesman Liability, and Turnover form a Liability Group, so a new policy with any of these types is considered a renewal
	CROSS APPLY (SELECT
					 [RAL].[POLICY_DETAILS_ID]
					,[RAL].[HISTORY_ID]
					,[RAL].[ACTIONDATE]
					,[RAL].[LOGINNAME]
					,[CPD].[POLICYNUMBER]
					,[CPD].[POLICYSTARTDATE]
					,[CPD].[POLICYENDDATE]
				 FROM
					[dbo].[REPORT_ACTION_LOG] AS [RAL]
					INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [RAL].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CPD].[HISTORY_ID]
						INNER JOIN [dbo].[RM_PRODUCT_GROUPING_VIEW] AS [PG] ON [CPD].[PRODUCT_ID] = [PG].[PRODUCT_ID]
						INNER JOIN [dbo].[CUSTOMER_POLICY_LINK] AS [CPL] ON [CPD].[POLICY_DETAILS_ID] = [CPL].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CPL].[POLICY_DETAILS_HISTORY_ID]
							INNER JOIN [dbo].[CUSTOMER_INSURED_PARTY] AS [CIP] ON [CPL].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND [CPL].[INSURED_PARTY_HISTORY_ID] = [CIP].[HISTORY_ID]
				 WHERE
					[CIP].[CLIENT_REF_NO] = [TMP].[Client ID]
					AND [RAL].[POLICY_DETAILS_ID] <> [TMP].[POLICY_DETAILS_ID]
					AND [RAL].[POLICYSTARTDATE] > DATEADD(dd, -30, [TMP].[End Date]) -- Allow overlap as sometimes replacement policy starts before end date of previous
					AND [RAL].[POLICYSTARTDATE] < DATEADD(yy, 1, [TMP].[End Date])
					AND [RAL].[ACTIONTYPE] = 2 -- New Policies only, otherwise clients with multiple concurrent policies for same product group can get mapped to wrong renewal
					AND [RAL].[ACTIONDATE] <= @TransactionDate
					AND [PG].[PRODUCT_GROUP_ID] = [TMPPG].[PRODUCT_GROUP_ID]
				 ) AS [NEW]
;


-- Set status and action data from the matched policies:

UPDATE [MR]
SET  [Status] = CASE
					WHEN [STATUSRAL].[ACTIONTYPE] IN (2, 5) THEN 'Renewed' -- Policy, Renewal
					WHEN [STATUSRAL].[ACTIONTYPE] = 4 THEN 'Cancelled' -- Cancellation
					WHEN [STATUSRAL].[ACTIONTYPE] = 8 THEN 'Lapsed'
					WHEN [STATUSRAL].[ACTIONTYPE] = 9 THEN 'Reinstated'
					WHEN [STATUSRAL].[ACTIONTYPE] = 10 THEN 'Invited'
					WHEN [STATUSRAL].[ACTIONTYPE] = 51 THEN 'Undo Renewal'
				END
	,[Lapse Reason] = CASE WHEN [STATUSRAL].[ACTIONTYPE] = 8 THEN ISNULL([STATUSRAL].[LAPSE_REASON_DEBUG], '') ELSE '' END -- 8 = Lapse
	,[Lapse Reason Freeform] = CASE
									WHEN [STATUSRAL].[ACTIONTYPE] = 8 AND [STATUSRAL].[LAPSE_REASON_DEBUG] IS NULL THEN ''
									WHEN [STATUSRAL].[ACTIONTYPE] = 8 THEN ISNULL([STATUSRAL].[EVENT_DESCRIPTION], '')
									ELSE ''
							   END
	,[Lapsed By] = CASE WHEN [STATUSRAL].[ACTIONTYPE] = 8 THEN ISNULL([STATUSRAL].[FULLNAME], '') ELSE '' END
	,[Cancellation Date] = CASE WHEN [STATUSRAL].[ACTIONTYPE] = 4 THEN [STATUSRAL].[ACTIONDATE] END
	,[Cancellation Effective Date] = CASE WHEN [STATUSRAL].[ACTIONTYPE] = 4 THEN [STATUSRAL].[CANCELLATIONDATE] END
FROM
	[#MatchRenewals] AS [MR]
	OUTER APPLY	(SELECT TOP 1
					 [RAL].[ACTIONDATE]
					,[RAL].[ACTIONTYPE]
					,[SSP].[FULLNAME]
					,[LLR].[LAPSE_REASON_DEBUG]
					,[CED].[EVENT_DESCRIPTION]
					,[CPD].[CANCELLATIONDATE]
				 FROM
					[dbo].[REPORT_ACTION_LOG] AS [RAL]
						LEFT JOIN [dbo].[SYSTEM_SECURITY_PROFILE] AS [SSP] ON [RAL].[LOGINNAME] = [SSP].[LOGINNAME]
																		   AND [SSP].[DELETED] <> 1
						LEFT JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [RAL].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CPD].[HISTORY_ID]
							LEFT JOIN [dbo].[LIST_LAPSE_REASON] AS [LLR] ON [CPD].[LAPSE_REASON_ID] = [LLR].[LAPSE_REASON_ID]
							LEFT JOIN [dbo].[CUSTOMER_EVENT_DESCRIPTION] AS [CED] ON [CPD].[POLICY_DETAILS_ID] = [CED].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CED].[HISTORY_ID]
																				  AND [CED].[ACTION_LOG_TYPE_ID] = [RAL].[ACTIONTYPE]
				 WHERE
					[RAL].[POLICY_DETAILS_ID] = [MR].[New POLICY_DETAILS_ID]
					AND [RAL].[ACTIONTYPE] IN (2,4,5,8,9,10,51) -- Policy, Cancellation, Renewal, Lapse, Reinstatement, UndoRenewal
					AND [RAL].[ACTIONDATE] <= @TransactionDate
					AND ([RAL].[POLICYSTARTDATE] >= [MR].[New Policy Effective Date] AND [RAL].[POLICYSTARTDATE] < [MR].[New Policy End Date]
						 OR
						 DATEDIFF(Day, [RAL].[ACTIONDATE], [MR].[New Policy Effective Date]) BETWEEN -45 AND +45
						 )
				 ORDER BY
					[ACTIONDATE] DESC
				) AS [STATUSRAL]
;


-- Set Renewal Replacement = true for matched policies that are outside of the renewal window but are within 30 days of a cancellation:

UPDATE [MRRep]
	SET [Renewal replacement] = 1
FROM
	[#MatchRenewals] AS [MRCanx]
	INNER JOIN [#MatchRenewals] AS [MRRep] ON [MRCanx].[POLICY_DETAILS_ID] = [MRRep].[POLICY_DETAILS_ID] AND [MRCanx].[HISTORY_ID] = [MRRep].[HISTORY_ID] -- These are the due policy keys
										   AND [MRCanx].[Outside of renewal window] = 0
										   AND [MRCanx].[Status] = 'Cancelled'
										   AND [MRRep].[Outside of renewal window] = 1
										   AND [MRRep].[Converted Date] < DATEADD(dd, 30, [MRCanx].[Cancellation Date])
;

WITH [MatchedRenewal] AS
(
	SELECT
		 ROW_NUMBER() OVER (PARTITION BY [POLICY_DETAILS_ID] ,[HISTORY_ID] ORDER BY CASE
																						WHEN [Status] = 'Renewed' THEN 1
																						WHEN [Status] = 'Reinstated' THEN 2
																						ELSE 99
																					END
																					,[New Policy Match Type]
																					,[New Policy Effective Date] DESC) AS [RowNum]
		,[POLICY_DETAILS_ID]
		,[HISTORY_ID]
		,[New Policy Match Type]
		,[New POLICY_DETAILS_ID]
		,[New HISTORY_ID]
		,[New Policy Effective Date]
		,[New Policy End Date]
		,[Converted Date]
		,[LOGINNAME]
		,[Status]
		,[Lapse Reason]
		,[Lapse Reason Freeform]
		,[Lapsed By]
		,[Cancellation Date]
		,[Cancellation Effective Date]
	FROM
		[#MatchRenewals]
	WHERE
		[Outside of renewal window] = 0
		OR ([Outside of renewal window] = 1 AND [Renewal replacement] = 1)
)
UPDATE [TMP]
SET  [New Policy Match Type] = [MR].[New Policy Match Type]
	,[New POLICY_DETAILS_ID] = [MR].[New POLICY_DETAILS_ID]
	,[New HISTORY_ID] = [MR].[New HISTORY_ID]
	,[New Policy Effective Date] = [MR].[New Policy Effective Date]
	,[New Policy End Date] = [MR].[New Policy End Date]
	,[Converted Date] = [MR].[Converted Date]
	,[Renewed By] = CASE WHEN [MR].[Status] = 'Renewed' THEN [SSP].[FULLNAME] ELSE '' END
	,[Status] = CASE
					WHEN [MR].[Status] = 'Undo Renewal' AND [TMP].[Policy Status] = 'Lapsed' THEN 'Lapsed'
					WHEN [MR].[Status] = 'Undo Renewal' THEN 'Invited' -- If renewal undone then set it back to Invited status per Rob Taylor; further enhanced with line above to set to Lapsed if policy status is Lapsed (Lapse RAL doesn't seem to be created for these)
					ELSE [MR].[Status]
				END
	,[Lapse Reason] = [MR].[Lapse Reason]
	,[Lapse Reason Freeform] = [MR].[Lapse Reason Freeform]
	,[Lapsed By] = [MR].[Lapsed By]
	,[Cancellation Date] = [MR].[Cancellation Date]
	,[Cancellation Effective Date] = [MR].[Cancellation Effective Date]
FROM
	[#RenewalsDue] AS [TMP]
	INNER JOIN [MatchedRenewal] AS [MR] ON [TMP].[POLICY_DETAILS_ID] = [MR].[POLICY_DETAILS_ID] AND [TMP].[HISTORY_ID] = [MR].[HISTORY_ID]
										AND [MR].[RowNum] = 1
		LEFT JOIN [dbo].[SYSTEM_SECURITY_PROFILE] AS [SSP] ON [MR].[LOGINNAME] = [SSP].[LOGINNAME]
														   AND [SSP].[DELETED] <> 1
;

-- Populate new policy details from the renewed policy and its transactions:

UPDATE [TMP]
	SET  [New Policy Number] = [CPD].[POLICYNUMBER]
		,[New Policy Insurer] = ISNULL([SI].[INSURER_DEBUG], '')
		,[New Policy Premium] = CASE WHEN [TRANS].[Premium] < 10 THEN 0 ELSE ISNULL([TRANS].[Premium], 0) END
		,[New Policy Brokerage] = CASE WHEN [TRANS].[Premium] < 10 THEN 0 ELSE ISNULL([TRANS].[Brokerage], 0) END
		,[New Policy Agent Commission] = CASE WHEN [TRANS].[Premium] < 10 THEN 0 ELSE ISNULL([TRANS].[Agent Commission], 0) END
		,[New Policy Subagent Commission] = CASE WHEN [TRANS].[Premium] < 10 THEN 0 ELSE ISNULL([TRANS].[Subagent Commission], 0) END
		,[New Policy Discount] = CASE WHEN [TRANS].[Premium] < 10 THEN 0 ELSE ISNULL([TRANS].[Discount], 0) END
		,[New Policy Fee] = CASE WHEN [TRANS].[Premium] < 10 THEN 0 ELSE ISNULL([TRANS].[Fee], 0) END
FROM
	[#RenewalsDue] AS [TMP]
	INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [TMP].[New POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [TMP].[New HISTORY_ID] = [CPD].[HISTORY_ID]
		INNER JOIN [dbo].[SYSTEM_INSURER] AS [SI] ON [CPD].[INSURER_ID] = [SI].[INSURER_ID]
	OUTER APPLY (SELECT	
					 SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Premium]
					,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'BRKCOMM%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Brokerage]
					,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'BRKDISC%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Discount]
					,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'AGECOMM%' OR [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'AGEDISC%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Agent Commission]
					,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'SUBCOMM%' OR [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'SUBDISC%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Subagent Commission]
					,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'FEE' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Fee]
				 FROM
					[dbo].[ACCOUNTS_TRANSACTION] AS [AT]
					INNER JOIN [dbo].[ACCOUNTS_TRAN_BREAKDOWN] AS [ATB] ON [AT].[TRANSACTION_ID] = [ATB].[TRANSACTION_ID]
					INNER JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] ON [AT].[TRANSACTION_ID] = [ACTL].[TRANSACTION_ID]
					INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [TCPD] ON [ACTL].[POLICY_DETAILS_ID] = [TCPD].[POLICY_DETAILS_ID] AND [ACTL].[POLICY_DETAILS_HISTORY_ID] = [TCPD].[HISTORY_ID]
				 WHERE
					[TCPD].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] -- This will sum transactions for all Policy History IDs with POLICYSTARTDATE within the policy term, i.e. will pick up MTAs, etc
					AND [TCPD].[POLICYSTARTDATE] < [CPD].[POLICYENDDATE]
					AND [TCPD].[POLICYSTARTDATE] >= [CPD].[POLICYSTARTDATE]
					AND [AT].[TRANSACTION_CODE_ID] <> 'PAY'
					AND [AT].[CREATEDDATE] <= @TransactionDate
				) AS [TRANS]
;

-- ===============================
-- POPULATE RENEWAL INVITE DETAILS
-- ===============================

-- 1. Get the original invite:

UPDATE [TMP]
SET  
	 [Invited HISTORY_ID] = [INVITE].[HISTORY_ID]
	,[Invited By] = [INVITE].[FULLNAME]
	,[Invited date] = [INVITE].[ACTIONDATE]
FROM
	[#RenewalsDue] AS [TMP]
	OUTER APPLY	(SELECT TOP 1
					 [RAL].[HISTORY_ID]
					,[SSP].[FULLNAME]
					,[RAL].[ACTIONDATE]
				 FROM
					[dbo].[REPORT_ACTION_LOG] AS [RAL]
						LEFT JOIN [dbo].[SYSTEM_SECURITY_PROFILE] AS [SSP] ON [RAL].[LOGINNAME] = [SSP].[LOGINNAME]
																		   AND [SSP].[DELETED] <> 1
				 WHERE
					[RAL].[POLICY_DETAILS_ID] = [TMP].[POLICY_DETAILS_ID]
					AND [RAL].[ACTIONTYPE] = 10 -- Invited
					AND [RAL].[ACTIONDATE] <= @TransactionDate
					AND [RAL].[POLICYSTARTDATE] BETWEEN [TMP].[End Date] AND DATEADD(yyyy, 1, [TMP].[End Date])
				 ORDER BY
					[ACTIONDATE] DESC
				) AS [INVITE]
;


-- 2. Overwrite the History ID from Amend or Client Contact actions (for Alternative Quotes, so we pick up the correct financials), but only if it comes after the
-- latest Invite action, and before the policy or renewal RAL (if converted). This is because there's no definitive RAL type to identify alternative quotes and we
-- don't want to pick up Amend actions that happened after the renewal as these are not related to the Invite:
UPDATE [TMP]
SET  
	 [Invited HISTORY_ID] = [AMEND].[HISTORY_ID]
FROM
	[#RenewalsDue] AS [TMP]
	CROSS APPLY	(SELECT TOP 1
					 [RAL].[HISTORY_ID]
				 FROM
					[dbo].[REPORT_ACTION_LOG] AS [RAL]
						LEFT JOIN [dbo].[SYSTEM_SECURITY_PROFILE] AS [SSP] ON [RAL].[LOGINNAME] = [SSP].[LOGINNAME]
																		   AND [SSP].[DELETED] <> 1
				 WHERE
					[RAL].[POLICY_DETAILS_ID] = [TMP].[POLICY_DETAILS_ID]
					AND [RAL].[ACTIONTYPE] IN (6, 43) -- 6 = Amend, 43 = Client Contact
					AND [RAL].[ACTIONDATE] > [TMP].[Invited date]
					AND ([RAL].[ACTIONDATE] < [TMP].[Converted Date] OR [TMP].[Converted Date] IS NULL)
					AND [RAL].[ACTIONDATE] <= @TransactionDate
					AND [RAL].[POLICYSTARTDATE] BETWEEN [TMP].[End Date] AND DATEADD(yyyy, 1, [TMP].[End Date])
				 ORDER BY
					[ACTIONDATE] DESC
				) AS [AMEND]
;


-- Where not matched to a renewal, populate new policy details from the invite and invited premium:

WITH [PREM] AS
(
	SELECT
		 [POLICY_DETAILS_ID]
		,[HISTORY_ID]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'NET' THEN [PREMIUM] ELSE 0 END) AS [Premium]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('BRKCOMMP','BRKCOMMF') THEN [PREMIUM] ELSE 0 END) AS [Brokerage]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('AGECOMMP','AGECOMMF','AGEDISCP','AGEDISCF') THEN [PREMIUM] ELSE 0 END) AS [Agent Commission]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('SUBCOMMP','SUBCOMMF','SUBDISCP','SUBDISCF') THEN [PREMIUM] ELSE 0 END) AS [Subagent Commission]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('BRKDISCP','BRKDISCF') THEN [PREMIUM] ELSE 0 END) AS [Discount]
	FROM
		[dbo].[CUSTOMER_PREMIUM] AS [CP]
	GROUP BY
		 [POLICY_DETAILS_ID]
		,[HISTORY_ID]
)
,[LatestPolicyStatusChangingRAL] AS -- The initial insert of policies due for renewal only excludes cancellations if cancelled before report start date. This section will set the status to 'Cancelled' for any that are included
(
	SELECT
		 ROW_NUMBER() OVER (PARTITION BY [POLICY_DETAILS_ID] ORDER BY [ACTIONDATE] DESC) AS [RowNum]
		,[POLICY_DETAILS_ID]
		,[ACTIONTYPE]
	FROM [dbo].[REPORT_ACTION_LOG]
	WHERE
		[ACTIONTYPE] IN (2,3,4,5,8,9) -- Policy, MTA, Cancellation, Renewal, Lapse, Reinstatement
		AND [ACTIONDATE] <= @TransactionDate
)
UPDATE [TMP]
SET  
	 [New Policy Match Type] = CASE WHEN [TMP].[Invited HISTORY_ID] IS NOT NULL THEN 0 END
	,[New POLICY_DETAILS_ID] = [TMP].[POLICY_DETAILS_ID]
	,[New HISTORY_ID] = [TMP].[Invited HISTORY_ID]
	,[New Policy Number] = [CPD].[POLICYNUMBER]
	,[New Policy Effective Date] = [CPD].[POLICYSTARTDATE]
	,[New Policy End Date] = [CPD].[POLICYENDDATE]
	,[New Policy Insurer] = [SI].[INSURER_DEBUG]
	,[New Policy Premium] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Premium], 0) END
	,[New Policy Brokerage] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Brokerage], 0) END
	,[New Policy Agent Commission] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Agent Commission], 0) END
	,[New Policy Subagent Commission] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Subagent Commission], 0) END
	,[New Policy Discount] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Discount], 0) END
	,[New Policy Fee] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([CPD].[ADMINFEE], 0) END
	,[Status] = CASE
					WHEN [TMP].[Invited HISTORY_ID] IS NULL AND [LCHG].[ACTIONTYPE] = 8 THEN 'Lapsed'
					WHEN [TMP].[Invited HISTORY_ID] IS NULL AND [LCHG].[ACTIONTYPE] = 4 THEN 'Cancelled'
					WHEN [TMP].[Invited HISTORY_ID] IS NULL AND [TMP].[End Date] < @TransactionDate THEN 'Lapsed' -- This mops up those that have lapsed (end date is in the past when compared to the picture date parameter) but have no lapsed action in the CTE above
					WHEN [TMP].[Invited HISTORY_ID] IS NULL THEN 'Outstanding'
					WHEN [LAPSE].[ACTIONTYPE] = 8 THEN 'Lapsed'
					ELSE 'Invited'
				END
	,[Lapse Reason] = CASE WHEN [LAPSE].[ACTIONTYPE] = 8 THEN ISNULL([LAPSE].[LAPSE_REASON_DEBUG], '') ELSE '' END -- 8 = Lapse
	,[Lapse Reason Freeform] = CASE
									WHEN [LAPSE].[ACTIONTYPE] = 8 AND [LAPSE].[LAPSE_REASON_DEBUG] IS NULL THEN ''
									WHEN [LAPSE].[ACTIONTYPE] = 8 THEN ISNULL([LAPSE].[EVENT_DESCRIPTION], '')
									ELSE ''
							   END
	,[Lapsed By] = CASE WHEN [LAPSE].[ACTIONTYPE] = 8 THEN ISNULL([LAPSE].[FULLNAME], '') ELSE '' END 
FROM
	[#RenewalsDue] AS [TMP]
	LEFT JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [TMP].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [TMP].[Invited HISTORY_ID] = [CPD].[HISTORY_ID]
		LEFT JOIN [dbo].[SYSTEM_INSURER] AS [SI] ON [CPD].[INSURER_ID] = [SI].[INSURER_ID]
	LEFT JOIN [PREM] ON [TMP].[POLICY_DETAILS_ID] = [PREM].[POLICY_DETAILS_ID] AND [TMP].[Invited HISTORY_ID] = [PREM].[HISTORY_ID]
	LEFT JOIN [LatestPolicyStatusChangingRAL] AS [LCHG] ON [TMP].[POLICY_DETAILS_ID] = [LCHG].[POLICY_DETAILS_ID]
														AND [LCHG].[RowNum] = 1
	OUTER APPLY	(SELECT TOP 1
					 [RAL].[ACTIONTYPE]
					,[SSP].[FULLNAME]
					,[LLR].[LAPSE_REASON_DEBUG]
					,[CED].[EVENT_DESCRIPTION]
				 FROM
					[dbo].[REPORT_ACTION_LOG] AS [RAL]
						LEFT JOIN [dbo].[SYSTEM_SECURITY_PROFILE] AS [SSP] ON [RAL].[LOGINNAME] = [SSP].[LOGINNAME]
																		   AND [SSP].[DELETED] <> 1
						LEFT JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [LCPD] ON [RAL].[POLICY_DETAILS_ID] = [LCPD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [LCPD].[HISTORY_ID]
							LEFT JOIN [dbo].[LIST_POLICY_STATUS] AS [LPS] ON [LCPD].[POLICY_STATUS_ID] = [LPS].[POLICY_STATUS_ID]
							LEFT JOIN [dbo].[LIST_LAPSE_REASON] AS [LLR] ON [LCPD].[LAPSE_REASON_ID] = [LLR].[LAPSE_REASON_ID]
							LEFT JOIN [dbo].[CUSTOMER_EVENT_DESCRIPTION] AS [CED] ON [LCPD].[POLICY_DETAILS_ID] = [CED].[POLICY_DETAILS_ID] AND [LCPD].[HISTORY_ID] = [CED].[HISTORY_ID]
																				  AND [CED].[ACTION_LOG_TYPE_ID] = [RAL].[ACTIONTYPE]
				 WHERE
					[RAL].[POLICY_DETAILS_ID] = [TMP].[POLICY_DETAILS_ID]
					AND ([RAL].[ACTIONTYPE] = 8 -- Lapse
						 OR ([RAL].[ACTIONTYPE] = 10 AND [LPS].[POLICY_STATUS_DEBUG] = 'Renewal Invited') -- Invited RAL, and Policy status is still Renewal Invited
						)
					AND [RAL].[ACTIONDATE] <= @TransactionDate
					AND ([RAL].[POLICYSTARTDATE] >= [CPD].[POLICYSTARTDATE] AND [RAL].[POLICYSTARTDATE] < [CPD].[POLICYENDDATE]
						 OR
						 DATEDIFF(Day, [RAL].[ACTIONDATE], [CPD].[POLICYSTARTDATE]) BETWEEN -45 AND +45
						 )
				 ORDER BY
					[ACTIONDATE] DESC
				) AS [LAPSE]
WHERE
	[TMP].[New Policy Match Type] IS NULL -- Not matched to a renewal
;

-- Mop up matched records where Premium is still zero by setting to the invited amounts. This takes care of policies where there has been an UndoRenewal,
-- for example, and so the sum of amounts from the Accounts tables is zero due to backed out premium. These need to continue matching to the Undone Renewal
-- version above in order to pick up the correct status, lapse reason, etc.

WITH [PREM] AS
(
	SELECT
		 [POLICY_DETAILS_ID]
		,[HISTORY_ID]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'NET' THEN [PREMIUM] ELSE 0 END) AS [Premium]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('BRKCOMMP','BRKCOMMF') THEN [PREMIUM] ELSE 0 END) AS [Brokerage]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('AGECOMMP','AGECOMMF','AGEDISCP','AGEDISCF') THEN [PREMIUM] ELSE 0 END) AS [Agent Commission]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('SUBCOMMP','SUBCOMMF','SUBDISCP','SUBDISCF') THEN [PREMIUM] ELSE 0 END) AS [Subagent Commission]
		,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('BRKDISCP','BRKDISCF') THEN [PREMIUM] ELSE 0 END) AS [Discount]
	FROM
		[dbo].[CUSTOMER_PREMIUM] AS [CP]
	GROUP BY
		 [POLICY_DETAILS_ID]
		,[HISTORY_ID]
)
UPDATE [TMP]
SET  
	 [New Policy Premium] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Premium], 0) END
	,[New Policy Brokerage] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Brokerage], 0) END
	,[New Policy Agent Commission] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Agent Commission], 0) END
	,[New Policy Subagent Commission] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Subagent Commission], 0) END
	,[New Policy Discount] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([PREM].[Discount], 0) END
	,[New Policy Fee] = CASE WHEN [PREM].[Premium] < 10 THEN 0 ELSE ISNULL([CPD].[ADMINFEE], 0) END
FROM
	[#RenewalsDue] AS [TMP]
	LEFT JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [TMP].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [TMP].[Invited HISTORY_ID] = [CPD].[HISTORY_ID]
	LEFT JOIN [PREM] ON [TMP].[POLICY_DETAILS_ID] = [PREM].[POLICY_DETAILS_ID] AND [TMP].[Invited HISTORY_ID] = [PREM].[HISTORY_ID]
WHERE
	ISNULL([TMP].[New Policy Match Type], 0) <> 0 -- Matched to a renewal
	AND [New Policy Premium] = 0
;


-- ==================
-- RETURN REPORT DATA
-- ==================

SELECT
	*
FROM
	[#RenewalsDue]
ORDER BY
	[Policy Number];