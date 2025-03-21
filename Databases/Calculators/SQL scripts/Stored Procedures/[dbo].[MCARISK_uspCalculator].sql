USE [Calculators]
GO
/****** Object:  StoredProcedure [dbo].[MCARISK_uspCalculator]    Script Date: 07/01/2025 08:46:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		System Generated
-- Date:        18 Oct 2023
-- Description: Boiler plate for translating wpd variables and returns can be regenerated apart from LOB level refers etc..
*******************************************************************************
-- Date			Who					Changes
-- 09/07/2024	Linga		        Monday ticket 6988243306 : Added update premium section to add pound if premium values ​​are zero
-- 02/01/2025   Linga				Monday Ticket 8142413832: UK postcode Referral
*******************************************************************************/
ALTER PROCEDURE[dbo].[MCARISK_uspCalculator]
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

    TRUNCATE TABLE [Transactor_Live].[dbo].[SchemeCommandDebug]
    SELECT * FROM [Transactor_Live].[dbo].[SchemeCommandDebug] WHERE [SchemeCommandText] LIKE '%MCARISK_uspCalculator%'

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

	DECLARE @TCCInfo MCARISK_TCCInfoTableType;
	INSERT INTO @TCCInfo( [HiredPlantYN] ,[EmptoolsMaxVal] ,[ValueHiredPlant] ,[EmpTools] ,[EmpToolsCover] ,[HiredPlant] ,[HireCharges] ,[ToolsValue] ,[Tools] ,[MaterialsValue] ,[ContractWorks] ,[maxHeight] ,[maxHeight_ID] ,[ContractLength] ,[TwelveMonth] ,[maxDepth] ,[maxDepth_ID] ,[Turnover] ,[ManualWorkers] ,[ManualWorkers_ID] ,[PandPNum] ,[CompStatus] ,[CompStatus_ID] ,[CovStart] ,[Insurer] ,[Insurer_ID] ,[SecondaryRisk] ,[SecondaryRisk_ID] ,[PrimaryRisk] ,[PrimaryRisk_ID])
    SELECT
		ISNULL(T.X.value('(./HiredPlantYN[text()])[1]', 'bit'),0) AS [HiredPlantYN]
		,ISNULL(T.X.value('(./EmptoolsMaxVal[text()])[1]', 'money'),0) AS [EmptoolsMaxVal]
		,ISNULL(T.X.value('(./ValueHiredPlant[text()])[1]', 'money'),0) AS [ValueHiredPlant]
		,ISNULL(T.X.value('(./EmpTools[text()])[1]', 'money'),0) AS [EmpTools]
		,ISNULL(T.X.value('(./EmpToolsCover[text()])[1]', 'bit'),0) AS [EmpToolsCover]
		,ISNULL(T.X.value('(./HiredPlant[text()])[1]', 'money'),0) AS [HiredPlant]
		,ISNULL(T.X.value('(./HireCharges[text()])[1]', 'money'),0) AS [HireCharges]
		,ISNULL(T.X.value('(./ToolsValue[text()])[1]', 'money'),0) AS [ToolsValue]
		,ISNULL(T.X.value('(./Tools[text()])[1]', 'bit'),0) AS [Tools]
		,ISNULL(T.X.value('(./MaterialsValue[text()])[1]', 'money'),0) AS [MaterialsValue]
		,ISNULL(T.X.value('(./ContractWorks[text()])[1]', 'bit'),0) AS [ContractWorks]
		,[LIST_MH_MAXHEIGHT1].[MH_MAXHEIGHT_Debug] AS [maxHeight]
		,T.X.value('(./maxHeight[text()])[1]', 'varchar(8)') AS [maxHeight_ID]
		,T.X.value('(./ContractLength[text()])[1]', 'varchar(2)') AS [ContractLength]
		,ISNULL(T.X.value('(./TwelveMonth[text()])[1]', 'bit'),0) AS [TwelveMonth]
		,[LIST_MH_MAXDEPTH1].[MH_MAXDEPTH_Debug] AS [maxDepth]
		,T.X.value('(./maxDepth[text()])[1]', 'varchar(8)') AS [maxDepth_ID]
		,ISNULL(T.X.value('(./Turnover[text()])[1]', 'money'),0) AS [Turnover]
		,[LIST_MH_NUMMANUAL1].[MH_NUMMANUAL_Debug] AS [ManualWorkers]
		,T.X.value('(./ManualWorkers[text()])[1]', 'varchar(8)') AS [ManualWorkers_ID]
		,ISNULL(T.X.value('(./PandPNum[text()])[1]', 'money'),0) AS [PandPNum]
		,[LIST_MH_COSTATUS1].[MH_COSTATUS_Debug] AS [CompStatus]
		,T.X.value('(./CompStatus[text()])[1]', 'varchar(8)') AS [CompStatus_ID]
		,CONVERT(datetime ,		T.X.value('(./CovStart[text()])[1]', 'varchar(30)'),103) AS [CovStart]
		,[System_Insurer1].[INSURER_Debug] AS [Insurer]
		,T.X.value('(./Insurer[text()])[1]', 'varchar(8)') AS [Insurer_ID]
		,[LIST_MH_TRADE1].[MH_TRADE_Debug] AS [SecondaryRisk]
		,T.X.value('(./SecondaryRisk[text()])[1]', 'varchar(8)') AS [SecondaryRisk_ID]
		,[LIST_MH_TRADE2].[MH_TRADE_Debug] AS [PrimaryRisk]
		,T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)') AS [PrimaryRisk_ID]
	FROM
		@RiskXML.nodes('(//TCCInfo)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_MAXHEIGHT] AS [LIST_MH_MAXHEIGHT1] ON [LIST_MH_MAXHEIGHT1].[MH_MAXHEIGHT_ID] = T.X.value('(./maxHeight[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_MAXDEPTH] AS [LIST_MH_MAXDEPTH1] ON [LIST_MH_MAXDEPTH1].[MH_MAXDEPTH_ID] = T.X.value('(./maxDepth[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_NUMMANUAL] AS [LIST_MH_NUMMANUAL1] ON [LIST_MH_NUMMANUAL1].[MH_NUMMANUAL_ID] = T.X.value('(./ManualWorkers[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_COSTATUS] AS [LIST_MH_COSTATUS1] ON [LIST_MH_COSTATUS1].[MH_COSTATUS_ID] = T.X.value('(./CompStatus[text()])[1]', 'varchar(8)')
        JOIN [dbo].[System_Insurer] AS [System_Insurer1] ON [System_Insurer1].[INSURER_ID] = T.X.value('(./Insurer[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_TRADE] AS [LIST_MH_TRADE1] ON [LIST_MH_TRADE1].[MH_TRADE_ID] = T.X.value('(./SecondaryRisk[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_TRADE] AS [LIST_MH_TRADE2] ON [LIST_MH_TRADE2].[MH_TRADE_ID] = T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)')

	DECLARE @PandPs MCARISK_PandPsTableType;
	INSERT INTO @PandPs( [Surname] ,[Forname] ,[Title] ,[Title_ID])
    SELECT
		T.X.value('(./Surname[text()])[1]', 'varchar(50)') AS [Surname]
		,T.X.value('(./Forname[text()])[1]', 'varchar(50)') AS [Forname]
		,[LIST_TITLE1].[TITLE_Debug] AS [Title]
		,T.X.value('(./Title[text()])[1]', 'varchar(8)') AS [Title_ID]
	FROM
		@RiskXML.nodes('(//PandPs)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_TITLE] AS [LIST_TITLE1] ON [LIST_TITLE1].[TITLE_ID] = T.X.value('(./Title[text()])[1]', 'varchar(8)')


	DECLARE @SchemeInsurer varchar(1000) = (SELECT [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)

--AgentID
	DECLARE @AgentID char(32) = (SELECT [Agent_ID] FROM [RM_Agent] WHERE [Name] = @AgentName)

	--Claims
	DECLARE @ClaimsSummary [dbo].[ClaimSummaryTableType]
    INSERT INTO @ClaimsSummary
	SELECT * FROM [dbo].[tvfClaimSummary](@RiskXML.query('./ClmSum') ,@PolicyStartDateTime )

--Employees
	DECLARE @EmployeeCounts EmployeeCountsTableType

--Refers
	--Insurer 
	--IF (SELECT CASE WHEN @PolicyQuoteStage = 'NB' AND [C].[Insurer] = @SchemeInsurer THEN 1 ELSE 0 END FROM {TableWithInsurerID} AS [C]) = 1
			--INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)

	--Assumptions	
	INSERT INTO @Refer([Message])
	SELECT [Message] FROM [dbo].[MCARISK_tvfReferredAssumptions](@RiskXML.query('./Assumpt') ,@PolicyStartDateTime);

-- Declines	
	-- Decline invalid postcode (8142413832)
    IF([dbo].[svfValidateUKPostcode](@PostCode) = 0)
	        INSERT INTO @Decline VALUES ('Invalid Postcode');

--Debugging
	IF @OutputRisk = 1
	BEGIN
		SELECT * FROM @TCCInfo;
		SELECT * FROM @PandPs;

		SELECT * FROM @ClaimsSummary
		SELECT [Message] FROM [dbo].[MCARISK_tvfReferredAssumptions](@RiskXML.query('./Assumpt') ,@PolicyStartDateTime);
		SELECT @PolicyStartDateTime AS [PolicyStartDateTime] ,@PolicyQuoteStage AS [PolicyQuoteStage] ,@PostCode AS [Postcode] ,@SchemeTableID AS [SchemeTableID] ,@SchemeInsurer AS [SchemeInsurer]
	END	

--MCARISK_tvfSchemeDispatcher
	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM [dbo].[MCARISK_tvfSchemeDispatcher] (@SchemeTableID, @PolicyStartDateTime, @PolicyQuoteStage, @PostCode, @AgentID, @ClaimsSummary, @EmployeeCounts, @RiskXML, @TCCInfo, @PandPs) FOR XML PATH(''))
 
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


	DECLARE @ContractsWorks bit = (SELECT [ContractWorks] FROM @TCCInfo)
	DECLARE @CoverPlantMachinery bit = (SELECT [Tools] FROM @TCCInfo)
	DECLARE @CoverHiredPlant bit = (SELECT [HiredPlantYN] FROM @TCCInfo)
	DECLARE @CoverEmpTools bit = (SELECT [EmpToolsCover] FROM @TCCInfo)
		

--Table Counts
	DECLARE @ReferCount int = (SELECT COUNT(*) FROM @Refer)
	DECLARE @DeclineCount int = (SELECT COUNT(*) FROM @Decline)
	
--Refer Premiums. /*6988243306*/
	IF @ReferCount > 0 
	BEGIN
		UPDATE
			@Premium 
		SET 
			[Value] = 
			CASE 
				WHEN [Name] = 'CWRKPREM' AND ISNULL([Value],0) = 0 AND @ContractsWorks = 1 THEN 1
				WHEN [Name] = 'PLMTPREM' AND ISNULL([Value],0) = 0 AND @CoverPlantMachinery = 1 THEN 1
				WHEN [Name] = 'HIPLPREM' AND ISNULL([Value],0) = 0 AND @CoverHiredPlant = 1    THEN 1
				WHEN [Name] = 'EMTLPREM' AND ISNULL([Value],0) = 0 AND @CoverEmpTools  = 1 THEN 1
				ELSE [Value]
			END
	END

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



	EXECUTE [dbo].[uspSchemeResults] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium ,@Endorsement
END	

