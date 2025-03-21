USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspReportAgedDebtors]    Script Date: 19/02/2025 08:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Joe Fathallah
-- Create Date: 17-AUG-2009
-- Description: Aged Debtors Report
-- NOTE: THIS PROCEDURE IS USED BY BOTH AGED DEBTORS AND AGENT DEBTORS WITH DIARIES REPORTS! ANY CHANGES SHOULD BE TESTED IN BOTH REPORTS.
-- =============================================

-- Date			Who						Change
-- 07/04/2010	Mark Evans				Sarah Evans added more diary action types 260118
-- 24/05/2019	Jeremai Smith			Added and removed diary action types and moved diary to CTE to remove duplication of action type list
-- 31/05/2019	Sarah Evans				Sarah Evans added more diary action types 260118
-- 23/12/2019	Jeremai Smith			Combined uspReportAgedDebtors and uspReportAgedDebtors2 into single procedure
-- 01/05/2020	Martin Clements			Amended the Action Types and changed the LEFT JOIN [LatestDiary] to RIGHT JOIN [LatestDiary] as only accounts with a Action
--										Type listed should be returned in the report.
-- 14/05/2020	Jeremai Smith			Changed RIGHT JOIN [LatestDiary] back to LEFT JOIN and added clause so it only restricts to diary type list for Aged Debtors
--										Report with Diaries and not Aged Debtors Report
-- 04/03/2021	Martin Clements			Added Action Type 43S55CC0 as per Monday (1079159624)
-- 04/05/2021	Martin Clements			Added Action Type 442BKLF2 as per Monday (123961694)
-- 04/11/2022	Simon Mackness-Pettit	Repopulated Action Type as per Monday (3457901434)
-- 24/02/2023	Jeremai Smith			Re-combined uspReportAgedDebtor and uspReportAgedDebtors into single procedure as the two reports had been split to use
--										separate procedures again (Monday ticket 3892206296)
--										Also replaced three seprate subqueries reading from CUSTOMER_BANK_DETAILS with single CTE
-- 28/02/2023	Jeremai Smith			Replaced three seprate subqueries reading from CUSTOMER_TELEPHONE with single CTE (Monday ticket 4057935340)
-- 09/03/2023	Jeremai Smith			Added original sale agent (Monday ticket 4050351522)
--										Also combined uspReportHistoricAgedDebtor with this procedure by adding new ReportType and list of action type IDs, to
--										reduce duplication of code
-- 29/03/2023	Jeremai Smith			Corrections to Agent list for Direct and Indirect (Monday ticket 4216112305)
-- 29/03/2023	Simon Mackness-Pettit	Added Diary types ZZ CC Refund Exhausted & CC CPF Validation (Monday ticket 4325259400)
-- 25/08/2023	Simon Mackness-Pettit	Added Diary types (Monday ticket 5045784093)
-- 14/12/2023	Jeremai Smith			Added Age of Debt column (Monday ticket 5679016819)
-- 11/01/2024	Simon Mackness-Pettit	Added Court Payment Plan – 41NS6BI1 (5837438934) to diary
-- 01/05/2024	Simon Mackness-Pettit	Added MTA/Cancelled Return of Premium Due – 3P2B9IT7 (6557209906) to diary
-- 15/07/2024	Jeremai Smith			Replaced @DirectAgents list with join to new RM_AGENT_MH_TYPE table (Monday ticket 6996624659)
-- 05/08/2024	Jeremai Smith			Stop subtracting SubAgent commission from outstanding amounts (Mondy ticket 7079658771)
-- 08/10/2024	Simon Mackness-Pettit	Added SubAgent commission to outstanding amounts (Mondy ticket 7587246878)
-- 03/02/2025	Simon Mackness-Pettit	Added CDC OS to diary entries


ALTER PROCEDURE [dbo].[uspReportAgedDebtors]
	 @DateTo			datetime
	,@PaymentPlanID		varchar(MAX)
	,@Direct			varchar(8)
	,@SubAgentID		varchar(MAX)
	,@ReportType		varchar(25)
					
AS

/*

DECLARE @DateTo				datetime
DECLARE @PaymentPlanID		VARCHAR(MAX)
DECLARE @Direct				varchar(8)
DECLARE @SubAgentID			VARCHAR(MAX)
DECLARE @ReportType			varchar(25)

SET @DateTo = '29 Mar 2023'
SET @PaymentPlanID = '010DF016C4CA401BB108CD9FC79F960C,07307B9B592B40DF80895F8913337ECB,0AF6FACD71AF4A8E8C074D1C9CBDC01A,0C7A0CC891E8455982957CD595F523AA,15490320D38A45D89A7F6685BAA057CC,2082FB178DE74BCF944DFD50A3F33427,253D192F547441D3AC7703375F1A1A9C,25AD9B228FE34A8F9A26CD26AB60A2EB,26FBE5C329634E0B814479F50EE6F073,28AB8521EBB943BAB096C863B2E44757,2A4E9E88C7A54897A62C2B9C80E61216,2E80446FF50B4F7DB96EEC25D65FA873,40F0C964844A4CDE87761AECFCE256A2,4563B2325B3A487B9954224ADE47B505,4BE5E10FD22F4A08ABA02EC0453D4D04,4ED05256AB5B484791C93E58F1F13CEF,504707FA7A8C42DBA5A8CB0FB56FE5DC,50CBAE153F84484DA0333B4C0DE6EBCA,5B84991504C84CB6B21027AEE98EA819,61DE7BE64C044A73A187D7B6600DECD0,652320AF256942149924DAE952A6C1C4,6714F2C987FA4A90A2573095DFEC169F,6FD0BB8BF74343B5A83A7463305B9C55,82941527E709471DA3DFA1B2F0C6F630,83D4DC909DA44C10B47FE2F4B0EEA89C,8886E5784C6F44D3B60BBD8A4084F3E1,88A1180205BA4E0082176EDB4F6CF66A,8B5BB9EB71944D91A63CD006DED9284A,8F1C14999A8A414B870B4FCF56E4F46E,8FF2BBEC288549ABA4DE61C6FB7D227F,91D4ACA9F8A147AC8E2B883E919FE919,9F1CDD6D0AC2486A9952539F72F2A4DF,9F2F9E70E27B4B2E89D01C7B16871B37,A12CE7944F284C349397995A43B0520E,AF1CA0D1E8B04E018F855ED4025D2943,B2DB9DEEB02C409983AA910175059FAC,B3CFD5F80A2D4D829519817E57DB0716,B4BD291F04EC44E281B3D22C9614CB8C,B8E4095D0F484CEFA14271FF993F302C,BA4967E165D04F1798EC2F306E199E82,BC1CAAA1FBCD4442931C74C5C388C673,C0D3118CC0AE4FD88FE0FCDFEBD2A583,C91B121D16554F7AB3EEE997D9C449AF,D322E23721914CFD8F271DD16D59E82B,E6C92418944844CFB2534F6266797A3A,EA345581BF884425BBDDFE3D810558B5,F21A107BD0064958A1DA92492A8ACA3A'
SET @Direct = 'Both' -- 'Direct', 'Indirect', 'Both'		
SET @SubAgentID = 'ALLSUBAGENTS'
SET @ReportType = 'Aged debtors with diaries' -- 'Aged debtors' == 'Historic aged debtors'

EXEC [dbo].[uspReportAgedDebtors] @DateTo, @PaymentPlanID, @Direct, @SubAgentID, @ReportType

*/

IF CONVERT(VARCHAR(12), @DateTo, 114) = '00:00:00:000'
	SET @DateTo = DATEADD(DAY, 1, @DateTo);

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @DiaryTypes TABLE (
	 [ACTION_TYPE_ID] varchar(8)
	,[ACTION_TYPE_DEBUG] varchar(255)
);

IF @ReportType = 'Aged debtors'
	INSERT INTO @DiaryTypes
	SELECT 
		 [ACTION_TYPE_ID]
		,[ACTION_TYPE_DEBUG]
	FROM
		[Transactor_Live].[dbo].[LIST_ACTION_TYPE]
	WHERE
		[ACTION_TYPE_ID] IN	(
								'45LILHD4'	--Cancellation Request
								,'45LILBV6'	--CC - Add to IPrompt
								,'45LILFN7'	--CC Canx Refunds Raised
								,'3P4EV5I5'	--CC CPF ADDACS List
								,'3P3737C4'	--CC DDD Final Reminder Due
								,'3VP6CUB9'	--CC Direct Debit Mandate Oustanding
								,'45LILF10'	--CC MTA Refunds Raised
								,'3OB2GFO4'	--CC Payment Method Invoice
								,'3P3GBML7'	--Registered with Debt Collection Agency
								,'41NVG283' --ZZ CC Refund Exhausted
								,'44B9TGF9' --CC CPF Validation
								,'40GLTBR5' --M Service Call
								,'413E4K36' --Debt Recovery Lovetts
								,'3NBN8HB7' --Check Insurer DD is set up
								,'4323LSH6' --Debt Collection
								,'40IP2EF6' --Debt Collection Moriarty
								,'41NS69K1' --Court Mediation
								,'413E4J91' --Debt Collection W&G
								,'46LP4DP6' --Payment Plan Agreed
								,'3P2HEQ52' --Write-off passed for approval
								,'41NS6BI1' --Court Payment Plan
								,'3P2B9IT7' --MTA/Cancelled Return of Premium Due
								,'484GNVR9' --CDC OS
							 );

IF @ReportType = 'Aged debtors with diaries'
	INSERT INTO @DiaryTypes
	SELECT 
		 [ACTION_TYPE_ID]
		,[ACTION_TYPE_DEBUG]
	FROM
		[Transactor_Live].[dbo].[LIST_ACTION_TYPE]
	WHERE
		[ACTION_TYPE_ID] IN (	 '3P2B8978' -- Accounts Processing
								,'3P373S65' -- CC - Broker Statement Query
								,'3P36KS30' -- CC - Credit Control Query
								,'3VR3PRH8' -- CC - Transaction processed outstanding balance
								,'3VTGEHI2' -- CC Add to IPrompt
								,'3NMRE426' -- CC Add to IPrompt - MTA Accepted on Finance
								,'3NQMS4J0' -- CC Add to IPrompt - Multiple NB or Rnl Accepted on Annual Instalments
								,'3NK3QNS5' -- CC Add to IPrompt - Policy Accepted on Direct Debit
								,'3NMRE302' -- CC Add to IPrompt - Renewed on Direct Debit
								,'3P2B8AH0' -- CC Add to IPrompt - Van DD
								,'3RNSHMP6' -- CC Auto Renewal - Cancel DD
								,'3RNSH4M8' -- CC Auto Renewal - Set up DD
								,'3PV4GVP6' -- CC Awaiting DD Clawback
								,'3OB2GFO4' -- CC Chase Outstanding Balance - Payment Method Invoice
								,'3OGAMTQ4' -- CC Chase Payment - Call 1st Reminder issued
								,'3OGANAA8' -- CC Chase Payment - Final Reminder Due
								,'3P2B8ER6' -- CC Chase Payment Van
								,'3NMREDJ6' -- CC Check Funding Received
								,'409SHF16' -- CC Client in Receivership
								,'4184ABG0'	-- CC Court
								,'41NS68G1' -- CC Court Judgement
								,'44B9TGF9' --CC CPF Validation
								,'45LILHD4'	--Cancellation Request
								,'45LILBV6'	--CC - Add to IPrompt
								,'45LILFN7'	--CC Canx Refunds Raised
								,'45LILF10'	--CC MTA Refunds Raised
								,'3P3737C4'	--CC DDD Final Reminder Due
								,'3P4EV5I5' -- CC CPF Arrears List
								,'411R0NJ1' -- CC DD Fail
								,'43S55CC0' -- CC Debt after Cancellation
								,'4323LSH6' -- CC Debt Awaiting Final Outcome
								,'3P2B7U54' -- CC Debt Collection
								,'40IP2EF6' -- CC Debt Collection Exhausted
								,'3VP6CUB9' -- CC Direct Debit Mandate Oustanding
								,'3P2B9AA8' -- CC Incorrect Bank Details Supplied
								,'3NSOEFI7' -- CC MTA Accepted with Multi Policy on Annual Instalments
								,'3HVUU7E5' -- CC MTA Quote Accepted - Payment Invoice
								,'3VTGEIE1' -- CC No Bank Details
								,'3P25CEL4' -- CC No Bank Details - Multiple NB or Rnl Accepted on Direct Debit
								,'3P25DD25' -- CC No Bank Details - Policy Accepted on Direct Debt
								,'3P25DQV5' -- CC No Bank Details - Renewal Accepted on Direct Debit
								,'3P25T8U5' -- CC Policy Cancelled - Debt Outstanding
								,'41R94H92'	-- CC Policy Cancelled with Debt
								,'3P2B7T18' -- CC Post Dated Payments - Held
								,'41NVG283' -- CC Refunds Exhausted
								,'3NBP8P92' -- Chase Outstanding Monies
								,'3OGAMMF9' -- Chase Payment - 1st Reminder Due
								,'3OGAN798' -- Chase Payment - 2nd Reminder Due
								,'3OGAN8I4' -- Chase Payment - 2nd Reminder issued
								,'3OGANJD1' -- Chase Payment - Final call Pre Canx
								,'3OGANBQ6' -- Chase Payment - Final Reminder issued
								,'3NBN8HB7' -- Check Insurer DD is set up
								,'3HAFLO31' -- Final Reminder - MTA - AP Payment Required
								,'3NBP7M39' -- Final Reminder - Outstanding Checklist Items
								,'3NBP8V23' -- Final Reminder - Outstanding Monies
								,'3P2B9IT7' -- MTA/Cancelled Return of Premium Due
								,'442BKLF2' -- Pending WOff ID
								,'3P3GBML7' -- Registered with Debt Collection Agency
								,'3NSOEE82' -- Renewal Accepted with Multi Policy on Annual Instalments
								,'3P2HEQ52' -- Write-off passed for approval
								,'40GLTBR5' -- M Service Call
								,'413E4K36' -- Debt Recovery Lovetts
								,'41NS69K1' -- Court Mediation
								,'413E4J91' -- Debt Collection W&G
								,'46LP4DP6' -- Payment Plan Agreed
								,'3P2HEQ52' --Write-off passed for approval
								,'41NS6BI1' --Court Payment Plan
								,'484GNVR9' --CDC OS
							 );

IF @ReportType = 'Historic aged debtors'
	INSERT INTO @DiaryTypes
	SELECT 
		 [ACTION_TYPE_ID]
		,[ACTION_TYPE_DEBUG]
	FROM
		[Transactor_Live].[dbo].[LIST_ACTION_TYPE]
	WHERE
		[ACTION_TYPE_ID] IN (	 '3P2B8978' -- Accounts Processing
								,'45LILHD4' -- Cancellation Request
								,'3NJGOE94' -- Cancellation Request from Broker
								,'3NK3JHJ7' -- Cancellation Request from Client
								,'3NK3JJ18' -- Cancellation Request from Credit Control
								,'3NK3JKE7' -- Cancellation Request from Sales
								,'3HAFH3N3' -- Cancellation Warning Issued
								,'3NJGOGC1' -- Cancellation z - Approved for Processing
								,'45LILBV6' -- CC - Add to IPrompt
								,'3VTGEHI2' -- CC Add to IPrompt
								,'3NMRE426' -- CC Add to IPrompt - MTA Accepted on Finance
								,'3NQMS4J0' -- CC Add to IPrompt - Multiple NB or Rnl Accepted on Annual Instalments
								,'3NK3QNS5' -- CC Add to IPrompt - Policy Accepted on Direct Debit
								,'3NMRE302' -- CC Add to IPrompt - Renewed on Direct Debit
								,'3RNSHMP6' -- CC Auto Renewal - Cancel DD
								,'3RNSH4M8' -- CC Auto Renewal - Set up DD
								,'3PV4GVP6' -- CC Awaiting DD Clawback
								,'45LILFN7' -- CC Canx Refunds Raised
								,'3OB2GFO4' -- CC Chase Outstanding Balance - Payment Method Invoice
								,'3OGAMTQ4' -- CC Chase Payment - Call 1st Reminder issued
								,'3OGANAA8' -- CC Chase Payment - Final Reminder Due
								,'3P2B8ER6' -- CC Chase Payment Van
								,'3NMREDJ6' -- CC Check Funding Received
								,'409SHF16' -- CC Client in Receivership
								,'41NS68G1' -- CC Court Judgement
								,'3P4EV5I5' -- CC CPF Arrears List
								,'3P373328' -- CC DDD Chase Payment - Call 1st Reminder Issued
								,'3P3737C4' -- CC DDD Chase Payment - Final Reminder Due
								,'3P3737C4' -- CC DDD Final Reminder Due
								,'43S55CC0' -- CC Debt after Cancellation
								,'4323LSH6' -- CC Debt Awaiting Final Outcome
								,'3P2B7U54' -- CC Debt Collection
								,'40IP2EF6' -- CC Debt Collection Exhausted
								,'3VP6CUB9' -- CC Direct Debit Mandate Oustanding
								,'3P2B9AA8' -- CC Incorrect Bank Details Supplied
								,'3NSOEFI7' -- CC MTA Accepted with Multi Policy on Annual Instalments
								,'45LILF10' -- CC MTA Refunds Raised
								,'3HVUU7E5' -- CC MTA Quote Accepted - Payment Invoice
								,'3VTGEIE1' -- CC No Bank Details
								,'3P25CEL4' -- CC No Bank Details - Multiple NB or Rnl Accepted on Direct Debit
								,'3P25DD25' -- CC No Bank Details - Policy Accepted on Direct Debt
								,'3P25DQV5' -- CC No Bank Details - Renewal Accepted on Direct Debit
								,'3P25T8U5' -- CC Policy Cancelled - Debt Outstanding
								,'41R94H92'	-- CC Policy Cancelled with Debt
								,'41NVG283' -- CC Refunds Exhausted
								,'3NBN8HB7' -- Check Insurer DD is set up
								,'442BKLF2' -- Pending WOff ID
								,'3P3GBML7' -- Registered with Debt Collection Agency
								,'3P2HEQ52' -- Write-off passed for approval
								,'41NS6BI1' --Court Payment Plan
							 )
	;

;WITH [LatestDiary] AS
(
	SELECT
		 ROW_NUMBER() OVER (PARTITION BY [CDM].[POLICY_DETAILS_ID] ORDER BY [CDM].[ACTIONDATE] DESC) AS [RowNum]
		,[CDM].[DIARY_ID]
		,[CDM].[POLICY_DETAILS_ID]
		,[LAT].[ACTION_TYPE_DEBUG]
		,[CDM].[NOTES]
	FROM
		[dbo].[CUSTOMER_DIARY_MODULE] AS [CDM]
	INNER JOIN
		[dbo].[LIST_ACTION_TYPE] AS [LAT] ON [CDM].[ACTION_TYPE_ID] = [LAT].[ACTION_TYPE_ID]
	INNER JOIN
		@DiaryTypes AS [DT] ON [CDM].[ACTION_TYPE_ID] = [DT].[ACTION_TYPE_ID]
	WHERE
		[CDM].[ACTIONEDYN] = 0					  
)
,[CBD] AS
(
	SELECT
		 ROW_NUMBER() OVER (PARTITION BY [POLICY_DETAILS_ID], [HISTORY_ID] ORDER BY [CREATEDDATE] DESC) AS [RowNum]
		,[POLICY_DETAILS_ID]
		,[HISTORY_ID]
		,[HOLDER]
		,[ACCOUNTNO]
		,[SORTCODE]
	FROM
		[Transactor_Live].[dbo].[CUSTOMER_BANK_DETAILS]
)
,[Telephone] AS
(
	SELECT
		 [INSURED_PARTY_ID]
		,[HISTORY_ID]
		,MAX(IIF([TELEPHONE_TYPE_ID] = '3AJPQ7C4', [TELEPHONENUMBER], NULL)) AS [Home]
		,MAX(IIF([TELEPHONE_TYPE_ID] = '3AJPQ7C6', [TELEPHONENUMBER], NULL)) AS [Mobile]
		,MAX(IIF([TELEPHONE_TYPE_ID] = '3AJPQ7C5', [TELEPHONENUMBER], NULL)) AS [Business]
		,MAX(IIF([TELEPHONE_TYPE_ID] NOT IN ('3AJPQ7C4', '3AJPQ7C6', '3AJPQ7C5'), [TELEPHONENUMBER], NULL)) AS [Other]
	FROM
		[dbo].[CUSTOMER_TELEPHONE]
	GROUP BY
		 [INSURED_PARTY_ID]
		,[HISTORY_ID]
)
SELECT
	 ISNULL([CIP].[CLIENT_REF_NO], '') AS [Client_ID]
	,ISNULL([RSA].[REFERENCE], '') AS 'Broker Ref'
	,ISNULL([RSA].[NAME], '') AS 'Broker Name'
	,ISNULL([ACV].[POLICYNUMBER], '') AS 'Policy Ref'
	,ISNULL(REPLACE([ACV].[CLIENTNAME], ',', ''), '') AS 'Client Name'
	,ISNULL([T].[Home], '') AS 'Client Home Phone' 
	,ISNULL([T].[Mobile], '') AS 'Client Mobile Phone'
	,ISNULL([T].[Business], '') AS 'Client Business Phone'
	,ISNULL([T].[Other], '') AS 'Client Other Phone'
	,ISNULL((SELECT TOP 1
			[RMCT].[TELEPHONE]
			FROM [dbo].[RM_CONTACT_TELEPHONE] AS [RMCT] WITH (NOLOCK)
			LEFT JOIN [dbo].[RM_SUBAGENT_CONTACT_LINK] AS [RMSCL] WITH (NOLOCK) ON [RSA].[SUBAGENT_ID] = [RMSCL].[SUBAGENT_ID]
			WHERE [RMCT].[CONTACT_ID] = [RMSCL].[CONTACT_ID]), '') AS 'Broker Default Telephone'
	,ISNULL([RMA].[NAME], '') AS [Agent]
	,ISNULL([LPT].[PRODUCT_TYPE_DEBUG], '') AS 'Policy Type'
	,ISNULL([LPS].[POLICY_STATUS_DEBUG], '') AS 'Policy Status'
	,CASE
		WHEN @ReportType = 'Aged debtors' THEN ISNULL(CASE WHEN [ACV].[PAYMENTDATE] <= @DateTo THEN [ACV].[Outstanding] + [APV].[SubAgentCommission] + [APV].[SubAgentDiscount] END, 0) 
		ELSE ISNULL([ACV].[Outstanding] + [APV].[SubAgentCommission] + [APV].[SubAgentDiscount], 0)
	 END AS 'Outstanding Amount'
	,ISNULL(CASE WHEN [ACV].[PAYMENTDATE] <= @DateTo AND [Days].[DebtAgeDays] BETWEEN 0 AND 30 THEN [ACV].[Outstanding] END, 0) AS '1 To 30 Days'
	,ISNULL(CASE WHEN [ACV].[PAYMENTDATE] <= @DateTo AND [Days].[DebtAgeDays] BETWEEN 31 AND 60 THEN [ACV].[Outstanding] END, 0) AS '31 To 60 Days'
	,ISNULL(CASE WHEN [ACV].[PAYMENTDATE] <= @DateTo AND [Days].[DebtAgeDays] BETWEEN 61 AND 90 THEN [ACV].[Outstanding] END, 0) AS '61 To 90 Days'
	,ISNULL(CASE WHEN [ACV].[PAYMENTDATE] <= @DateTo AND [Days].[DebtAgeDays] >= 91 THEN [ACV].[Outstanding] END, 0) AS 'Over 90 Days'
	,ISNULL(CASE WHEN [ACV].[PAYMENTDATE] <= @DateTo AND [Days].[DebtAgeDays] BETWEEN 91 AND 120 THEN [ACV].[Outstanding] END, 0) AS '91 To 120 Days'
	,ISNULL(CASE WHEN [ACV].[PAYMENTDATE] <= @DateTo AND [Days].[DebtAgeDays] BETWEEN 121 AND 180 THEN [ACV].[Outstanding] END, 0) AS '121 To 180 Days'
	,ISNULL(CASE WHEN [ACV].[PAYMENTDATE] <= @DateTo AND [Days].[DebtAgeDays] >= 181 THEN [ACV].[Outstanding] END, 0) AS 'Over 180 Days'
	,ISNULL([CPD].[POLICYSTARTDATE], '') AS 'Policy Effective Date'
	,ISNULL([CPD].[CREATEDDATE], '') AS 'Policy Created Date'
	,ISNULL([LTC].[TRANSACTION_CODE_DEBUG], '') AS 'Transaction Type'  
	,ISNULL([ACV].[CREATEDDATE], '') AS 'Transaction Created Date'
	,ISNULL([RPP].[NAME], '') AS 'Payment Plan'
	,ISNULL([CBD].[HOLDER], '') AS [Account Holder]
	,ISNULL([CBD].[ACCOUNTNO], '') AS [Account Number]
	,ISNULL([CBD].[SORTCODE], '') AS [Sort Code]
	,ISNULL([AFA].[REFERENCE], '') AS 'Finance Agreement Ref'
	,ISNULL([LP].[PAYMETHOD_DEBUG], '') AS 'Payment Method'
	,[D].[ACTION_TYPE_DEBUG] AS [Diary]
	,[D].[NOTES] AS [Diary Notes]
	,REPLACE(((SELECT 
					(RTRIM(CAST((ROW_NUMBER() OVER(ORDER BY [CDM].[ACTIONDATE] DESC)) AS CHAR(8))) + ') ' + [DT].[ACTION_TYPE_DEBUG] + char(10))
				FROM [dbo].[CUSTOMER_DIARY_MODULE] AS [CDM]
					INNER JOIN @DiaryTypes AS [DT] ON [CDM].[ACTION_TYPE_ID] = [DT].[ACTION_TYPE_ID]
				WHERE [CDM].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID]
					AND [CDM].[ACTIONEDYN] = 0
					AND [CDM].[DIARY_ID] <> [D].[DIARY_ID]
				ORDER BY [CDM].[ACTIONDATE] DESC
				FOR XML PATH ('') )), '&#x0A;', '') AS [Other Diaries]
	,REPLACE(((SELECT 
					(RTRIM(CAST((ROW_NUMBER() OVER(ORDER BY [CDM].[ACTIONDATE] DESC)) AS CHAR(8))) + ') ' + [CDM].[NOTES] + char(10))
				FROM [dbo].[CUSTOMER_DIARY_MODULE] AS [CDM]
					INNER JOIN @DiaryTypes AS [DT] ON [CDM].[ACTION_TYPE_ID] = [DT].[ACTION_TYPE_ID]
				WHERE [CDM].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID]
					AND [CDM].[ACTIONEDYN] = 0
					AND [CDM].[DIARY_ID] <> [D].[DIARY_ID]
				ORDER BY [CDM].[ACTIONDATE] DESC
				FOR XML PATH ('') )), '&#x0A;', '') AS [Other Diaries Notes]
	,(SELECT
		COUNT(*)
	  FROM
		[dbo].[CUSTOMER_DIARY_MODULE] AS [CDM]
		INNER JOIN @DiaryTypes AS [DT] ON [CDM].[ACTION_TYPE_ID] = [DT].[ACTION_TYPE_ID]
	  WHERE
		[CDM].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID]
		AND [CDM].[ACTIONEDYN] = 0
	 ) AS [Diary Count]
	,COALESCE([SSP].[FULLNAME], [RALOrig].[LOGINNAME], 'Unknown') AS [Original Sale Agent]
	,CASE
		WHEN [ACV].[PAYMENTDATE] <= @DateTo
			THEN CASE
					WHEN [Days].[DebtAgeDays] BETWEEN 0 AND 30 THEN '0-30'
					WHEN [Days].[DebtAgeDays] BETWEEN 31 AND 60 THEN '31-60'
					WHEN [Days].[DebtAgeDays] BETWEEN 61 AND 90 THEN '61-90'
					WHEN [Days].[DebtAgeDays] BETWEEN 91 AND 180 THEN '91-180'
					WHEN [Days].[DebtAgeDays] BETWEEN 181 AND 365 THEN '181-365'
					WHEN [Days].[DebtAgeDays] > 365 THEN '365+'
				 END
	 END AS [Age of Debt]
FROM 
	[dbo].[ACCOUNTS_CLIENT_VIEW] AS [ACV] 
	LEFT JOIN [dbo].[CUSTOMER_INSURED_PARTY] AS [CIP] ON [ACV].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND [ACV].[INSURED_PARTY_HISTORY_ID] = [CIP].[HISTORY_ID]
	INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [ACV].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [ACV].[POLICY_DETAILS_HISTORY_ID] = [CPD].[HISTORY_ID]
	LEFT JOIN [dbo].[CUSTOMER_POLICY_LINK] AS [CPL] ON [CPD].[POLICY_DETAILS_ID] = [CPL].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CPL].[POLICY_DETAILS_HISTORY_ID]
	LEFT JOIN [dbo].[RM_SUBAGENT] AS [RSA]  ON [ACV].[SUBAGENT_ID] = [RSA].[SUBAGENT_ID]
	INNER JOIN [dbo].[LIST_POLICY_STATUS] AS [LPS]  ON [CPD].[POLICY_STATUS_ID] = [LPS].[POLICY_STATUS_ID]
	LEFT JOIN [dbo].[CUSTOMER_PAY_PLAN] AS [CPP]  ON [CPD].[POLICY_DETAILS_ID] = [CPP].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CPP].[HISTORY_ID] 
	LEFT JOIN [dbo].[LIST_PRODUCT_TYPE] AS [LPT]  ON [ACV].[PRODUCTTYPE] = [LPT].[PRODUCT_TYPE_ID] 
	LEFT JOIN [dbo].[LIST_TRANSACTION_CODE] AS [LTC]  ON [ACV].[TRANSACTION_CODE_ID] = [LTC].[TRANSACTION_CODE_ID] 
	LEFT JOIN [dbo].[RM_PAYMENT_PLAN] AS [RPP]  ON [CPP].[PAYMENT_PLAN_ID] = [RPP].[PAYMENT_PLAN_ID]
	LEFT JOIN [dbo].[ACCOUNTS_FINANCE_AGREEMENT] AS [AFA]  ON [CPD].[POLICY_DETAILS_ID] = [AFA].[POLICY_DETAILS_ID]
	LEFT JOIN [dbo].[LIST_PAYMETHOD] AS [LP]  ON [CPD].[PAYMETHOD_ID] = [LP].[PAYMETHOD_ID]
	LEFT JOIN [dbo].[ACCOUNTS_PREMIUM_VIEW] AS [APV]  ON [ACV].[TRANSACTION_ID] = [APV].[Transaction_ID]
	LEFT JOIN [dbo].[RM_AGENT] AS [RMA]  ON [CPD].[AGENT_ID] = [RMA].[AGENT_ID]
	LEFT JOIN [dbo].[RM_AGENT_MH_TYPE] AS [RMAMH]  ON [CPD].[AGENT_ID] = [RMAMH].[AGENT_ID]
	LEFT JOIN [dbo].[REPORT_ACTION_LOG] AS [RALOrig] ON [ACV].[POLICY_DETAILS_ID] = [RALOrig].[POLICY_DETAILS_ID]
													 AND [RALOrig].[ACTIONTYPE] = 2 -- Original policy sale
	LEFT JOIN [dbo].[SYSTEM_SECURITY_PROFILE] AS [SSP] ON [RALOrig].[LOGINNAME] = [SSP].[LOGINNAME]
	LEFT JOIN [LatestDiary] AS [D] ON [CPD].[POLICY_DETAILS_ID] = [D].[POLICY_DETAILS_ID] AND [D].[RowNum] = 1
	LEFT JOIN [CBD] ON [CPD].[POLICY_DETAILS_ID] = [CBD].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CBD].[HISTORY_ID]
					AND [CBD].[RowNum] = 1
	LEFT JOIN [Telephone] AS [T] ON [CPL].[INSURED_PARTY_ID] = [T].[INSURED_PARTY_ID] AND [CPL].[INSURED_PARTY_HISTORY_ID] = [T].[HISTORY_ID]
	OUTER APPLY (SELECT DATEDIFF(DAY, [ACV].[PAYMENTDATE], @DateTo) AS [DebtAgeDays]) AS [Days]
WHERE
	(@ReportType = 'Aged debtors with diaries' OR (@ReportType IN ('Historic aged debtors', 'Aged debtors') AND [ACV].[EFFECTIVEDATE] < @DateTo))
	AND (@ReportType IN ('Historic aged debtors', 'Aged debtors') OR (@ReportType = 'Aged debtors with diaries' AND [D].[POLICY_DETAILS_ID] IS NOT NULL)) -- Restrict to only those rows with a diary in the diary type list for Aged Debtors with Diaries report
	AND [ACV].[Settled] = 0
	AND ISNULL([RSA].[DELETED],0) = 0
	AND ([CPP].[PAYMENT_PLAN_ID] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@PaymentPlanID,',')) OR [CPP].[PAYMENT_PLAN_ID] IS NULL)
	AND (@Direct = 'Both'
		 OR (@Direct = 'Direct' AND [RMAMH].[Direct] = 1)
		 OR (@Direct = 'Indirect' AND [RMAMH].[Indirect] = 1)
		 )
	AND ([CPD].[SUBAGENT_ID] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@SubAgentID,',')) OR 'ALLSUBAGENTS' IN (@SubAgentID))
;

