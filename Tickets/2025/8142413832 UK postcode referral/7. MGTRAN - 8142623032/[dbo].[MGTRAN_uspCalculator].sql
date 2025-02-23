USE [Calculators]
GO
/****** Object:  StoredProcedure [dbo].[MGTRAN_uspCalculator]    Script Date: 21/01/2025 08:03:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
-- Author:		System Generated
-- Date:        04 Apr 2023
-- Description: Boiler plate for translating wpd variables and returns can be regenerated apart from LOB level refers etc..
*******************************************************************************
-- Date			Who					Changes
-- 02/01/2025   Linga				Monday Ticket 8142413832: UK postcode Referral 

*******************************************************************************/

ALTER PROCEDURE[dbo].[MGTRAN_uspCalculator]
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
    SELECT * FROM [Transactor_Live].[dbo].[uspSchemeCommandDebug] WHERE [uspSchemeCommandText] LIKE '%MGTRAN_uspCalculator%'

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

--PolicyStartDatetime
	IF @PolicyStartDateTime = cast(getdate() AS date)
		SET @PolicyStartDatetime = getdate()

--Risk Tables
	SET @RiskXML = REPLACE(REPLACE(cast(@RiskXML AS varchar(max)), '> ', '>'), ' <', '<');

	DECLARE @PolInfo MGTRAN_PolInfoTableType;
	INSERT INTO @PolInfo( [Trailers] ,[Trailers_ID] ,[TrailerCover] ,[VehiclesNum] ,[VehiclesNum_ID] ,[PrimaryRisk] ,[PrimaryRisk_ID] ,[CoverStart] ,[Insurer] ,[Insurer_ID])
    SELECT
		[LIST_MH_NUMTRLCOV1].[MH_NUMTRLCOV_Debug] AS [Trailers]
		,T.X.value('(./Trailers[text()])[1]', 'varchar(8)') AS [Trailers_ID]
		,ISNULL(T.X.value('(./TrailerCover[text()])[1]', 'bit'),0) AS [TrailerCover]
		,[LIST_MH_NUMVEHCOV1].[MH_NUMVEHCOV_Debug] AS [VehiclesNum]
		,T.X.value('(./VehiclesNum[text()])[1]', 'varchar(8)') AS [VehiclesNum_ID]
		,[LIST_MH_TRADE1].[MH_TRADE_Debug] AS [PrimaryRisk]
		,T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)') AS [PrimaryRisk_ID]
,CONVERT(datetime ,		T.X.value('(./CoverStart[text()])[1]', 'varchar(30)'),103) AS [CoverStart]
		,[System_Insurer1].[INSURER_Debug] AS [Insurer]
		,T.X.value('(./Insurer[text()])[1]', 'varchar(8)') AS [Insurer_ID]
	FROM
		@RiskXML.nodes('(//PolInfo)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_NUMTRLCOV] AS [LIST_MH_NUMTRLCOV1] ON [LIST_MH_NUMTRLCOV1].[MH_NUMTRLCOV_ID] = T.X.value('(./Trailers[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_NUMVEHCOV] AS [LIST_MH_NUMVEHCOV1] ON [LIST_MH_NUMVEHCOV1].[MH_NUMVEHCOV_ID] = T.X.value('(./VehiclesNum[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_TRADE] AS [LIST_MH_TRADE1] ON [LIST_MH_TRADE1].[MH_TRADE_ID] = T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)')
        JOIN [dbo].[System_Insurer] AS [System_Insurer1] ON [System_Insurer1].[INSURER_ID] = T.X.value('(./Insurer[text()])[1]', 'varchar(8)')

	DECLARE @VehDtail MGTRAN_VehDtailTableType;
	INSERT INTO @VehDtail( [VehModel] ,[VehMake] ,[ToolsPercent] ,[Limit] ,[Limit_ID] ,[RegNum])
    SELECT
		T.X.value('(./VehModel[text()])[1]', 'varchar(50)') AS [VehModel]
		,T.X.value('(./VehMake[text()])[1]', 'varchar(50)') AS [VehMake]
		,ISNULL(T.X.value('(./ToolsPercent[text()])[1]', 'money'),0) AS [ToolsPercent]
		,[LIST_MH_GDSLIMIT1].[MH_GDSLIMIT_Debug] AS [Limit]
		,T.X.value('(./Limit[text()])[1]', 'varchar(8)') AS [Limit_ID]
		,T.X.value('(./RegNum[text()])[1]', 'varchar(10)') AS [RegNum]
	FROM
		@RiskXML.nodes('(//VehDtail)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_GDSLIMIT] AS [LIST_MH_GDSLIMIT1] ON [LIST_MH_GDSLIMIT1].[MH_GDSLIMIT_ID] = T.X.value('(./Limit[text()])[1]', 'varchar(8)')

	DECLARE @TrlDtail MGTRAN_TrlDtailTableType;
	INSERT INTO @TrlDtail( [Value] ,[Description])
    SELECT
		ISNULL(T.X.value('(./Value[text()])[1]', 'money'),0) AS [Value]
		,T.X.value('(./Description[text()])[1]', 'varchar(50)') AS [Description]
	FROM
		@RiskXML.nodes('(//TrlDtail)') AS T(x) --Lookup table


-- Claim Detail
	DECLARE @ClmDtail MGTRAN_ClmDtailTableType;
	INSERT INTO @ClmDtail([Details], [Outstanding] , [Paid], [Date], [Type], [Type_ID] )
    SELECT
		T.X.value('(./Details[text()])[1]', 'varchar(500)') AS [Details]
		,ISNULL(T.X.value('(./Outstanding[text()])[1]', 'money'),0) AS [Outstanding]
		,ISNULL(T.X.value('(./Paid[text()])[1]', 'money'),0) AS [Paid]
		,CONVERT(datetime , T.X.value('(./Date[text()])[1]', 'varchar(30)'),103) AS [Date]
		,[LIST_MH_CLAIMTYPE1].MH_CLAIMTYPE_DEBUG AS [Type]
		,T.X.value('(./Type[text()])[1]', 'varchar(8)') AS [Type_ID]
	FROM
		@RiskXML.nodes('(//ClmDtail)') AS T(x) --Lookup table
		JOIN [dbo].[LIST_MH_CLAIMTYPE] AS [LIST_MH_CLAIMTYPE1] ON [LIST_MH_CLAIMTYPE1]. MH_CLAIMTYPE_ID = T.X.value('(./Type[text()])[1]', 'varchar(8)')

-- Claim Summary

   	DECLARE @ClmSum MGTRAN_ClmSumTableType;
	INSERT INTO @ClmSum([Incidents])
    SELECT
		T.X.value('(./Incidents[text()])[1]', 'bit') AS [Incidents]
	FROM
		@RiskXML.nodes('(//ClmSum)') AS T(x) --Lookup table

--Assumptions
	
   	DECLARE @Assump MGTRAN_AssumpTableType;
	INSERT INTO @Assump ( [Convictions], [Convictions_ID], [Bankrupt] , [Bankrupt_ID], [Declined], [Declined_ID], [Aspestos], [Aspestos_ID], [PowerStations], [PowerStations_ID], [Aircraft], [Aircraft_ID] )
    SELECT
	    [LIST_MH_ASSUMPT1].MH_ASSUMPT_DEBUG AS [Convictions]
		,T.X.value('(./Convictions[text()])[1]', 'varchar(8)') AS [Convictions_ID]
		,[LIST_MH_ASSUMPT2].MH_ASSUMPT_DEBUG AS [Bankrupt]
		,T.X.value('(./Bankrupt[text()])[1]', 'varchar(8)') AS [Bankrupt_ID]
		,[LIST_MH_ASSUMPT3].MH_ASSUMPT_DEBUG AS [Declined]
		,T.X.value('(./Declined[text()])[1]', 'varchar(8)') AS [Declined_ID]
		,[LIST_MH_ASSUMPT4].MH_ASSUMPT_DEBUG AS [Aspestos]
		,T.X.value('(./Aspestos[text()])[1]', 'varchar(8)') AS [Aspestos_ID]
		,[LIST_MH_ASSUMPT5].MH_ASSUMPT_DEBUG AS [PowerStations]
		,T.X.value('(./PowerStations[text()])[1]', 'varchar(8)') AS [PowerStations_ID]
		,[LIST_MH_ASSUMPT6].MH_ASSUMPT_DEBUG AS [Aircraft]
		,T.X.value('(./Aircraft[text()])[1]', 'varchar(8)') AS [Aircraft_ID]

	FROM
		@RiskXML.nodes('(//Assump)') AS T(x) --Lookup table
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT1] ON [LIST_MH_ASSUMPT1].MH_ASSUMPT_ID = T.X.value('(./Convictions[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT2] ON [LIST_MH_ASSUMPT2].MH_ASSUMPT_ID = T.X.value('(./Bankrupt[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT3] ON [LIST_MH_ASSUMPT3].MH_ASSUMPT_ID = T.X.value('(./Declined[text()])[1]', 'varchar(8)') 
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT4] ON [LIST_MH_ASSUMPT4].MH_ASSUMPT_ID = T.X.value('(./Aspestos[text()])[1]', 'varchar(8)') 
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT5] ON [LIST_MH_ASSUMPT5].MH_ASSUMPT_ID = T.X.value('(./PowerStations[text()])[1]', 'varchar(8)') 
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT6] ON [LIST_MH_ASSUMPT6].MH_ASSUMPT_ID = T.X.value('(./Aircraft[text()])[1]', 'varchar(8)')

	DECLARE @SchemeInsurer varchar(1000) = (SELECT [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)

--AgentID
	DECLARE @AgentID char(32) = (SELECT [Agent_ID] FROM [RM_Agent] WHERE [Name] = @AgentName)


--Refers
	--Insurer 
	--IF (SELECT CASE WHEN @PolicyQuoteStage = 'NB' AND [C].[Insurer] = @SchemeInsurer THEN 1 ELSE 0 END FROM {TableWithInsurerID} AS [C]) = 1
			--INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)

	--Assumptions	
	INSERT INTO @Refer([Message])
	SELECT [Message] FROM [dbo].[MGTRAN_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);

--Declines
	-- Decline invalid postcode (8142413832)
    IF([dbo].[svfValidateUKPostcode](@PostCode) = 0)
	        INSERT INTO @Decline VALUES ('Invalid Postcode');


--Debugging
	IF @OutputRisk = 1
	BEGIN
		SELECT * FROM @PolInfo;
		SELECT * FROM @VehDtail;
		SELECT * FROM @TrlDtail;
		SELECT * FROM @ClmDtail;
		SELECT * FROM @ClmSum
		SELECT * FROM @Assump

		
		SELECT [Message] FROM [dbo].[MGTRAN_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);
		SELECT @PolicyStartDateTime AS [PolicyStartDateTime] ,@PolicyQuoteStage AS [PolicyQuoteStage] ,@PostCode AS [Postcode] ,@SchemeTableID AS [SchemeTableID] ,@SchemeInsurer AS [SchemeInsurer]
	END	

--MGTRAN_tvfSchemeDispatcher
	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM [dbo].[MGTRAN_tvfSchemeDispatcher] (@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode, @PolInfo, @VehDtail ,@TrlDtail, @ClmDtail, @ClmSum, @Assump) FOR XML PATH(''))
 

--Shred Scheme results
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



--Table Counts
	DECLARE @ReferCount int = (SELECT COUNT(*) FROM @Refer)
	DECLARE @DeclineCount int = (SELECT COUNT(*) FROM @Decline)

--Summary
	INSERT INTO @Summary([Message])	VALUES(	'Quote Date :' + CONVERT(varchar(11) ,GETDATE(),106))
	INSERT INTO @Summary([Message])	VALUES(	'Quote is valid for 30 days' )

--Product Details		
	--DECLARE @ExampleVariable int 
	--INSERT INTO @ProductDetail([Message])	VALUES(	'Example Message = '+ [dbo].[svfFormatMoneyString](@ExampleVariable))

--Return Values
	DECLARE @Endorsements varchar(255) 
	SELECT 
		@Endorsements = COALESCE(@Endorsements + ',','') + [Message] 
	FROM 
		@Endorsement


	--SELECT * FROM @Premium2
	EXECUTE [dbo].[uspSchemeResults] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium ,@Endorsement
END	

