USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [Moorhouse].[uspGetMultipleCustomerQuotesPoliciesByPolicyId]    Script Date: 04/02/2025 12:46:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		Jeremai Smith, Sonny lloyd
-- Create date: 27/08/2020
-- Description: Returns all quotes and policies for a list of Insured IDs(based on [Moorhouse].[uspGetMultipleCustomerQuotesPoliciesByPolicyId])
-- =============================================
-- Updated by:	Adam Copner
-- Date:		18/01/2024
-- Description: If the status of the policy is Renewal Requested (3AJPUL79) then the premium excludes the admin fee
-- =============================================

ALTER PROCEDURE [Moorhouse].[uspGetMultipleCustomerQuotesPoliciesByPolicyId] (
	 @InsuredPartyIDs varchar(MAX)
	,@AgentIDs varchar(MAX)
	,@PolicyStatusIDs varchar(MAX)
	,@PolicyID varchar(MAX)
	,@PolicyHID int = null
)

/*

DECLARE	@InsuredPartyIDs varchar(MAX)
DECLARE @AgentIDs varchar(MAX)
DECLARE @PolicyStatusIDs varchar(MAX)
DECLARE @PolicyID varchar(MAX)
DECLARE @PolicyHID int

SET @InsuredPartyIDs = '05D78C0049DE41D6856373B497B95793'
SET @AgentIDs = 'E2F376B621E14C1FB532CED74C7EDCE1,5208F39A498E4706A91BEEC84ED25686' -- Constructaquote, Constructaquote.com
SET @PolicyStatusIDs = '3AJPUL66,3AJPUL60,3AJPUL67,3AU9IQ25,3AJPUL68,3AJPUL69,3AJPUL75,3AJPUL76,3AJPUL77,3F9246U1' -- Internet Quote, Policy, Prospect, Automatic Decline, Manual Decline, Automatic Refer, Manual Refer, Client Decline, Incomplete
SET @PolicyID = 'MMATL1076368'
SET @PolicyHID = 3
EXEC [Moorhouse].[uspGetMultipleCustomerQuotesPoliciesByPolicyId] @InsuredPartyIDs, @AgentIDs, @PolicyStatusIDs, @PolicyID, @PolicyHID

*/

AS

INSERT INTO [dbo].AdamTest(InsuredPartyIDs, AgentIDs, PolicyStatusIDs, PolicyID, PolicyHID)
VALUES(@InsuredPartyIDs, @AgentIDs, @PolicyStatusIDs, @PolicyID, @PolicyHID)

SELECT
	 [CPD].[POLICY_DETAILS_ID]
	,[CPD].[HISTORY_ID]
	,[CPL].[INSURED_PARTY_ID]
	,[CPL].[INSURED_PARTY_HISTORY_ID]
	,[CPD].[PRODUCT_ID]
	,[CPD].[POLICY_STATUS_ID]
	,[LPS].[POLICY_STATUS_DEBUG]
	,CONVERT(VARCHAR, [CREATEDDATE], 103) AS [CREATEDDATE]
	,CONVERT(VARCHAR, [POLICYSTARTDATE], 103) AS [STARTDATE]
	,[PREMIUMINCAPR]
	,CASE WHEN [CPD].[POLICY_STATUS_ID] = '3AJPUL79'
	THEN (SELECT SUM([PREMIUM]) FROM [CUSTOMER_PREMIUM]
	  WHERE (POLICY_DETAILS_ID = CPD.POLICY_DETAILS_ID AND HISTORY_ID = CPD.HISTORY_ID) 
	  AND (PREMIUM_TYPE_ID = 'NET'
		   OR PREMIUM_TYPE_ID LIKE '%DISC%' 
		   OR PREMIUM_SECTION_ID LIKE 'TAX%')
	 )
	ELSE [PREMIUM]
	END AS [PREMIUM]
	,(SELECT SUM([PREMIUM]) FROM [CUSTOMER_PREMIUM]
	  WHERE (POLICY_DETAILS_ID = CPD.POLICY_DETAILS_ID AND HISTORY_ID = CPD.HISTORY_ID) 
	  AND (PREMIUM_TYPE_ID = 'NET'
		   OR PREMIUM_TYPE_ID LIKE '%DISC%' 
		   OR PREMIUM_SECTION_ID LIKE 'TAX%')
	 ) + [CPD].[ADMINFEE] AS [SUMMARYPREMIUM]
	,[CPD].[POLICYNUMBER]
	,[CPD].[CURRENCY_ID]
	,[SAC].[CODE]
	,[SAC].[CURRENCY_FORMAT]
	,ISNULL([SCHEMENAME],'') + ' - ' + ISNULL([INSURER_DEBUG],'') AS [SCHEMEINSURER]
	,ISNULL([SCHEMENAME],'') AS [SCHEMENAME]
	,ISNULL([INSURER_DEBUG],'') AS [INSURER]
	,[CPD].[SCHEMETABLE_ID]
	,[SRP].[PRODUCTTYPE_ID] AS [PRODUCTTYPE]
	,[SSP].[FULLNAME] AS [CREATEDBY]
	,[CPD].[MARKETINGREFERENCE]
	,[CPD].[AGENT_ID]
	,[CPD].[INSURER_ID]
	,[RP].[NAME] AS [PRODUCTNAME]
	,[CPD].[POLICY_DETAILS_ID] + '-' + CAST([CPD].[HISTORY_ID] as varchar(10)) AS [UNIQUE_ID]
FROM 
	[dbo].[CUSTOMER_INSURED_PARTY] AS [CIP] WITH(NOLOCK)
	INNER JOIN [dbo].[CUSTOMER_POLICY_LINK] AS [CPL] WITH(NOLOCK) ON [CPL].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND [CPL].[INSURED_PARTY_HISTORY_ID] = [CIP].[HISTORY_ID]
	INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] WITH(NOLOCK) ON [CPL].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [CPL].[POLICY_DETAILS_HISTORY_ID] = [CPD].[HISTORY_ID]
	INNER JOIN [dbo].[tvfSplitStringByDelimiter] (@InsuredPartyIDs, ',') AS [INS] ON [CIP].[INSURED_PARTY_ID] = [INS].[Data]
	INNER JOIN [dbo].[tvfSplitStringByDelimiter] (@AgentIDs, ',') AS [A] ON [CPD].[AGENT_ID] = [A].[Data]
	INNER JOIN [dbo].[tvfSplitStringByDelimiter] (@PolicyStatusIDs, ',') AS [PS] ON [CPD].[POLICY_STATUS_ID] = [PS].[Data]
	INNER JOIN [dbo].[RM_PRODUCT_BY_AGENT] AS [SRP] WITH(NOLOCK) ON [SRP].[PRODUCT_ID] = [CPD].[PRODUCT_ID] AND [SRP].[AGENT_ID] = [CPD].[AGENT_ID]
	INNER JOIN [dbo].[SYSTEM_ACCOUNTS_CURRENCY] AS [SAC] WITH(NOLOCK) ON [SAC].[CURRENCY_ID] = [CPD].[CURRENCY_ID]
	LEFT JOIN [dbo].[SYSTEM_INSURER] AS [SI] WITH(NOLOCK) ON [SI].[INSURER_ID] = [CPD].[INSURER_ID]
	LEFT JOIN [dbo].[LIST_POLICY_STATUS] AS [LPS] WITH(NOLOCK) ON [LPS].[POLICY_STATUS_ID] = [CPD].[POLICY_STATUS_ID]
	LEFT JOIN [dbo].[SYSTEM_SCHEME_NAME] AS [SRS] WITH(NOLOCK) ON [SRS].[SCHEMETABLE_ID] = [CPD].[SCHEMETABLE_ID] AND [SRS].[PRODUCTTYPE] = [SRP].[PRODUCTTYPE_ID]
	LEFT JOIN [dbo].[SYSTEM_SECURITY_PROFILE] AS [SSP] WITH(NOLOCK)	ON [SSP].[PROFILE_ID] = [CPD].[CREATEDBY]
	LEFT JOIN [dbo].[RM_PRODUCT] AS [RP] WITH(NOLOCK) ON [RP].[PRODUCTTYPE_ID] = [SRP].[PRODUCTTYPE_ID]
WHERE
	[CPD].[PURGEDYN] = 0
AND 
	[CPD].[POLICYNUMBER] = (@PolicyID)
AND 
	(@PolicyHID IS NULL OR @PolicyHID = [CPD].[HISTORY_ID])
AND
	(
		--AXA
		[CPD].[INSURER_ID] NOT IN ('209', '236', '240', '7', 'AXAL')
	OR
		--Renewal Invited
		[CPD].[POLICY_STATUS_ID] != '3AJPUL79'
	)