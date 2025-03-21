USE [Calculators]
GO
/****** Object:  StoredProcedure [dbo].[MCOURIER_uspCalculator]    Script Date: 09/01/2025 10:30:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		System Generated
-- Date:        05 Jul 2023
-- Description: Boiler plate for translating wpd variables and returns can be regenerated apart from LOB level refers etc..
*******************************************************************************
-- Date			Who					Changes
-- 02/01/2025   Linga				Monday Ticket 8142413832: UK postcode Referral

*******************************************************************************/

ALTER PROCEDURE[dbo].[MCOURIER_uspCalculator]
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
    SELECT * FROM [Transactor_Live].[dbo].[uspSchemeCommandDebug] WHERE [uspSchemeCommandText] LIKE '%MCOURIER_uspCalculator%'

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

	DECLARE @PTVInfo MCOURIER_PTVInfoTableType;
	INSERT INTO @PTVInfo( [ERNRef] ,[ERNExempt] ,[TotalEmps] ,[NumVehicles] ,[NumVehicles_ID] ,[NetworkName] ,[WhichNetwork] ,[WhichNetwork_ID] ,[Franchise] ,[CarryFurni] ,[NumScanners] ,[NumScanners_ID] ,[ScannerCover] ,[StartDate] ,[PrimaryRisk] ,[PrimaryRisk_ID] ,[PresentInsurer] ,[PresentInsurer_ID] ,[IncludeYN] ,[SubsidYN] ,[Temporary] ,[Permenant] ,[EmpLiabCover] ,[PubLiabLimit] ,[PubLiabLimit_ID] ,[PubLiabCover] ,[ManualWork] ,[CompanyStatus] ,[CompanyStatus_ID])
    SELECT
		T.X.value('(./ERNRef[text()])[1]', 'varchar(20)') AS [ERNRef]
		,ISNULL(T.X.value('(./ERNExempt[text()])[1]', 'bit'),0) AS [ERNExempt]
		,ISNULL(T.X.value('(./TotalEmps[text()])[1]', 'money'),0) AS [TotalEmps]
		,[LIST_MH_NUMVEHCOV1].[MH_NUMVEHCOV_Debug] AS [NumVehicles]
		,T.X.value('(./NumVehicles[text()])[1]', 'varchar(8)') AS [NumVehicles_ID]
		,T.X.value('(./NetworkName[text()])[1]', 'varchar(50)') AS [NetworkName]
		,[LIST_MH_NETWORK1].[MH_NETWORK_Debug] AS [WhichNetwork]
		,T.X.value('(./WhichNetwork[text()])[1]', 'varchar(8)') AS [WhichNetwork_ID]
		,ISNULL(T.X.value('(./Franchise[text()])[1]', 'bit'),0) AS [Franchise]
		,ISNULL(T.X.value('(./CarryFurni[text()])[1]', 'bit'),0) AS [CarryFurni]
		,[LIST_MH_NUMSCAN1].[MH_NUMSCAN_Debug] AS [NumScanners]
		,T.X.value('(./NumScanners[text()])[1]', 'varchar(8)') AS [NumScanners_ID]
		,ISNULL(T.X.value('(./ScannerCover[text()])[1]', 'bit'),0) AS [ScannerCover]
        ,CONVERT(datetime ,		T.X.value('(./StartDate[text()])[1]', 'varchar(30)'),103) AS [StartDate]
		,[LIST_MH_TRADE1].[MH_TRADE_Debug] AS [PrimaryRisk]
		,T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)') AS [PrimaryRisk_ID]
		,[System_Insurer1].[INSURER_Debug] AS [PresentInsurer]
		,T.X.value('(./PresentInsurer[text()])[1]', 'varchar(8)') AS [PresentInsurer_ID]
		,ISNULL(T.X.value('(./IncludeYN[text()])[1]', 'bit'),0) AS [IncludeYN]
		,ISNULL(T.X.value('(./SubsidYN[text()])[1]', 'bit'),0) AS [SubsidYN]
		,ISNULL(T.X.value('(./Temporary[text()])[1]', 'money'),0) AS [Temporary]
		,ISNULL(T.X.value('(./Permenant[text()])[1]', 'money'),0) AS [Permenant]
		,ISNULL(T.X.value('(./EmpLiabCover[text()])[1]', 'bit'),0) AS [EmpLiabCover]
		,[LIST_MH_PUBLIAB1].[MH_PUBLIAB_Debug] AS [PubLiabLimit]
		,T.X.value('(./PubLiabLimit[text()])[1]', 'varchar(8)') AS [PubLiabLimit_ID]
		,ISNULL(T.X.value('(./PubLiabCover[text()])[1]', 'bit'),0) AS [PubLiabCover]
		,ISNULL(T.X.value('(./ManualWork[text()])[1]', 'bit'),0) AS [ManualWork]
		,[LIST_MH_COSTATUS1].[MH_COSTATUS_Debug] AS [CompanyStatus]
		,T.X.value('(./CompanyStatus[text()])[1]', 'varchar(8)') AS [CompanyStatus_ID]
	FROM
		@RiskXML.nodes('(//PTVInfo)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_NUMVEHCOV] AS [LIST_MH_NUMVEHCOV1] ON [LIST_MH_NUMVEHCOV1].[MH_NUMVEHCOV_ID] = T.X.value('(./NumVehicles[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_NETWORK] AS [LIST_MH_NETWORK1] ON [LIST_MH_NETWORK1].[MH_NETWORK_ID] = T.X.value('(./WhichNetwork[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_NUMSCAN] AS [LIST_MH_NUMSCAN1] ON [LIST_MH_NUMSCAN1].[MH_NUMSCAN_ID] = T.X.value('(./NumScanners[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_TRADE] AS [LIST_MH_TRADE1] ON [LIST_MH_TRADE1].[MH_TRADE_ID] = T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)')
        JOIN [dbo].[System_Insurer] AS [System_Insurer1] ON [System_Insurer1].[INSURER_ID] = T.X.value('(./PresentInsurer[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_PUBLIAB] AS [LIST_MH_PUBLIAB1] ON [LIST_MH_PUBLIAB1].[MH_PUBLIAB_ID] = T.X.value('(./PubLiabLimit[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_COSTATUS] AS [LIST_MH_COSTATUS1] ON [LIST_MH_COSTATUS1].[MH_COSTATUS_ID] = T.X.value('(./CompanyStatus[text()])[1]', 'varchar(8)')

	DECLARE @VehDtail MCOURIER_VehDtailTableType;
	INSERT INTO @VehDtail( [Territorial] ,[Territorial_ID] ,[VehModel] ,[VehMake] ,[SumInsured] ,[SumInsured_ID] ,[RegNumber])
    SELECT
		[LIST_MH_TERRITORIAL1].[MH_TERRITORIAL_Debug] AS [Territorial]
		,T.X.value('(./Territorial[text()])[1]', 'varchar(8)') AS [Territorial_ID]
		,T.X.value('(./VehModel[text()])[1]', 'varchar(50)') AS [VehModel]
		,T.X.value('(./VehMake[text()])[1]', 'varchar(50)') AS [VehMake]
		,[LIST_MH_GITC_INSURED1].[MH_GITC_INSURED_Debug] AS [SumInsured]
		,T.X.value('(./SumInsured[text()])[1]', 'varchar(8)') AS [SumInsured_ID]
		,T.X.value('(./RegNumber[text()])[1]', 'varchar(10)') AS [RegNumber]
	FROM
		@RiskXML.nodes('(//VehDtail)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_TERRITORIAL] AS [LIST_MH_TERRITORIAL1] ON [LIST_MH_TERRITORIAL1].[MH_TERRITORIAL_ID] = T.X.value('(./Territorial[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_GITC_INSURED] AS [LIST_MH_GITC_INSURED1] ON [LIST_MH_GITC_INSURED1].[MH_GITC_INSURED_ID] = T.X.value('(./SumInsured[text()])[1]', 'varchar(8)')



	DECLARE @PandP MCOURIER_PandPTableType;
	INSERT INTO @PandP( [Status] ,[Status_ID] ,[Surname] ,[Forename] ,[Title] ,[Title_ID])
    SELECT
		[LIST_MH_P_STATUS1].[MH_P_STATUS_Debug] AS [Status]
		,T.X.value('(./Status[text()])[1]', 'varchar(8)') AS [Status_ID]
		,T.X.value('(./Surname[text()])[1]', 'varchar(50)') AS [Surname]
		,T.X.value('(./Forename[text()])[1]', 'varchar(50)') AS [Forename]
		,[LIST_TITLE1].[TITLE_Debug] AS [Title]
		,T.X.value('(./Title[text()])[1]', 'varchar(8)') AS [Title_ID]
	FROM
		@RiskXML.nodes('(//PandP)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_P_STATUS] AS [LIST_MH_P_STATUS1] ON [LIST_MH_P_STATUS1].[MH_P_STATUS_ID] = T.X.value('(./Status[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_TITLE] AS [LIST_TITLE1] ON [LIST_TITLE1].[TITLE_ID] = T.X.value('(./Title[text()])[1]', 'varchar(8)')

	DECLARE @Business MCOURIER_BusinessTableType;
	INSERT INTO @Business( [SafetyDetails] ,[Safety] ,[TribunalDetails] ,[Tribunal] ,[DisputeDetails] ,[Dispute] ,[RegDetails] ,[Regs] ,[DismissDetails] ,[DismissedStaff] ,[ClaimDetails] ,[Claim] ,[BusinessCover])
    SELECT
		T.X.value('(./SafetyDetails[text()])[1]', 'varchar(100)') AS [SafetyDetails]
		,ISNULL(T.X.value('(./Safety[text()])[1]', 'bit'),0) AS [Safety]
		,T.X.value('(./TribunalDetails[text()])[1]', 'varchar(100)') AS [TribunalDetails]
		,ISNULL(T.X.value('(./Tribunal[text()])[1]', 'bit'),0) AS [Tribunal]
		,T.X.value('(./DisputeDetails[text()])[1]', 'varchar(100)') AS [DisputeDetails]
		,ISNULL(T.X.value('(./Dispute[text()])[1]', 'bit'),0) AS [Dispute]
		,T.X.value('(./RegDetails[text()])[1]', 'varchar(100)') AS [RegDetails]
		,ISNULL(T.X.value('(./Regs[text()])[1]', 'bit'),0) AS [Regs]
		,T.X.value('(./DismissDetails[text()])[1]', 'varchar(100)') AS [DismissDetails]
		,ISNULL(T.X.value('(./DismissedStaff[text()])[1]', 'bit'),0) AS [DismissedStaff]
		,T.X.value('(./ClaimDetails[text()])[1]', 'varchar(100)') AS [ClaimDetails]
		,ISNULL(T.X.value('(./Claim[text()])[1]', 'bit'),0) AS [Claim]
		,ISNULL(T.X.value('(./BusinessCover[text()])[1]', 'bit'),0) AS [BusinessCover]
	FROM
		@RiskXML.nodes('(//Business)') AS T(x) --Lookup table

	DECLARE @Subsid MCOURIER_SubsidTableType;
	INSERT INTO @Subsid( [SubsidInsurer] ,[SubsidInsurer_ID] ,[SubsidERN] ,[SubsidName])
    SELECT
		[System_Insurer2].[INSURER_Debug] AS [SubsidInsurer]
		,T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)') AS [SubsidInsurer_ID]
		,T.X.value('(./SubsidERN[text()])[1]', 'varchar(20)') AS [SubsidERN]
		,T.X.value('(./SubsidName[text()])[1]', 'varchar(200)') AS [SubsidName]
	FROM
		@RiskXML.nodes('(//Subsid)') AS T(x) --Lookup table
        JOIN [dbo].[System_Insurer] AS [System_Insurer2] ON [System_Insurer2].[INSURER_ID] = T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)')

	------Assumptions

   DECLARE @Assump [MCOURIER_AssumpTableType];
   INSERT INTO @Assump ( [BANKRUPT], [BANKRUPT_ID],[CONVICTION],[CONVICTION_ID] ,[DECLINED],[DECLINED_ID],[RESPONSIBILITY],[RESPONSIBILITY_ID],[SECURITYEQUIP] ,[SECURITYEQUIP_ID] ,[GOODSTATE],[GOODSTATE_ID], [LICENCES] ,[LICENCES_ID] ,[MOORINGS] ,[MOORINGS_ID] ,[MAINTAINVEH] ,[MAINTAINVEH_ID] ,[TANKERS] ,[TANKERS_ID] )
   SELECT 
      [LIST_MH_ASSUMPT1].[MH_ASSUMPT_DEBUG] AS [BANKRUPT]
	 ,T.X.value('(./Bankrupt[text()])[1]', 'varchar(8)')  AS [BANKRUPT_ID]
	 ,[LIST_MH_ASSUMPT2].[MH_ASSUMPT_DEBUG] AS [CONVICTION]
	 ,T.X.value('(./Conviction[text()])[1]', 'varchar(8)') AS [CONVICTION_ID]
	 ,[LIST_MH_ASSUMPT3].[MH_ASSUMPT_DEBUG] AS [DECLINED]
	 ,T.X.value('(./Declined[text()])[1]', 'varchar(8)') AS [DECLINED_ID]
	 ,[LIST_MH_ASSUMPT4].[MH_ASSUMPT_DEBUG] AS [RESPONSIBILITY]
	 ,T.X.value('(./Responsibility[text()])[1]', 'varchar(8)') AS [RESPONSIBILITY_ID]
	 ,[LIST_MH_ASSUMPT5].[MH_ASSUMPT_DEBUG] AS [SECURITYEQUIP]
	 ,T.X.value('(./SecurityEquip[text()])[1]', 'varchar(8)') AS [SECURITYEQUIP]
	 ,[LIST_MH_ASSUMPT6].[MH_ASSUMPT_DEBUG] AS [GOODSTATE]
     ,T.X.value('(./GoodState[text()])[1]', 'varchar(8)') AS [GOODSTATE_ID]
	 ,[LIST_MH_ASSUMPT7].[MH_ASSUMPT_DEBUG] AS [LICENCES]
	 ,T.X.value('(./Licences[text()])[1]', 'varchar(8)') AS [LICENCES_ID]
	 ,[LIST_MH_ASSUMPT8].[MH_ASSUMPT_DEBUG] AS [MOORINGS]
     ,T.X.value('(./Moorings[text()])[1]', 'varchar(8)') AS [MOORINGS_ID]
	 ,[LIST_MH_ASSUMPT9].[MH_ASSUMPT_DEBUG] AS [MAINTAINVEH]
	 ,T.X.value('(./MaintainVeh[text()])[1]', 'varchar(8)') AS [MAINTAINVEH_ID]
	 ,[LIST_MH_ASSUMPT10].[MH_ASSUMPT_DEBUG] AS [TANKERS]
	 ,T.X.value('(./Tankers[text()])[1]', 'varchar(8)') AS [TANKERS_ID]

	 FROM @RiskXML.nodes('(//Assump)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT1] ON [LIST_MH_ASSUMPT1].[MH_ASSUMPT_ID] = T.X.value('(./Bankrupt[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT2] ON [LIST_MH_ASSUMPT2].[MH_ASSUMPT_ID] = T.X.value('(./Conviction[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT3] ON [LIST_MH_ASSUMPT3].[MH_ASSUMPT_ID] = T.X.value('(./Declined[text()])[1]', 'varchar(8)')

		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT4] ON [LIST_MH_ASSUMPT4].[MH_ASSUMPT_ID] = T.X.value('(./Responsibility[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT5] ON [LIST_MH_ASSUMPT5].[MH_ASSUMPT_ID] = T.X.value('(./SecurityEquip[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT6] ON [LIST_MH_ASSUMPT6].[MH_ASSUMPT_ID] = T.X.value('(./GoodState[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT7] ON [LIST_MH_ASSUMPT7].[MH_ASSUMPT_ID] = T.X.value('(./Licences[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT8] ON [LIST_MH_ASSUMPT8].[MH_ASSUMPT_ID] = T.X.value('(./Moorings[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT9] ON [LIST_MH_ASSUMPT9].[MH_ASSUMPT_ID] = T.X.value('(./MaintainVeh[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT10] ON [LIST_MH_ASSUMPT10].[MH_ASSUMPT_ID] = T.X.value('(./Tankers[text()])[1]', 'varchar(8)')


	DECLARE @SchemeInsurer varchar(1000) = (SELECT [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)

--AgentID
	DECLARE @AgentID char(32) = (SELECT [Agent_ID] FROM [RM_Agent] WHERE [Name] = @AgentName)

	--Claims
	DECLARE @ClaimsSummary [dbo].[ClaimTableType]
    INSERT INTO @ClaimsSummary
		SELECT 
         T.X.value('(./Details[text()])[1]','varchar(500)')  AS [Details]
		 ,ISNULL(T.X.value('(./Outstanding[text()])[1]', 'money'),0) AS [Outstanding]
		 ,ISNULL(T.X.value('(./Paid[text()])[1]', 'money'),0) AS [Paid]
		 ,CONVERT(datetime , T.X.value('(./Date[text()])[1]', 'varchar(30)'),103) AS [Date]
		 ,[CT].[MH_CLAIMTYPE_DEBUG] AS [Type]

	FROM @RiskXML.nodes('(//ClmDtail)') AS T(x) --Lookup table ClmSum
	JOIN [dbo].[LIST_MH_CLAIMTYPE] AS [CT] ON [CT].[MH_CLAIMTYPE_ID] = T.X.value('(./Type[text()])[1]','varchar(8)')

	----SELECT * FROM [dbo].[tvfClaimYearsSummary](@RiskXML.query('./ClmSum') ,5 ,@PolicyStartDateTime )

----Employees
--	DECLARE @EmployeeCounts EmployeeCountsTableType

--Refers
	--Insurer 
	--IF (SELECT CASE WHEN @PolicyQuoteStage = 'NB' AND [C].[Insurer] = @SchemeInsurer THEN 1 ELSE 0 END FROM {TableWithInsurerID} AS [C]) = 1
			--INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)

	--Assumptions	
	--INSERT INTO @Refer([Message])
	--SELECT [Message] FROM [dbo].[MCOURIER_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime ,@SchemeTableID);

--Declines
	-- Decline invalid postcode (8142413832)
    IF([dbo].[svfValidateUKPostcode](@PostCode) = 0)
	        INSERT INTO @Decline VALUES ('Invalid Postcode');

--Debugging
	IF @OutputRisk = 1
	BEGIN
		SELECT * FROM @PTVInfo;
		SELECT * FROM @VehDtail;
		SELECT * FROM @PandP;
		SELECT * FROM @Business;
		SELECT * FROM @Subsid;
		SELECT * FROM @Assump;
		SELECT * FROM @ClaimsSummary;

		
		SELECT [Message] FROM [dbo].[MCOURIER_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime); --@SchemeTableID
		SELECT @PolicyStartDateTime AS [PolicyStartDateTime] ,@PolicyQuoteStage AS [PolicyQuoteStage] ,@PostCode AS [Postcode] ,@SchemeTableID AS [SchemeTableID] ,@SchemeInsurer AS [SchemeInsurer]
	END	

--MCOURIER_tvfSchemeDispatcher
 --@EmployeeCounts
	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM [dbo].[MCOURIER_tvfSchemeDispatcher] (@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode ,@ClaimsSummary ,@PTVInfo ,@VehDtail ,@PandP ,@Business ,@Subsid, @Assump) FOR XML PATH(''))
 

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
	--select * from @Premium
--Product Details		
	--DECLARE @ExampleVariable int 
	--INSERT INTO @ProductDetail([Message])	VALUES(	'Example Message = '+ [dbo].[svfFormatMoneyString](@ExampleVariable))

--Return Values
	DECLARE @Endorsements varchar(255) 
	SELECT 
		@Endorsements = COALESCE(@Endorsements + ',','') + [Message] 
	FROM 
		@Endorsement

--Refer Premiums.
	--IF @ReferCount > 0 
	--BEGIN
	--	UPDATE
	--		@Premium 
	--	SET 
	--		[Value] = 
	--		CASE 
	--			WHEN [Name] = 'GITRPREM' AND ISNULL([Value],0) = 0 /*AND {predicate} */ THEN 1
	--			ELSE [Value]
	--		END
	--END

	--SELECT * FROM @Premium2
	EXECUTE [dbo].[uspSchemeResults] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium ,@Endorsement
END	

