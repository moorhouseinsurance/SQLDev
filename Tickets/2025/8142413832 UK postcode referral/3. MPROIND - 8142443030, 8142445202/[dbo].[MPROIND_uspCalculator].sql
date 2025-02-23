USE [Calculators]
GO
/****** Object:  StoredProcedure [dbo].[MPROIND_uspCalculator]    Script Date: 07/01/2025 08:23:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		System Generated
-- Date:        22 Apr 2024
-- Description: Boiler plate for translating wpd variables and returns can be regenerated apart from LOB level refers etc..
*******************************************************************************
-- Date			Who						Change

-- 02/01/2025   Linga					Monday Ticket 8142413832: UK postcode Referral

*******************************************************************************/

ALTER PROCEDURE [dbo].[MPROIND_uspCalculator]
	 @RiskXML XML
    ,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
    ,@SchemeTableID int
	,@AgentName varchar(255)
    ,@SubAgentID char(32)
	,@OutputRisk bit = 0
	,@HistoryID int = NULL --Supplied If recalculating
AS
/*

    TRUNCATE TABLE [Transactor_Live].[dbo].[uspSchemeCommandDebug]
    SELECT * FROM [Transactor_Live].[dbo].[uspSchemeCommandDebug] WHERE [uspSchemeCommandText] LIKE '%MPROIND_uspCalculator%'

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

	SET @RiskXML = REPLACE(REPLACE(cast(@RiskXML AS varchar(max)), '> ', '>'), ' <', '<');

	DECLARE @ClientDt MPROIND_ClientDtTableType;
	INSERT INTO @ClientDt( [ERNExempt] ,[ERNRef] ,[HistoryID] ,[PolicyDetailsID] ,[IncludeYN] ,[SubsidYN] ,[ManualWorkYN] ,[SoilYN] ,[SolarProjectsYN] ,[WaterWorkYN] ,[GroundWorkYN] ,[WorkDomainsYN] ,[UnusalWorkYN] ,[ServiceInquiry] ,[country] ,[country_ID] ,[EmpsAndDirec] ,[EmpsAndDirec_ID] ,[EmpLiab] ,[NumOfEmps] ,[NumOfEmps_ID] ,[PubLiabCover] ,[PubLiabCover_ID] ,[PubLiab] ,[CoverType] ,[CoverType_ID] ,[LimitOfIndem] ,[LimitOfIndem_ID] ,[FeeIncome] ,[Turnover] ,[RetroDate] ,[Retroactive] ,[CurrentPI] ,[YrsExp] ,[Yrs] ,[YearEstab] ,[CovStart] ,[RiskTrade] ,[RiskTrade_ID])
    SELECT
		ISNULL(T.X.value('(./ERNExempt[text()])[1]', 'bit'),0) AS [ERNExempt]
		,T.X.value('(./ERNRef[text()])[1]', 'varchar(20)') AS [ERNRef]
		,ISNULL(T.X.value('(./HistoryID[text()])[1]', 'money'),0) AS [HistoryID]
		,T.X.value('(./PolicyDetailsID[text()])[1]', 'varchar(32)') AS [PolicyDetailsID]
		,ISNULL(T.X.value('(./IncludeYN[text()])[1]', 'bit'),0) AS [IncludeYN]
		,ISNULL(T.X.value('(./SubsidYN[text()])[1]', 'bit'),0) AS [SubsidYN]
		,ISNULL(T.X.value('(./ManualWorkYN[text()])[1]', 'bit'),0) AS [ManualWorkYN]
		,ISNULL(T.X.value('(./SoilYN[text()])[1]', 'bit'),0) AS [SoilYN]
		,ISNULL(T.X.value('(./SolarProjectsYN[text()])[1]', 'bit'),0) AS [SolarProjectsYN]
		,ISNULL(T.X.value('(./WaterWorkYN[text()])[1]', 'bit'),0) AS [WaterWorkYN]
		,ISNULL(T.X.value('(./GroundWorkYN[text()])[1]', 'bit'),0) AS [GroundWorkYN]
		,ISNULL(T.X.value('(./WorkDomainsYN[text()])[1]', 'bit'),0) AS [WorkDomainsYN]
		,ISNULL(T.X.value('(./UnusalWorkYN[text()])[1]', 'bit'),0) AS [UnusalWorkYN]
		,ISNULL(T.X.value('(./ServiceInquiry[text()])[1]', 'bit'),0) AS [ServiceInquiry]
		,[LIST_COUNTRY1].[COUNTRY_Debug] AS [country]
		,T.X.value('(./country[text()])[1]', 'varchar(8)') AS [country_ID]
		,[LIST_MH_PA_NUMEMP1].[MH_PA_NUMEMP_Debug] AS [EmpsAndDirec]
		,T.X.value('(./EmpsAndDirec[text()])[1]', 'varchar(8)') AS [EmpsAndDirec_ID]
		,ISNULL(T.X.value('(./EmpLiab[text()])[1]', 'bit'),0) AS [EmpLiab]
		,[LIST_MH_PA_NUMEMP2].[MH_PA_NUMEMP_Debug] AS [NumOfEmps]
		,T.X.value('(./NumOfEmps[text()])[1]', 'varchar(8)') AS [NumOfEmps_ID]
		,[LIST_MH_LIABLIMIT1].[MH_LIABLIMIT_Debug] AS [PubLiabCover]
		,T.X.value('(./PubLiabCover[text()])[1]', 'varchar(8)') AS [PubLiabCover_ID]
		,ISNULL(T.X.value('(./PubLiab[text()])[1]', 'bit'),0) AS [PubLiab]
		,[LIST_MH_COVER1].[MH_COVER_Debug] AS [CoverType]
		,T.X.value('(./CoverType[text()])[1]', 'varchar(8)') AS [CoverType_ID]
		,[LIST_MH_INDEMNITY1].[MH_INDEMNITY_Debug] AS [LimitOfIndem]
		,T.X.value('(./LimitOfIndem[text()])[1]', 'varchar(8)') AS [LimitOfIndem_ID]
		,ISNULL(T.X.value('(./FeeIncome[text()])[1]', 'money'),0) AS [FeeIncome]
		,ISNULL(T.X.value('(./Turnover[text()])[1]', 'money'),0) AS [Turnover]
,CONVERT(datetime ,		T.X.value('(./RetroDate[text()])[1]', 'varchar(30)'),103) AS [RetroDate]
		,ISNULL(T.X.value('(./Retroactive[text()])[1]', 'bit'),0) AS [Retroactive]
		,ISNULL(T.X.value('(./CurrentPI[text()])[1]', 'bit'),0) AS [CurrentPI]
		,ISNULL(T.X.value('(./YrsExp[text()])[1]', 'money'),0) AS [YrsExp]
		,ISNULL(T.X.value('(./Yrs[text()])[1]', 'money'),0) AS [Yrs]
		,T.X.value('(./YearEstab[text()])[1]', 'varchar(8)') AS [YearEstab]
,CONVERT(datetime ,		T.X.value('(./CovStart[text()])[1]', 'varchar(30)'),103) AS [CovStart]
		,[LIST_MH_TRADE1].[MH_TRADE_Debug] AS [RiskTrade]
		,T.X.value('(./RiskTrade[text()])[1]', 'varchar(8)') AS [RiskTrade_ID]
	FROM
		@RiskXML.nodes('(//ClientDt)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_COUNTRY] AS [LIST_COUNTRY1] ON [LIST_COUNTRY1].[COUNTRY_ID] = T.X.value('(./country[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_PA_NUMEMP] AS [LIST_MH_PA_NUMEMP1] ON [LIST_MH_PA_NUMEMP1].[MH_PA_NUMEMP_ID] = T.X.value('(./EmpsAndDirec[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_PA_NUMEMP] AS [LIST_MH_PA_NUMEMP2] ON [LIST_MH_PA_NUMEMP2].[MH_PA_NUMEMP_ID] = T.X.value('(./NumOfEmps[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_LIABLIMIT] AS [LIST_MH_LIABLIMIT1] ON [LIST_MH_LIABLIMIT1].[MH_LIABLIMIT_ID] = T.X.value('(./PubLiabCover[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_COVER] AS [LIST_MH_COVER1] ON [LIST_MH_COVER1].[MH_COVER_ID] = T.X.value('(./CoverType[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_INDEMNITY] AS [LIST_MH_INDEMNITY1] ON [LIST_MH_INDEMNITY1].[MH_INDEMNITY_ID] = T.X.value('(./LimitOfIndem[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_TRADE] AS [LIST_MH_TRADE1] ON [LIST_MH_TRADE1].[MH_TRADE_ID] = T.X.value('(./RiskTrade[text()])[1]', 'varchar(8)')

---TrdDtail

	DECLARE @TrdDtail MPROIND_TrdDtailTableType;
	INSERT INTO @TrdDtail( [TaxWorkPct] ,[LargestFeeSI] ,[ProbateAuthYN] ,[TaxPlanningYN] ,[LloydsYN] ,[SecretaryYN] ,[TrustWork] ,[Directorship] ,[CorporationTax] ,[Mergers] ,[Offshore] ,[TaxSchemes] ,[PublicCom] ,[FinanceAdvice] ,[Chartered])
    SELECT
		ISNULL(T.X.value('(./TaxWorkPct[text()])[1]', 'money'),0) AS [TaxWorkPct]
		,ISNULL(T.X.value('(./LargestFeeSI[text()])[1]', 'money'),0) AS [LargestFeeSI]
		,ISNULL(T.X.value('(./ProbateAuthYN[text()])[1]', 'bit'),0) AS [ProbateAuthYN]
		,ISNULL(T.X.value('(./TaxPlanningYN[text()])[1]', 'bit'),0) AS [TaxPlanningYN]
		,ISNULL(T.X.value('(./LloydsYN[text()])[1]', 'bit'),0) AS [LloydsYN]
		,ISNULL(T.X.value('(./SecretaryYN[text()])[1]', 'bit'),0) AS [SecretaryYN]
		,ISNULL(T.X.value('(./TrustWork[text()])[1]', 'bit'),0) AS [TrustWork]
		,ISNULL(T.X.value('(./Directorship[text()])[1]', 'bit'),0) AS [Directorship]
		,ISNULL(T.X.value('(./CorporationTax[text()])[1]', 'bit'),0) AS [CorporationTax]
		,ISNULL(T.X.value('(./Mergers[text()])[1]', 'bit'),0) AS [Mergers]
		,ISNULL(T.X.value('(./Offshore[text()])[1]', 'bit'),0) AS [Offshore]
		,ISNULL(T.X.value('(./TaxSchemes[text()])[1]', 'bit'),0) AS [TaxSchemes]
		,ISNULL(T.X.value('(./PublicCom[text()])[1]', 'bit'),0) AS [PublicCom]
		,ISNULL(T.X.value('(./FinanceAdvice[text()])[1]', 'bit'),0) AS [FinanceAdvice]
		,ISNULL(T.X.value('(./Chartered[text()])[1]', 'bit'),0) AS [Chartered]
	FROM
		@RiskXML.nodes('(//TrdDtail)') AS T(x) --Lookup table

---TDConstr
	DECLARE @TDConstr MPROIND_TDConstrTableType;
	INSERT INTO @TDConstr( [InspectionYN] ,[ExcessOf] ,[Cladding] ,[Lifitng] ,[Dams])
    SELECT
		ISNULL(T.X.value('(./InspectionYN[text()])[1]', 'bit'),0) AS [InspectionYN]
		,ISNULL(T.X.value('(./ExcessOf[text()])[1]', 'bit'),0) AS [ExcessOf]
		,ISNULL(T.X.value('(./Cladding[text()])[1]', 'bit'),0) AS [Cladding]
		,ISNULL(T.X.value('(./Lifitng[text()])[1]', 'bit'),0) AS [Lifitng]
		,ISNULL(T.X.value('(./Dams[text()])[1]', 'bit'),0) AS [Dams]
	FROM
		@RiskXML.nodes('(//TDConstr)') AS T(x) --Lookup table

---TDEstate
	DECLARE @TDEstate MPROIND_TDEstateTableType;
	INSERT INTO @TDEstate( [PropIncomeYN] ,[ShortTermLetsYN] ,[FinServicesYN] ,[BonaFideWorkYN] ,[PropRepairYN] ,[PropMgmtYN] ,[ExcessOf] ,[Surveying] ,[RentReviews] ,[Chartered])
    SELECT
		ISNULL(T.X.value('(./PropIncomeYN[text()])[1]', 'bit'),0) AS [PropIncomeYN]
		,ISNULL(T.X.value('(./ShortTermLetsYN[text()])[1]', 'bit'),0) AS [ShortTermLetsYN]
		,ISNULL(T.X.value('(./FinServicesYN[text()])[1]', 'bit'),0) AS [FinServicesYN]
		,ISNULL(T.X.value('(./BonaFideWorkYN[text()])[1]', 'bit'),0) AS [BonaFideWorkYN]
		,ISNULL(T.X.value('(./PropRepairYN[text()])[1]', 'bit'),0) AS [PropRepairYN]
		,ISNULL(T.X.value('(./PropMgmtYN[text()])[1]', 'bit'),0) AS [PropMgmtYN]
		,ISNULL(T.X.value('(./ExcessOf[text()])[1]', 'bit'),0) AS [ExcessOf]
		,ISNULL(T.X.value('(./Surveying[text()])[1]', 'bit'),0) AS [Surveying]
		,ISNULL(T.X.value('(./RentReviews[text()])[1]', 'bit'),0) AS [RentReviews]
		,ISNULL(T.X.value('(./Chartered[text()])[1]', 'bit'),0) AS [Chartered]
	FROM
		@RiskXML.nodes('(//TDEstate)') AS T(x) --Lookup table

---TDSurvey 
	DECLARE @TDSurvey MPROIND_TDSurveyTableType;
	INSERT INTO @TDSurvey( [Project] ,[ExcessOf] ,[Chartered])
    SELECT
		ISNULL(T.X.value('(./Project[text()])[1]', 'bit'),0) AS [Project]
		,ISNULL(T.X.value('(./ExcessOf[text()])[1]', 'bit'),0) AS [ExcessOf]
		,ISNULL(T.X.value('(./Chartered[text()])[1]', 'bit'),0) AS [Chartered]
	FROM
		@RiskXML.nodes('(//TDSurvey)') AS T(x) --Lookup table
---TDWill
	DECLARE @TDWill MPROIND_TDWillTableType;
	INSERT INTO @TDWill( [Experience])
    SELECT
		ISNULL(T.X.value('(./Experience[text()])[1]', 'bit'),0) AS [Experience]
	FROM
		@RiskXML.nodes('(//TDWill)') AS T(x) --Lookup table

---TDMrktng
	DECLARE @TDMrktng MPROIND_TDMrktngTableType;
	INSERT INTO @TDMrktng( [ContentRightsYN] ,[PublishingYN] ,[WrittenWorkYN] ,[Website] ,[Sourcing] ,[Competitions] ,[DirectMail] ,[Broking])
    SELECT
		ISNULL(T.X.value('(./ContentRightsYN[text()])[1]', 'bit'),0) AS [ContentRightsYN]
		,ISNULL(T.X.value('(./PublishingYN[text()])[1]', 'bit'),0) AS [PublishingYN]
		,ISNULL(T.X.value('(./WrittenWorkYN[text()])[1]', 'bit'),0) AS [WrittenWorkYN]
		,ISNULL(T.X.value('(./Website[text()])[1]', 'bit'),0) AS [Website]
		,ISNULL(T.X.value('(./Sourcing[text()])[1]', 'bit'),0) AS [Sourcing]
		,ISNULL(T.X.value('(./Competitions[text()])[1]', 'bit'),0) AS [Competitions]
		,ISNULL(T.X.value('(./DirectMail[text()])[1]', 'bit'),0) AS [DirectMail]
		,ISNULL(T.X.value('(./Broking[text()])[1]', 'bit'),0) AS [Broking]
	FROM
		@RiskXML.nodes('(//TDMrktng)') AS T(x) --Lookup table
---TDBrokrs
	DECLARE @TDBrokrs MPROIND_TDBrokrsTableType;
	INSERT INTO @TDBrokrs( [Commercial] ,[Marine] ,[Facultative] ,[Treaty] ,[FinanceAdv])
    SELECT
		ISNULL(T.X.value('(./Commercial[text()])[1]', 'bit'),0) AS [Commercial]
		,ISNULL(T.X.value('(./Marine[text()])[1]', 'bit'),0) AS [Marine]
		,ISNULL(T.X.value('(./Facultative[text()])[1]', 'bit'),0) AS [Facultative]
		,ISNULL(T.X.value('(./Treaty[text()])[1]', 'bit'),0) AS [Treaty]
		,ISNULL(T.X.value('(./FinanceAdv[text()])[1]', 'bit'),0) AS [FinanceAdv]
	FROM
		@RiskXML.nodes('(//TDBrokrs)') AS T(x) --Lookup table
---TDMngmnt
	DECLARE @TDMngmnt MPROIND_TDMngmntTableType;
	INSERT INTO @TDMngmnt( [ExcessOf])
    SELECT
		ISNULL(T.X.value('(./ExcessOf[text()])[1]', 'bit'),0) AS [ExcessOf]
	FROM
		@RiskXML.nodes('(//TDMngmnt)') AS T(x) --Lookup table
---TDTaxCon
	DECLARE @TDTaxCon MPROIND_TDTaxConTableType;
	INSERT INTO @TDTaxCon( [advice] ,[ExcessOf] ,[TaxEfficient] ,[Trusts])
    SELECT
		ISNULL(T.X.value('(./advice[text()])[1]', 'bit'),0) AS [advice]
		,ISNULL(T.X.value('(./ExcessOf[text()])[1]', 'bit'),0) AS [ExcessOf]
		,ISNULL(T.X.value('(./TaxEfficient[text()])[1]', 'bit'),0) AS [TaxEfficient]
		,ISNULL(T.X.value('(./Trusts[text()])[1]', 'bit'),0) AS [Trusts]
	FROM
		@RiskXML.nodes('(//TDTaxCon)') AS T(x) --Lookup table
---TDLndSur
	DECLARE @TDLndSur MPROIND_TDLndSurTableType;
	INSERT INTO @TDLndSur( [Sampling])
    SELECT
		ISNULL(T.X.value('(./Sampling[text()])[1]', 'bit'),0) AS [Sampling]
	FROM
		@RiskXML.nodes('(//TDLndSur)') AS T(x) --Lookup table
---TDIntDes
	DECLARE @TDIntDes MPROIND_TDIntDesTableType;
	INSERT INTO @TDIntDes( [WorkRespYN] ,[Structural])
    SELECT
		ISNULL(T.X.value('(./WorkRespYN[text()])[1]', 'bit'),0) AS [WorkRespYN]
		,ISNULL(T.X.value('(./Structural[text()])[1]', 'bit'),0) AS [Structural]
	FROM
		@RiskXML.nodes('(//TDIntDes)') AS T(x) --Lookup table
---Business
	DECLARE @Business MPROIND_BusinessTableType;
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
---TDIt
	DECLARE @TDIt MPROIND_TDItTableType;
	INSERT INTO @TDIt( [IPAssuranceYN] ,[BizServicesYN] ,[ProductRisksYN] ,[Manufacturing] ,[Security] ,[Aerospace] ,[WebHosting] ,[CriticalSys])
    SELECT
		ISNULL(T.X.value('(./IPAssuranceYN[text()])[1]', 'bit'),0) AS [IPAssuranceYN]
		,ISNULL(T.X.value('(./BizServicesYN[text()])[1]', 'bit'),0) AS [BizServicesYN]
		,ISNULL(T.X.value('(./ProductRisksYN[text()])[1]', 'bit'),0) AS [ProductRisksYN]
		,ISNULL(T.X.value('(./Manufacturing[text()])[1]', 'bit'),0) AS [Manufacturing]
		,ISNULL(T.X.value('(./Security[text()])[1]', 'bit'),0) AS [Security]
		,ISNULL(T.X.value('(./Aerospace[text()])[1]', 'bit'),0) AS [Aerospace]
		,ISNULL(T.X.value('(./WebHosting[text()])[1]', 'bit'),0) AS [WebHosting]
		,ISNULL(T.X.value('(./CriticalSys[text()])[1]', 'bit'),0) AS [CriticalSys]
	FROM
		@RiskXML.nodes('(//TDIt)') AS T(x) --Lookup table

---Subsid
	DECLARE @Subsid MPROIND_SubsidTableType;
	INSERT INTO @Subsid( [SubsidInsurer] /*,[SubsidInsurer_ID]*/ ,[SubsidERN] ,[SubsidName])
    SELECT
		[System_Insurer1].[INSURER_Debug] AS [SubsidInsurer]
		--,T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)') AS [SubsidInsurer_ID]
		,T.X.value('(./SubsidERN[text()])[1]', 'varchar(20)') AS [SubsidERN]
		,T.X.value('(./SubsidName[text()])[1]', 'varchar(200)') AS [SubsidName]
	FROM
		@RiskXML.nodes('(//Subsid)') AS T(x) --Lookup table
        JOIN [dbo].[System_Insurer] AS [System_Insurer1] ON [System_Insurer1].[INSURER_ID] = T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)')
---TDArcht
	DECLARE @TDArcht MPROIND_TDArchtTableType;
	INSERT INTO @TDArcht( [ConstProjectsYN] ,[ConstructCostYN] ,[ErectionWorkYN] ,[SpecChangeYN] ,[ArchtDesignYN] ,[ArchContractsYN] ,[ArchtMemberYN])
    SELECT
		ISNULL(T.X.value('(./ConstProjectsYN[text()])[1]', 'bit'),0) AS [ConstProjectsYN]
		,ISNULL(T.X.value('(./ConstructCostYN[text()])[1]', 'bit'),0) AS [ConstructCostYN]
		,ISNULL(T.X.value('(./ErectionWorkYN[text()])[1]', 'bit'),0) AS [ErectionWorkYN]
		,ISNULL(T.X.value('(./SpecChangeYN[text()])[1]', 'bit'),0) AS [SpecChangeYN]
		,ISNULL(T.X.value('(./ArchtDesignYN[text()])[1]', 'bit'),0) AS [ArchtDesignYN]
		,ISNULL(T.X.value('(./ArchContractsYN[text()])[1]', 'bit'),0) AS [ArchContractsYN]
		,ISNULL(T.X.value('(./ArchtMemberYN[text()])[1]', 'bit'),0) AS [ArchtMemberYN]
	FROM
		@RiskXML.nodes('(//TDArcht)') AS T(x) --Lookup table
---TDAccid
	DECLARE @TDAccid MPROIND_TDAccidTableType;
	INSERT INTO @TDAccid( [ClaimsAuthYN])
    SELECT
		ISNULL(T.X.value('(./ClaimsAuthYN[text()])[1]', 'bit'),0) AS [ClaimsAuthYN]
	FROM
		@RiskXML.nodes('(//TDAccid)') AS T(x) --Lookup table
---TDEvntOr
	DECLARE @TDEvntOr MPROIND_TDEvntOrTableType;
	INSERT INTO @TDEvntOr( [EventOrgYN] ,[ConcertOrgYN] ,[TourOperatorsYN])
    SELECT
		ISNULL(T.X.value('(./EventOrgYN[text()])[1]', 'bit'),0) AS [EventOrgYN]
		,ISNULL(T.X.value('(./ConcertOrgYN[text()])[1]', 'bit'),0) AS [ConcertOrgYN]
		,ISNULL(T.X.value('(./TourOperatorsYN[text()])[1]', 'bit'),0) AS [TourOperatorsYN]
	FROM
		@RiskXML.nodes('(//TDEvntOr)') AS T(x) --Lookup table
---ClmSum
    DECLARE @ClmSum [dbo].[MPROIND_ClmSumTableType]
	INSERT INTO @ClmSum( [Shortcoming] ,[Incidents])
    SELECT
		T.X.value('(./shortcoming[text()])[1]', 'bit') AS [Shortcoming]
		,T.X.value('(./Incidents[text()])[1]', 'bit') AS [Incidents]
	FROM
		@RiskXML.nodes('(//ClmSum)') AS T(x) --Lookup table
	
-- Claims:
	
	DECLARE @ClaimsSummary [dbo].[ClaimYearsSummaryTableType]
    INSERT INTO @ClaimsSummary
	SELECT * FROM [dbo].[tvfClaimYearsSummary](@RiskXML.query('./ClmSum') ,6 ,@PolicyStartDateTime )
	--SELECT * FROM [dbo].[tvfClaimSummary](@RiskXML.query('./ClmSum'), @PolicyStartDateTime )

	

	DECLARE @SchemeInsurer varchar(1000) = (SELECT [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)

	DECLARE 
		 @PolicyDetailsID varchar(32)
	SELECT 
		 @PolicyDetailsID = PolicyDetailsID 
	FROM
		@ClientDt
			
--Quote Stage
	DECLARE @PolicyQuoteStageMTA bit = 0
	IF @PolicyQuoteStage = 'MTA' 
		SET @PolicyQuoteStageMTA = 'True'
			
--Previous History ID
	DECLARE @PreviousPolicyHistoryID int 

	IF @PolicyQuoteStage IN ('MTA', 'REN')
	BEGIN
		DECLARE @PreviousPolicyQuoteStage varchar(3)
		SELECT TOP 1
			 @PreviousPolicyHistoryID = [ACV].[POLICY_DETAILS_HISTORY_ID]
			,@PreviousPolicyQuoteStage = MAX([ACV].[TRANSACTION_CODE_ID])
		FROM 
			[Transactor_Live].[dbo].[ACCOUNTS_CLIENT_VIEW] AS [ACV]
		WHERE 
			[ACV].[TRANSACTION_CODE_ID] IN ('NB','REN','XREN')
			AND [ACV].[POLICY_DETAILS_ID] = @POLICYDETAILSID
			AND (@HistoryID IS NULL OR [ACV].[POLICY_DETAILS_HISTORY_ID] < @HistoryID)
		GROUP BY			
			[ACV].[POLICY_DETAILS_HISTORY_ID]
		HAVING
			count(DISTINCT [ACV].[TRANSACTION_CODE_ID])=1			
		
		ORDER BY 
			[ACV].[POLICY_DETAILS_HISTORY_ID] DESC	
		
		SET @PolicyQuoteStage = 'REN'
		IF @PolicyQuoteStageMTA = 'True' AND @PreviousPolicyQuoteStage = 'NB'
			SET @PolicyQuoteStage = 'MTA'
			
	END	
	

-- AgentID:
	DECLARE @AgentID char(32) = (SELECT [Agent_ID] FROM [RM_Agent] WHERE [Name] = @AgentName)


	-- Employees:
	--DECLARE @EmployeeCounts EmployeeCountsTableType

-- Refers:

	--Insurer 
	--IF (SELECT CASE WHEN @PolicyQuoteStage = 'NB' AND [C].[Insurer] = @SchemeInsurer THEN 1 ELSE 0 END FROM {TableWithInsurerID} AS [C]) = 1
			--INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)


-- Assumptions:
	INSERT INTO @Refer([Message])
	SELECT [Message] FROM [dbo].[MPROIND_tvfReferredAssumptions](@RiskXML.query('./Assump'), @PolicyStartDateTime);

-- Declines
   
   	-- Decline invalid postcode (8142413832)
    IF([dbo].[svfValidateUKPostcode](@PostCode) = 0)
	        INSERT INTO @Decline VALUES ('Invalid Postcode');

-- Debugging:
	
    IF @OutputRisk = 1
	BEGIN
		SELECT * FROM @ClientDt;
		SELECT * FROM @TrdDtail;
		SELECT * FROM @TDConstr;
		SELECT * FROM @TDEstate;
		SELECT * FROM @TDSurvey;
		SELECT * FROM @TDWill;
		SELECT * FROM @TDMrktng;
		SELECT * FROM @TDBrokrs;
		SELECT * FROM @TDMngmnt;
		SELECT * FROM @TDTaxCon;
		SELECT * FROM @TDLndSur;
		SELECT * FROM @TDIntDes;
		SELECT * FROM @Business;
		SELECT * FROM @TDIt;
		SELECT * FROM @Subsid;
		SELECT * FROM @TDArcht;
		SELECT * FROM @TDAccid;
		SELECT * FROM @TDEvntOr;
		SELECT * FROM @ClmSum;
		SELECT * FROM @Refer

		SELECT * FROM @ClaimsSummary
		SELECT [Message] FROM [dbo].[MPROIND_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);
		SELECT @PolicyStartDateTime AS [PolicyStartDateTime] ,@PolicyQuoteStage AS [PolicyQuoteStage] ,@PostCode AS [Postcode] ,@SchemeTableID AS [SchemeTableID] ,@SchemeInsurer AS [SchemeInsurer]
	END	


	--MPROIND_tvfSchemeDispatcher:

	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM [dbo].[MPROIND_tvfSchemeDispatcher] (@SchemeTableID, @PolicyStartDateTime, @PolicyQuoteStage, @PostCode, @AgentID,  @ClientDt , @ClmSum, @ClaimsSummary, @TrdDtail ,@TDConstr ,@TDEstate ,@TDSurvey ,@TDWill ,@TDMrktng ,@TDBrokrs ,@TDMngmnt ,@TDTaxCon ,@TDLndSur ,@TDIntDes ,@Business ,@TDIt ,@Subsid ,@TDArcht ,@TDAccid ,@TDEvntOr, @RiskXML) FOR XML PATH(''))
 

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

	
--Product Details	
	DECLARE	 
		 @ClientDt_EmpsAndDirec varchar(250)
        ,@ClientDt_EmpLiab bit
        ,@ClientDt_NumOfEmps varchar(250)
        ,@ClientDt_PubLiabCover varchar(250)
        ,@ClientDt_PubLiab bit
        ,@ClientDt_CoverType varchar(250)
        ,@ClientDt_LimitOfIndem varchar(250)
	SELECT	 
		 @ClientDt_EmpsAndDirec		= [EmpsAndDirec]
        ,@ClientDt_EmpLiab			= [EmpLiab]
        ,@ClientDt_NumOfEmps		= [NumOfEmps]
        ,@ClientDt_PubLiabCover		= [PubLiabCover]
        ,@ClientDt_PubLiab			= [PubLiab]
        ,@ClientDt_CoverType		= [CoverType]
        ,@ClientDt_LimitOfIndem		= [LimitOfIndem]
	FROM
		@ClientDt
	
	INSERT INTO @ProductDetail VALUES  ('Sums Insured')
	INSERT INTO @ProductDetail([Message])	VALUES(	'Professional Indemnity Limit = '+ [dbo].[svfFormatMoneyString](@ClientDt_LimitOfIndem))

	IF @ClientDt_PubLiab = 1
		INSERT INTO @ProductDetail([Message])	VALUES(	'Public Liability Cover of '+ [dbo].[svfFormatMoneyString](@ClientDt_PubLiabCover) + ' for ' + @ClientDt_NumOfEmps + ' employees')
	ELSE
		INSERT INTO @ProductDetail([Message])	VALUES(	'Public Liability Cover Not taken')
	
	IF @ClientDt_EmpLiab = 1
		INSERT INTO @ProductDetail([Message])	VALUES(	'Employers Liability Cover for ' + @ClientDt_EmpsAndDirec + ' employees')
	ELSE
		INSERT INTO @ProductDetail([Message])	VALUES(	'Employers Liability Cover Not taken')
	
	IF @SchemeTableID = 1455
	BEGIN
		DECLARE 
			 @TradeID [varchar](12) = (SELECT [RiskTrade_ID] FROM @ClientDt)
			,@ClaimType[varchar](30)
			,@Liability bit
			,@CharteredAccountant bit = (SELECT ISNULL([Chartered],0) FROM @TrdDtail)

		INSERT INTO @ProductDetail([Message]) SELECT [dbo].[MPROIND_svfDocumentSelect]( @SchemeTableID ,@TradeID	,@ClaimType	,@Liability	,@CharteredAccountant ,@PolicyStartDateTime )
	END

--Return Values


--Refer Premiums.
	IF @ReferCount > 0 
	BEGIN

		UPDATE
			@Premium 
		SET 
			[Value] = 
			CASE 
				WHEN [Name] = 'PROFPREM' AND ISNULL([Value],0) = 0 THEN 1
				WHEN [Name] = 'LIABPREM' AND ISNULL([Value],0) = 0 AND @ClientDt_PubLiab = 1 THEN 1
				WHEN [Name] = 'EMPLPREM' AND ISNULL([Value],0) = 0 AND @ClientDt_EmpLiab = 1 THEN 1
				ELSE [Value]
			END
	END


/*
Rule Based commission and Premium adjustment
*/
	DECLARE 
		 @LOB varchar(255) = 'Professional Indemnity'
		,@Trade varchar(255) 
		,@SecondaryTrade varchar(255) = 'None' 
		,@IndemnityLevel varchar(255) = @ClientDt_LimitOfIndem
		,@EmployeeLevel varchar(255)  = @ClientDt_NumOfEmps

		SELECT 
			@Trade = [RiskTrade]
			,@HistoryID = ISNULL(@HistoryID , [HistoryID])
		FROM
			@ClientDt

	SELECT @SchemeResultsXML = [dbo].[svfSchemeCommissionApportionment] (@SchemeTableID ,@AgentName ,@SubAgentID ,@PolicyQuoteStage ,@PolicyDetailsID ,@HistoryID ,@LOB ,@Trade ,@SecondaryTrade ,@IndemnityLevel ,@EmployeeLevel ,@Postcode ,@PolicyStartDateTime ,@Premium)

	INSERT INTO @ProductDetail
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//ProductDetail)') AS T(x) 

	INSERT INTO @Breakdown
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Breakdown)') AS T(x) 

	INSERT INTO @Premium2
	SELECT	T.X.value('(./Name[text()])[1]', 'varchar(20)'),T.X.value('(./Value[text()])[1]', 'money') ,ISNULL(T.X.value('(./PartnerCommission[text()])[1]', 'money'),0) ,ISNULL(T.X.value('(./AgentCommission[text()])[1]', 'money'),0) ,ISNULL(T.X.value('(./SubAgentCommission[text()])[1]', 'money'),0) FROM @SchemeResultsXML.nodes('(//Premium)') AS T(x) 
	
	-- Endorsements:
	
	DECLARE @Endorsements varchar(255) 
	SELECT 
		@Endorsements = COALESCE(@Endorsements + ',','') + [Message] 
	FROM 
		@Endorsement


	EXECUTE [dbo].[uspSchemeResults] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium2 ,@Endorsement
END	

