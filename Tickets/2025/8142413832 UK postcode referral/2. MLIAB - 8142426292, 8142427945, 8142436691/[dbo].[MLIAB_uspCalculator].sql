USE [Calculators]
GO
/****** Object:  StoredProcedure [dbo].[MLIAB_uspCalculator]    Script Date: 07/01/2025 08:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		System Generated
-- Date:        {Datetime}
-- Description: Boiler plate for translating wpd variables and returns can be regenerated apart from LOB level refers etc..
*******************************************************************************
-- Date			Who						Change

-- 02/10/2024   Linga                   Monday Ticket 6184978943: £10,000,000 PL limit on Axa Tradesman
--                                      - Solution: AXA Scheme does not cover "Personal Accident and Income Protection" and "Professional Indemnity". 
--                                                  Hence, Axa Scheme is excluded for 'PAASPREM' and 'PROFPREM' while updating Premiums to £1 

-- 09/10/2024   Linga                   Monday Ticket 6185012180: Refer Lift installers
--                                      - Solution: Companion Scheme does not cover "Personal Accident and Income Protection" and "Professional Indemnity". 
--                                                  Hence, Companion Scheme is excluded for 'PAASPREM' and 'PROFPREM' while updating Premiums to £1 
-- 15/11/2024	Simon					Monday Ticket 7859939201: renewal invites refer with a referral message of - "Roll Over to Companion at Renewal"
										For new business, if the effective date is 01st Jan 2025 onwards refer "scheme is no longer available"

-- 02/01/2025   Linga					Monday Ticket 8142413832: UK postcode Referral 
*******************************************************************************/
ALTER PROCEDURE [dbo].[MLIAB_uspCalculator]
	 @RiskXML XML
    ,@PolicyStartDateTime datetime = NULL
	,@InceptionStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
    ,@SchemeTableID int
	,@AgentName varchar(255)
    ,@SubAgentID char(32)
	,@OutputRisk bit = 0
	,@HistoryID int = NULL --Supplied If recalculating

AS
/*

    TRUNCATE TABLE [Transactor_Live].[dbo].[SchemeCommandDebug]
    SELECT * FROM [Transactor_Live].[dbo].[SchemeCommandDebug] WHERE [SchemeCommandText] LIKE '%MLIAB_uspCalculator%'

	CREATE TABLE RiskXML (RiskXML xml);
	INSERT INTO RiskXML(RiskXML) values(@RiskXML);
*/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
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

--{RiskTables}
	DECLARE @TrdDtail MLIAB_TrdDtailTableType
	INSERT INTO @TrdDtail( [HistoryID] ,[PolicyDetailsID] ,[EfficacyCover] ,[WorkshopPercent] ,[Workshop] ,[EmpsUsing] ,[FixedMachinery] ,[CavityWall] ,[Solvent] ,[Waterproofing] ,[Roofing] ,[Ventilation] ,[CorgiReg] ,[RoadSurfacing] ,[Paving] ,[MaxDepth] ,[MaxDepth_ID] ,[Phase] ,[SecondaryRisk] ,[SecondaryRisk_ID] ,[PrimaryRisk] ,[PrimaryRisk_ID] ,[CoverStartDate] ,[PresentInsurer] ,[PresentInsurer_ID])
    SELECT
		 T.X.value('(./HistoryID[text()])[1]', 'varchar(3)') AS [HistoryID]
		 ,T.X.value('(./PolicyDetailsID[text()])[1]', 'varchar(32)') AS [PolicyDetailsID]
		 ,ISNULL(T.X.value('(./EfficacyCover[text()])[1]', 'bit'),0) AS [EfficacyCover]
		 ,ISNULL(T.X.value('(./WorkshopPercent[text()])[1]', 'money'),0) AS [WorkshopPercent]
		 ,ISNULL(T.X.value('(./Workshop[text()])[1]', 'bit'),0) AS [Workshop]
		 ,ISNULL(T.X.value('(./EmpsUsing[text()])[1]', 'money'),0) AS [EmpsUsing]
		 ,ISNULL(T.X.value('(./FixedMachinery[text()])[1]', 'bit'),0) AS [FixedMachinery]
		 ,ISNULL(T.X.value('(./CavityWall[text()])[1]', 'bit'),0) AS [CavityWall]
		 ,ISNULL(T.X.value('(./Solvent[text()])[1]', 'bit'),0) AS [Solvent]
		 ,ISNULL(T.X.value('(./Waterproofing[text()])[1]', 'bit'),0) AS [Waterproofing]
		 ,ISNULL(T.X.value('(./Roofing[text()])[1]', 'bit'),0) AS [Roofing]
		 ,ISNULL(T.X.value('(./Ventilation[text()])[1]', 'bit'),0) AS [Ventilation]
		 ,ISNULL(T.X.value('(./CorgiReg[text()])[1]', 'bit'),0) AS [CorgiReg]
		 ,ISNULL(T.X.value('(./RoadSurfacing[text()])[1]', 'bit'),0) AS [RoadSurfacing]
		 ,ISNULL(T.X.value('(./Paving[text()])[1]', 'bit'),0) AS [Paving]
		 ,[LIST_MH_MAXDEPTH1].[MH_MAXDEPTH_Debug] AS [MaxDepth]
		 ,T.X.value('(./MaxDepth[text()])[1]', 'varchar(8)') AS [MaxDepth_ID]
		 ,ISNULL(T.X.value('(./Phase[text()])[1]', 'bit'),0) AS [Phase]
		 ,[LIST_MH_TRADE1].[MH_TRADE_Debug] AS [SecondaryRisk]
		 ,T.X.value('(./SecondaryRisk[text()])[1]', 'varchar(8)') AS [SecondaryRisk_ID]
		 ,[LIST_MH_TRADE2].[MH_TRADE_Debug] AS [PrimaryRisk]
		 ,T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)') AS [PrimaryRisk_ID]
		,CONVERT(datetime ,T.X.value('(./CoverStartDate[text()])[1]', 'varchar(30)'),103) AS [CoverStartDate]
		 ,[System_Insurer1].[INSURER_Debug] AS [PresentInsurer]
		 ,T.X.value('(./PresentInsurer[text()])[1]', 'varchar(8)') AS [PresentInsurer_ID]
	FROM
		@RiskXML.nodes('(//TrdDtail)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_MAXDEPTH] AS [LIST_MH_MAXDEPTH1] ON [LIST_MH_MAXDEPTH1].[MH_MAXDEPTH_ID] = T.X.value('(./MaxDepth[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_TRADE] AS [LIST_MH_TRADE1] ON [LIST_MH_TRADE1].[MH_TRADE_ID] = T.X.value('(./SecondaryRisk[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_TRADE] AS [LIST_MH_TRADE2] ON [LIST_MH_TRADE2].[MH_TRADE_ID] = T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)')
        JOIN [dbo].[System_Insurer] AS [System_Insurer1] ON [System_Insurer1].[INSURER_ID] = T.X.value('(./PresentInsurer[text()])[1]', 'varchar(8)')

	DECLARE @CInfo AS MLIAB_CInfoTableType
	INSERT INTO @CInfo( [ManDays] ,[TempInsurance] ,[BonaFideWR] ,[YrEstablished] ,[AnnualTurnover] ,[yrs] ,[YrsExp] ,[WrittenRA] ,[HealthSafety] ,[WhichAssoci] ,[WhichAssoci_ID] ,[AssociMem] ,[MaxHeight] ,[MaxHeight_ID] ,[HeatPercent] ,[Heat] ,[WorkSoley] ,[PsDrawings] ,[SupervisorWR] ,[LabourWR] ,[ClericalPAYE] ,[ManualPAYE] ,[ERNExempt] ,[ERNRef] ,[includeYN] ,[SubsidYN] ,[TotalEmployees] ,[NonManualEmps] ,[ManualEmps] ,[NonManuDirec] ,[ManualDirectors] ,[TotalPandP] ,[ManualWork] ,[CompanyStatus] ,[CompanyStatus_ID] ,[employeetool] ,[ToolValue] ,[ToolValue_ID] ,[ToolCover] ,[PubLiabLimit] ,[PubLiabLimit_ID])
    SELECT
		 ISNULL(T.X.value('(./ManDays[text()])[1]', 'money'),0) AS [ManDays]
		 ,ISNULL(T.X.value('(./TempInsurance[text()])[1]', 'bit'),0) AS [TempInsurance]
		 ,ISNULL(T.X.value('(./BonaFideWR[text()])[1]', 'money'),0) AS [BonaFideWR]
		 ,ISNULL(T.X.value('(./YrEstablished[text()])[1]', 'money'),0) AS [YrEstablished]
		 ,ISNULL(T.X.value('(./AnnualTurnover[text()])[1]', 'money'),0) AS [AnnualTurnover]
		 ,ISNULL(T.X.value('(./yrs[text()])[1]', 'money'),0) AS [yrs]
		 ,ISNULL(T.X.value('(./YrsExp[text()])[1]', 'money'),0) AS [YrsExp]
		 ,ISNULL(T.X.value('(./WrittenRA[text()])[1]', 'bit'),0) AS [WrittenRA]
		 ,ISNULL(T.X.value('(./HealthSafety[text()])[1]', 'bit'),0) AS [HealthSafety]
		 ,[LIST_MH_ASSOC_FED1].[MH_ASSOC_FED_Debug] AS [WhichAssoci]
		 ,T.X.value('(./WhichAssoci[text()])[1]', 'varchar(8)') AS [WhichAssoci_ID]
		 ,ISNULL(T.X.value('(./AssociMem[text()])[1]', 'bit'),0) AS [AssociMem]
		 ,[LIST_MH_MAXHEIGHT1].[MH_MAXHEIGHT_Debug] AS [MaxHeight]
		 ,T.X.value('(./MaxHeight[text()])[1]', 'varchar(8)') AS [MaxHeight_ID]
		 ,ISNULL(T.X.value('(./HeatPercent[text()])[1]', 'money'),0) AS [HeatPercent]
		 ,ISNULL(T.X.value('(./Heat[text()])[1]', 'bit'),0) AS [Heat]
		 ,ISNULL(T.X.value('(./WorkSoley[text()])[1]', 'bit'),0) AS [WorkSoley]
		 ,ISNULL(T.X.value('(./PsDrawings[text()])[1]', 'money'),0) AS [PsDrawings]
		 ,ISNULL(T.X.value('(./SupervisorWR[text()])[1]', 'money'),0) AS [SupervisorWR]
		 ,ISNULL(T.X.value('(./LabourWR[text()])[1]', 'money'),0) AS [LabourWR]
		 ,ISNULL(T.X.value('(./ClericalPAYE[text()])[1]', 'money'),0) AS [ClericalPAYE]
		 ,ISNULL(T.X.value('(./ManualPAYE[text()])[1]', 'money'),0) AS [ManualPAYE]
		 ,ISNULL(T.X.value('(./ERNExempt[text()])[1]', 'bit'),0) AS [ERNExempt]
		 ,T.X.value('(./ERNRef[text()])[1]', 'varchar(20)') AS [ERNRef]
		 ,ISNULL(T.X.value('(./includeYN[text()])[1]', 'bit'),0) AS [includeYN]
		 ,ISNULL(T.X.value('(./SubsidYN[text()])[1]', 'bit'),0) AS [SubsidYN]
		 ,ISNULL(T.X.value('(./TotalEmployees[text()])[1]', 'money'),0) AS [TotalEmployees]
		 ,ISNULL(T.X.value('(./NonManualEmps[text()])[1]', 'money'),0) AS [NonManualEmps]
		 ,ISNULL(T.X.value('(./ManualEmps[text()])[1]', 'money'),0) AS [ManualEmps]
		 ,ISNULL(T.X.value('(./NonManuDirec[text()])[1]', 'money'),0) AS [NonManuDirec]
		 ,ISNULL(T.X.value('(./ManualDirectors[text()])[1]', 'money'),0) AS [ManualDirectors]
		 ,ISNULL(T.X.value('(./TotalPandP[text()])[1]', 'money'),0) AS [TotalPandP]
		 ,ISNULL(T.X.value('(./ManualWork[text()])[1]', 'bit'),0) AS [ManualWork]
		 ,[LIST_MH_COSTATUS1].[MH_COSTATUS_Debug] AS [CompanyStatus]
		 ,T.X.value('(./CompanyStatus[text()])[1]', 'varchar(8)') AS [CompanyStatus_ID]
		 ,ISNULL(T.X.value('(./employeetool[text()])[1]', 'bit'),0) AS [employeetool]
		 ,[LIST_MH_COVTOOLS1].[MH_COVTOOLS_Debug] AS [ToolValue]
		 ,T.X.value('(./ToolValue[text()])[1]', 'varchar(8)') AS [ToolValue_ID]
		 ,ISNULL(T.X.value('(./ToolCover[text()])[1]', 'bit'),0) AS [ToolCover]
		 ,[LIST_MH_PUBLIAB1].[MH_PUBLIAB_Debug] AS [PubLiabLimit]
		 ,T.X.value('(./PubLiabLimit[text()])[1]', 'varchar(8)') AS [PubLiabLimit_ID]
	FROM
		@RiskXML.nodes('(//CInfo)') AS T(x) --Lookup table
		JOIN [dbo].[LIST_MH_ASSOC_FED] AS [LIST_MH_ASSOC_FED1] ON [LIST_MH_ASSOC_FED1].[MH_ASSOC_FED_ID] = T.X.value('(./WhichAssoci[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_MAXHEIGHT] AS [LIST_MH_MAXHEIGHT1] ON [LIST_MH_MAXHEIGHT1].[MH_MAXHEIGHT_ID] = T.X.value('(./MaxHeight[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_COSTATUS] AS [LIST_MH_COSTATUS1] ON [LIST_MH_COSTATUS1].[MH_COSTATUS_ID] = T.X.value('(./CompanyStatus[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_COVTOOLS] AS [LIST_MH_COVTOOLS1] ON [LIST_MH_COVTOOLS1].[MH_COVTOOLS_ID] = T.X.value('(./ToolValue[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_PUBLIAB] AS [LIST_MH_PUBLIAB1] ON [LIST_MH_PUBLIAB1].[MH_PUBLIAB_ID] = T.X.value('(./PubLiabLimit[text()])[1]', 'varchar(8)')

	DECLARE @PandP AS MLIAB_PandPTableType
	INSERT INTO @PandP([Status] ,[Status_ID] ,[Surname] ,[Forename] ,[Title] ,[Title_ID])
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

    DECLARE @BusSupp AS MLIAB_BusSuppTableType
	INSERT INTO @BusSupp([HandSDetails] ,[HandS] ,[TribunalDetails] ,[Tribunal] ,[DiscussDetails] ,[Discussions] ,[ReguDetails] ,[Regulations] ,[RedunDetails] ,[Redundancies] ,[EmpDisDetails] ,[EmpDispute] ,[Emps] ,[BusSuppCover])
    SELECT
		 T.X.value('(./HandSDetails[text()])[1]', 'varchar(100)') AS [HandSDetails]
		 ,ISNULL(T.X.value('(./HandS[text()])[1]', 'bit'),0) AS [HandS]
		 ,T.X.value('(./TribunalDetails[text()])[1]', 'varchar(100)') AS [TribunalDetails]
		 ,ISNULL(T.X.value('(./Tribunal[text()])[1]', 'bit'),0) AS [Tribunal]
		 ,T.X.value('(./DiscussDetails[text()])[1]', 'varchar(100)') AS [DiscussDetails]
		 ,ISNULL(T.X.value('(./Discussions[text()])[1]', 'bit'),0) AS [Discussions]
		 ,T.X.value('(./ReguDetails[text()])[1]', 'varchar(100)') AS [ReguDetails]
		 ,ISNULL(T.X.value('(./Regulations[text()])[1]', 'bit'),0) AS [Regulations]
		 ,T.X.value('(./RedunDetails[text()])[1]', 'varchar(100)') AS [RedunDetails]
		 ,ISNULL(T.X.value('(./Redundancies[text()])[1]', 'bit'),0) AS [Redundancies]
		 ,T.X.value('(./EmpDisDetails[text()])[1]', 'varchar(100)') AS [EmpDisDetails]
		 ,ISNULL(T.X.value('(./EmpDispute[text()])[1]', 'bit'),0) AS [EmpDispute]
		 ,ISNULL(T.X.value('(./Emps[text()])[1]', 'money'),0) AS [Emps]
		 ,ISNULL(T.X.value('(./BusSuppCover[text()])[1]', 'bit'),0) AS [BusSuppCover]
	FROM
		@RiskXML.nodes('(//BusSupp)') AS T(x) --Lookup table

    DECLARE @Subsid AS MLIAB_SubsidTableType
	INSERT INTO @Subsid( [SubsidInsurer] ,[SubsidInsurer_ID] ,[SubsidERN] ,[SubsidName])
    SELECT
		  [System_Insurer2].[INSURER_Debug] AS [SubsidInsurer]
		 ,T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)') AS [SubsidInsurer_ID]
		 ,T.X.value('(./SubsidERN[text()])[1]', 'varchar(20)') AS [SubsidERN]
		 ,T.X.value('(./SubsidName[text()])[1]', 'varchar(200)') AS [SubsidName]
	FROM
		@RiskXML.nodes('(//Subsid)') AS T(x) --Lookup table
        JOIN [dbo].[System_Insurer] AS [System_Insurer2] ON [System_Insurer2].[INSURER_ID] = T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)')
		
	DECLARE @CAR MLIAB_CARTableType
	INSERT INTO @CAR( [MaxHirPlantVal] ,[MaxHirPlantVal_ID] ,[HirPlantMacVal] ,[HirPlantMacVal_ID] ,[HireChargeVal] ,[HireChargeVal_ID] ,[OwnPlantMacVal] ,[OwnPlantMacVal_ID] ,[MaxContractVal] ,[MaxContractVal_ID] ,[coverhireplant] ,[coverplant] ,[Contractsworks])
    SELECT
		 [LIST_MH_CARMaxHirPlantVal1].[MH_CARMAXHIRPLANTVAL_Debug] AS [MaxHirPlantVal]
		 ,T.X.value('(./MaxHirPlantVal[text()])[1]', 'varchar(8)') AS [MaxHirPlantVal_ID]
		 ,[LIST_MH_CARHirPlantMacVal1].[MH_CARHIRPLANTMACVAL_Debug] AS [HirPlantMacVal]
		 ,T.X.value('(./HirPlantMacVal[text()])[1]', 'varchar(8)') AS [HirPlantMacVal_ID]
		 ,[LIST_MH_CARHireChargeVal1].[MH_CARHIRECHARGEVAL_Debug] AS [HireChargeVal]
		 ,T.X.value('(./HireChargeVal[text()])[1]', 'varchar(8)') AS [HireChargeVal_ID]
		 ,[LIST_MH_CAROwnPlantMacVal1].[MH_CAROWNPLANTMACVAL_Debug] AS [OwnPlantMacVal]
		 ,T.X.value('(./OwnPlantMacVal[text()])[1]', 'varchar(8)') AS [OwnPlantMacVal_ID]
		 ,[LIST_MH_CARMaxContractVal1].[MH_CARMAXCONTRACTVAL_Debug] AS [MaxContractVal]
		 ,T.X.value('(./MaxContractVal[text()])[1]', 'varchar(8)') AS [MaxContractVal_ID]
		 ,ISNULL(T.X.value('(./coverhireplant[text()])[1]', 'bit'),0) AS [coverhireplant]
		 ,ISNULL(T.X.value('(./coverplant[text()])[1]', 'bit'),0) AS [coverplant]
		 ,ISNULL(T.X.value('(./Contractsworks[text()])[1]', 'bit'),0) AS [Contractsworks]		 
	FROM
		@RiskXML.nodes('(//CAR)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_CARMaxHirPlantVal] AS [LIST_MH_CARMaxHirPlantVal1] ON [LIST_MH_CARMaxHirPlantVal1].[MH_CARMAXHIRPLANTVAL_ID] = T.X.value('(./MaxHirPlantVal[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_CARHirPlantMacVal] AS [LIST_MH_CARHirPlantMacVal1] ON [LIST_MH_CARHirPlantMacVal1].[MH_CARHIRPLANTMACVAL_ID] = T.X.value('(./HirPlantMacVal[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_CARHireChargeVal] AS [LIST_MH_CARHireChargeVal1] ON [LIST_MH_CARHireChargeVal1].[MH_CARHIRECHARGEVAL_ID] = T.X.value('(./HireChargeVal[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_CAROwnPlantMacVal] AS [LIST_MH_CAROwnPlantMacVal1] ON [LIST_MH_CAROwnPlantMacVal1].[MH_CAROWNPLANTMACVAL_ID] = T.X.value('(./OwnPlantMacVal[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_CARMaxContractVal] AS [LIST_MH_CARMaxContractVal1] ON [LIST_MH_CARMaxContractVal1].[MH_CARMAXCONTRACTVAL_ID] = T.X.value('(./MaxContractVal[text()])[1]', 'varchar(8)')

	DECLARE @AccIncom MLIAB_AccIncomTableType;
	INSERT INTO @AccIncom( [PeopleNum] ,[IncomeCover] ,[IncomeCover_ID] ,[AccidentCover] ,[AccidentCover_ID] ,[CoverYN])
    SELECT
		ISNULL(T.X.value('(./PeopleNum[text()])[1]', 'money'),0) AS [PeopleNum]
		,[LIST_MH_PAIncomeProtectionLevel1].[MH_PAINCOMEPROTECTIONLEVEL_Debug] AS [IncomeCover]
		,T.X.value('(./IncomeCover[text()])[1]', 'varchar(8)') AS [IncomeCover_ID]
		,[LIST_MH_PersonalAccidentLevel1].[MH_PERSONALACCIDENTLEVEL_Debug] AS [AccidentCover]
		,T.X.value('(./AccidentCover[text()])[1]', 'varchar(8)') AS [AccidentCover_ID]
		,ISNULL(T.X.value('(./CoverYN[text()])[1]', 'bit'),0) AS [CoverYN]
	FROM
		@RiskXML.nodes('(//AccIncom)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_PAIncomeProtectionLevel] AS [LIST_MH_PAIncomeProtectionLevel1] ON [LIST_MH_PAIncomeProtectionLevel1].[MH_PAINCOMEPROTECTIONLEVEL_ID] = T.X.value('(./IncomeCover[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_PersonalAccidentLevel] AS [LIST_MH_PersonalAccidentLevel1] ON [LIST_MH_PersonalAccidentLevel1].[MH_PERSONALACCIDENTLEVEL_ID] = T.X.value('(./AccidentCover[text()])[1]', 'varchar(8)')

	DECLARE @PAPeople MLIAB_PAPeopleTableType;
	INSERT INTO @PAPeople( [Title] ,[Title_ID] ,[UKResidentYN] ,[DateOfBirth] ,[Surname] ,[Forenames])
    SELECT
		[LIST_TITLE2].[TITLE_Debug] AS [Title]
		,T.X.value('(./Title[text()])[1]', 'varchar(8)') AS [Title_ID]
		,ISNULL(T.X.value('(./UKResidentYN[text()])[1]', 'bit'),0) AS [UKResidentYN]
		,CONVERT(datetime ,		T.X.value('(./DateOfBirth[text()])[1]', 'varchar(30)'),103) AS [DateOfBirth]
		,T.X.value('(./Surname[text()])[1]', 'varchar(50)') AS [Surname]
		,T.X.value('(./Forenames[text()])[1]', 'varchar(50)') AS [Forenames]
	FROM
		@RiskXML.nodes('(//PAPeople)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_TITLE] AS [LIST_TITLE2] ON [LIST_TITLE2].[TITLE_ID] = T.X.value('(./Title[text()])[1]', 'varchar(8)')

	DECLARE @ProfIndm MLIAB_ProfIndmTableType;
	INSERT INTO @ProfIndm( [DesignYN] ,[PILevel] ,[PILevel_ID] ,[PIYN])
    SELECT
		ISNULL(T.X.value('(./DesignYN[text()])[1]', 'bit'),0) AS [DesignYN]
		,[LIST_MH_ProfessionalIndemnityLevel1].[MH_PROFESSIONALINDEMNITYLEVEL_Debug] AS [PILevel]
		,T.X.value('(./PILevel[text()])[1]', 'varchar(8)') AS [PILevel_ID]
		,ISNULL(T.X.value('(./PIYN[text()])[1]', 'bit'),0) AS [PIYN]
	FROM
		@RiskXML.nodes('(//ProfIndm)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_ProfessionalIndemnityLevel] AS [LIST_MH_ProfessionalIndemnityLevel1] ON [LIST_MH_ProfessionalIndemnityLevel1].[MH_PROFESSIONALINDEMNITYLEVEL_ID] = T.X.value('(./PILevel[text()])[1]', 'varchar(8)')

	DECLARE @Claim ClaimTableType
	INSERT INTO @Claim ([Details] ,[Outstanding] ,[Paid] ,[Date] ,[Type])
	SELECT
		 T.X.value('(./Details[text()])[1]', 'varchar(500)')  AS [Details]	
		,T.X.value('(./Outstanding[text()])[1]', 'money') AS [Outstanding]	
		,T.X.value('(./Paid[text()])[1]', 'money') AS [Paid]	
		,convert(datetime ,T.X.value('(./Date[text()])[1]', 'varchar(100)'),103) AS [Date]
		,[CT].[MH_CLAIMTYPE_DEBUG] AS [Type]
	FROM
		@RiskXML.nodes('(//ClmDtail)') AS T(x)
		JOIN [dbo].[LIST_MH_CLAIMTYPE] AS [CT] ON [CT].[MH_CLAIMTYPE_ID] = T.X.value('(./Type[text()])[1]','varchar(8)')

--Claims
	DECLARE @ClaimsSummary ClaimSummaryTableType
    INSERT INTO @ClaimsSummary
	SELECT * FROM [dbo].[tvfClaimSummary](@RiskXML.query('./ClmSum') ,@PolicyStartDateTime )

--Employees
	DECLARE @EmployeesPAndP int = (SELECT COUNT(*) FROM  @PandP WHERE [Status] IN ('Manual' ,'Work Away'))
	DECLARE @EmployeeCounts EmployeeCountsTableType
	INSERT INTO @EmployeeCounts
	SELECT [T].* FROM 
		@CInfo AS [C] 
		CROSS APPLY [dbo].[tvfEmployeeCounts]([C].[CompanyStatus] ,@EmployeesPAndP ,[C].[ManualDirectors] ,[C].[ManualEmps] ,[C].[NonManuDirec] ,[C].[NonManualEmps] ,[C].[ManualWork]) AS [T]

	DECLARE @SchemeInsurer varchar(1000) = (SELECT top 1 [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)

	DECLARE 
		 @PolicyDetailsID char(32)
	SELECT 
		 @PolicyDetailsID = PolicyDetailsID 
	FROM
		@TrdDtail
			
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
			SET @PolicyQuoteStage = 'NB'
			
	END	
		
--IPT
	DECLARE @ChargeIPT bit = CASE WHEN @postcode like 'IM%' THEN 0 WHEN @postcode like 'GY%' THEN 0 WHEN @postcode like 'JE%' THEN 0 ELSE 1 END

--Product Details

	--INSERT INTO @ProductDetail	SELECT 'Sums Insured'
	INSERT INTO @ProductDetail	SELECT 'Public Liability = ' + PubLiabLimit FROM @CInfo
	INSERT INTO @ProductDetail	SELECT 'Employers Liability = '+ CASE WHEN EmployeesELManual != 0 THEN '£10,000,000' ELSE 'NOT TAKEN' END FROM @EmployeeCounts
	INSERT INTO @ProductDetail	SELECT 'Temporary Employees Liability = '+ CASE WHEN TempInsurance = 1 THEN '£10,000,000' ELSE 'NOT TAKEN' END FROM @CInfo
	INSERT INTO @ProductDetail	SELECT 'Tools = '+ CASE WHEN ToolCover = 1 THEN ToolValue + ' Per Person' ELSE 'NOT TAKEN' END FROM @CInfo
	INSERT INTO @ProductDetail	SELECT 'Fixed Machinery = '+ CASE WHEN FixedMachinery = 1 THEN (SELECT PubLiabLimit FROM @CInfo) ELSE 'NOT TAKEN' END FROM @TrdDtail
	INSERT INTO @ProductDetail	SELECT 'Personal Accident Income = '+ CASE WHEN [CoverYN] = 1 THEN [IncomeCover] ELSE 'NOT TAKEN' END FROM @AccIncom
	INSERT INTO @ProductDetail	SELECT 'Personal Accident = '+ CASE WHEN [CoverYN] = 1 THEN [AccidentCover] ELSE 'NOT TAKEN' END FROM @AccIncom
	INSERT INTO @ProductDetail	SELECT 'Professional Indemnity = '+ CASE WHEN [PIYN] = 1 THEN [PILevel] ELSE 'NOT TAKEN' END FROM @ProfIndm

--Refers

	--Assumptions	
	INSERT INTO @Refer([Message])
	SELECT [Message] FROM [dbo].[MLIAB_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);
	IF (SELECT CASE WHEN [C].[PrimaryRisk] = 'None' THEN 1 ELSE 0 END FROM @TrdDtail AS [C]) = 1
			INSERT INTO @Refer VALUES ('No Primary Trade has been selected.')

	--Insurer 
	IF @PolicyQuoteStage = 'NB' AND (SELECT CASE WHEN [C].[PresentInsurer] = @SchemeInsurer THEN 1 WHEN [C].[PresentInsurer] LIKE 'AXA%' AND @SchemeInsurer LIKE 'AXA%' THEN 1 ELSE 0 END FROM @TrdDtail AS [C]) = 1
		INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)

	--CAR
		DECLARE  @ReferCAR SchemeResultTableType
	INSERT INTO @ReferCAR
		  SELECT 'This Scheme does not allow Contractors All Risks' FROM @CAR WHERE @SchemeTableID NOT IN (1325,1311,878,1448,1463,1484,1488,1492) AND 1 IN ([coverhireplant],[coverplant],[Contractsworks])
	UNION SELECT 'You must provide a maximum Value of any one contract if Choosing Contract Work Cover' FROM @CAR WHERE [Contractsworks] = 1 AND  [MaxContractVal_ID] = 0
	UNION SELECT 'You must provide a Plant and Machinery Value if choosing Plant and Machinery Cover' FROM @CAR WHERE [coverplant] = 1 AND [OwnPlantMacVal_ID] = 0
	UNION SELECT 'You must provide a Total value for hired Plant and Machinery if choosing Plant and Machinery Cover' FROM @CAR WHERE [coverhireplant] = 1 AND [HirPlantMacVal_ID] = 0
	UNION SELECT 'You must provide a 12 month hire charges spend value if choosing Plant and Machinery Cover' FROM @CAR WHERE [coverhireplant] = 1 AND [HireChargeVal_ID] = 0
	UNION SELECT 'You must provide Maximum value of any one item if choosing Plant and Machinery Cover' FROM @CAR WHERE [coverhireplant] = 1 AND [MaxHirPlantVal_ID] = 0
	UNION SELECT 'Maximum value of any one item Cannot exceed Total Plant and Machinery Cover' FROM @CAR WHERE [coverhireplant] = 1 AND [dbo].[svfFormatNumber]([MaxHirPlantVal]) >  [dbo].[svfFormatNumber]([HirPlantMacVal])
	UNION SELECT 'Contract Works limit cannot be greater than Turnover' FROM @CAR ,@CInfo WHERE [Contractsworks] = 1 AND [dbo].[svfFormatNumber]([MaxContractVal]) > [AnnualTurnover]
	
	--PA
	INSERT INTO @Refer SELECT 'This Scheme does not cover Personal Accident' FROM @AccIncom WHERE @SchemeTableID NOT IN (878) AND [CoverYN] = 1 

	--PI
	INSERT INTO @Refer SELECT 'This Scheme does not cover Professional Indemnity' FROM @ProfIndm WHERE @SchemeTableID NOT IN (878) AND [PIYN] = 1

	--Renewal Invites (7859939201)
	INSERT INTO @Refer SELECT 'Roll Over to Companion at Renewal' FROM @AccIncom WHERE @SchemeTableID = 1325 AND @PolicyQuoteStage = 'REN';

	--New Business (7859939201)
	INSERT INTO @Refer SELECT 'Scheme is no longer available' FROM @AccIncom WHERE @SchemeTableID = 1325 AND @PolicyQuoteStage = 'NB' AND @PolicyStartDateTime >= '01 Jan 2025';

--Excess
	INSERT INTO @Excess
	SELECT [E].* FROM @CAR CROSS APPLY [dbo].[MLIAB_CAR_tvfExcess] ( @SchemeTableID,[Contractsworks],[coverplant],[coverhireplant],@PolicystartDateTime) AS [E]


--Employee
    IF( @SchemeTableID NOT IN (1595, 1606)) --Toledo Tradesman Liability
	BEGIN
	IF (SELECT [E].[EmployeesPL] FROM @EmployeeCounts AS [E]) IS NULL
			INSERT INTO @Decline VALUES ('No employees')	

	IF (SELECT [E].[EmployeesPL] FROM @EmployeeCounts AS [E]) = 0
			INSERT INTO @Decline VALUES ('You have not entered any manual workers')	

	IF (SELECT CASE WHEN [C].[CompanyStatus] = 'Limited' AND  ([C].[ManualDirectors] + [C].[NonManuDirec]) = 0 THEN 1 ELSE 0 END FROM @CInfo AS [C] ) = 1
			INSERT INTO @Refer VALUES ('Limited Company: Total Number of Directors are 0')
    END

--Declines
    
	-- Decline invalid postcode (8142413832)
    IF([dbo].[svfValidateUKPostcode](@PostCode) = 0)
	        INSERT INTO @Decline VALUES ('Invalid Postcode');
	
--Debugging
	IF @OutputRisk = 1
	BEGIN
		IF (SELECT COUNT(*) FROM @TrdDtail) != 0 SELECT 'TrdDtail' AS [Table] ,* FROM @TrdDtail
		IF (SELECT COUNT(*) FROM @CInfo) != 0 SELECT 'CInfo' AS [Table] ,* FROM @CInfo
		IF (SELECT COUNT(*) FROM @PandP) != 0 SELECT 'PandP' AS [Table] ,* FROM @PandP
		IF (SELECT COUNT(*) FROM @BusSupp) != 0 SELECT 'BusSupp' AS [Table] ,* FROM @BusSupp
		IF (SELECT COUNT(*) FROM @Subsid) != 0 SELECT 'Subsid' AS [Table] ,* FROM @Subsid
		IF (SELECT COUNT(*) FROM @CAR) != 0 SELECT 'CAR' AS [Table] ,* FROM @CAR
		IF (SELECT COUNT(*) FROM @AccIncom) != 0 SELECT 'AccIncom' AS [Table] ,* FROM @AccIncom
		IF (SELECT COUNT(*) FROM @PAPeople) != 0 SELECT 'PAPeople' AS [Table] ,* FROM @PAPeople
		IF (SELECT COUNT(*) FROM @ProfIndm) != 0 SELECT 'ProfIndm' AS [Table] ,* FROM @ProfIndm
		IF (SELECT COUNT(*) FROM @Claim) != 0 SELECT 'ClmDtail' AS [Table] , * FROM @Claim

		SELECT 'ClaimsSummary' AS [tvf] ,* FROM @ClaimsSummary
		IF (SELECT COUNT(*) FROM [dbo].[MLIAB_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime)) != 0 SELECT 'Assumptions' AS [tvf] ,[Message] FROM [dbo].[MLIAB_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);
		SELECT 'EmployeeCounts' AS [tvf] ,* FROM @EmployeeCounts
		SELECT @PolicyStartDateTime AS [PolicyStartDateTime],@PolicyQuoteStage AS [PolicyQuoteStage] ,@PostCode AS [Postcode] ,@SchemeTableID AS [SchemeTableID] ,@SchemeInsurer AS [SchemeInsurer]
	END	
		

--MLIAB_tvfSchemeDispatcher
	    DECLARE @SchemeResultsXML xml
	    SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM [dbo].[MLIAB_tvfSchemeDispatcher] (@SchemeTableID ,@PolicyDetailsID ,@PreviousPolicyHistoryID ,@PolicyStartDateTime ,@InceptionStartDateTime ,@PolicyQuoteStage ,@PolicyQuoteStageMTA ,@PostCode  , @AgentName, @ClaimsSummary ,@EmployeeCounts ,@TrdDtail ,@CInfo ,@PandP ,@BusSupp ,@Subsid ,@CAR ,@AccIncom ,@PAPeople ,@ProfIndm ,@Claim ) FOR XML PATH(''))

--Shred Scheme results
	INSERT INTO @Decline
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(2000)') FROM @SchemeResultsXML.nodes('(//Decline)') AS T(x) 

	INSERT INTO @Refer
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(2000)') FROM @SchemeResultsXML.nodes('(//Refer)') AS T(x) 
	
	INSERT INTO @ReferCAR
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(2000)') FROM @SchemeResultsXML.nodes('(//SchemeResultSet[@SubLOBName="CAR"]/Refer)') AS T(x) 

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

	INSERT INTO @Premium ([Name] ,[Value]) VALUES ('LIABPREM',0),('EMPLPREM',0),('TOOLPREM',0),('FXMCPREM',0),('CWRKPREM',0),('PLMAPREM',0),('HIPLPREM',0),('PAASPREM',0),('PROFPREM',0),('NONMPREM',0)	

	;WITH [V] AS
	(
		SELECT
			 T.X.value('(./Name[text()])[1]', 'varchar(20)') AS [Name]
			,T.X.value('(./Value[text()])[1]', 'money') AS [Value]
		FROM 
			@SchemeResultsXML.nodes('(//Premium)') AS T(x) 
	)
	UPDATE
		[P]
	SET 
		[P].[Value] = ISNULL([V].[Value],0)
	FROM
		@Premium AS [P]
		LEFT JOIN [V] ON [P].[Name] = [V].[Name]	

		DECLARE @PremiumTotal money = ISNULL((SELECT SUM([Value]) FROM @Premium),0)
		IF @PremiumTotal = 0
			INSERT INTO @Refer Values ('Premium Total cannot be £0.00')

--Save Calculated Policy Scheme Details 
	IF @SchemeTableID != 878 --Not Price MAtch (Not Covea but will do for now)
	BEGIN	
		DECLARE @SchemeDetails xml = (SELECT @SchemeResultsXML.query('(//SchemeDetails/*)') FOR XML PATH('SchemeDetails'))
		IF (SELECT @SchemeDetails.value('(count(SchemeDetails/*))','int')) >0
		BEGIN
			DECLARE @SchemePremiums xml = (SELECT @SchemeResultsXML.query('(//Premium)') FOR XML PATH('Premiums'))	
			DECLARE @RiskCheckSum int = (SELECT @SchemeDetails.value('(//RiskCheckSum[text()])[1]', 'int'))
			DECLARE @SchemePolicyDetailsID bigint 
			EXECUTE @SchemePolicyDetailsID = [dbo].[uspSchemePolicyDetailsInsert] 
			   @SchemeTableID
			  ,@PolicyDetailsID
			  ,@PolicyQuoteStage
			  ,@PolicyQuoteStageMTA
			  ,@PreviousPolicyHistoryID
			  ,@PolicyStartDateTime
			  ,@RiskCheckSum
			  ,@SchemePremiums
			  ,@SchemeDetails
			  ,@HistoryID
			  
			INSERT INTO @ProductDetail VALUES ('<SchemePolicyDetailsID>' + CAST(@SchemePolicyDetailsID AS varchar(11)) + '</SchemePolicyDetailsID>')
		END
	END
--Remove PI Endorsment
	--Covea
	DELETE [E] FROM @Endorsement AS [E] CROSS JOIN 	@ProfIndm AS [P] WHERE [P].[PIYN] = 1 AND [E].[Message] = 'MMALIA39'

--Covid endorsement 
	--IF @SchemeTableID in (1488) --Square Peg
	--	INSERT INTO @Endorsement VALUES ('SQPTL001')

--Summary
	INSERT INTO @Summary([Message])	VALUES(	'Quote Date :' + CONVERT(varchar(11) ,GETDATE(),106))
	INSERT INTO @Summary([Message])	VALUES(	'Quote is valid for 30 days' )

--Return Values
	DECLARE @Endorsements varchar(255) 
	SELECT 
		@Endorsements = COALESCE(@Endorsements + ',','') + [Message] 
	FROM 
		@Endorsement
		

	DECLARE  @EmployeesELManual int = 0
			,@EmployeesELNonManual int = 0
	SELECT 
		 @EmployeesELManual = [EmployeesELManual]
		,@EmployeesELNonManual = [EmployeesELNonManual] 
	FROM 
		@EmployeeCounts			

	DECLARE @CInfo_TempInsurance bit = (SELECT [TempInsurance] FROM @CInfo)
	DECLARE @CInfo_ToolCover bit = (SELECT [ToolCover] FROM @CInfo)
	DECLARE @TrdDtail_FixedMachinery bit = (SELECT [FixedMachinery] FROM @TrdDtail)
	DECLARE @CAR_ContractsWorks bit = (SELECT [ContractsWorks] FROM @CAR)
	DECLARE @CAR_CoverPlant bit = (SELECT [CoverPlant] FROM @CAR)
	DECLARE @CAR_CoverHirePlant bit = (SELECT [CoverHirePlant] FROM @CAR)
	DECLARE @AccIncom_CoverYN bit = (SELECT [CoverYN] FROM @AccIncom)
	DECLARE @ProfIndmTable_PIYN bit = (SELECT [PIYN] FROM @ProfIndm)			

	INSERT INTO @Refer 
		  SELECT 'Public Liability cannot be £0.00'				FROM @Premium WHERE [Name] = 'LIABPREM' AND ISNULL([Value],0) = 0
	UNION SELECT 'Employees Liability cannot be £0.00'			FROM @Premium WHERE	[Name] = 'EMPLPREM' AND ISNULL([Value],0) = 0 AND (@EmployeesELManual > 0)		
	UNION SELECT 'Tool Cover cannot be £0.00'					FROM @Premium WHERE	[Name] = 'TOOLPREM' AND ISNULL([Value],0) = 0 AND @CInfo_ToolCover = 1			
	UNION SELECT 'Fixed Machinery Cover cannot be £0.00'		FROM @Premium WHERE	[Name] = 'FXMCPREM' AND ISNULL([Value],0) = 0 AND @TrdDtail_FixedMachinery = 1 
	UNION SELECT 'Contract Works Cover cannot be £0.00'			FROM @Premium WHERE	[Name] = 'CWRKPREM' AND ISNULL([Value],0) = 0 AND @CAR_ContractsWorks = 1		
	UNION SELECT 'Own Plant Cover cannot be £0.00'				FROM @Premium WHERE	[Name] = 'PLMAPREM' AND ISNULL([Value],0) = 0 AND @CAR_CoverPlant = 1			
	UNION SELECT 'Hired Plant Cover cannot be £0.00'			FROM @Premium WHERE	[Name] = 'HIPLPREM' AND ISNULL([Value],0) = 0 AND @CAR_CoverHirePlant = 1		
	UNION SELECT 'Accident Income Cover cannot be £0.00'		FROM @Premium WHERE	[Name] = 'PAASPREM' AND ISNULL([Value],0) = 0 AND @AccIncom_CoverYN = 1		
	UNION SELECT 'Professional Indemnity Cover cannot be £0.00'	FROM @Premium WHERE	[Name] = 'PROFPREM' AND ISNULL([Value],0) = 0 AND @ProfIndmTable_PIYN = 1		

--Table Counts
	DECLARE @ReferCount int = (SELECT COUNT(*) FROM @Refer)
	DECLARE @DeclineCount int = (SELECT COUNT(*) FROM @Decline)
--Refer Premiums.
	IF @ReferCount > 0 
	BEGIN

		--Premium void
		IF EXISTS (SELECT [Message] FROM @Refer WHERE [Message] = 'Premiums Voided')
		BEGIN
			UPDATE @Premium SET [Value] = 0
			DELETE FROM @Breakdown
		END

		UPDATE
			@Premium 
		SET 
			[Value] = 
			CASE 
				WHEN [Name] = 'EMPLPREM' AND ISNULL([Value],0) = 0 AND (@EmployeesELManual > 0  OR @CInfo_TempInsurance = 1 ) THEN 1
				WHEN [Name] = 'LIABPREM' AND ISNULL([Value],0) = 0 THEN 1
				WHEN [Name] = 'TOOLPREM' AND ISNULL([Value],0) = 0 AND @CInfo_ToolCover = 1 THEN 1
				WHEN [Name] = 'FXMCPREM' AND ISNULL([Value],0) = 0 AND @TrdDtail_FixedMachinery = 1 THEN 1
				WHEN [Name] = 'CWRKPREM' AND ISNULL([Value],0) = 0 AND @CAR_ContractsWorks = 1 THEN 1
				WHEN [Name] = 'PLMAPREM' AND ISNULL([Value],0) = 0 AND @CAR_CoverPlant = 1 THEN 1
				WHEN [Name] = 'HIPLPREM' AND ISNULL([Value],0) = 0 AND @CAR_CoverHirePlant = 1 THEN 1
				WHEN [Name] = 'PAASPREM' AND ISNULL([Value],0) = 0 AND @AccIncom_CoverYN = 1 AND @SchemeTableID NOT IN (1325, 1448) /*axa, Companion*/ THEN 1
				WHEN [Name] = 'PROFPREM' AND ISNULL([Value],0) = 0 AND @ProfIndmTable_PIYN = 1 AND @SchemeTableID NOT IN (1325, 1448) /*axa, Companion*/ THEN 1
				WHEN [Name] = 'NONMPREM' AND ISNULL([Value],0) = 0 AND @EmployeesELManual = 0 AND @EmployeesELNonManual != 0  AND @SchemeTableID != 1606 THEN 1
				ELSE [Value]
			END
	END
	

/*
Rule Based commission and Premium adjustment
*/
	DECLARE 
		 @LOB varchar(255) = 'Tradesman Liability'
		,@Trade varchar(255) 
		,@SecondaryTrade varchar(255) 
		,@IndemnityLevel varchar(255) = (SELECT PubLiabLimit FROM @CInfo)
		,@EmployeeLevel varchar(255)  = (SELECT TotalEmployees FROM @EmployeeCounts)

		SELECT 
			 @Trade = PrimaryRisk
			,@SecondaryTrade = SecondaryRisk 
			,@HistoryID = ISNULL(@HistoryID , [HistoryID])
		FROM
			@TrdDtail

	SELECT @SchemeResultsXML = [dbo].[svfSchemeCommissionApportionment] (@SchemeTableID ,@AgentName ,@SubAgentID ,@PolicyQuoteStage ,@PolicyDetailsID ,@HistoryID ,@LOB ,@Trade ,@SecondaryTrade ,@IndemnityLevel ,@EmployeeLevel ,@Postcode ,@PolicyStartDateTime ,@Premium)

	INSERT INTO @ProductDetail
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//ProductDetail)') AS T(x) 

	INSERT INTO @Breakdown
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Breakdown)') AS T(x) 

	INSERT INTO @Premium2
	SELECT	T.X.value('(./Name[text()])[1]', 'varchar(20)'),T.X.value('(./Value[text()])[1]', 'money') ,T.X.value('(./PartnerCommission[text()])[1]', 'money') ,T.X.value('(./AgentCommission[text()])[1]', 'money') ,T.X.value('(./SubAgentCommission[text()])[1]', 'money') FROM @SchemeResultsXML.nodes('(//Premium)') AS T(x) 

	EXECUTE [dbo].[MLIAB_uspSchemeResults] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium2 ,@Endorsement ,@ReferCar
	--SELECT * FROM @Premium2	
	--INSERT INTO [Transactor_Support].[dbo].[TestResultsRefer] SELECT @PolicyDetailsID ,@HistoryID ,[Message] FROM @Refer
END;

