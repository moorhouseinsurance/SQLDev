USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_tvfCalculator]    Script Date: 19/03/2025 08:51:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		System Generated
-- Date:        {Datetime}
-- Description: Return Scheme Information
*******************************************************************************

-- Date			Who						Change
-- 24/01/2024	Jeremai Smith			Added DeclineTradeNB (Monday.com ticket 5903075954)
-- 23/04/2024	Jeremai Smith			Removed hard coded endorsements and put them in the trade table as they were missing on secondary trades (Monday.com ticket 6444202451)
-- 08/10/2024   Linga                   Added IsMinPremAppl  (Monday.com Ticket 6185012180)
-- 08/11/2024   Linga					Monday.com Ticket 7742757533 - Change the Companion - Tradesman Liability Scheme (ID 1448)
-- 26/11/2024   Linga					Monday.com Ticket 7929136440 - TL QS changes and TM referal - Changed Refer text messages and included an additional filter @EmployeesPL to validate the number of PLs.
-- 14/01/2025   Linga					Monday Ticket 8177482880: Changes to TL and Companion TL Scheme - Quarz & Solar
                                         -- Solution: Replaced [MLIAB_TrdDtailTableType] with new [MLIAB_TrdDtail_TableType] that contains the new fields
-- 19/03/2025	Simon					Monday Ticket 8720586881: Amended refer rule @EmployeesPL > 10 to @EmployeesPL > 15
*******************************************************************************/
ALTER FUNCTION [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_tvfCalculator]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PolicyQuoteStageMTA bit  
    ,@PostCode varchar(12)
	,@ClaimsSummary ClaimSummaryTableType READONLY
	,@EmployeeCounts EmployeeCountsTableType READONLY
	,@TrdDtail MLIAB_TrdDtail_TableType READONLY
	,@CInfo MLIAB_CInfoTableType READONLY
	,@PandP MLIAB_PandPTableType READONLY
	,@BusSupp MLIAB_BusSuppTableType READONLY
	,@Subsid MLIAB_SubsidTableType READONLY
	,@CAR MLIAB_CARTableType READONLY
)

/*

	TRUNCATE TABLE [Transactor_Live].[dbo].[SchemeCommandDebug]
	SELECT * FROM [Transactor_Live].[dbo].[SchemeCommandDebug] WHERE [SchemeCommandText] LIKE '%MLIAB_uspCalculator%'

	CREATE TABLE RiskXML (RiskXML xml);
	INSERT INTO RiskXML(RiskXML) values(@RiskXML);
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
			  ,@TrdDtail_Manufacture bit
			  ,@TrdDtail_Engineering bit

	SELECT	 @TrdDtail_SecondaryRisk    = SecondaryRisk
			,@TrdDtail_SecondaryRisk_ID = SecondaryRisk_ID
			,@TrdDtail_Phase            = Phase
			,@TrdDtail_Paving           = Paving
			,@TrdDtail_MaxDepth         = MaxDepth
			,@TrdDtail_PrimaryRisk      = PrimaryRisk
			,@TrdDtail_PrimaryRisk_ID   = PrimaryRisk_ID
			,@TrdDtail_FixedMachinery   = FixedMachinery
			,@TrdDtail_PresentInsurer   = PresentInsurer
			,@TrdDtail_WorkshopPercent  = WorkshopPercent
			,@TrdDtail_EmpsUsing        = EmpsUsing
			,@TrdDtail_CavityWall       = CavityWall
			,@TrdDtail_EfficacyCover    = EfficacyCover
			,@TrdDtail_Manufacture      = Manufacture
			,@TrdDtail_Engineering      = Engineering
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
			  ,@CInfo_WrittenRA bit
			  ,@Cinfo_HealthSafety bit

	SELECT	   @CInfo_PubLiabLimit    = PubLiabLimit
			  ,@CInfo_WorkSoley	      = WorkSoley
			  ,@CInfo_Heat		      = Heat
			  ,@CInfo_MaxHeight	      = MaxHeight
			  ,@CInfo_ToolCover		  = ToolCover
			  ,@CInfo_EmployeeTool	  = EmployeeTool
			  ,@CInfo_CompanyStatus   = CompanyStatus  
			  ,@CInfo_ManualWork      = ManualWork     
			  ,@CInfo_ManualDirectors = ManualDirectors
			  ,@CInfo_YrsExp		  = YrsExp		 
			  ,@CInfo_YrEstablished	  = YrEstablished	 
			  ,@CInfo_ToolValue		  = ToolValue	
			  ,@CInfo_TempInsurance	  = TempInsurance	
			  ,@CInfo_BonaFideWR	  = BonaFideWR	
			  ,@CInfo_Annualturnover  = Annualturnover
			  ,@CInfo_NonManuDirec	  = NonManuDirec	
			  ,@CInfo_ManDays		  = ManDays
			  ,@CInfo_WrittenRA       = WrittenRA
			  ,@Cinfo_HealthSafety    = HealthSafety
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

	DECLARE
		 @Contractsworks bit

	SELECT
		 @Contractsworks =			[Contractsworks]
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
			,@Insurer [varchar] (30) = 'Tokio Marine HCC'
			,@LineOfBusiness [varchar] (30) = 'MLIAB'

	SET @LimitPremiumRateMin = [dbo].[svfLimitSelect](@SchemeTableID ,@Insurer ,@LineOfBusiness ,'Premium'	,'Min'	,@PolicyStartDateTime )
	--SET @LimitEmployeesPLMax = [dbo].[svfLimitSelect]( @Insurer ,@LineOfBusiness ,'EmployeesPL'	,'Max'	,@PolicyStartDateTime )
	--SET @LimitEmployeesELMax = [dbo].[svfLimitSelect]( @Insurer ,@LineOfBusiness ,'EmployeesEL'	,'Max'	,@PolicyStartDateTime )
	--SET @TrdDtail_WorkshopPercentLimitMax = [dbo].[svfLimitSelect]( @Insurer ,@LineOfBusiness ,'TrdDtail_WorkshopPercent' ,'Max'	,@PolicyStartDateTime )
	--SET @CInfo_ManDaysLimitMax = [dbo].[svfLimitSelect]( @Insurer ,@LineOfBusiness ,'@CInfo_ManDays'	,'Max'	,@PolicyStartDateTime )
	--SET @LimitClaimMax = [dbo].[svfLimitSelect]( @Insurer ,@LineOfBusiness ,'Claim'	,'Max'	,@PolicyStartDateTime )
	--SET @LimitEmployersLiability		= [dbo].[svfLimitSelect]( @Insurer ,@LineOfBusiness ,'EmployersLiability' ,'Max'	,@PolicyStartDateTime )

--Loads Discount Rates

	--Section Discount
	DECLARE @LoadDiscountRatePremiumSections money = 0 ---0.01
	SET @LoadDiscountRatePremiumSections = ([dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfLoadDiscountsSelect](NULL ,'Section' ,NULL ,@PolicyStartDateTime) -1)

	--Employee Discount
	DECLARE @DiscountRate money = 0
	DECLARE @DiscountRateEL money = 0
	SET @DiscountRateEL = ([dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfLoadDiscountsSelect](NULL ,'EmployeesELManual' ,@EmployeesELManual ,@PolicyStartDateTime) -1)

	DECLARE @LoadDiscountRateTempEmployeesPLEL money = 0
	SET @LoadDiscountRateTempEmployeesPLEL = ([dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfLoadDiscountsSelect](NULL ,'TempEmployeesPLEL' ,@CInfo_ManDays ,@PolicyStartDateTime) -1)

	IF @EmployeesELManual > 3
		SET @DiscountRate = @DiscountRateEL

	--No Claims Discount
	DECLARE @ExperienceYears int = @CInfo_YrsExp
	IF @ExperienceYears = 0
		SET @ExperienceYears = YEAR(@PolicyStartDateTime) - @CInfo_YrEstablished
	DECLARE @MostRecentClaimYears int = ISNULL( [dbo].[svfAgeInYears](@MostRecentClaim,@PolicyStartDateTime) ,1000)
	DECLARE @NoClaimsLoadDiscountRate money = [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfLoadDiscountClaims] (@ExperienceYears,@MostRecentClaimYears,@PolicyStartDateTime) - 1

	--Postcode Weight
	DECLARE @PostcodeWeight decimal(6,4) = 1
	SET @PostcodeWeight = [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfLoadDiscountPostcode] (@PostCode ,@PolicyStartDateTime)
	DECLARE @PostcodeLoadDiscountPctRate money = @PostcodeWeight - 1

	--Tools rates
	DECLARE @ToolsRate int = 0
	SET @ToolsRate = [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfRateTools] ([dbo].[svfformatnumber](@CInfo_ToolValue) ,@PolicyStartDateTime)

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
		,[ReferBuilder] varchar(250)
		,[TradeDescriptionInsurer] varchar(250)
		,[PL] money
		,[EL] money
		,[ExcessProperty] BIGINT
		,[ExcessHeat] BIGINT
		,[Endorsement] varchar(250)
		,[DeclineTrade] varchar(250)
		,[DeclineTradeNB] varchar(250)
		,[IsMinPremAppl] BIT
	)
	INSERT INTO @TradeELPLTable
	SELECT
	  *
	FROM [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_tvfTrades] 
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
		  ,@CInfo_MaxHeight
		  ,@TrdDtail_MaxDepth
		  ,@EmployeesPL
		  ,@EmployeesELManual
	 )

	IF @TrdDtail_SecondaryRisk != 'None'
	BEGIN
		INSERT INTO @TradeELPLTable
		SELECT
		  *
		FROM [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_tvfTrades] 
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
			  ,@CInfo_MaxHeight
			  ,@TrdDtail_MaxDepth
			  ,@EmployeesPL
			  ,@EmployeesELManual
		  )
	END

	DECLARE @PLRate money
		,@ELRate money
		,@ExcessPropertyAmount bigint
		,@ExcessHeatAmount bigint

	DECLARE @IsMinPremApp BIT ;

	SELECT
		 @PLRate = (CASE WHEN @TrdDtail_PrimaryRisk_ID IN ( '3N0TVFQ9', '3N0TVFR9') OR @TrdDtail_SecondaryRisk_ID IN ( '3N0TVFQ9', '3N0TVFR9') THEN MIN(PL) 
		                 ELSE MAX(PL)
					END)
		,@ELRate = (CASE WHEN @TrdDtail_PrimaryRisk_ID IN ( '3N0TVFQ9', '3N0TVFR9') OR @TrdDtail_SecondaryRisk_ID IN ( '3N0TVFQ9', '3N0TVFR9') THEN MIN(EL) 
		                ELSE MAX(EL)
					END)
		,@ExcessPropertyAmount = MAX([ExcessProperty])
		,@ExcessHeatAmount = MAX([ExcessHeat])
		,@IsMinPremApp = (CASE WHEN @TrdDtail_PrimaryRisk_ID IN ( '3N0TVFQ9', '3N0TVFR9') OR @TrdDtail_SecondaryRisk_ID IN ( '3N0TVFQ9', '3N0TVFR9') THEN 0
		                       ELSE 1
					     END)
	FROM
		@TradeELPLTable


	--Fixed Machinery Rates
	DECLARE @RateFixedMachinery int = [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfRate] ('FixedMachinery',@PolicyStartDateTime)


--Calculate Premiums and Insert Breakdowns
	DECLARE 
	 	 @Cover bigint =0
		,@Premium numeric(18, 4) = 0
		,@BasePremium money = 0

		,@PostcodeLoadDiscountPremium money = 0
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

	SET @PostcodeLoadDiscountPremium = @Premium * @PostcodeLoadDiscountPctRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
	SET @Premium = @Premium + @PostcodeLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @EmployeeDiscountPremium = @Premium * @DiscountRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRateEL ,@Premium ,@EmployeeDiscountPremium))	
	SET @Premium = @Premium + @EmployeeDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
	SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @DiscountPremiumSections = @Premium * @LoadDiscountRatePremiumSections
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSections ,@Premium ,@DiscountPremiumSections))	
	SET @Premium = @Premium + @DiscountPremiumSections
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @LoadDiscountPremiumTempEmployeesPLEL = @Premium * @LoadDiscountRateTempEmployeesPLEL
	INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString](@Section +' Load Temp Man days Premium' ,@LoadDiscountRateTempEmployeesPLEL ,@Premium ,@LoadDiscountPremiumTempEmployeesPLEL))	
	SET @Premium = @Premium + @LoadDiscountPremiumTempEmployeesPLEL
	INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	INSERT INTO @Breakdown	VALUES(	':::')--Blank line

	SET @TotalBasePremium = @TotalBasePremium + @BasePremium 
	SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium 
	SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
	SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
	SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections
	SET @TotalLoadDiscountPremiumTempEmployeesPLEL = @TotalLoadDiscountPremiumTempEmployeesPLEL + @LoadDiscountPremiumTempEmployeesPLEL
	SET @TotalPremium = @TotalPremium + @Premium

	UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'LIABPREM'

	--ELPremium 
	SET @Cover = NULL
	IF @EmployeesELManual != 0
	BEGIN
		SELECT	 @Section = 'Employers Liability'
				,@Premium = @ELRate  * @EmployeesELManual
				,@Cover = CASE WHEN @EmployeesELManual != 0 THEN @LimitEmployersLiability ELSE NULL END
				,@BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesELManual AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		SET @PostcodeLoadDiscountPremium = @Premium * @PostcodeLoadDiscountPctRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @EmployeeDiscountPremium = @Premium * @DiscountRateEL
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRateEL ,@Premium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @DiscountPremiumSections = @Premium * @LoadDiscountRatePremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSections ,@Premium ,@DiscountPremiumSections))	
		SET @Premium = @Premium + @DiscountPremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @LoadDiscountPremiumTempEmployeesPLEL = @Premium * @LoadDiscountRateTempEmployeesPLEL
		INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString](@Section +' Load Temp Man days Premium' ,@LoadDiscountRateTempEmployeesPLEL ,@Premium ,@LoadDiscountPremiumTempEmployeesPLEL))	
		SET @Premium = @Premium + @LoadDiscountPremiumTempEmployeesPLEL
		INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium 
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium 
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections
		SET @TotalLoadDiscountPremiumTempEmployeesPLEL = @TotalLoadDiscountPremiumTempEmployeesPLEL + @LoadDiscountPremiumTempEmployeesPLEL
		SET @TotalPremium = @TotalPremium + @Premium

		UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'EMPLPREM'
	END

	--TempELPremium
	SET @Cover = NULL
	IF @CInfo_TempInsurance = 'True' AND @EmployeesELManual = 0 
	BEGIN	
		SELECT	 @Section = 'Temp Employees EL'
				,@Premium = @ELRate 
				,@Cover =	@LimitEmployersLiability
				,@BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section ,null ,null ,@Premium))

		SET @PostcodeLoadDiscountPremium = @Premium * @PostcodeLoadDiscountPctRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @EmployeeDiscountPremium = @Premium * @DiscountRateEL
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRateEL ,@Premium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @DiscountPremiumSections = @Premium * @LoadDiscountRatePremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSections ,@Premium ,@DiscountPremiumSections))	
		SET @Premium = @Premium + @DiscountPremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @LoadDiscountPremiumTempEmployeesPLEL = @Premium * @LoadDiscountRateTempEmployeesPLEL
		INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString](@Section +' Load Temp Man days Premium' ,@LoadDiscountRateTempEmployeesPLEL ,@Premium ,@LoadDiscountPremiumTempEmployeesPLEL))	
		SET @Premium = @Premium + @LoadDiscountPremiumTempEmployeesPLEL
		INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium 
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium 
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections
		SET @TotalLoadDiscountPremiumTempEmployeesPLEL = @TotalLoadDiscountPremiumTempEmployeesPLEL + @LoadDiscountPremiumTempEmployeesPLEL
		SET @TotalPremium = @TotalPremium + @Premium

		UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'EMPLPREM'
	END

	--ToolsPremium 
	SET @Cover = NULL
	IF @CInfo_ToolCover = 'True'
	BEGIN	
		SELECT	 @Section = 'Tools'
				,@Premium = @ToolsRate * @EmployeeTools
				,@BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeeTools AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		SET @PostcodeLoadDiscountPremium = @Premium * @PostcodeLoadDiscountPctRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @EmployeeDiscountPremium = @Premium * @DiscountRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRateEL ,@Premium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @DiscountPremiumSections = @Premium * @LoadDiscountRatePremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSections ,@Premium ,@DiscountPremiumSections))	
		SET @Premium = @Premium + @DiscountPremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium 
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium 
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections
		SET @TotalLoadDiscountPremiumTempEmployeesPLEL = @TotalLoadDiscountPremiumTempEmployeesPLEL + @LoadDiscountPremiumTempEmployeesPLEL
		SET @TotalPremium = @TotalPremium + @Premium

		UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'TOOLPREM'
	END

	--Fixed Machinery = @TrdDtail_EmpsUsing * @RateFixedMachinery * @NoClaimsDicountRate
	DECLARE  @FixedMachineryPremium money = 0
	IF @TrdDtail_FixedMachinery = 1
	BEGIN	
		SELECT	 @Section = 'Fixed Machinery'
				,@Premium = @TrdDtail_EmpsUsing * @RateFixedMachinery
				,@Cover = [dbo].[svfFormatNumber](@CInfo_PubLiabLimit)
				,@BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@TrdDtail_EmpsUsing AS varchar(10)) + ' Employees' ,null ,null ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @DiscountPremiumSections = @Premium * @LoadDiscountRatePremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSections ,@Premium ,@DiscountPremiumSections))	
		SET @Premium = @Premium + @DiscountPremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium
		SET @TotalPremium = @TotalPremium + @Premium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections

		INSERT INTO @ProductDetail VALUES (@Section + ' = ' + ISNULL([dbo].[svfFormatCoverString](@Cover),'Not taken'))

		UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'FXMCPREM'
	END
	
	--Breakdown totals
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Base Premium' ,NULL ,NULL ,@TotalBasePremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Postcode Load Discount Premium' ,NULL ,NULL ,@TotalPostcodeLoadDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Employees Discount Premium' ,NULL ,NULL ,@TotalEmployeeDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total No Claims Discount Premium' ,NULL ,NULL ,@TotalNoClaimsDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Discount Premium Sections' ,NULL ,NULL ,@TotalDiscountPremiumSections))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Load Temp Days Premium' ,NULL ,NULL ,@TotalLoadDiscountPremiumTempEmployeesPLEL))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium))

--Min Premium
     --Min Premium Applicable check
	--IF EXISTS (SELECT 1 FROM @TradeELPLTable WHERE [IsMinPremAppl] = 1) SET @IsMinPremApp = 1
	--ELSE SET @IsMinPremApp = 0;
	IF((@IsMinPremApp IS NOT NULL OR @IsMinPremApp <> '') AND @IsMinPremApp = 1)
	BEGIN
	    IF (@TotalPremium != 0) AND (@TotalPremium < @LimitPremiumRateMin)
	    BEGIN
	    	UPDATE @Premiums SET [Value] = ([value]/@TotalPremium)* @LimitPremiumRateMin
	    	INSERT INTO @Breakdown	VALUES('Minimum Premium:::')
	    	INSERT INTO @Breakdown	SELECT ([dbo].[svfFormatBreakdownString](CASE [NAME] WHEN 'LIABPREM' THEN 'Public Liability' WHEN 'EMPLPREM' THEN 'Employers Liability' WHEN 'TOOLPREM' THEN 'Tools' WHEN 'FXMCPREM' THEN 'Fixed Machinery' END + ' Premium' ,NULL ,NULL ,[Value])) FROM @Premiums WHERE [Value] != 0
	    END
	END

--Referrals
	IF (ISNULL(@CInfo_Annualturnover,0) != 0 AND @CInfo_BonaFideWR > @CInfo_Annualturnover/2)
		INSERT INTO @Refer	VALUES('BFSC spend more than 50% of the turnover')

	IF @CInfo_MaxHeight LIKE '%15%'
	BEGIN
		IF @TrdDtail_PrimaryRisk_ID IN ('3N0TV819' ,'3N0TV899')
			INSERT INTO @Refer	VALUES( 'Maximum height restricted to under 15m for' + @TrdDtail_PrimaryRisk)
		IF @TrdDtail_SecondaryRisk_ID IN ('3N0TV819' ,'3N0TV899')
			INSERT INTO @Refer	VALUES( 'Maximum height restricted to under 15m for' + @TrdDtail_SecondaryRisk)
	END

	IF @CInfo_WorkSoley = 0 
	BEGIN
		IF @TrdDtail_PrimaryRisk_ID IN ('3N0TVEQ9' ,'3NVE0D03' ,'3NVE0DH8' ,'3N0TVBK9')
			INSERT INTO @Refer	VALUES( 'Premises restricted to  Private Dwelling Houses, Offices, Shops only for ' + @TrdDtail_PrimaryRisk)
		IF @TrdDtail_SecondaryRisk_ID IN ('3N0TVEQ9' ,'3NVE0D03' ,'3NVE0DH8' ,'3N0TVBK9')
			INSERT INTO @Refer	VALUES( 'Premises restricted to  Private Dwelling Houses, Offices, Shops only for ' + @TrdDtail_SecondaryRisk)
	END

	IF @TrdDtail_CavityWall = 1
	BEGIN
		IF @TrdDtail_PrimaryRisk_ID IN ('3N1MK894' ,'3N0TVEQ9')
			INSERT INTO @Refer	VALUES( 'Cavity wall Injection not allowed for ' + @TrdDtail_PrimaryRisk)
		IF @TrdDtail_SecondaryRisk_ID IN ('3N1MK894' ,'3N0TVEQ9')
			INSERT INTO @Refer	VALUES( 'Cavity wall Injection not allowed for ' + @TrdDtail_SecondaryRisk)
	END

	IF (ISNULL(@EmployeesELManual,0) != 0 OR ISNULL(@CInfo_TempInsurance,0) = 1)
	BEGIN
		IF @TrdDtail_PrimaryRisk_ID  = 'LABOURER'
			INSERT INTO @Refer	VALUES( 'Employee Liability required and no EL Rates for ' + @TrdDtail_PrimaryRisk)
		IF @TrdDtail_SecondaryRisk_ID  = 'LABOURER'
			INSERT INTO @Refer	VALUES( 'Employee Liability required and no EL Rates for ' + @TrdDtail_SecondaryRisk)
	END

	IF @CInfo_WorkSoley = 1 AND @CInfo_MaxHeight = 'Over 15'
	 	INSERT INTO @Refer VALUES ('Yes selected for "Do you work solely on Private Dwellings, Shops and Offices only" yet the maximum height has been set to Over 15 metres') 


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
	UNION	SELECT [ReferBuilder] FROM @TradeELPLTable WHERE [ReferBuilder] IS NOT NULL

	IF @CInfo_TempInsurance= 'True' AND @CInfo_ManDays > 200
	 	INSERT INTO @Refer VALUES ('More than 200 days for temporary employees is not acceptable') 

	IF @CInfo_ToolCover= 'True' AND @ToolsRate = 0
	 	INSERT INTO @Refer VALUES ('No Rates Available for this level of Tools Cover') 

	IF @PostCode LIKE 'IM32%'
		INSERT INTO @Refer VALUES ('Check postcode for premium')

	IF @LargestClaim > 1000
			INSERT INTO @Refer VALUES ('Proposer has made a Claim in excess of £1,000')

	IF @ToolsClaimInLastFiveYears = 1
			INSERT INTO @Refer VALUES ('Proposer has made a tools Claim in the last 5 years')

	IF @ClaimsInLast5Years > 1
			INSERT INTO @Refer VALUES ('Proposer has made ' + CAST(@ClaimsInLast5Years AS VARCHAR(2)) + ' Claims in the last 5 years')

	IF @CInfo_ToolCover = 1 AND @CInfo_EmployeeTool= 0 AND @NonEmployeeManual = 0
			INSERT INTO @Refer VALUES ('Tools selected but no one working manually who is not an employee.')
	
	IF @EmployeesPL > 15
			INSERT INTO @Refer VALUES ('Maximum 0f 15 Manual Employees.')
	
	IF @EmployeesELNonManual > 10
			INSERT INTO @Refer VALUES ('Maximum 0f 10 Non Manual Employees')

	IF @CInfo_CompanyStatus = 'Limited' AND  (@CInfo_ManualDirectors + @CInfo_NonManuDirec) = 0
			INSERT INTO @Refer VALUES ('Limited Company: Total Number of Directors are 0')
		

	IF (@PolicyQuoteStage = 'NB' AND @TrdDtail_PresentInsurer = 'Tokio Marine HCC')
			INSERT INTO @Refer VALUES ('Previous Insurer Tokio Marine HCC')

	IF @TrdDtail_PrimaryRisk IS NULL
			INSERT INTO @Refer VALUES ('No Primary Trade has been selected.')

	IF @TrdDtail_WorkshopPercent > 20
			INSERT INTO @Refer VALUES ('Usage excedes Workshop Limit')

	IF 'Window Cleaner' IN (@TrdDtail_PrimaryRisk ,@TrdDtail_SecondaryRisk) AND @CInfo_TempInsurance = 1
			INSERT INTO @Refer VALUES ('Temporary EL not available for Window Cleaner ')

	IF 'Gutter Cleaner' IN (@TrdDtail_PrimaryRisk ,@TrdDtail_SecondaryRisk) AND @CInfo_TempInsurance = 1
			INSERT INTO @Refer VALUES ('Temporary EL not available for Gutter Cleaner')

    /*7742757533*/ /*7929136440*/
   IF @CInfo_WrittenRA = 0 AND @EmployeesPL > 1 
      INSERT INTO @Refer VALUES ('No Selected for "Do you complete Risk Assessments & Method Statements where appropriate?" and number of PL is greater than 1')
    /*7742757533*/ /*7929136440*/
   IF @Cinfo_HealthSafety = 0 AND @EmployeesPL > 1 
      INSERT INTO @Refer VALUES ('No Selected for "Does your business comply with HSE rules and regulations?" and number of PL is greater than 1')

	--IF 'Lift Installation' IN (@TrdDtail_PrimaryRisk ,@TrdDtail_SecondaryRisk)
	--BEGIN
	--	INSERT INTO @Refer VALUES('Automatic Referral')
	--END
	/*8177482880*/
	IF(@TrdDtail_Manufacture = 1)
	INSERT INTO @Refer VALUES ('Yes Selected for "Do you Manufacture, Process (including cutting/grinding) or Supply any Kitchen Worktops (or any other similar products)?"');

--Decline
	INSERT INTO @Decline
	SELECT [DeclineTrade] FROM @TradeELPLTable WHERE [DeclineTrade] IS NOT NULL;

	INSERT INTO @Decline
	SELECT [DeclineTradeNB] FROM @TradeELPLTable WHERE [DeclineTradeNB] IS NOT NULL;

	/*	Groundworker - any depth greater than 5 meters needs to decline	*/
	IF @TrdDtail_PrimaryRisk_ID = '3N0TVE89' AND @TrdDtail_MaxDepth > 5
		INSERT INTO @Decline VALUES ('Depth Limit Exceeds 5 meters')

	/* 4223122759 */
	IF(@TrdDtail_PrimaryRisk_ID IN ('3N0TVHP9','3N0TVHQ9') AND ISNULL(@CInfo_Annualturnover, 0) > 0 AND @CInfo_Annualturnover >= 2000000)
	   INSERT INTO @Decline VALUES ('Trade '+ @TrdDtail_PrimaryRisk +'''s Total Annual Turnover Exceeds £2,000,000')

    /*4223138901*/
    IF(SUBSTRING(@PostCode,1,2) ='BT')
      INSERT INTO @Decline VALUES( 'New business for Postcode ' + @PostCode + ' cannot be covered')

    /*5297879614*/
	--IF(@TrdDtail_PrimaryRisk_ID = '3N0TVFQ9' OR @TrdDtail_SecondaryRisk_ID = '3N0TVFQ9')
	--  INSERT INTO @Decline VALUES('Trade is not acceptable')

--Endorsements
	INSERT INTO @Endorsement 
	SELECT [Token] FROM @TradeELPLTable CROSS APPLY [dbo].[tvfSplitStringByDelimiter]([Endorsement],',') WHERE ISNULL([Endorsement],'') !='' 

	IF ISNULL(@CInfo_BonaFideWR ,0) != 0
		INSERT INTO @Endorsement VALUES ('418GJME2')

	IF ISNULL(@TrdDtail_EfficacyCover ,0) != 0
		INSERT INTO @Endorsement VALUES ('4167EOA9')

	IF @Contractsworks = 'true'
		INSERT INTO @Endorsement VALUES ('TOMTLTFP')


--Excesses '{Excess Desc}:{ExcessVal000}:{List_Excess_Section.Excess_Section_ID}:{LIST_EXCESSTYPE.ExcessType_ID}'
	INSERT INTO @Excess 
	SELECT * FROM [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_tvfExcess](@ExperienceYears ,@ExcessPropertyAmount ,@ExcessHeatAmount ,@CInfo_ToolCover ,@PolicyStartDatetime)


--Return Table
	declare @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN
END
