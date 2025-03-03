USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspReportSagicGITC_BDX]    Script Date: 06/02/2025 10:04:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=============================================
-- Author:		Linga Nageswara
-- Create Date: 19-July-2023
-- Description: Sagic Bordereaux
-- =============================================

-- Date			Who						Change
-- 05/10/2023	Linga        			Monday ticket 5216496310: Update to the SAGIC GIT BDX
--										- Change: Updated the Net Premium based on requirement, 
--                                      - Issue: There is an issue where some policies are not showing in BDX
--                                        --Findings: There is a connection between customer policy details and telephone details that allows to display the customer's contact information in the BDX, however, some policies do not have client telephone information. Thus, some recordings won't be seen on BDX.
--                                        --Solution: Changed from INNER JOIN to LEFT JOIN for the [CUSTOMER_TELEPHONE] TABLE
-- 21/11/2023    Linga                  Monday ticket 5324756740: SAGIC BDX Fixes
-- 03/05/2024	 Linga / Jez			Monday ticket 5548817961: SAGIC BDX Fixes



ALTER PROCEDURE [dbo].[uspReportSagicGITC_BDX]
	 @FromDate			datetime
	,@ToDate			datetime
	
/**********************************

DECLARE @FromDate datetime
DECLARE @ToDate datetime

SET @FromDate = '01 Feb 2024'
SET @ToDate = '29 Feb 2024'

EXECUTE [Transactor_Live].[dbo].[uspReportSagicGITC_BDX] @FromDate, @ToDate

**********************************/ 
	
AS

IF CONVERT(VARCHAR(12), @ToDate, 114) = '00:00:00:000'
	SET @ToDate = DATEADD(DAY, 1, @ToDate);

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


WITH [Accounts] AS
(
  SELECT
		 [ACV].[TRANSACTION_ID]
		,[ACV].[POLICY_DETAILS_ID]
		,[ACV].[POLICY_DETAILS_HISTORY_ID]
		,[ACV].[TRANSACTION_CODE_ID]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [NET]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID]  = 'TAX_IPT' THEN [ATB].[AMOUNT] ELSE 0 END) AS [TAX_IPT]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID]  = 'FEE' THEN [ATB].[AMOUNT] ELSE 0 END) AS [FEE]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID]  IN ('BRKCOMMP','BRKCOMMF') THEN [ATB].[AMOUNT] ELSE 0 END) AS [Partner Commission]	
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID]  IN ('SUBCOMMP','SUBCOMMF') THEN [ATB].[AMOUNT] ELSE 0 END) AS [Sub-Agent Commission]
		,CASE 
			[ACV].[TRANSACTION_CODE_ID]
			WHEN 'NB' THEN 2 -- Policy
			WHEN 'ADD' THEN 3 -- MTA
			WHEN 'RET' THEN 3 -- MTA
			WHEN 'XLD' THEN 4 -- Cancellation
			WHEN 'XADD' THEN 47 -- UndoMTA
			WHEN 'XRET' THEN 47 -- UndoMTA
			WHEN 'REN' THEN 5 -- Renewal
			WHEN 'XREN' THEN 51 -- UndoRenewal
			WHEN 'REIN' THEN 9 -- Reinstatement
		 END AS [ActionType] -- To join to correct RAL records
		,CASE [ACV].[TRANSACTION_CODE_ID]
			WHEN 'ADD' THEN 'DR'
			WHEN 'RET' THEN 'CR'
		 END AS [Type]
	FROM
		[dbo].[ACCOUNTS_CLIENT_VIEW] AS [ACV]
		LEFT JOIN [dbo].[ACCOUNTS_TRAN_BREAKDOWN] AS [ATB] ON [ACV].[TRANSACTION_ID] = [ATB].[TRANSACTION_ID]
	WHERE
		[ACV].[TRANSACTION_CODE_ID] <> 'PAY'
	AND
		[ATB].[INSURER_ID] = 'SAGIC'
	GROUP BY
		 [ACV].[TRANSACTION_ID]
		,[ACV].[POLICY_DETAILS_ID]
		,[ACV].[POLICY_DETAILS_HISTORY_ID]
		,[ACV].[TRANSACTION_CODE_ID]
),
[CPREMIUM] AS
(
   SELECT
		[CP].POLICY_DETAILS_ID as [Policy_Details_ID]
	   ,[CP].HISTORY_ID as [History_ID]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'AGECOMMF' THEN [CP].[PREMIUM] ELSE 0 END) AS [AGECOMMF]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'AGECOMMP' THEN [CP].[PREMIUM] ELSE 0 END) AS [AGECOMMP]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'AGEDISCF' THEN [CP].[PREMIUM] ELSE 0 END) AS [AGEDISCF]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'AGEDISCP' THEN [CP].[PREMIUM] ELSE 0 END) AS [AGEDISCP]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'BRKCOMMF' THEN [CP].[PREMIUM] ELSE 0 END) AS [BRKCOMMF]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'BRKCOMMP' THEN [CP].[PREMIUM] ELSE 0 END) AS [BRKCOMMP]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'BRKDISCF' THEN [CP].[PREMIUM] ELSE 0 END) AS [BRKDISCF]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'BRKDISCP' THEN [CP].[PREMIUM] ELSE 0 END) AS [BRKDISCP]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'FEE' THEN [CP].[PREMIUM] ELSE 0 END) AS [FEE]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'INTCOMMF' THEN [CP].[PREMIUM] ELSE 0 END) AS [INTCOMMF]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'INTCOMMP' THEN [CP].[PREMIUM] ELSE 0 END) AS [INTCOMMP]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'NET' THEN [CP].[PREMIUM] ELSE 0 END) AS [NET]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'SC' THEN [CP].[PREMIUM] ELSE 0 END) AS [SC]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'SUBCOMMF' THEN [CP].[PREMIUM] ELSE 0 END) AS [SUBCOMMF]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'SUBCOMMP' THEN [CP].[PREMIUM] ELSE 0 END) AS [SUBCOMMP]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'SUBDISCP' THEN [CP].[PREMIUM] ELSE 0 END) AS [SUBDISCP]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] = 'TAX_IPT' THEN [CP].[PREMIUM] ELSE 0 END) AS [TAX_IPT]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('BRKCOMMF','BRKCOMMP','AGECOMMP','AGECOMMF','SUBCOMMP','SUBCOMMF') THEN [CP].[PREMIUM] ELSE 0 END) AS [Gross Commission]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('BRKCOMMP','BRKCOMMF') THEN [CP].[PREMIUM] ELSE 0 END) AS [Partner Commission]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('BRKDISCP','BRKDISCF') THEN [CP].[PREMIUM] ELSE 0 END) AS [Partner Commission Discount]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('AGECOMMP','AGECOMMF') THEN [CP].[PREMIUM] ELSE 0 END) AS [Agent Commission]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('AGEDISCP','AGEDISCF') THEN [CP].[PREMIUM] ELSE 0 END) AS [Agent Commission Discount]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('SUBCOMMP','SUBCOMMF') THEN [CP].[PREMIUM] ELSE 0 END) AS [Sub-Agent Commission]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('SUBDISCP','SUBDISCF') THEN [CP].[PREMIUM] ELSE 0 END) AS [Sub-Agent Commission Discount]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('INTCOMMP') THEN [CP].[PREMIUM] ELSE 0 END) AS [Introducer Commission]
	   ,SUM(CASE WHEN [PREMIUM_TYPE_ID] IN ('%DISC%') THEN [CP].[PREMIUM] ELSE 0 END) AS [Discount]
	FROM
		[dbo].[CUSTOMER_PREMIUM] AS [CP]
		INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [CP].POLICY_DETAILS_ID = [CPD].[POLICY_DETAILS_ID] AND [CP].[HISTORY_ID] = [CPD].[HISTORY_ID]
	WHERE
		[CP].[POLICY_SECTION_ID] <> 'BUSUPREM' AND [CP].[INSURER_ID] = 'SAGIC'
	GROUP BY
		[CP].[POLICY_DETAILS_ID]
	   ,[CP].[HISTORY_ID]
),
[VehDetails] AS 
(
	SELECT
		 [CPD].[POLICY_DETAILS_ID]
		,[CPD].[HISTORY_ID] 
		,[UMPTV].[PRIMARYRISK_ID]
		,[UMPTV].[PUBLIABCOVER]
		,COUNT([UMV].[REGNUMBER]) AS [VehicleCount]
	FROM
		[dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] 
		INNER JOIN [dbo].[USER_MCOURIER_PTVINFO] AS [UMPTV] ON [CPD].[POLICY_DETAILS_ID] = [UMPTV].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [UMPTV].[HISTORY_ID]
		INNER JOIN [dbo].[USER_MCOURIER_VEHDTAIL] AS [UMV] ON [UMPTV].[MCOURIER_PTVINFO_ID] = [UMV].[MCOURIER_PTVINFO_ID] AND [UMPTV].[HISTORY_ID] = [UMV].[HISTORY_ID]
	GROUP BY
		 [CPD].[POLICY_DETAILS_ID]
		,[CPD].[HISTORY_ID]
		,[UMPTV].[PRIMARYRISK_ID]
		,[UMPTV].[PUBLIABCOVER]	   
)
,[Telephone] AS (
	SELECT
		ROW_NUMBER() OVER(PARTITION BY [INSURED_PARTY_ID], [HISTORY_ID] ORDER BY CASE WHEN [TELEPHONE_TYPE_ID] = '3AJPQ7C6' THEN 1 ELSE 9 END) AS [RowNum] -- Prioritise Mobile number
		,[INSURED_PARTY_ID]
		,[HISTORY_ID]
		,[TELEPHONENUMBER]
	FROM
		[dbo].[CUSTOMER_TELEPHONE]
)
SELECT
      [CPD].[POLICYNUMBER] AS [Policy Reference]
	 ,(CASE
		WHEN [RAL].[ActionType] = 2 THEN 'New Business'
		WHEN [RAL].[ActionType] = 3 THEN 'MTA - '+[ACC].[Type] /* Monday ticket 5324756740*/
		WHEN [RAL].[ActionType] = 4 THEN 'Cancellation'
		WHEN [RAL].[ActionType] = 47 THEN [ACC].[Type]
		WHEN [RAL].[ActionType] = 5 THEN 'Renewal'
		WHEN [RAL].[ActionType] = 51 THEN [ACC].[Type]
		WHEN [RAL].[ActionType] = 9 THEN 'New Business'
		ELSE '0'
	END) AS [Transaction Type]
	,NULL AS [Scheme Code]
    ,(CASE 
	     WHEN [CPD].[AGENT_ID] = '0F849A389DD4477CAF66BBCBECA49AA4' THEN [RA].[NAME]
		 ELSE [RA].[NAME]
	  END) AS [Retailer]
    , NULL AS [Scheme Name]
	, NULL AS [Insurer Reference Code]
	, NULL AS [U/W YOA]
	, FORMAT([RAL].[ACTIONDATE], 'dd/MM/yyyy') AS [Purchase Date] 
	, FORMAT([RAL].[POLICYSTARTDATE], 'dd/MM/yyyy') AS [Start Date] 
	,(CASE WHEN [RAL].[ActionType] = 4 THEN FORMAT([CPD].[CANCELLATIONDATE], 'dd/MM/yyyy')
	       WHEN [RAL].[ActionType] = 3 THEN FORMAT([CPD].[MTASTARTDATE], 'dd/MM/yyyy')
	       ELSE NULL
	  END) AS [Amendment Effective Date] 
	,FORMAT([CPD].[POLICYENDDATE],'dd/MM/yyyy') AS [End Date]
	,[LT].[TITLE_DEBUG] AS [Policy Holder Title]
	,CASE
		WHEN [LT].[TITLE_DEBUG] IS NOT NULL THEN LTRIM(RTRIM(ISNULL([CIP].[FORENAME],'')))
		ELSE NULL
	END AS [Policy Holder First Name]
	,CASE
		WHEN [LT].[TITLE_DEBUG] IS NOT NULL THEN LTRIM(RTRIM(ISNULL([CIP].[SURNAME],'')))
		ELSE NULL
	END AS [Policy Holder Last Name]
	,CASE
		WHEN [LT].[TITLE_DEBUG] IS NOT NULL THEN NULL
		ELSE LTRIM(RTRIM(ISNULL([CIP].[SURNAME],'')))
	END AS [Company/Business Name]
	,CASE
	    WHEN [CIP].[DOB] IS NOT NULL AND FORMAT([CIP].[DOB], 'dd/MM/yyyy') != '30/12/1899' THEN FORMAT([CIP].[DOB], 'dd/MM/yyyy')
		ELSE 'N/A'
	 END AS [Cusotmer Date of Birth]
	,[CCA].[HOUSE] AS [Customer Address Line 1]
	,[CCA].[STREET] AS [Customer Address Line 2]
	,[CCA].[LOCALITY] AS [Customer Address Line 3]
	,[CCA].[CITY] AS [Customer Address Line 4]
	,[CCA].[COUNTY] AS [Customer Address Line 5]
	,[CCA].[POSTCODE] AS [Customer Address Postcode]
	,[LMT].[MH_TRADE_DEBUG] AS [Customer Occupation]
	,[TEL].[TELEPHONENUMBER] AS [Customer Contact Number]
	,(CASE WHEN [CEDV].[Email] IS NOT NULL THEN [CEDV].[Email]
	       ELSE 'N/A'
	  END) AS [Customer Email Address]
	,[UMV].[VEHMAKE] AS [Vehicle Make]
	, NULL AS [Vehicle Model]
	,[UMV].[REGNUMBER] AS [Vehicle Registration Number]
	,NULL AS [Registered Date]
	,NULL AS [Vehicle Mileage]
	,NULL AS [Policy Term]
	/* Monday ticket 5324756740*/
	,ISNULL([LMHPL].[MH_PUBLIAB_DEBUG], '£0') AS [Public Liability Limit] /*[Aggregate Policy Limit (Cover Limit)]*/
	,(CASE
        /* /* Monday ticket 5324756740*/
	    WHEN [UMPTV].[PUBLIABCOVER] = 1 AND [UMPTV].[PUBLIABLIMIT_ID]='3MQQLQI7' THEN 'COURIER GOODS IN TRANSIT PL/EL (UPTO £5M TURNOVER)' /*(UPTO £5M PL)*/
		WHEN [UMPTV].[PUBLIABCOVER] = 1 AND [UMPTV].[PUBLIABLIMIT_ID]='3MQQLQI6' THEN 'COURIER GOODS IN TRANSIT PL/EL (UPTO £2M TURNOVER)' /*(UPTO £2M PL)*/
		WHEN [UMPTV].[PUBLIABCOVER] = 1 AND [UMPTV].[PUBLIABLIMIT_ID]='3MQQLQH9' THEN 'COURIER GOODS IN TRANSIT PL/EL (UPTO £1M TURNOVER)' /*(UPTO £1M PL)*/
		WHEN [UMPTV].[PUBLIABCOVER] = 0 AND [UMPTV].[PUBLIABLIMIT_ID]='0' THEN 'COURIER GOODS IN TRANSIT STANDALONE' /*'COURIER GOODS IN TRANSIT PL/EL STANDALONE'*/ */

		WHEN [VehDetails].[PUBLIABCOVER] = 1 THEN 'COURIER GOODS IN TRANSIT PL/EL (UPTO £2M TURNOVER)' 
		WHEN [VehDetails].[PUBLIABCOVER] = 0 THEN 'COURIER GOODS IN TRANSIT STANDALONE' 
	 END) AS [Business Class] 
	 ,NULL AS [Source (Route to Market)]
	 ,NULL AS [Are you a home owner? (Goods in transit only)]
	 ,NULL AS [Courier driving experience in years (Goods in transit only)]
	 ,NULL AS [Insured Address Line 1]
	 ,NULL AS [Insured Address Line 2]
	 ,NULL AS [Insured Address Line 3]
	 ,NULL AS [Insured Address Line 4]
	 ,NULL AS [Insured Address Line 5]
	 ,NULL AS [Insured Post Code]
	 ,CASE
		WHEN [RAL].[ActionType] = 4 THEN 'Change in customer''s Circumstances' 
		ELSE NULL
	END AS [Cancellation reason]
	,ISNULL([VSI].SumInsured1,0) AS [Spare 1]         /*  NULL AS [Spare 1]   Monday ticket 5324756740*/
	,NULL AS [Premium Payment Type]
	,NULL AS [Sales Method]
	/*(CASE
		WHEN [RAL].[ActionType] = 4 THEN -ABS([CPD].[PREMIUM])
		ELSE [CPD].[PREMIUM] /*- [CPD].[ADMINFEE]*/
	END) AS [Retail Price (inc IPT)]*/
	,(CASE
		WHEN [RAL].[ActionType] = 4 THEN -ABS(([ACC].[NET]+[ACC].[FEE]+[ACC].[TAX_IPT])/([VehDetails].VehicleCount))
		ELSE ([ACC].[NET]+[ACC].[FEE]+[ACC].[TAX_IPT])/([VehDetails].VehicleCount)
	END) AS [Retail Price (inc IPT)]
	,(CASE
		WHEN [RAL].[ActionType] = 4 THEN -ABS(([ACC].[NET]+[ACC].[FEE])/([VehDetails].VehicleCount))
		ELSE ([ACC].[NET]+[ACC].[FEE])/([VehDetails].VehicleCount)
	END) AS [Retail Price (ex IPT)]

	,(CASE WHEN [RAL].[ActionType] = 4  THEN -ABS(([ACC].[Partner Commission] + [ACC].[Sub-Agent Commission])/([VehDetails].VehicleCount))
	          ELSE ([ACC].[Partner Commission] + [ACC].[Sub-Agent Commission])/([VehDetails].VehicleCount)
	  END) AS [Commission]
	  /*(CASE WHEN [RAL].[ActionType] = 4 THEN -ABS([CPREMIUM].[NET]- ([CPREMIUM].[Partner Commission] + [CPREMIUM].[Sub-Agent Commission]))
	      ELSE ([CPREMIUM].[NET] - ([CPREMIUM].[Partner Commission] + [CPREMIUM].[Sub-Agent Commission]))
	  END)AS [Net Premium]*/
	,(CASE WHEN [RAL].[ActionType] = 4 THEN -ABS((([ACC].[NET]+[ACC].[FEE])- ([ACC].[Partner Commission] + [ACC].[Sub-Agent Commission]))/([VehDetails].VehicleCount))
	      ELSE (([ACC].[NET]+[ACC].[FEE])- ([ACC].[Partner Commission] + [ACC].[Sub-Agent Commission]))/([VehDetails].VehicleCount)
	  END)AS [Net Premium]
	,'12%' AS [IPT/TAX Rate]
	,(CASE WHEN [RAL].[ActionType] = 4 THEN -ABS(([ACC].[TAX_IPT])/([VehDetails].VehicleCount))
	       ELSE  [ACC].[TAX_IPT]/([VehDetails].VehicleCount)
	 END) AS [IPT]
	,'UK' AS [IPT Territory]
	/*(CASE
		WHEN [RAL].[ActionType] = 4 THEN -ABS([CPREMIUM].[NET]+[CPREMIUM].[TAX_IPT])
		ELSE [CPREMIUM].[NET]+[CPREMIUM].[TAX_IPT]
	 END) AS [Total Payable to UW]*/
	,(CASE
		WHEN [RAL].[ActionType] = 4 THEN -ABS(((([ACC].[NET]+[ACC].[FEE]+[ACC].[TAX_IPT]) - ([ACC].[Partner Commission] + [ACC].[Sub-Agent Commission])))/([VehDetails].VehicleCount))
		ELSE ((([ACC].[NET]+[ACC].[FEE]+[ACC].[TAX_IPT]) - ([ACC].[Partner Commission] + [ACC].[Sub-Agent Commission])))/([VehDetails].VehicleCount)
	 END) AS [Total Payable to UW]
FROM
	[dbo].[REPORT_ACTION_LOG] AS [RAL] 
		INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [RAL].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CPD].[HISTORY_ID]
			INNER JOIN [dbo].[SYSTEM_INSURER] AS [SI] ON [CPD].[INSURER_ID] = [SI].[INSURER_ID]
			INNER JOIN [dbo].[RM_AGENT] AS [RA] ON [CPD].[AGENT_ID] = [RA].[AGENT_ID]
			INNER JOIN [dbo].[CUSTOMER_POLICY_LINK] AS [CPL] ON [CPD].[POLICY_DETAILS_ID] = [CPL].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CPL].[POLICY_DETAILS_HISTORY_ID]
				INNER JOIN [dbo].[CUSTOMER_INSURED_PARTY] AS [CIP] ON [CIP].[INSURED_PARTY_ID] = [CPL].[INSURED_PARTY_ID] AND [CIP].[HISTORY_ID] = [CPL].[INSURED_PARTY_HISTORY_ID]
					INNER JOIN [dbo].[LIST_TITLE] AS [LT] ON [LT].[TITLE_ID] = [CIP].[TITLE_ID]
					INNER JOIN [dbo].[CUSTOMER_CLIENT_ADDRESS] AS [CCA] ON [CCA].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND	[CCA].[HISTORY_ID] = [CIP].[HISTORY_ID]
					LEFT JOIN [Telephone] AS [TEL] ON [TEL].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND [TEL].[HISTORY_ID] = [CIP].[HISTORY_ID]
																										  AND [TEL].[RowNum] = 1
			INNER JOIN [dbo].[CUSTOMER_EMAIL_DETAILS_VIEW] AS [CEDV] ON [CEDV].[Policy_Details_ID] = [CPD].[Policy_Details_ID] AND [CEDV].[HISTORY_ID] = [CPD].[HISTORY_ID]
			INNER JOIN [dbo].[USER_MCOURIER_PTVINFO] AS [UMPTV] ON [CPD].[POLICY_DETAILS_ID] = [UMPTV].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [UMPTV].[HISTORY_ID]
				LEFT JOIN [dbo].[LIST_MH_PUBLIAB] AS [LMHPL] ON [UMPTV].[PUBLIABLIMIT_ID] = [LMHPL].[MH_PUBLIAB_ID]
			INNER JOIN [dbo].[USER_MCOURIER_VEHDTAIL] AS [UMV] ON [UMPTV].[MCOURIER_PTVINFO_ID] = [UMV].[MCOURIER_PTVINFO_ID] AND [UMPTV].[HISTORY_ID] = [UMV].[HISTORY_ID]
			INNER JOIN [VehDetails] ON [VehDetails].POLICY_DETAILS_ID = [CPD].[POLICY_DETAILS_ID] AND [VehDetails].[HISTORY_ID] = [CPD].[HISTORY_ID]
				INNER JOIN [dbo].[LIST_MH_TRADE] AS[LMT] ON [VehDetails].[PRIMARYRISK_ID] = [LMT].[MH_TRADE_ID]
			OUTER APPLY [dbo].[tvfGetVehiclesSumInsured]([CPD].[POLICY_DETAILS_ID],[CPD].[HISTORY_ID]) AS [VSI]
			INNER JOIN [CPREMIUM] ON [CPREMIUM].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [CPREMIUM].[HISTORY_ID] = [CPD].[HISTORY_ID]
		INNER JOIN [Accounts] AS [ACC] ON [RAL].[POLICY_DETAILS_ID] = [ACC].[POLICY_DETAILS_ID] AND	[RAL].[HISTORY_ID] = [ACC].[POLICY_DETAILS_HISTORY_ID]
									   AND [RAL].[ACTIONTYPE] = [ACC].[ActionType]
WHERE
	[SI].[INSURER_DEBUG] = 'SAGIC' 
	AND [CEDV].[Type] <> 'Sub Agent' /* Monday ticket 5324756740*/ 
    AND	[RAL].[ACTIONDATE] BETWEEN @FromDate AND @ToDate
;

