USE [Calculators]
GO
/****** Object:  StoredProcedure [dbo].[MLETPROP_uspCalculator]    Script Date: 21/01/2025 07:44:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		System Generated
-- Date:        26 Feb 2024
-- Description: Boiler plate for translating wpd variables and returns can be regenerated apart from LOB level refers etc..
*******************************************************************************/

-- Date			Who						Change
-- 05/03/2024	Jeremai Smith			Added PropertyNum and OccupancyNum columns as part of Toledo development in order to link the child Occupancy
--										records to the correct parent Property record
-- 12/04/2024	Jeremai Smith			Call uspSchemeResults50XS instead of uspSchemeResults to allow more excess rows (Monday.com ticket 6380270288)

/************************************************************************************************************************************************
WARNING: IF REPLACING THIS PROCEDURE WITH A NEW VERSION PRODUCED BY TGSLLOBSCHEMEBUILDER (TO PICK UP NEW SCREEN FIELDS, ETC) BE SURE TO MERGE THE
ABOVE CHANGES BACK IN!!!! USE A SCRIPT COMPARISON TOOL E.G. BEYOND COMPARE.
*************************************************************************************************************************************************/


ALTER PROCEDURE [dbo].[MLETPROP_uspCalculator]
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
    SELECT * FROM [Transactor_Live].[dbo].[uspSchemeCommandDebug] WHERE [uspSchemeCommandText] LIKE '%MLETPROP_uspCalculator%'

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

	DECLARE @PropInfo MLETPROP_PropInfoTableType;
	INSERT INTO @PropInfo( [IncludeYN] ,[SubsidYN] ,[Properties] ,[Yrs] ,[Established] ,[Trade] ,[Trade_ID] ,[PolicyExpire] ,[Insurer] ,[Insurer_ID] ,[CovStart])
    SELECT
		ISNULL(T.X.value('(./IncludeYN[text()])[1]', 'bit'),0) AS [IncludeYN]
		,ISNULL(T.X.value('(./SubsidYN[text()])[1]', 'bit'),0) AS [SubsidYN]
		,ISNULL(T.X.value('(./Properties[text()])[1]', 'money'),0) AS [Properties]
		,ISNULL(T.X.value('(./Yrs[text()])[1]', 'money'),0) AS [Yrs]
		,CONVERT(datetime ,		T.X.value('(./Established[text()])[1]', 'varchar(30)'),103) AS [Established]
		,[LIST_MH_TRADE1].[MH_TRADE_Debug] AS [Trade]
		,T.X.value('(./Trade[text()])[1]', 'varchar(8)') AS [Trade_ID]
		,CONVERT(datetime ,		T.X.value('(./PolicyExpire[text()])[1]', 'varchar(30)'),103) AS [PolicyExpire]
		,[System_Insurer1].[INSURER_Debug] AS [Insurer]
		,T.X.value('(./Insurer[text()])[1]', 'varchar(8)') AS [Insurer_ID]
		,CONVERT(datetime ,		T.X.value('(./CovStart[text()])[1]', 'varchar(30)'),103) AS [CovStart]
	FROM
		@RiskXML.nodes('(//PropInfo)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_TRADE] AS [LIST_MH_TRADE1] ON [LIST_MH_TRADE1].[MH_TRADE_ID] = T.X.value('(./Trade[text()])[1]', 'varchar(8)')
        JOIN [dbo].[System_Insurer] AS [System_Insurer1] ON [System_Insurer1].[INSURER_ID] = T.X.value('(./Insurer[text()])[1]', 'varchar(8)')

	
	DECLARE @PrpDtail MLETPROP_PrpDtailTableType;
	
	INSERT INTO @PrpDtail([PropertyNum], [BusActivities] ,[BusActivities_ID] ,[Business] ,[BusiActivities] ,[Cooking] ,[Convictions] ,[PropUnOccupied] ,[FireAlarm] ,[FireStation] ,[FireSuppression] ,[IEE] ,[Maintenance] ,[Alarm] ,[Sprinkler] ,[OccuType] ,[OccuType_ID] ,[FireCover] ,[ContentsTotal] ,[Whitegoods] ,[LandlordsSI] ,[Carpets] ,[LandlordsCont] ,[Accidental] ,[BuildingsSI] ,[RentIncome] ,[FinanceDetails] ,[rentlosscover] ,[AccountNum] ,[FinancialIntr] ,[Unoccupied] ,[PropBoardedUp] ,[Occupied] ,[SecondHome] ,[HolidayLet] ,[NonStructWork] ,[NonStructWork_ID] ,[Structuralwork] ,[Structuralwork_ID] ,[BuildingWork] ,[RoofConstruct] ,[RoofConstruct_ID] ,[WallConstruct] ,[WallConstruct_ID] ,[FiveyrsPlus] ,[Stories] ,[Stories_ID] ,[Listed] ,[Listed_ID] ,[ConstructYr] ,[Scotland] ,[FlatsNum] ,[OwnEntire] ,[BuildingType] ,[BuildingType_ID] ,[County] ,[Town] ,[AddThree] ,[AddTwo] ,[AddOne] ,[Postcode] ,[Part])
    SELECT
		 T.x.value('let $i := . return count(../PrpDtail[. << $i])', 'int') + 1  AS [PropertyNum] -- Custom field not produced by TGSLLOBSchemeBuilder; used for linking child Occupancy records to correct parent Property record
		,[LIST_MH_BUSINESS_ACTIVITY1].[MH_BUSINESS_ACTIVITY_Debug] AS [BusActivities]
		,T.X.value('(./BusActivities[text()])[1]', 'varchar(8)') AS [BusActivities_ID]
		,ISNULL(T.X.value('(./Business[text()])[1]', 'bit'),0) AS [Business]
		,T.X.value('(./BusiActivities[text()])[1]', 'varchar(200)') AS [BusiActivities]
		,ISNULL(T.X.value('(./Cooking[text()])[1]', 'bit'),0) AS [Cooking]
		,ISNULL(T.X.value('(./Convictions[text()])[1]', 'bit'),0) AS [Convictions]
		,CONVERT(datetime ,		T.X.value('(./PropUnOccupied[text()])[1]', 'varchar(30)'),103) AS [PropUnOccupied]
		,ISNULL(T.X.value('(./FireAlarm[text()])[1]', 'bit'),0) AS [FireAlarm]
		,ISNULL(T.X.value('(./FireStation[text()])[1]', 'bit'),0) AS [FireStation]
		,ISNULL(T.X.value('(./FireSuppression[text()])[1]', 'bit'),0) AS [FireSuppression]
		,ISNULL(T.X.value('(./IEE[text()])[1]', 'bit'),0) AS [IEE]
		,ISNULL(T.X.value('(./Maintenance[text()])[1]', 'bit'),0) AS [Maintenance]
		,ISNULL(T.X.value('(./Alarm[text()])[1]', 'bit'),0) AS [Alarm]
		,ISNULL(T.X.value('(./Sprinkler[text()])[1]', 'bit'),0) AS [Sprinkler]
		,[LIST_MH_RESOCC1].[MH_RESOCC_Debug] AS [OccuType]
		,T.X.value('(./OccuType[text()])[1]', 'varchar(8)') AS [OccuType_ID]
		,ISNULL(T.X.value('(./FireCover[text()])[1]', 'bit'),0) AS [FireCover]
		,ISNULL(T.X.value('(./ContentsTotal[text()])[1]', 'money'),0) AS [ContentsTotal]
		,ISNULL(T.X.value('(./Whitegoods[text()])[1]', 'money'),0) AS [Whitegoods]
		,ISNULL(T.X.value('(./LandlordsSI[text()])[1]', 'money'),0) AS [LandlordsSI]
		,ISNULL(T.X.value('(./Carpets[text()])[1]', 'money'),0) AS [Carpets]
		,ISNULL(T.X.value('(./LandlordsCont[text()])[1]', 'bit'),0) AS [LandlordsCont]
		,ISNULL(T.X.value('(./Accidental[text()])[1]', 'bit'),0) AS [Accidental]
		,ISNULL(T.X.value('(./BuildingsSI[text()])[1]', 'money'),0) AS [BuildingsSI]
		,ISNULL(T.X.value('(./RentIncome[text()])[1]', 'money'),0) AS [RentIncome]
		,T.X.value('(./FinanceDetails[text()])[1]', 'varchar(200)') AS [FinanceDetails]
		,ISNULL(T.X.value('(./rentlosscover[text()])[1]', 'bit'),0) AS [rentlosscover]
		,ISNULL(T.X.value('(./AccountNum[text()])[1]', 'money'),0) AS [AccountNum]
		,ISNULL(T.X.value('(./FinancialIntr[text()])[1]', 'bit'),0) AS [FinancialIntr]
		,ISNULL(T.X.value('(./Unoccupied[text()])[1]', 'money'),0) AS [Unoccupied]
		,ISNULL(T.X.value('(./PropBoardedUp[text()])[1]', 'bit'),0) AS [PropBoardedUp]
		,ISNULL(T.X.value('(./Occupied[text()])[1]', 'bit'),0) AS [Occupied]
		,ISNULL(T.X.value('(./SecondHome[text()])[1]', 'bit'),0) AS [SecondHome]
		,ISNULL(T.X.value('(./HolidayLet[text()])[1]', 'bit'),0) AS [HolidayLet]
		,[LIST_VALUE_NONSTRUCTURAL_WORK1].[VALUE_NONSTRUCTURAL_WORK_Debug] AS [NonStructWork]
		,T.X.value('(./NonStructWork[text()])[1]', 'varchar(8)') AS [NonStructWork_ID]
		,[LIST_VALUE_STRUCTURAL_WORK1].[VALUE_STRUCTURAL_WORK_Debug] AS [Structuralwork]
		,T.X.value('(./Structuralwork[text()])[1]', 'varchar(8)') AS [Structuralwork_ID]
		,ISNULL(T.X.value('(./BuildingWork[text()])[1]', 'bit'),0) AS [BuildingWork]
		,[LIST_ROOF_CONSTRUCTION1].[ROOF_CONSTRUCTION_Debug] AS [RoofConstruct]
		,T.X.value('(./RoofConstruct[text()])[1]', 'varchar(8)') AS [RoofConstruct_ID]
		,[LIST_WALL_CONSTRUCTION1].[WALL_CONSTRUCTION_Debug] AS [WallConstruct]
		,T.X.value('(./WallConstruct[text()])[1]', 'varchar(8)') AS [WallConstruct_ID]
		,CONVERT(datetime ,		T.X.value('(./FiveyrsPlus[text()])[1]', 'varchar(30)'),103) AS [FiveyrsPlus]
		,[LIST_MH_STORIES1].[MH_STORIES_Debug] AS [Stories]
		,T.X.value('(./Stories[text()])[1]', 'varchar(8)') AS [Stories_ID]
		,[LIST_MH_LISTED1].[MH_LISTED_Debug] AS [Listed]
		,T.X.value('(./Listed[text()])[1]', 'varchar(8)') AS [Listed_ID]
		,ISNULL(T.X.value('(./ConstructYr[text()])[1]', 'money'),0) AS [ConstructYr]
		,ISNULL(T.X.value('(./Scotland[text()])[1]', 'bit'),0) AS [Scotland]
		,ISNULL(T.X.value('(./FlatsNum[text()])[1]', 'money'),0) AS [FlatsNum]
		,ISNULL(T.X.value('(./OwnEntire[text()])[1]', 'bit'),0) AS [OwnEntire]
		,[LIST_MH_BUILDING1].[MH_BUILDING_Debug] AS [BuildingType]
		,T.X.value('(./BuildingType[text()])[1]', 'varchar(8)') AS [BuildingType_ID]
		,T.X.value('(./County[text()])[1]', 'varchar(50)') AS [County]
		,T.X.value('(./Town[text()])[1]', 'varchar(50)') AS [Town]
		,T.X.value('(./AddThree[text()])[1]', 'varchar(50)') AS [AddThree]
		,T.X.value('(./AddTwo[text()])[1]', 'varchar(50)') AS [AddTwo]
		,T.X.value('(./AddOne[text()])[1]', 'varchar(50)') AS [AddOne]
		,REPLACE(T.X.value('(./Postcode[text()])[1]', 'varchar(12)'),' ','') AS [Postcode]
		,ISNULL(T.X.value('(./Part[text()])[1]', 'bit'),0) AS [Part]
	FROM
		@RiskXML.nodes('(//PrpDtail)') AS T(x)
		-- Lookup tables:
        JOIN [dbo].[LIST_MH_BUSINESS_ACTIVITY] AS [LIST_MH_BUSINESS_ACTIVITY1] ON [LIST_MH_BUSINESS_ACTIVITY1].[MH_BUSINESS_ACTIVITY_ID] = T.X.value('(./BusActivities[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_RESOCC] AS [LIST_MH_RESOCC1] ON [LIST_MH_RESOCC1].[MH_RESOCC_ID] = T.X.value('(./OccuType[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_VALUE_NONSTRUCTURAL_WORK] AS [LIST_VALUE_NONSTRUCTURAL_WORK1] ON [LIST_VALUE_NONSTRUCTURAL_WORK1].[VALUE_NONSTRUCTURAL_WORK_ID] = T.X.value('(./NonStructWork[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_VALUE_STRUCTURAL_WORK] AS [LIST_VALUE_STRUCTURAL_WORK1] ON [LIST_VALUE_STRUCTURAL_WORK1].[VALUE_STRUCTURAL_WORK_ID] = T.X.value('(./Structuralwork[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_ROOF_CONSTRUCTION] AS [LIST_ROOF_CONSTRUCTION1] ON [LIST_ROOF_CONSTRUCTION1].[ROOF_CONSTRUCTION_ID] = T.X.value('(./RoofConstruct[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_WALL_CONSTRUCTION] AS [LIST_WALL_CONSTRUCTION1] ON [LIST_WALL_CONSTRUCTION1].[WALL_CONSTRUCTION_ID] = T.X.value('(./WallConstruct[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_STORIES] AS [LIST_MH_STORIES1] ON [LIST_MH_STORIES1].[MH_STORIES_ID] = T.X.value('(./Stories[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_LISTED] AS [LIST_MH_LISTED1] ON [LIST_MH_LISTED1].[MH_LISTED_ID] = T.X.value('(./Listed[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_BUILDING] AS [LIST_MH_BUILDING1] ON [LIST_MH_BUILDING1].[MH_BUILDING_ID] = T.X.value('(./BuildingType[text()])[1]', 'varchar(8)')


	DECLARE @AddCover MLETPROP_AddCoverTableType;
	
	INSERT INTO @AddCover( [ERNExempt] ,[ERNRef] ,[AnnualWages] ,[TotalEmp] ,[EmpLiab] ,[ExcessAmount] ,[ExcessAmount_ID] ,[ExcessYN])
    SELECT
		 ISNULL(T.X.value('(./ERNExempt[text()])[1]', 'bit'),0) AS [ERNExempt]
		,T.X.value('(./ERNRef[text()])[1]', 'varchar(20)') AS [ERNRef]
		,ISNULL(T.X.value('(./AnnualWages[text()])[1]', 'money'),0) AS [AnnualWages]
		,ISNULL(T.X.value('(./TotalEmp[text()])[1]', 'money'),0) AS [TotalEmp]
		,ISNULL(T.X.value('(./EmpLiab[text()])[1]', 'bit'),0) AS [EmpLiab]
		,[LIST_MH_LET_VOLXS1].[MH_LET_VOLXS_Debug] AS [ExcessAmount]
		,T.X.value('(./ExcessAmount[text()])[1]', 'varchar(8)') AS [ExcessAmount_ID]
		,ISNULL(T.X.value('(./ExcessYN[text()])[1]', 'bit'),0) AS [ExcessYN]
	FROM
		@RiskXML.nodes('(//AddCover)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_LET_VOLXS] AS [LIST_MH_LET_VOLXS1] ON [LIST_MH_LET_VOLXS1].[MH_LET_VOLXS_ID] = T.X.value('(./ExcessAmount[text()])[1]', 'varchar(8)')


	DECLARE @Business MLETPROP_BusinessTableType;
	
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

	
	DECLARE @Subsid MLETPROP_SubsidTableType;
	
	INSERT INTO @Subsid( [SubsidInsurer] ,[SubsidInsurer_ID] ,[SubsidERN] ,[SubsidName])
    SELECT
		 [System_Insurer2].[INSURER_Debug] AS [SubsidInsurer]
		,T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)') AS [SubsidInsurer_ID]
		,T.X.value('(./SubsidERN[text()])[1]', 'varchar(20)') AS [SubsidERN]
		,T.X.value('(./SubsidName[text()])[1]', 'varchar(200)') AS [SubsidName]
	FROM
		@RiskXML.nodes('(//Subsid)') AS T(x) --Lookup table
        JOIN [dbo].[System_Insurer] AS [System_Insurer2] ON [System_Insurer2].[INSURER_ID] = T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)')

	
	DECLARE @OCCDtail MLETPROP_OCCDtailTableType;
	
	INSERT INTO @OCCDtail([PropertyNum], [OccupancyNum], [Unoccupied] ,[Occupied] ,[CrimConvictions] ,[Proptunoccupied] ,[OccupancyType] ,[OccupancyType_ID] ,[PropType] ,[PropType_ID])
    SELECT
		 PrpDtail.PrpDtailXML.value('let $i := . return count(../PrpDtail[. << $i])', 'int') + 1  AS [PropertyNum] -- Custom field not produced by TGSLLOBSchemeBuilder; used for linking child Occupancy records to correct parent Property record
		,T.x.value('let $i := . return count(../OCCDtail[. << $i])', 'int') + 1  AS [OccupancyNum] -- Custom field not produced by TGSLLOBSchemeBuilder; used for linking child Occupancy records to correct parent Property record
		,ISNULL(T.X.value('(./Unoccupied[text()])[1]', 'money'),0) AS [Unoccupied]
		,ISNULL(T.X.value('(./Occupied[text()])[1]', 'money'),0) AS [Occupied]
		,ISNULL(T.X.value('(./CrimConvictions[text()])[1]', 'bit'),0) AS [CrimConvictions]
		,CONVERT(datetime ,		T.X.value('(./Proptunoccupied[text()])[1]', 'varchar(30)'),103) AS [Proptunoccupied]
		,[LIST_MH_RESOCC2].[MH_RESOCC_Debug] AS [OccupancyType]
		,T.X.value('(./OccupancyType[text()])[1]', 'varchar(8)') AS [OccupancyType_ID]
		,[LIST_MH_BUILDING2].[MH_BUILDING_Debug] AS [PropType]
		,T.X.value('(./PropType[text()])[1]', 'varchar(8)') AS [PropType_ID]
	FROM
		@RiskXML.nodes('PropInfo/PrpDtail') AS PrpDtail(PrpDtailXML)
		CROSS APPLY PrpDtail.PrpDtailXML.nodes('OCCDtail') AS T(x) -- Custom join not produced by TGSLLOBSchemeBuilder; used for linking child Occupancy records to correct parent Property record
	    JOIN [dbo].[LIST_MH_RESOCC] AS [LIST_MH_RESOCC2] ON [LIST_MH_RESOCC2].[MH_RESOCC_ID] = T.X.value('(./OccupancyType[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_BUILDING] AS [LIST_MH_BUILDING2] ON [LIST_MH_BUILDING2].[MH_BUILDING_ID] = T.X.value('(./PropType[text()])[1]', 'varchar(8)')


-- Assumptions:
   DECLARE @Assump [MLETPROP_AssumpTableType];

   INSERT INTO @Assump ([JCTCONTRACT] ,[JCTCONTRACT_ID],[BANKRUPT],[BANKRUPT_ID],[NUMOFFLATS] ,[NUMOFFLATS_ID],[CONVICTED] ,[CONVICTED_ID], [DECLINED] ,[DECLINED_ID],
                        [DSS] ,[DSS_ID], [HEATING], [HEATING_ID], [COOKING], [COOKING_ID], [BLOCKINSURANCE], [BLOCKINSURANCE_ID], [RENOVATION] ,[RENOVATION_ID] ,[UNOCCUPIED] ,[UNOCCUPIED_ID] ,[FIREALARM] ,[FIREALARM_ID] ,
                        [STATEOFREPAIR] ,[STATEOFREPAIR_ID],[NHSUBSIDENCE] ,[NHSUBSIDENCE_ID] ,[SUBSIDENCE] ,[SUBSIDENCE_ID],[FLOODING] ,[FLOODING_ID] ,[SELFCONTAINED] ,
						[SELFCONTAINED_ID],[BRICK] ,[BRICK_ID] )
   SELECT 
      [LIST_MH_ASSUMPT1].[MH_ASSUMPT_DEBUG] AS [JCTCONTRACT]
	 ,T.X.value('(./JCTContract[text()])[1]','varchar(8)')  AS [JCTCONTRACT_ID]
	 ,[LIST_MH_ASSUMPT2].[MH_ASSUMPT_DEBUG] AS [BANKRUPT]
	 ,T.X.value('(./Bankrupt[text()])[1]','varchar(8)') AS [BANKRUPT_ID]
	 ,[LIST_MH_ASSUMPT3].[MH_ASSUMPT_DEBUG] AS [NUMOFFLATS]
	 ,T.X.value('(./NumOfFlats[text()])[1]','varchar(8)') AS [NUMOFFLATS_ID]
	 ,[LIST_MH_ASSUMPT4].[MH_ASSUMPT_DEBUG] AS [CONVICTED]
	 ,T.X.value('(./Convicted[text()])[1]','varchar(8)') AS [CONVICTED_ID]
	 ,[LIST_MH_ASSUMPT5].[MH_ASSUMPT_DEBUG] AS [DECLINED]
	 ,T.X.value('(./Declined[text()])[1]','varchar(8)') AS [DECLINED_ID]
	 ,[LIST_MH_ASSUMPT6].[MH_ASSUMPT_DEBUG] AS [DSS]
     ,T.X.value('(./DSS[text()])[1]','varchar(8)') AS [DSS_ID]
	 ,[LIST_MH_ASSUMPT7].[MH_ASSUMPT_DEBUG] AS [HEATING]
	 ,T.X.value('(./Heating[text()])[1]','varchar(8)') AS [HEATING_ID]
	 ,[LIST_MH_ASSUMPT8].[MH_ASSUMPT_DEBUG] AS [COOKING]
     ,T.X.value('(./Cooking[text()])[1]','varchar(8)') AS [COOKING_ID]
	 ,[LIST_MH_ASSUMPT9].[MH_ASSUMPT_DEBUG] AS [BLOCKINSURANCE]
	 ,T.X.value('(./BlockInsurance[text()])[1]','varchar(8)') AS [BLOCKINSURANCE_ID]
	 ,[LIST_MH_ASSUMPT10].[MH_ASSUMPT_DEBUG] AS [RENOVATION]
	 ,T.X.value('(./Renovation[text()])[1]','varchar(8)') AS [RENOVATION_ID]
	 ,[LIST_MH_ASSUMPT11].[MH_ASSUMPT_DEBUG] AS [UNOCCUPIED]
	 ,T.X.value('(./Unoccupied[text()])[1]','varchar(8)') AS [UNOCCUPIED_ID]
	 ,[LIST_MH_ASSUMPT12].[MH_ASSUMPT_DEBUG] AS [FIREALARM]
	 ,T.X.value('(./Firealarm[text()])[1]','varchar(8)') AS [FIREALARM_ID]
	 ,[LIST_MH_ASSUMPT13].[MH_ASSUMPT_DEBUG] AS [STATEOFREPAIR]
     ,T.X.value('(./StateOfRepair[text()])[1]','varchar(8)') AS [STATEOFREPAIR_ID]
	 ,[LIST_MH_ASSUMPT14].[MH_ASSUMPT_DEBUG] AS [NHSUBSIDENCE]
	 ,T.X.value('(./NHSubsidence[text()])[1]','varchar(8)') AS [NHSUBSIDENCE_ID]
	 ,[LIST_MH_ASSUMPT15].[MH_ASSUMPT_DEBUG] AS [SUBSIDENCE]
	 ,T.X.value('(./Subsidence[text()])[1]','varchar(8)') AS [SUBSIDENCE_ID]
	 ,[LIST_MH_ASSUMPT16].[MH_ASSUMPT_DEBUG] AS [FLOODING]
	 ,T.X.value('(./Flooding[text()])[1]','varchar(8)') AS [FLOODING_ID]
	 ,[LIST_MH_ASSUMPT17].[MH_ASSUMPT_DEBUG] AS [SELFCONTAINED]
	 ,T.X.value('(./SelfContained[text()])[1]','varchar(8)') AS [SELFCONTAINED_ID]
	 ,[LIST_MH_ASSUMPT18].[MH_ASSUMPT_DEBUG] AS [BRICK]
     ,T.X.value('(./Brick[text()])[1]','varchar(8)') [BRICK_ID]
	 FROM @RiskXML.nodes('(//Assump)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT1] ON [LIST_MH_ASSUMPT1].[MH_ASSUMPT_ID] = T.X.value('(./JCTContract[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT2] ON [LIST_MH_ASSUMPT2].[MH_ASSUMPT_ID] = T.X.value('(./Bankrupt[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT3] ON [LIST_MH_ASSUMPT3].[MH_ASSUMPT_ID] = T.X.value('(./NumOfFlats[text()])[1]', 'varchar(8)')

		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT4] ON [LIST_MH_ASSUMPT4].[MH_ASSUMPT_ID] = T.X.value('(./Convicted[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT5] ON [LIST_MH_ASSUMPT5].[MH_ASSUMPT_ID] = T.X.value('(./Declined[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT6] ON [LIST_MH_ASSUMPT6].[MH_ASSUMPT_ID] = T.X.value('(./DSS[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT7] ON [LIST_MH_ASSUMPT7].[MH_ASSUMPT_ID] = T.X.value('(./Heating[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT8] ON [LIST_MH_ASSUMPT8].[MH_ASSUMPT_ID] = T.X.value('(./Cooking[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT9] ON [LIST_MH_ASSUMPT9].[MH_ASSUMPT_ID] = T.X.value('(./BlockInsurance[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT10] ON [LIST_MH_ASSUMPT10].[MH_ASSUMPT_ID] = T.X.value('(./Renovation[text()])[1]', 'varchar(8)')

		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT11] ON [LIST_MH_ASSUMPT11].[MH_ASSUMPT_ID] = T.X.value('(./Unoccupied[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT12] ON [LIST_MH_ASSUMPT12].[MH_ASSUMPT_ID] = T.X.value('(./Firealarm[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT13] ON [LIST_MH_ASSUMPT13].[MH_ASSUMPT_ID] = T.X.value('(./StateOfRepair[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT14] ON [LIST_MH_ASSUMPT14].[MH_ASSUMPT_ID] = T.X.value('(./NHSubsidence[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT15] ON [LIST_MH_ASSUMPT15].[MH_ASSUMPT_ID] = T.X.value('(./Subsidence[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT16] ON [LIST_MH_ASSUMPT16].[MH_ASSUMPT_ID] = T.X.value('(./Flooding[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT17] ON [LIST_MH_ASSUMPT17].[MH_ASSUMPT_ID] = T.X.value('(./SelfContained[text()])[1]', 'varchar(8)')
		JOIN [dbo].[LIST_MH_ASSUMPT] AS [LIST_MH_ASSUMPT18] ON [LIST_MH_ASSUMPT18].[MH_ASSUMPT_ID] = T.X.value('(./Brick[text()])[1]', 'varchar(8)')

	DECLARE @SchemeInsurer varchar(1000) = (SELECT [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)

--AgentID
	DECLARE @AgentID char(32) = (SELECT [Agent_ID] FROM [RM_Agent] WHERE [Name] = @AgentName)

--Claims
	DECLARE @ClaimsSummary [dbo].[ClaimTableType]
    INSERT INTO @ClaimsSummary ([Details],[Outstanding],[Paid],[Date],[Type])
	SELECT 
         T.X.value('(./Details[text()])[1]','varchar(500)')  AS [Details]
		 ,ISNULL(T.X.value('(./Outstanding[text()])[1]', 'money'),0) AS [Outstanding]
		 ,ISNULL(T.X.value('(./Paid[text()])[1]', 'money'),0) AS [Paid]
		 ,CONVERT(datetime , T.X.value('(./Date[text()])[1]', 'varchar(30)'),103) AS [Date]
		 ,[CT].[MH_CLAIMTYPE_DEBUG] AS [Type]

	FROM @RiskXML.nodes('(//ClmDtail)') AS T(x) --Lookup table ClmSum
	JOIN [dbo].[LIST_MH_CLAIMTYPE] AS [CT] ON [CT].[MH_CLAIMTYPE_ID] = T.X.value('(./Type[text()])[1]','varchar(8)')

--Refers
	--Insurer 
	--IF (SELECT CASE WHEN @PolicyQuoteStage = 'NB' AND [C].[Insurer] = @SchemeInsurer THEN 1 ELSE 0 END FROM {TableWithInsurerID} AS [C]) = 1
			--INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)

	--Assumptions	
	INSERT INTO @Refer([Message])
	SELECT [Message] FROM [dbo].[MLETPROP_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);


--Debugging
	IF @OutputRisk = 1
	BEGIN
		SELECT * FROM @PropInfo;
		SELECT * FROM @PrpDtail;
		SELECT * FROM @AddCover;
		SELECT * FROM @Business;
		SELECT * FROM @Subsid;
		SELECT * FROM @OCCDtail;
		SELECT * FROM @Assump;
		SELECT * FROM @ClaimsSummary;

		SELECT [Message] FROM [dbo].[MLETPROP_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);
		SELECT @PolicyStartDateTime AS [PolicyStartDateTime] ,@PolicyQuoteStage AS [PolicyQuoteStage] ,@PostCode AS [Postcode] ,@SchemeTableID AS [SchemeTableID] ,@SchemeInsurer AS [SchemeInsurer]
	END	

--MLETPROP_tvfSchemeDispatcher
	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM [dbo].[MLETPROP_tvfSchemeDispatcher] (@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode ,@ClaimsSummary ,@PropInfo ,@PrpDtail ,@AddCover ,@Business ,@Subsid ,@OCCDtail, @Assump) FOR XML PATH(''))
 

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


	EXECUTE [dbo].[uspSchemeResults50XS] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium ,@Endorsement
END	

