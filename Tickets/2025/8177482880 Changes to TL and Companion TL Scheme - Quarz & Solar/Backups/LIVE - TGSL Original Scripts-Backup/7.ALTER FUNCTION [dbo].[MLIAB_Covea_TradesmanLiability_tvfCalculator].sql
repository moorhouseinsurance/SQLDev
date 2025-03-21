USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_Covea_TradesmanLiability_tvfCalculator]    Script Date: 21/01/2025 23:11:01 ******/
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
-- 17/08/2023	Linga			        Monday ticket 4971099984: Scheme Change Specification For Covea Tradesman and Small Business
-- 06/02/2024	Simon Mackness-Pettit	Monday ticket 6010275155: Decline Solar Panel Installation
-- 16/09/2024   Linga                   Monday Ticket 6184964279: £10,000,000 PL Covea Rate - Added £1 premium rates for £10,000,000,and added new field [IsMinPremAppl] to check whether min Premium applicable or not
*******************************************************************************/
ALTER FUNCTION [dbo].[MLIAB_Covea_TradesmanLiability_tvfCalculator]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
	,@ClaimsSummary ClaimSummaryTableType READONLY
	,@EmployeeCounts EmployeeCountsTableType READONLY
	,@TrdDtail MLIAB_TrdDtailTableType READONLY
	,@CInfo MLIAB_CInfoTableType READONLY
	,@PandP MLIAB_PandPTableType READONLY
	,@BusSupp MLIAB_BusSuppTableType READONLY
	,@Subsid MLIAB_SubsidTableType READONLY
	,@CAR MLIAB_CARTableType READONLY
)

/*

truncate table uspSchemeCommandDebug
Select * from uspSchemeCommandDebug WHERE uspSchemeCommandText LIKE '%MLIAB_Covea_TradesmanLiability_tvfCalculator%'

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
			,@Insurer [varchar] (30) = 'Covea Insurance'
			,@LineOfBusiness [varchar] (30) = 'MLIAB'

	SET @LimitPremiumRateMin = [dbo].[svfLimitSelect](@SchemeTableID ,@Insurer ,@LineOfBusiness ,'Premium'	,'Min'	,@PolicyStartDateTime )
	SET @LimitEmployeesPLMax = [dbo].[svfLimitSelect](@SchemeTableID , @Insurer ,@LineOfBusiness ,'EmployeesPL'	,'Max'	,@PolicyStartDateTime )
	SET @LimitEmployeesELMax = [dbo].[svfLimitSelect](@SchemeTableID , @Insurer ,@LineOfBusiness ,'EmployeesEL'	,'Max'	,@PolicyStartDateTime )
	SET @TrdDtail_WorkshopPercentLimitMax = [dbo].[svfLimitSelect](@SchemeTableID , @Insurer ,@LineOfBusiness ,'TrdDtail_WorkshopPercent' ,'Max'	,@PolicyStartDateTime )
	SET @CInfo_ManDaysLimitMax = [dbo].[svfLimitSelect](@SchemeTableID , @Insurer ,@LineOfBusiness ,'CInfo_ManDays'	,'Max'	,@PolicyStartDateTime )
	SET @LimitClaimMax = [dbo].[svfLimitSelect](@SchemeTableID , @Insurer ,@LineOfBusiness ,'Claim'	,'Max'	,@PolicyStartDateTime )
	SET @LimitEmployersLiability		= [dbo].[svfLimitSelect](@SchemeTableID , @Insurer ,@LineOfBusiness ,'EmployersLiability' ,'Max'	,@PolicyStartDateTime )
	
	DECLARE @ChargeIPT bit = CASE WHEN @postcode like 'IM%' THEN 0 WHEN @postcode like 'GY%' THEN 0 WHEN @postcode like 'JE%' THEN 0 ELSE 1 END

--Loads Discount Rates
	--Employee Discount
	DECLARE @DiscountRatePL money = 0
	DECLARE @DiscountRateEL money = 0
	SET @DiscountRateEL = [dbo].[MLIAB_Covea_TradesmanLiability_svfLoadDiscountEmployees] (@EmployeesELManual, @PolicyStartDateTime) - 1
	IF @EmployeesELManual > 3
		SET @DiscountRatePL = @DiscountRateEL

	--No Claims Discount
	DECLARE @ExperienceYears int = @CInfo_YrsExp
	IF @ExperienceYears = 0
		SET @ExperienceYears = YEAR(@PolicyStartDateTime) - @CInfo_YrEstablished
	DECLARE @MostRecentClaimYears int = ISNULL( [dbo].[svfAgeInYears](@MostRecentClaim,@PolicyStartDateTime) ,1000)
	DECLARE @NoClaimsLoadDiscountRate money = [dbo].[MLIAB_Covea_TradesmanLiability_svfLoadDiscountClaims] (@ExperienceYears,@MostRecentClaimYears,@PolicyStartDateTime) - 1

	--Postcode Weight
	SET @PostCode = REPLACE(@PostCode,' ','')
	DECLARE @PostcodeWeight decimal(6,4) = 1
	SET @PostcodeWeight = [dbo].[MLIAB_Covea_TradesmanLiability_svfLoadDiscountPostcode] (@PostCode ,@PolicyStartDateTime)
	DECLARE @PostcodeLoadDiscountPctRate money = @PostcodeWeight - 1
																												
--Tools rates
	DECLARE @ToolsRate int = 0
	SET @ToolsRate = [dbo].[MLIAB_Covea_TradesmanLiability_svfRateTools] ([dbo].[svfformatnumber](@CInfo_ToolValue) ,@PolicyStartDateTime)

	DECLARE @TradeELPLTable table
	(
		 Trade varchar(250)
		,[ReferTrade] varchar(250)
		,[Refer_ReferFlag] varchar(250)
		,[ReferCInfo_PubLiabLimit] varchar(250)
		,[ReferCInfo_WorkSoley] varchar(250)
		,[ReferTrdDtail_Phase] varchar(250)
		,[ReferCInfo_Heat] varchar(250)
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
		,[IsMinPremAppl] BIT
	)
	INSERT INTO @TradeELPLTable
	SELECT
	  *
	FROM [dbo].[MLIAB_Covea_TradesmanLiability_tvfTrades] 
	(
		   @TrdDtail_PrimaryRisk
		  ,@TrdDtail_PrimaryRisk_ID
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
		FROM [dbo].[MLIAB_Covea_TradesmanLiability_tvfTrades] 
		(
			   @TrdDtail_SecondaryRisk
			  ,@TrdDtail_SecondaryRisk_ID
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

	SELECT
		 @PLRate = MAX(PL)
		,@ELRate = MAX(EL)
		,@ExcessPropertyAmount = MAX([ExcessProperty])
		,@ExcessHeatAmount = MAX([ExcessHeat])
	FROM
		@TradeELPLTable


--Fixed Machinery Rates
	DECLARE @RateFixedMachinery int = [dbo].[MLIAB_Covea_TradesmanLiability_svfRate] ('FixedMachinery',@PolicyStartDateTime)


--Calculate Premiums and Insert Breakdowns
	DECLARE @Cover bigint =0
	DECLARE @Premium numeric(18, 4) = 0
	DECLARE @BasePremium money = 0
	DECLARE @TotalBasePremium money = 0
	DECLARE @TotalPremium money = 0

	DECLARE @Section varchar(50) 
	DECLARE @PostcodeLoadDiscountPremium money = 0
	DECLARE @TotalPostcodeLoadDiscountPremium money = 0
	DECLARE @NoClaimsLoadDiscountPremium money = 0
	DECLARE @TotalNoClaimsDiscountPremium money = 0
	DECLARE @EmployeeDiscountPremium money = 0
	DECLARE @TotalEmployeeDiscountPremium money = 0
	--4971099984
	DECLARE @ClaimsDiscountRate decimal(10,4)
	DECLARE @ClaimsLoadDiscountPremium money = 0
	DECLARE @TotalClaimsLoadDiscountPremium  money = 0
	DECLARE @ClaimsLoadReferFlag BIT 
	DECLARE @ClaimsLoadReferMonths int  
    DECLARE @ClaimsLoadReferSectionPremium money  	
	

	INSERT INTO @ProductDetail	VALUES(	'Sums Insured')

	SELECT	 @Section = 'Public Liability'
			,@Premium = @PLRate 
			,@Cover = [dbo].[svfFormatNumber](@CInfo_PubLiabLimit)
			,@BasePremium = @Premium

	INSERT INTO @Breakdown	VALUES(	':::')--Blank line
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

	SET @PostcodeLoadDiscountPremium = @Premium * ISNULL(@PostcodeLoadDiscountPctRate,0)
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
	SET @Premium = @Premium + @PostcodeLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @EmployeeDiscountPremium = @Premium * ISNULL(@DiscountRatePL,0)
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRatePL ,@Premium ,@EmployeeDiscountPremium))	
	SET @Premium = @Premium + @EmployeeDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @NoClaimsLoadDiscountPremium = @Premium * ISNULL(@NoClaimsLoadDiscountRate,0)
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
	SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	--Claims load -- 4971099984
	IF(@ClaimsInLast5Years = 1 AND @LargestClaim >= 1000 AND @MostRecentClaim IS NOT NULL)
	BEGIN
	SET @ClaimsLoadDiscountPremium = 0;
	SET @ClaimsDiscountRate = (SELECT ISNULL([LoadDiscountValue], 0) FROM [dbo].[MLIAB_Covea_TradesmanLiability_LoadDiscount_Claims_Range] WHERE [ClaimStartRange] <= @LargestClaim AND [ClaimEndRange] > @LargestClaim 
	AND  [MonthsStartRange] <= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [MonthsEndRange] >= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [PremiumStartRange] <= ISNULL(@Premium,0)  AND ([PremiumEndRange] > ISNULL(@Premium,0) OR [PremiumEndRange] IS NULL));
	   IF(@ClaimsDiscountRate IS NOT NULL )
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
	SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
	SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
	SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
	SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium


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

		SET @PostcodeLoadDiscountPremium = @Premium * ISNULL(@PostcodeLoadDiscountPctRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @EmployeeDiscountPremium = @Premium * ISNULL(@DiscountRateEL,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRateEL ,@Premium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * ISNULL(@NoClaimsLoadDiscountRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		--Claims load -- 4971099984
	    IF(@ClaimsInLast5Years = 1 AND @LargestClaim >= 1000 AND @MostRecentClaim IS NOT NULL)
	    BEGIN
	    SET @ClaimsLoadDiscountPremium = 0;
	    SET @ClaimsDiscountRate = (SELECT ISNULL([LoadDiscountValue], 0) FROM [dbo].[MLIAB_Covea_TradesmanLiability_LoadDiscount_Claims_Range] WHERE [ClaimStartRange] <= @LargestClaim AND [ClaimEndRange] > @LargestClaim 
	    AND  [MonthsStartRange] <= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [MonthsEndRange] >= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [PremiumStartRange] <= ISNULL(@Premium,0)  AND ([PremiumEndRange] > ISNULL(@Premium,0) OR [PremiumEndRange] IS NULL));
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
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium

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

		SET @PostcodeLoadDiscountPremium = @Premium * ISNULL(@PostcodeLoadDiscountPctRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @EmployeeDiscountPremium = @Premium * ISNULL(@DiscountRatePL,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRatePL ,@Premium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * ISNULL(@NoClaimsLoadDiscountRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		--Claims load -- 4971099984
	    IF(@ClaimsInLast5Years = 1 AND @LargestClaim >= 1000 AND @MostRecentClaim IS NOT NULL)
	    BEGIN
	    SET @ClaimsLoadDiscountPremium = 0;
	    SET @ClaimsDiscountRate = (SELECT ISNULL([LoadDiscountValue], 0) FROM [dbo].[MLIAB_Covea_TradesmanLiability_LoadDiscount_Claims_Range] WHERE [ClaimStartRange] <= @LargestClaim AND [ClaimEndRange] > @LargestClaim 
	    AND  [MonthsStartRange] <= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [MonthsEndRange] >= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [PremiumStartRange] <= ISNULL(@Premium,0)  AND ([PremiumEndRange] > ISNULL(@Premium,0) OR [PremiumEndRange] IS NULL));
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
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium

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

		SET @PostcodeLoadDiscountPremium = @Premium * ISNULL(@PostcodeLoadDiscountPctRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @EmployeeDiscountPremium = @Premium * ISNULL(@DiscountRatePL,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRatePL ,@Premium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * ISNULL(@NoClaimsLoadDiscountRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		--Claims load -- 4971099984
	    IF(@ClaimsInLast5Years = 1 AND @LargestClaim >= 1000 AND @MostRecentClaim IS NOT NULL)
	    BEGIN
	    SET @ClaimsLoadDiscountPremium = 0;
	    SET @ClaimsDiscountRate = (SELECT ISNULL([LoadDiscountValue], 0) FROM [dbo].[MLIAB_Covea_TradesmanLiability_LoadDiscount_Claims_Range] WHERE [ClaimStartRange] <= @LargestClaim AND [ClaimEndRange] > @LargestClaim 
	    AND  [MonthsStartRange] <= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [MonthsEndRange] >= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [PremiumStartRange] <= ISNULL(@Premium,0)  AND ([PremiumEndRange] > ISNULL(@Premium,0) OR [PremiumEndRange] IS NULL));
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
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium

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

		SET @EmployeeDiscountPremium = @Premium * ISNULL(@DiscountRatePL,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRatePL ,@Premium ,@EmployeeDiscountPremium))	
		SET @Premium = @Premium + @EmployeeDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * ISNULL(@NoClaimsLoadDiscountRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		--Claims load -- 4971099984
	    IF(@ClaimsInLast5Years = 1 AND @LargestClaim >= 1000 AND @MostRecentClaim IS NOT NULL)
	    BEGIN
	    SET @ClaimsLoadDiscountPremium = 0;
	    SET @ClaimsDiscountRate = (SELECT ISNULL([LoadDiscountValue], 0) FROM [dbo].[MLIAB_Covea_TradesmanLiability_LoadDiscount_Claims_Range] WHERE [ClaimStartRange] <= @LargestClaim AND [ClaimEndRange] > @LargestClaim 
	    AND  [MonthsStartRange] <= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [MonthsEndRange] >= DATEDIFF(MONTH, @MostRecentClaim, GETDATE()) AND [PremiumStartRange] <= ISNULL(@Premium,0)  AND ([PremiumEndRange] > ISNULL(@Premium,0) OR [PremiumEndRange] IS NULL));

		IF(@ClaimsDiscountRate IS NOT NULL ) 
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
		SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium

		UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'FXMCPREM'
	END
	
	--Breakdown totals
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Base Premium' ,NULL ,NULL ,@TotalBasePremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Postcode Load Discount Premium' ,NULL ,NULL ,@TotalPostcodeLoadDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Employees Discount Premium' ,NULL ,NULL ,@TotalEmployeeDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total No Claims Discount Premium' ,NULL ,NULL ,@TotalNoClaimsDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Claim Load/Discount Premium' ,NULL ,NULL ,@TotalClaimsLoadDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium))

----Min Premium
--	IF (@TotalPremium != 0) AND (@TotalPremium < @LimitPremiumRateMin)
--	BEGIN
--		UPDATE @Premiums SET [Value] = ([value]/@TotalPremium)* @LimitPremiumRateMin
--		INSERT INTO @Breakdown	VALUES('Minimum Premium:::')
--		INSERT INTO @Breakdown	SELECT ([dbo].[svfFormatBreakdownString](CASE [NAME] WHEN 'LIABPREM' THEN 'Public Liability' WHEN 'EMPLPREM' THEN 'Employers Liability' WHEN 'TOOLPREM' THEN 'Tools' WHEN 'FXMCPREM' THEN 'Fixed Machinery' END + ' Premium' ,NULL ,NULL ,[Value])) FROM @Premiums WHERE [Value] != 0
--	END
	--Min Premium
    --Min Premium Applicable check
    DECLARE @IsMinPremApp BIT ;
	IF EXISTS (SELECT 1 FROM @TradeELPLTable WHERE [IsMinPremAppl] = 1) SET @IsMinPremApp = 1
	ELSE SET @IsMinPremApp = 0;
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
	DECLARE @MaxBonaFideWageRoll int  = (@EmployeesPL * 10000) + 40000
	IF @CInfo_BonaFideWR > @MaxBonaFideWageRoll
		INSERT INTO @Refer	VALUES('Max bonafide wage Level of ' + [dbo].[svfFormatmoneyString](@MaxBonaFideWageRoll) + ' Exceeded for ' + CAST(@EmployeesPL as Varchar(2)) + ' employees' )

	IF @CInfo_WorkSoley = 1 AND @CInfo_MaxHeight = 'Over 15'
	 	INSERT INTO @Refer VALUES ('Yes selected for "Do you work solely on Private Dwellings, Shops and Offices only" yet the maximum height has been set to Over 15 metres') 

	--Trade refers
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

	IF @CInfo_TempInsurance= 'True' AND @CInfo_ManDays > @CInfo_ManDaysLimitMax
	 	INSERT INTO @Refer VALUES ('More than ' + CAST(@CInfo_ManDaysLimitMax AS varchar(3)) +' days for temporary employees is not acceptable') 

	IF @CInfo_ToolCover= 'True' AND @ToolsRate = 0
	 	INSERT INTO @Refer VALUES ('No Rates Available for this level of Tools Cover') 

	IF @PostCode LIKE 'IM32%'
		INSERT INTO @Refer VALUES ('Check postcode for premium')
	---- 4971099984	
	IF(@ClaimsLoadReferFlag IS NOT NULL AND @ClaimsLoadReferFlag = 1)
	    INSERT INTO @Refer VALUES ('No Loading rule to a claim of '+ [dbo].[svfFormatMoneyString](@LargestClaim) +' per section premium of '+[dbo].[svfFormatMoneyString](@ClaimsLoadReferSectionPremium) + +' for a period of '+CAST(@ClaimsLoadReferMonths AS VARCHAR(10))+'months')
	-- 4971099984	
	IF @LargestClaim >= @LimitClaimMax
			INSERT INTO @Refer VALUES ('Proposer has made a Claim in excess of '+ [dbo].[svfFormatMoneyString](@LimitClaimMax))

	IF @ToolsClaimInLastFiveYears = 1
			INSERT INTO @Refer VALUES ('Proposer has made a tools Claim in the last 5 years')

	IF @ClaimsInLast5Years > 1
			INSERT INTO @Refer VALUES ('Proposer has made ' + CAST(@ClaimsInLast5Years AS VARCHAR(2)) + ' Claims in the last 5 years')

	IF @CInfo_ToolCover = 1 AND @CInfo_EmployeeTool= 0 AND @NonEmployeeManual = 0
			INSERT INTO @Refer VALUES ('Tools selected but no one working manually who is not an employee.')

	IF @EmployeesPL > @LimitEmployeesPLMax
			INSERT INTO @Refer VALUES ('Maximum 0f 10 Manual Employees.')

	IF @EmployeesELNonManual > @LimitEmployeesELMax
			INSERT INTO @Refer VALUES ('Maximum 0f 10 Non Manual Employees')

	IF (@TrdDtail_SecondaryRisk like 'Landscape Gardener%' OR @TrdDtail_PrimaryRisk like'Landscape Gardener%' ) AND @TrdDtail_MaxDepth > '3'
			INSERT INTO @Refer VALUES ('Landscape Gardener restricted to 3M depth.')

	IF (@PolicyQuoteStage = 'NB' AND @TrdDtail_PresentInsurer = 'Covea Insurance')
			INSERT INTO @Refer VALUES ('Previous Insurer Covea Insurance')

	IF @TrdDtail_PrimaryRisk IS NULL
			INSERT INTO @Refer VALUES ('No Primary Trade has been selected.')

	IF @TrdDtail_WorkshopPercent > @TrdDtail_WorkshopPercentLimitMax
			INSERT INTO @Refer VALUES ('Usage excedes Workshop Limit')

	IF 'Window Cleaner' IN (@TrdDtail_PrimaryRisk ,@TrdDtail_SecondaryRisk) AND @CInfo_TempInsurance = 1
			INSERT INTO @Refer VALUES ('Temporary EL not available for Window Cleaner ')

	IF 'Gutter Cleaner' IN (@TrdDtail_PrimaryRisk ,@TrdDtail_SecondaryRisk) AND @CInfo_TempInsurance = 1
			INSERT INTO @Refer VALUES ('Temporary EL not available for Gutter Cleaner')

	--Declines
	IF @PostCode like 'BT%' --(Refer for Covea)
		INSERT INTO @Decline VALUES ('Northern Ireland Risks must be declined')

	IF 'Solar Panel Installation' IN (@TrdDtail_PrimaryRisk ,@TrdDtail_SecondaryRisk)
		INSERT INTO @Decline VALUES ('Solar Panel Installation not available')

--Endorsements
	INSERT INTO @Endorsement 
	SELECT [Token] FROM @TradeELPLTable CROSS APPLY [dbo].[tvfSplitStringByDelimiter]([Endorsement],',') WHERE ISNULL([Endorsement],'') !='' 
	
	IF @TrdDtail_PrimaryRisk IN ('Bathroom Installation' ,'Kitchen Installer') AND  @TrdDtail_SecondaryRisk IN ('Bathroom Installation' ,'Kitchen Installer')
	BEGIN
		DELETE @Endorsement
		INSERT INTO @Endorsement Values ('MMALIA01'),('MMALIA14'),('MMALIA27') 
	END

	IF @TrdDtail_PrimaryRisk = 'Chimney Sweep'
	BEGIN
		DELETE @Endorsement
		INSERT INTO @Endorsement Values ('MMALIA01'),('MMALIA02'),('MMALIA10') 
	END

	IF @TrdDtail_PrimaryRisk = 'Skip Hire'
	BEGIN
		INSERT INTO @Endorsement Values ('MMALIA1J'), ('MMALIA1K'), ('MMALIA1L') 
	END

	IF @TrdDtail_FixedMachinery = 1
		DELETE FROM @Endorsement WHERE [Message] = 'MMALIA14'

	IF  'Aerial & Satellite Dish Erector' IN (@TrdDtail_PrimaryRisk ,@TrdDtail_SecondaryRisk)
	BEGIN
		DELETE FROM @Endorsement WHERE [Message] IN ('MMALIA06' ,'MMALIA34')
		INSERT INTO @Endorsement Values ('MMALIA32')
	END

	IF EXISTS (SELECT 1 FROM @Endorsement WHERE [Message] = 'MMALIA28')
	BEGIN
		DELETE FROM  @Endorsement WHERE [Message] = 'MMALIA02'
	END 
--Excesses '{Excess Desc}:{ExcessVal000}:{List_Excess_Section.Excess_Section_ID}:{LIST_EXCESSTYPE.ExcessType_ID}'
	INSERT INTO @Excess 
	SELECT * FROM [dbo].[MLIAB_Covea_TradesmanLiability_tvfExcess](@ExperienceYears ,@ExcessPropertyAmount ,@ExcessHeatAmount ,@CInfo_ToolCover ,@PolicyStartDatetime)

--Product Details		
	INSERT INTO @ProductDetail	VALUES(	'No Claims Discount = '+ CAST(@NoClaimsLoadDiscountRate*100 AS VARCHAR(10)) + '%')

--Return Table
	declare @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN
END
