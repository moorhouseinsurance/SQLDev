USE [Calculators]
GO
/****** Object:  StoredProcedure [dbo].[MDO_uspCalculator]    Script Date: 07/01/2025 08:25:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		System Generated
-- Date:        25 Jul 2024
-- Description: Boiler plate for translating wpd variables and returns can be regenerated apart from LOB level refers etc..
*******************************************************************************
-- Date			Who						Change

-- 02/01/2025   Linga					Monday Ticket 8142413832: UK postcode Referral

*******************************************************************************/

ALTER PROCEDURE [dbo].[MDO_uspCalculator]
	 @RiskXML XML
    ,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
    ,@SchemeTableID int
	,@AgentName varchar(255)
    ,@SubAgentID char(32)
	,@OutputRisk bit = 0
AS
/*

    TRUNCATE TABLE [Transactor_Live].[dbo].[uspSchemeCommandDebug]
    SELECT * FROM [Transactor_Live].[dbo].[uspSchemeCommandDebug] WHERE [uspSchemeCommandText] LIKE '%MDO_uspCalculator%'

	CREATE TABLE RiskXML (RiskXML xml);
	INSERT INTO RiskXML(RiskXML) values(@RiskXML);
*/

BEGIN
    SET NOCOUNT ON

	DECLARE  @Refer SchemeResultTableType
			,@Decline SchemeResultTableType
			,@Excess SchemeResultTableType
			,@Summary SchemeResultTableType
			,@Breakdown SchemeResultTableType
			,@ProductDetail SchemeResultTableType	
			,@Premium SchemeResultPremiumTableType
			,@Premium2 SchemeResultPremiumTableType
			,@Endorsement SchemeResultEndorsementTableType	

	-- PolicyStartDatetime:
	
	IF @PolicyStartDateTime = cast(getdate() AS date)
		SET @PolicyStartDatetime = getdate()

	
	-- Risk Tables:

	SET @RiskXML = CAST(REPLACE(REPLACE(cast(@RiskXML AS varchar(max)), '> ', '>'), ' <', '<') AS xml);

	DECLARE @DircOffi [dbo].[MDO_DircOffiTableType];
	INSERT INTO @DircOffi 
	([RiskTrade] 
	,[CoverType] 
	,[CoverType_ID] 
	,[USATurnoverYN] 
	,[USAAssetsYN] 
	,[BizSectorsYN] 
	,[CompRegNum] 
	,[RetroactiveDate] 
	,[RetroactiveYN] 
	,[DOInsuranceYN] 
	,[IncDate] 
	,[anualturn] 
	,[coverlevel] 
	,[coverlevel_ID] 
	,[typecomp] 
	,[typecomp_ID])
    SELECT
		T.X.value('(./RiskTrade[text()])[1]', 'varchar(200)') AS [RiskTrade]
		,[LIST_MH_COVER1].[MH_COVER_Debug] AS [CoverType]
		,T.X.value('(./CoverType[text()])[1]', 'varchar(8)') AS [CoverType_ID]
		,ISNULL(T.X.value('(./USATurnoverYN[text()])[1]', 'bit'),0) AS [USATurnoverYN]
		,ISNULL(T.X.value('(./USAAssetsYN[text()])[1]', 'bit'),0) AS [USAAssetsYN]
		,ISNULL(T.X.value('(./BizSectorsYN[text()])[1]', 'bit'),0) AS [BizSectorsYN]
		,T.X.value('(./CompRegNum[text()])[1]', 'varchar(20)') AS [CompRegNum]
,CONVERT(datetime ,		T.X.value('(./RetroactiveDate[text()])[1]', 'varchar(30)'),103) AS [RetroactiveDate]
		,ISNULL(T.X.value('(./RetroactiveYN[text()])[1]', 'bit'),0) AS [RetroactiveYN]
		,ISNULL(T.X.value('(./DOInsuranceYN[text()])[1]', 'bit'),0) AS [DOInsuranceYN]
,CONVERT(datetime ,		T.X.value('(./IncDate[text()])[1]', 'varchar(30)'),103) AS [IncDate]
		,ISNULL(T.X.value('(./anualturn[text()])[1]', 'money'),0) AS [anualturn]
		,[LIST_MH_COVERLEVEL1].[MH_COVERLEVEL_Debug] AS [coverlevel]
		,T.X.value('(./coverlevel[text()])[1]', 'varchar(8)') AS [coverlevel_ID]
		,[LIST_MH_COMPANYTYPE1].[MH_COMPANYTYPE_Debug] AS [typecomp]
		,T.X.value('(./typecomp[text()])[1]', 'varchar(8)') AS [typecomp_ID]
	FROM
		@RiskXML.nodes('(//DircOffi)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_COVER] AS [LIST_MH_COVER1] ON [LIST_MH_COVER1].[MH_COVER_ID] = T.X.value('(./CoverType[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_COVERLEVEL] AS [LIST_MH_COVERLEVEL1] ON [LIST_MH_COVERLEVEL1].[MH_COVERLEVEL_ID] = T.X.value('(./coverlevel[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_COMPANYTYPE] AS [LIST_MH_COMPANYTYPE1] ON [LIST_MH_COMPANYTYPE1].[MH_COMPANYTYPE_ID] = T.X.value('(./typecomp[text()])[1]', 'varchar(8)')



	DECLARE @Assumpt MDO_AssumptTableType;
	INSERT INTO @Assumpt( [NetWorth] ,[NetWorth_ID] ,[NetProfit] ,[NetProfit_ID] ,[Litigation] ,[Litigation_ID] ,[Convicted] ,[Convicted_ID] ,[Bankrupt] ,[Bankrupt_ID] ,[Subsidiary] ,[Subsidiary_ID] ,[Refused] ,[Refused_ID] ,[Acquisition] ,[Acquisition_ID] ,[Circumstances] ,[Circumstances_ID] ,[Disqualified] ,[Disqualified_ID])
    SELECT
		[LIST_MH_ASSUMPT1].[MH_ASSUMPT_Debug] AS [NetWorth]
		,T.X.value('(./NetWorth[text()])[1]', 'varchar(8)') AS [NetWorth_ID]
		,[LIST_MH_ASSUMPT2].[MH_ASSUMPT_Debug] AS [NetProfit]
		,T.X.value('(./NetProfit[text()])[1]', 'varchar(8)') AS [NetProfit_ID]
		,[LIST_MH_ASSUMPT3].[MH_ASSUMPT_Debug] AS [Litigation]
		,T.X.value('(./Litigation[text()])[1]', 'varchar(8)') AS [Litigation_ID]
		,[LIST_MH_ASSUMPT4].[MH_ASSUMPT_Debug] AS [Convicted]
		,T.X.value('(./Convicted[text()])[1]', 'varchar(8)') AS [Convicted_ID]
		,[LIST_MH_ASSUMPT5].[MH_ASSUMPT_Debug] AS [Bankrupt]
		,T.X.value('(./Bankrupt[text()])[1]', 'varchar(8)') AS [Bankrupt_ID]
		,[LIST_MH_ASSUMPT6].[MH_ASSUMPT_Debug] AS [Subsidiary]
		,T.X.value('(./Subsidiary[text()])[1]', 'varchar(8)') AS [Subsidiary_ID]
		,[LIST_MH_ASSUMPT7].[MH_ASSUMPT_Debug] AS [Refused]
		,T.X.value('(./Refused[text()])[1]', 'varchar(8)') AS [Refused_ID]
		,[LIST_MH_ASSUMPT8].[MH_ASSUMPT_Debug] AS [Acquisition]
		,T.X.value('(./Acquisition[text()])[1]', 'varchar(8)') AS [Acquisition_ID]
		,[LIST_MH_ASSUMPT9].[MH_ASSUMPT_Debug] AS [Circumstances]
		,T.X.value('(./Circumstances[text()])[1]', 'varchar(8)') AS [Circumstances_ID]
		,[LIST_MH_ASSUMPT10].[MH_ASSUMPT_Debug] AS [Disqualified]
		,T.X.value('(./Disqualified[text()])[1]', 'varchar(8)') AS [Disqualified_ID]
	FROM
		@RiskXML.nodes('(//Assumpt)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT1] ON [LIST_MH_ASSUMPT1].[MH_ASSUMPT_ID] = T.X.value('(./NetWorth[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT2] ON [LIST_MH_ASSUMPT2].[MH_ASSUMPT_ID] = T.X.value('(./NetProfit[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT3] ON [LIST_MH_ASSUMPT3].[MH_ASSUMPT_ID] = T.X.value('(./Litigation[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT4] ON [LIST_MH_ASSUMPT4].[MH_ASSUMPT_ID] = T.X.value('(./Convicted[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT5] ON [LIST_MH_ASSUMPT5].[MH_ASSUMPT_ID] = T.X.value('(./Bankrupt[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT6] ON [LIST_MH_ASSUMPT6].[MH_ASSUMPT_ID] = T.X.value('(./Subsidiary[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT7] ON [LIST_MH_ASSUMPT7].[MH_ASSUMPT_ID] = T.X.value('(./Refused[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT8] ON [LIST_MH_ASSUMPT8].[MH_ASSUMPT_ID] = T.X.value('(./Acquisition[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT9] ON [LIST_MH_ASSUMPT9].[MH_ASSUMPT_ID] = T.X.value('(./Circumstances[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT10] ON [LIST_MH_ASSUMPT10].[MH_ASSUMPT_ID] = T.X.value('(./Disqualified[text()])[1]', 'varchar(8)')


	DECLARE @SchemeInsurer varchar(1000) = (SELECT [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)

	-- AgentID:
	DECLARE @AgentID char(32) = (SELECT [Agent_ID] FROM [RM_Agent] WHERE [Name] = @AgentName)

	
	-- Claims:
	DECLARE @ClaimsSummary [dbo].[MDO_ClaimSummaryTableType]
    INSERT INTO @ClaimsSummary
	SELECT * FROM [dbo].[MDO_tvfClaimSummary](@RiskXML.query('./ClmSum'), @PolicyStartDateTime )
	--SELECT * FROM [dbo].[tvfClaimSummary](@RiskXML.query('./ClmSum'), @PolicyStartDateTime )

	
	-- Employees:
	--DECLARE @EmployeeCounts EmployeeCountsTableType

	-- Refers:

	--Insurer 
	--IF (SELECT CASE WHEN @PolicyQuoteStage = 'NB' AND [C].[Insurer] = @SchemeInsurer THEN 1 ELSE 0 END FROM {TableWithInsurerID} AS [C]) = 1
			--INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)

	-- Assumptions:	
	INSERT INTO @Refer([Message])
	SELECT [Message] FROM [dbo].[MDO_tvfReferredAssumptions](@RiskXML.query('./Assumpt'), @PolicyStartDateTime);

	-- Declines

	-- Decline invalid postcode (8142413832)
    IF([dbo].[svfValidateUKPostcode](@PostCode) = 0)
	        INSERT INTO @Decline VALUES ('Invalid Postcode');

	-- Debugging:
	
IF @OutputRisk = 1
	BEGIN
		SELECT * FROM @DircOffi;
		SELECT * FROM @Assumpt;
		SELECT * FROM @ClaimsSummary
		SELECT [Message] FROM [dbo].[MDO_tvfReferredAssumptions](@RiskXML.query('./Assumpt') ,@PolicyStartDateTime);
		SELECT @PolicyStartDateTime AS [PolicyStartDateTime] ,@PolicyQuoteStage AS [PolicyQuoteStage] ,@PostCode AS [Postcode] ,@SchemeTableID AS [SchemeTableID] ,@SchemeInsurer AS [SchemeInsurer]
	END	


	--MDO_tvfSchemeDispatcher:

	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM [dbo].[MDO_tvfSchemeDispatcher] (@SchemeTableID, @PolicyStartDateTime, @PolicyQuoteStage, @PostCode, @AgentID, @ClaimsSummary, @DircOffi) FOR XML PATH(''))
 

	-- Shred Scheme results:

	INSERT INTO @Decline
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(2000)') FROM @SchemeResultsXML.nodes('(//Decline)') AS T(x) 

	INSERT INTO @Refer
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(2000)') FROM @SchemeResultsXML.nodes('(//Refer)') AS T(x) 

	INSERT INTO @ProductDetail
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//ProductDetail)') AS T(x) 

	INSERT INTO @Breakdown
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Breakdown)') AS T(x) 

	INSERT INTO @Excess
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Excess)') AS T(x) 

	INSERT INTO @Summary
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Summary)') AS T(x) 

	INSERT INTO @Endorsement
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(50)') FROM @SchemeResultsXML.nodes('(//Endorsement)') AS T(x) 

	INSERT INTO @Premium ([Name] ,[Value] ,[PartnerCommission] ,[AgentCommission] ,[SubAgentCommission])
	SELECT	T.X.value('(./Name[text()])[1]', 'varchar(20)'),T.X.value('(./Value[text()])[1]', 'money'),0,0,0 FROM @SchemeResultsXML.nodes('(//Premium)') AS T(x) 

	
	-- Table Counts:

	DECLARE @ReferCount int = (SELECT COUNT(*) FROM @Refer)
	DECLARE @DeclineCount int = (SELECT COUNT(*) FROM @Decline)

	
	-- Summary:

	INSERT INTO @Summary([Message])	VALUES(	'Quote Date :' + CONVERT(varchar(11) ,GETDATE(),106))
	INSERT INTO @Summary([Message])	VALUES(	'Quote is valid for 30 days' )

	
	-- Product Details:
	
	--DECLARE @ExampleVariable int 
	--INSERT INTO @ProductDetail([Message])	VALUES(	'Example Message = '+ [dbo].[svfFormatMoneyString](@ExampleVariable))


	-- Endorsements:
	
	DECLARE @Endorsements varchar(255) 
	SELECT 
		@Endorsements = COALESCE(@Endorsements + ',','') + [Message] 
	FROM 
		@Endorsement


	EXECUTE [dbo].[uspSchemeResults] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium ,@Endorsement
END	

