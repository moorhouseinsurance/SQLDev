USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_Toledo_TradesmanLiability_tvfCalculator]    Script Date: 14/01/2025 14:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		Linga
-- Date:        07 Dec 2023
-- Description: Return Scheme Information
*******************************************************************************

-- Date			Who						Change
-- 06/02/2024	Jeremai Smith			Removal of heat referral (Monday.com ticket 5932028765)
-- 07/02/2024	Jeremai Smith			Stop EL discount from applying for non-manual employees (Monday.com ticket 5932303659)
-- 12/02/2024	Jeremai Smith			Added NULL handling around @DiscountRateEL to prevent missing EL premium (Monday.com ticket 6000402141)
-- 12/02/2024	Jeremai Smith			Removed height referral as this is already handled by function MLIAB_Toledo_TradesmanLiability_tvfTrades
--										(Monday.com ticket 6019327757)
-- 03/04/2024	Simon Mackness-Pettit	6380878777 - Selected the highest EL/PL rate when two trades present
-- 28/06/2024	Jeremai Smith			6925107849 - Refer all Northern Ireland postcodes
-- 14/01/2025   Linga					Monday Ticket 8177482880: Changes to TL and Companion TL Scheme - Quarz & Solar
                                         -- Solution: Replaced [MLIAB_TrdDtailTableType] with new [MLIAB_TrdDtail_TableType] that contains the new fields

*******************************************************************************/
ALTER FUNCTION [dbo].[MLIAB_Toledo_TradesmanLiability_tvfCalculator]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PolicyQuoteStageMTA varchar(8)
    ,@PostCode varchar(12)
	,@AgentName VARCHAR(255)
	--,@RiskXML XML
	,@ClaimsSummary [dbo].[ClaimSummaryTableType] READONLY
	,@EmployeeCounts [dbo].[EmployeeCountsTableType] READONLY
	,@TrdDtail [dbo].[MLIAB_TrdDtail_TableType] READONLY
	,@CInfo [dbo].[MLIAB_CInfoTableType] READONLY
	,@PandP [dbo].[MLIAB_PandPTableType] READONLY
	,@BusSupp [dbo].[MLIAB_BusSuppTableType] READONLY
	,@Subsid [dbo].[MLIAB_SubsidTableType] READONLY
	,@CAR [dbo].[MLIAB_CARTableType] READONLY
	--,@AccIncom [dbo].[MLIAB_AccIncomTableType] READONLY
	--,@PAPeople [dbo].[MLIAB_PAPeopleTableType] READONLY
	--,@ProfIndm [dbo].[MLIAB_ProfIndmTableType] READONLY
)

/*

*/

RETURNS @SchemeResults TABLE 
(
	SchemeResultsXML xml
)
AS
BEGIN
	DECLARE  @Refer SchemeResultTableType
			,@Decline SchemeResultTableType
			,@Excess SchemeResultTableType
			,@Summary SchemeResultTableType
			,@Breakdown SchemeResultTableType
			,@ProductDetail SchemeResultTableType	
			,@Premiums SchemeResultPremiumTableType
			,@Endorsement SchemeResultEndorsementTableType
			
   INSERT INTO @Premiums ([Name] ,[Value]) VALUES ('LIABPREM',0),('EMPLPREM',0),('TOOLPREM',0),('FXMCPREM',0)

   DECLARE	   @TrdDtail_SecondaryRisk varchar(250)
			  ,@TrdDtail_SecondaryRisk_ID varchar(8)
			  ,@TrdDtail_Phase bit
			  ,@TrdDtail_Paving bit
			  ,@TrdDtail_MaxDepth varchar(250)
			  ,@TrdDtail_PrimaryRisk varchar(250)
			  ,@TrdDtail_PrimaryRisk_ID varchar(8)
			  ,@TrdDtail_FixedMachinery bit
			  ,@TrdDtail_PresentInsurer varchar(250)
			  ,@TrdDtail_WorkshopPercent money
			  ,@TrdDtail_EmpsUsing money
			  ,@TrdDtail_CavityWall bit
			  ,@TrdDtail_EfficacyCover bit

	SELECT	 @TrdDtail_SecondaryRisk = SecondaryRisk
			,@TrdDtail_SecondaryRisk_ID = SecondaryRisk_ID
			,@TrdDtail_Phase = Phase
			,@TrdDtail_Paving = Paving
			,@TrdDtail_MaxDepth = MaxDepth
			,@TrdDtail_PrimaryRisk = PrimaryRisk
			,@TrdDtail_PrimaryRisk_ID = PrimaryRisk_ID
			,@TrdDtail_FixedMachinery = FixedMachinery
			,@TrdDtail_PresentInsurer = PresentInsurer
			,@TrdDtail_WorkshopPercent = WorkshopPercent
			,@TrdDtail_EmpsUsing = EmpsUsing
			,@TrdDtail_CavityWall = CavityWall
			,@TrdDtail_EfficacyCover = EfficacyCover
	FROM
		@TrdDtail

   	DECLARE	   @CInfo_PubLiabLimit varchar(250)
			  ,@CInfo_WorkSoley bit
			  ,@CInfo_Heat bit
			  ,@CInfo_MaxHeight varchar(250)
			  ,@CInfo_ToolCover bit		
			  ,@CInfo_EmployeeTool bit
			  ,@CInfo_CompanyStatus varchar(250)
			  ,@CInfo_ManualWork bit
			  ,@CInfo_ManualDirectors money
			  ,@CInfo_YrsExp money
			  ,@CInfo_YrEstablished money
			  ,@CInfo_ToolValue varchar(8)
			  ,@CInfo_TempInsurance bit
			  ,@CInfo_BonaFideWR money
			  ,@CInfo_Annualturnover money
			  ,@CInfo_NonManuDirec money
			  ,@CInfo_ManDays money
	SELECT	   @CInfo_PubLiabLimit = PubLiabLimit
			  ,@CInfo_WorkSoley	   = WorkSoley
			  ,@CInfo_Heat		   = Heat
			  ,@CInfo_MaxHeight	   = MaxHeight
			  ,@CInfo_ToolCover		= ToolCover
			  ,@CInfo_EmployeeTool	= EmployeeTool
			  ,@CInfo_CompanyStatus    = CompanyStatus  
			  ,@CInfo_ManualWork       = ManualWork     
			  ,@CInfo_ManualDirectors  = ManualDirectors
			  ,@CInfo_YrsExp		   = YrsExp		 
			  ,@CInfo_YrEstablished	   = YrEstablished	 
			  ,@CInfo_ToolValue		   = ToolValue	
			  ,@CInfo_TempInsurance		= TempInsurance	
			  ,@CInfo_BonaFideWR		= BonaFideWR	
			  ,@CInfo_Annualturnover	= Annualturnover
			  ,@CInfo_NonManuDirec		= NonManuDirec	
			  ,@CInfo_ManDays			= ManDays
	FROM
		@CInfo

--Claims
	DECLARE  @ClaimsInLast5Years int
			,@MostRecentClaim datetime
			,@LargestClaim money
			,@ToolsClaimInLastFiveYears bit
	SELECT
		 @ClaimsInLast5Years		= [Count5Years]
		,@MostRecentClaim			= [MostRecentClaim]
		,@LargestClaim				= [LargestClaim]
		,@ToolsClaimInLastFiveYears	= [ToolsClaimInLastFiveYears]
	FROM
		@ClaimsSummary
 
--Employees
	DECLARE @EmployeesPAndP int = (SELECT COUNT(*) FROM  @PandP WHERE [Status] IN ('Manual' ,'Work Away'))

	DECLARE
		 @EmployeesELManual int
		,@EmployeesELNonManual int
		,@EmployeesPL int
		,@EmployeesEL int
		,@TotalEmployees int
		,@NonEmployeeManual int

	SELECT
		 @EmployeesELManual =		[EmployeesELManual]
		,@EmployeesELNonManual =	[EmployeesELNonManual]
		,@EmployeesPL =				[EmployeesPL]
		,@EmployeesEL =				[EmployeesEL]
		,@TotalEmployees =			[TotalEmployees]
		,@NonEmployeeManual =		[NonEmployeeManual]
	FROM
		@EmployeeCounts

--CAR

	DECLARE @Contractsworks bit
	       ,@OwnPlant bit
		   ,@HirePlant bit

	SELECT
		 @Contractsworks =	[Contractsworks]
		,@OwnPlant       =  [coverplant]
		,@HirePlant      =  [coverhireplant]
	FROM
		@CAR

--EmployeeTools
	DECLARE @EmployeeTools int
	IF @CInfo_ToolCover = 1 AND @CInfo_EmployeeTool = 1
			SET @EmployeeTools = @EmployeesPL
	IF @CInfo_ToolCover = 1 AND @CInfo_EmployeeTool = 0
			SET @EmployeeTools = CASE @CInfo_CompanyStatus WHEN 'Individual Trading As' THEN @CInfo_ManualWork WHEN 'Partnership' THEN @EmployeesPAndP ELSE @CInfo_ManualDirectors END
			
--Limits
	DECLARE  @LimitEmployersLiability			int = 0
			,@LimitPremiumRateMin				int = 0
			,@LimitEmployeesPLMax				int
			,@LimitEmployeesELMax				int
			,@TrdDtail_WorkshopPercentLimitMax	int
			,@CInfo_ManDaysLimitMax				int
			,@LimitClaimMax						int
			,@Insurer [varchar] (30) = 'Toledo Insurance Solutions'
			,@LineOfBusiness [varchar] (30) = 'MLIAB'

	SET @LimitPremiumRateMin = [dbo].[svfLimitSelect](@SchemeTableID ,@Insurer ,@LineOfBusiness ,'Premium'	,'Min'	,@PolicyStartDateTime )

--Loads Discount Rates   
	--No Claims Discount
	DECLARE @ExperienceYears int = @CInfo_YrsExp
	IF @ExperienceYears = 0
		SET @ExperienceYears = YEAR(@PolicyStartDateTime) - @CInfo_YrEstablished
	DECLARE @MostRecentClaimYears int = ISNULL( [dbo].[svfAgeInYears](@MostRecentClaim,@PolicyStartDateTime) ,1000)
	DECLARE @NoClaimsLoadDiscountRate money = [dbo].[MLIAB_Toledo_TradesmanLiability_svfLoadNoClaimsDiscount] (@ExperienceYears,@MostRecentClaimYears,@PolicyStartDateTime) - 1

	--Employee Discount
	DECLARE @DiscountRatePLELTool money = 0
	DECLARE @DiscountRateEL money = 0

	SET @DiscountRateEL = [dbo].[MLIAB_Toledo_TradesmanLiability_svfLoadEmployeesDiscount] (@EmployeesELManual, @PolicyStartDateTime) - 1

	IF @EmployeesEL > 3
		SET @DiscountRatePLELTool = @DiscountRateEL

	--Tools rates
	DECLARE @ToolsRate int = 0
	SET @ToolsRate = [dbo].[MLIAB_Toledo_TradesmanLiability_svfRateTools]([dbo].[svfformatnumber](@CInfo_ToolValue) ,@PolicyStartDateTime)

	--Trade Rates
	DECLARE @TradeELPLTable table
	(
		 [Trade] varchar(250)
		,[ReferTrade] varchar(250)
		,[Refer_ReferFlag] varchar(250)
		,[ReferCInfo_PubLiabLimit] varchar(250)
		,[ReferCInfo_WorkSoley] varchar(250)
		,[ReferTrdDtail_Phase] varchar(250)
		,[ReferCInfo_Heat] varchar(250)
		,[ReferTrdDtail_Paving] varchar(250)
		,[ReferCInfo_MaxHeight] varchar(250)
		,[ReferTrdDtail_MaxDepth] varchar(250)
		,[ReferEmployeesPL] varchar(250)
		,[ReferEmployeeEL] varchar(250)
		--,[ReferBuilder] varchar(250)
		,[TradeDescriptionInsurer] varchar(250)
		,[PL] money
		,[EL] money
		,[ExcessProperty] BIGINT
		,[ExcessHeat] BIGINT
		,[Endorsement] varchar(250)
		,[DeclineTrade] varchar(250)
	)
	INSERT INTO @TradeELPLTable
	SELECT
	  *
	FROM [dbo].[MLIAB_Toledo_TradesmanLiability_tvfTrades] 
	(
		   @TrdDtail_PrimaryRisk
		  ,@TrdDtail_PrimaryRisk_ID
		  ,@PolicyQuoteStage
		  ,@PolicyQuoteStageMTA
		  ,@PolicyStartDateTime
		  ,@CInfo_PubLiabLimit
		  ,@CInfo_WorkSoley
		  ,@TrdDtail_Phase
		  ,@CInfo_Heat
		  ,@TrdDtail_Paving
          ,@TrdDtail_EfficacyCover
		  ,@CInfo_MaxHeight
		  ,@TrdDtail_MaxDepth
		  ,@EmployeesPL
		  ,@EmployeesELManual
		  ,@AgentName
	 )

	IF @TrdDtail_SecondaryRisk != 'None'
	BEGIN
		INSERT INTO @TradeELPLTable
		SELECT
		  *
		FROM [dbo].[MLIAB_Toledo_TradesmanLiability_tvfTrades] 
		(
			   @TrdDtail_SecondaryRisk
			  ,@TrdDtail_SecondaryRisk_ID
			  ,@PolicyQuoteStage
			  ,@PolicyQuoteStageMTA
			  ,@PolicyStartDateTime
			  ,@CInfo_PubLiabLimit
			  ,@CInfo_WorkSoley
			  ,@TrdDtail_Phase
			  ,@CInfo_Heat
			  ,@TrdDtail_Paving
			  ,@TrdDtail_EfficacyCover
			  ,@CInfo_MaxHeight
			  ,@TrdDtail_MaxDepth
			  ,@EmployeesPL
			  ,@EmployeesELManual
			  ,@AgentName
		  )
	END

	DECLARE
		@PLRate money
		,@ELRate money
		,@ExcessPropertyAmount bigint
		,@ExcessHeatAmount bigint
		,@CombinedEndorsements varchar(250)
		,@Endorsements varchar(250)

	SET @PLRate = (SELECT MAX([PL]) FROM @TradeELPLTable);
	SET @ELRate = (SELECT MAX([EL]) FROM @TradeELPLTable);
	SET @ExcessPropertyAmount = (SELECT MAX([ExcessProperty]) FROM @TradeELPLTable);
	SET @ExcessHeatAmount = (SELECT MAX([ExcessHeat]) FROM @TradeELPLTable);
	SELECT @CombinedEndorsements = COALESCE(@CombinedEndorsements + ',', '') + Endorsement FROM @TradeELPLTable;

	DECLARE @Rate_Endorsements AS TABLE
	(
		Endorsements varchar(250)
	);

	INSERT INTO @Rate_Endorsements
		SELECT
			DISTINCT *
		FROM
			[Transactor_Live].[dbo].[svfSplitString](@CombinedEndorsements, ',')

	SELECT @Endorsements = COALESCE(@Endorsements + ',', '') + Endorsements FROM @Rate_Endorsements;
	
	DECLARE @ClaimsDiscountRate decimal(10,4)
	DECLARE @ClaimsLoadDiscountPremium money = 0
	DECLARE @TotalClaimsLoadDiscountPremium  money = 0
	DECLARE @ClaimsLoadReferFlag BIT 
	DECLARE @ClaimsLoadReferMonths int  
    DECLARE @ClaimsLoadReferSectionPremium money  

--Calculate Premiums and Insert Breakdowns
	DECLARE 
	 	 @Cover bigint =0
		,@Premium numeric(18, 4) = 0
		,@EmpPremium numeric(18, 4) = 0
		,@NonManualEmpPremium numeric(18, 4) = 0
		,@BasePremium money = 0

		--,@PostcodeLoadDiscountPremium money = 0
		,@DiscountPremium money = 0
		,@NoClaimsDiscountPremium money = 0
		,@DiscountPremiumSections money = 0
		,@LoadDiscountPremiumTempEmployeesPLEL MONEY = 0
		,@TotalBasePremium money = 0
		,@TotalPremium money = 0

		,@Section varchar(50) 
		,@TotalPostcodeLoadDiscountPremium money = 0
		,@NoClaimsLoadDiscountPremium money = 0
		,@TotalNoClaimsDiscountPremium money = 0
		,@EmployeeDiscountPremium money = 0
		,@TotalEmployeeDiscountPremium money = 0
		,@TotalDiscountPremium money = 0
		,@TotalDiscountPremiumSections money = 0
		,@TotalLoadDiscountPremiumTempEmployeesPLEL money = 0

	SELECT	 @Section = 'Public Liability'
			,@Premium = @PLRate 
			,@BasePremium = @Premium

	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees Premium' ,null ,null ,@Premium))

	SET @EmployeeDiscountPremium = @Premium * ISNULL(@DiscountRatePLELTool,0)
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRatePLELTool ,@Premium ,@EmployeeDiscountPremium))	
	SET @Premium = @Premium + @EmployeeDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
	SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal '+CAST(@LargestClaim as varchar(100))+ ' '+CAST(@MostRecentClaim as varchar(150)) ,NULL ,NULL ,@Premium))
	IF(@ClaimsInLast5Years = 1)
	BEGIN
	SET @ClaimsLoadDiscountPremium = 0;
	SET @ClaimsDiscountRate =  [dbo].[MLIAB_Toledo_TradesmanLiability_svfLoad_Claims_Discounts] (@LargestClaim, @MostRecentClaim, @Premium) 
	IF(@ClaimsDiscountRate IS NOT NULL)
	BEGIN
		   SET @ClaimsLoadDiscountPremium = ISNULL(@Premium,0) * (@ClaimsDiscountRate/100)
	       INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Claim Load/Discount Premium' ,(@ClaimsDiscountRate/100) ,ISNULL(@Premium,0) ,@ClaimsLoadDiscountPremium))	
	       SET @Premium = @Premium + @ClaimsLoadDiscountPremium
	       INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,ISNULL(@Premium,0)))	
	END
	ELSE
	BEGIN
	   SET @ClaimsLoadReferFlag = 1
	   SET @ClaimsLoadReferMonths = DATEDIFF(MONTH, @MostRecentClaim, GETDATE())
	   SET @ClaimsLoadReferSectionPremium = @Premium
	END
	END  
	
	INSERT INTO @Breakdown	VALUES(	':::')--Blank line

	SET @TotalBasePremium = @TotalBasePremium + @BasePremium 
	SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
	SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
	SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium
	--SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections
	SET @TotalPremium = @TotalPremium + @Premium

	UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'LIABPREM'

	--ELPremium 
	   SET @Cover = NULL
	--IF @EmployeesELManual != 0
	--BEGIN
		SELECT	 @Section = 'Employers Liability'
				,@EmpPremium = @ELRate  * @EmployeesELManual
				,@NonManualEmpPremium = (@EmployeesELNonManual * [dbo].[MLIAB_Toledo_TradesmanLiability_svfRate] ('Non-Manual Employees',@PolicyStartDateTime))
				,@Premium = @EmpPremium + @NonManualEmpPremium
				,@Cover = CASE WHEN @EmployeesELManual != 0 THEN @LimitEmployersLiability ELSE NULL END
				,@BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesELManual AS varchar(3)) + ' Employees' ,null ,null ,@EmpPremium))
		
		SET @EmployeeDiscountPremium = @EmpPremium * ISNULL(@DiscountRateEL,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRateEL ,@EmpPremium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesELNonManual AS varchar(3)) + ' Non-Manual Employees' ,null , @NonManualEmpPremium ,@Premium))
				
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		IF(@ClaimsInLast5Years = 1)
	    BEGIN
	    SET @ClaimsLoadDiscountPremium = 0;
	    SET @ClaimsDiscountRate =  [dbo].[MLIAB_Toledo_TradesmanLiability_svfLoad_Claims_Discounts] (@LargestClaim, @MostRecentClaim, @Premium) 
	    IF(@ClaimsDiscountRate IS NOT NULL)
	    BEGIN
	    	   SET @ClaimsLoadDiscountPremium = ISNULL(@Premium,0) * (@ClaimsDiscountRate/100)
	           INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Claim Load/Discount Premium' ,(@ClaimsDiscountRate/100) ,ISNULL(@Premium,0) ,@ClaimsLoadDiscountPremium))	
	           SET @Premium = @Premium + @ClaimsLoadDiscountPremium
	           INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,ISNULL(@Premium,0)))	
	    END
	    ELSE
	    BEGIN
	       SET @ClaimsLoadReferFlag = 1
	       SET @ClaimsLoadReferMonths = DATEDIFF(MONTH, @MostRecentClaim, GETDATE())
	       SET @ClaimsLoadReferSectionPremium = @Premium
	    END
	    END  

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium 
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium
		--SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections
		SET @TotalPremium = @TotalPremium + @Premium

		UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'EMPLPREM'
	--END

	
	--TempELPremium
	SET @Cover = NULL
	IF @CInfo_TempInsurance = 'True' AND @EmployeesELManual = 0 
	BEGIN	
		SELECT	 @Section = 'Temp Employees EL'
				,@Premium = @ELRate 
				,@Cover =	@LimitEmployersLiability
				,@BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section ,null ,null ,@Premium))

		SET @EmployeeDiscountPremium = @Premium * ISNULL(@DiscountRateEL, 0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRateEL ,@Premium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium 
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium
		--SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections
		SET @TotalPremium = @TotalPremium + @Premium

		UPDATE @Premiums SET [Value] = [Value] + @Premium WHERE [Name] = 'EMPLPREM'
	END

	--ToolsPremium 
	SET @Cover = NULL
	IF @CInfo_ToolCover = 'True'
	BEGIN	
		SELECT	 @Section = 'Tools'
				,@Premium = @ToolsRate * @EmployeeTools
				,@BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeeTools AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		SET @EmployeeDiscountPremium = @Premium * ISNULL(@DiscountRatePLELTool,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRatePLELTool ,@Premium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		IF(@ClaimsInLast5Years = 1)
	    BEGIN
	    SET @ClaimsLoadDiscountPremium = 0;
	    SET @ClaimsDiscountRate =  [dbo].[MLIAB_Toledo_TradesmanLiability_svfLoad_Claims_Discounts] (@LargestClaim, @MostRecentClaim, @Premium) 
	    IF(@ClaimsDiscountRate IS NOT NULL)
	    BEGIN
	    	   SET @ClaimsLoadDiscountPremium = ISNULL(@Premium,0) * (@ClaimsDiscountRate/100)
	           INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Claim Load/Discount Premium' ,(@ClaimsDiscountRate/100) ,ISNULL(@Premium,0) ,@ClaimsLoadDiscountPremium))	
	           SET @Premium = @Premium + @ClaimsLoadDiscountPremium
	           INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,ISNULL(@Premium,0)))	
	    END
	    ELSE
	    BEGIN
	       SET @ClaimsLoadReferFlag = 1
	       SET @ClaimsLoadReferMonths = DATEDIFF(MONTH, @MostRecentClaim, GETDATE())
	       SET @ClaimsLoadReferSectionPremium = @Premium
	    END
	    END  

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium 
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium
		--SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections
		SET @TotalPremium = @TotalPremium + @Premium

		UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'TOOLPREM'
	END

	--Fixed Machinery = @TrdDtail_EmpsUsing * @RateFixedMachinery * @NoClaimsDicountRate
	DECLARE  @FixedMachineryPremium money = 0
	IF @TrdDtail_FixedMachinery = 1
	BEGIN
		--Fixed Machinery Rates
	    DECLARE @RateFixedMachinery int = [dbo].[MLIAB_Toledo_TradesmanLiability_svfRate] ('FixedMachinery',@PolicyStartDateTime)
		SELECT	 @Section = 'Fixed Machinery'
				,@Premium = @TrdDtail_EmpsUsing * @RateFixedMachinery
				,@Cover = [dbo].[svfFormatNumber](@CInfo_PubLiabLimit)
				,@BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@TrdDtail_EmpsUsing AS varchar(10)) + ' Employees' ,null ,null ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	    IF(@ClaimsInLast5Years = 1)
	    BEGIN
	    SET @ClaimsLoadDiscountPremium = 0;
	    SET @ClaimsDiscountRate =  [dbo].[MLIAB_Toledo_TradesmanLiability_svfLoad_Claims_Discounts] (@LargestClaim, @MostRecentClaim, @Premium) 
	    IF(@ClaimsDiscountRate IS NOT NULL)
	    BEGIN
	    	   SET @ClaimsLoadDiscountPremium = ISNULL(@Premium,0) * (@ClaimsDiscountRate/100)
	           INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Claim Load/Discount Premium' ,(@ClaimsDiscountRate/100) ,ISNULL(@Premium,0) ,@ClaimsLoadDiscountPremium))	
	           SET @Premium = @Premium + @ClaimsLoadDiscountPremium
	           INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,ISNULL(@Premium,0)))	
	    END
	    ELSE
	    BEGIN
	       SET @ClaimsLoadReferFlag = 1
	       SET @ClaimsLoadReferMonths = DATEDIFF(MONTH, @MostRecentClaim, GETDATE())
	       SET @ClaimsLoadReferSectionPremium = @Premium
	    END
	    END 
		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium
		SET @TotalPremium = @TotalPremium + @Premium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium
		--SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections

		INSERT INTO @ProductDetail VALUES (@Section + ' = ' + ISNULL([dbo].[svfFormatCoverString](@Cover),'Not taken'))

		UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'FXMCPREM'
	END
	
	--Breakdown totals
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Base Premium' ,NULL ,NULL ,@TotalBasePremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Employees Discount Premium' ,NULL ,NULL ,@TotalEmployeeDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total No Claims Discount Premium' ,NULL ,NULL ,@TotalNoClaimsDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Claim Load/Discount Premium' ,NULL ,NULL ,@TotalClaimsLoadDiscountPremium))
	--INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Discount Premium Sections' ,NULL ,NULL ,@TotalDiscountPremiumSections))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium))


--Referrals
    
	IF @TrdDtail_PrimaryRisk IS NULL
			INSERT INTO @Refer VALUES ('No Primary Trade has been selected.')

	IF @EmployeesPL = 0
			INSERT INTO @Refer VALUES ('No Manual Employees.')

	IF @EmployeesPL > 10
			INSERT INTO @Refer VALUES ('Maximum 0f 10 Manual Employees.')

	IF @EmployeesELNonManual > 10
			INSERT INTO @Refer VALUES ('Maximum 0f 10 Non Manual Employees')


	IF (ISNULL(@CInfo_Annualturnover,0) != 0 AND @CInfo_BonaFideWR > @CInfo_Annualturnover/2)
		INSERT INTO @Refer	VALUES('BFSC spend more than 50% of the turnover')

	IF @CInfo_CompanyStatus = 'Limited' AND  (@CInfo_ManualDirectors + @CInfo_NonManuDirec) = 0
			INSERT INTO @Refer VALUES ('Limited Company: Total Number of Directors are 0')
	
	IF @CInfo_TempInsurance= 'True' AND @CInfo_ManDays > 50
	 	INSERT INTO @Refer VALUES ('Max 50 days for temporary employees is allowed') 
	IF @TrdDtail_EfficacyCover = 1
	   INSERT INTO @Refer VALUES ('Efficacy Cover is not applicable') 

	IF @ClaimsInLast5Years > 1
			INSERT INTO @Refer VALUES ('Proposer has made ' + CAST(@ClaimsInLast5Years AS VARCHAR(2)) + ' Claims in the last 5 years')

	IF @LargestClaim > 10000
	  INSERT INTO @Refer VALUES ('Proposer has made a Claim in excess of £10,000')

	IF(@ClaimsLoadReferFlag IS NOT NULL AND @ClaimsLoadReferFlag = 1)
	    INSERT INTO @Refer VALUES ('No Loading rule to a claim of '+ [dbo].[svfFormatMoneyString](@LargestClaim) +' per section premium of '+[dbo].[svfFormatMoneyString](@ClaimsLoadReferSectionPremium) + +' for a period of '+CAST(@ClaimsLoadReferMonths AS VARCHAR(10))+' months')

	IF @CInfo_ToolCover= 'True' AND @ToolsRate = 0
	 	INSERT INTO @Refer VALUES ('No Rates Available for this level of Tools Cover') 

	IF @ToolsClaimInLastFiveYears = 1
			INSERT INTO @Refer VALUES ('Proposer has made a tools Claim in the last 5 years')

	IF @CInfo_ToolCover = 1 AND @CInfo_EmployeeTool= 0 AND @NonEmployeeManual = 0
			INSERT INTO @Refer VALUES ('Tools selected but no one working manually who is not an employee.')
	
	IF @Postcode LIKE 'BT%' INSERT INTO @Refer VALUES('Refer all BT postcodes');


	--Trade refers
	--Premium void
	IF EXISTS (SELECT [ReferTrade] FROM @TradeELPLTable WHERE [ReferTrade] IS NOT NULL)
		INSERT INTO @Refer VALUES ('Premiums Voided')

	INSERT INTO @Refer
			SELECT [ReferTrade] FROM @TradeELPLTable WHERE [ReferTrade] IS NOT NULL
	UNION	SELECT [Refer_ReferFlag] FROM @TradeELPLTable WHERE [Refer_ReferFlag] IS NOT NULL
	UNION	SELECT [ReferCInfo_PubLiabLimit] FROM @TradeELPLTable WHERE [ReferCInfo_PubLiabLimit] IS NOT NULL
	UNION	SELECT [ReferCInfo_WorkSoley] FROM @TradeELPLTable WHERE [ReferCInfo_WorkSoley] IS NOT NULL
	UNION	SELECT [ReferTrdDtail_Phase] FROM @TradeELPLTable WHERE [ReferTrdDtail_Phase] IS NOT NULL
	UNION	SELECT [ReferCInfo_Heat] FROM @TradeELPLTable WHERE [ReferCInfo_Heat] IS NOT NULL
	UNION	SELECT [ReferCInfo_MaxHeight] FROM @TradeELPLTable WHERE [ReferCInfo_MaxHeight] IS NOT NULL
	UNION	SELECT [ReferTrdDtail_MaxDepth] FROM @TradeELPLTable WHERE [ReferTrdDtail_MaxDepth] IS NOT NULL
	UNION	SELECT [ReferEmployeesPL] FROM @TradeELPLTable WHERE [ReferEmployeesPL] IS NOT NULL
	UNION	SELECT [ReferEmployeeEL] FROM @TradeELPLTable WHERE [ReferEmployeeEL] IS NOT NULL
	
--Decline
	INSERT INTO @Decline
			SELECT [DeclineTrade] FROM @TradeELPLTable WHERE [DeclineTrade] IS NOT NULL

--Endorsements
	INSERT INTO @Endorsement 
	SELECT [Token] FROM @TradeELPLTable CROSS APPLY [dbo].[tvfSplitStringByDelimiter]([Endorsement],',') WHERE ISNULL([Endorsement],'') !='' 
	IF(@EmployeesELManual > 0) INSERT INTO @Endorsement  VALUES ('TISTL077');
	INSERT INTO @Endorsement  VALUES ('TISTL078')
	INSERT INTO @Endorsement  VALUES ('TISTL034')
	--7160280938
	INSERT INTO @Endorsement  VALUES ('TISTL080')
	--IF @TrdDtail_EfficacyCover = 1
	--BEGIN
	--INSERT INTO @Endorsement  VALUES ('TISTL020')
	--END
--Excesses '{Excess Desc}:{ExcessVal000}:{List_Excess_Section.Excess_Section_ID}:{LIST_EXCESSTYPE.ExcessType_ID}'
	INSERT INTO @Excess 
	SELECT * FROM [dbo].[MLIAB_Toledo_TradesmanLiability_tvfExcess](@ExperienceYears ,@ExcessPropertyAmount ,@ExcessHeatAmount ,@CInfo_ToolCover ,@PolicyStartDatetime, @Endorsements)

--Return Table
	declare @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN
END

