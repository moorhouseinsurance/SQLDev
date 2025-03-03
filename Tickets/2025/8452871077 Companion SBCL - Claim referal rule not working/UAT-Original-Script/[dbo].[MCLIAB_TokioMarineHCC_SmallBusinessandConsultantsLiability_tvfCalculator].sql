USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MCLIAB_TokioMarineHCC_SmallBusinessandConsultantsLiability_tvfCalculator]    Script Date: 12/02/2025 08:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
-- Author:		System Generated
-- Date:        {Datetime}
-- Description: Return Scheme Information
*******************************************************************************/

ALTER FUNCTION [dbo].[MCLIAB_TokioMarineHCC_SmallBusinessandConsultantsLiability_tvfCalculator]
(
     @PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
    ,@SchemeTableID int
	,@EmployeeCounts EmployeeCountsTableType READONLY
	,@CInfo CInfoTableType READONLY
	,@ClaimsSummary ClaimSummaryTableType READONLY
)

/*
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

	DECLARE	 @Cinfo_PubLiabLimit varchar(250)
			,@Cinfo_PrimaryRisk varchar(250)
			,@Cinfo_PrimaryRisk_ID varchar(8)
			,@Cinfo_YrsExp money
			,@CInfo_YrEstablished money
	SELECT 
		 @Cinfo_YrsExp = [YrsExp]
		,@Cinfo_YrEstablished = [YrEstablished]
		,@Cinfo_PrimaryRisk = [PrimaryRisk]
		,@Cinfo_PrimaryRisk_ID = [PrimaryRisk_ID]
		,@Cinfo_PubLiabLimit = [PubLiabLimit]
	FROM
		@CInfo

	DECLARE	 @EmployeesPL int
			,@EmployeesELManual	int
			,@EmployeesELNonManual int
	SELECT 
		 @EmployeesPL = [E].[EmployeesPL] 
		,@EmployeesELManual = [E].[EmployeesELManual]
		,@EmployeesELNonManual = [E].[EmployeesELNonManual] 
	FROM 
		@EmployeeCounts AS [E]

	DECLARE  @Count5Years int
			,@MostRecentClaim datetime
			,@LargestClaim money
			,@ToolsClaimInLastFiveYears bit
	SELECT
		 @Count5Years				= [Count5Years]
		,@MostRecentClaim			= [MostRecentClaim]
		,@LargestClaim				= [LargestClaim]
		,@ToolsClaimInLastFiveYears	= [ToolsClaimInLastFiveYears]
	FROM
		@ClaimsSummary

--Limits
	DECLARE 
		 @Insurer [varchar] (30) = 'Covea Insurance'
		,@LineOfBusiness [varchar] (30) = 'MCLIAB'

	DECLARE  
		 @LimitEmployersLiability_Max int		= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'EmployersLiability' ,'Max'	,@PolicyStartDateTime )
		,@LimitEmployeesPL_Max int				= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'EmployeesPL' ,'Max'	,@PolicyStartDateTime )
		,@LimitEmployeesNonManual_Max int		= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'EmployeesNonManual' ,'Max'	,@PolicyStartDateTime )
		,@LimitClaimAmount_Max int				= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'Claim' ,'Max'	,@PolicyStartDateTime )
		,@LimitPremiumRate_Min int 				= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'Premium' ,'Min'	,@PolicyStartDateTime )
		,@LimitClaimsInLastFiveYears_Max int	= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'ClaimsInLastFiveYears' ,'Max'	,@PolicyStartDateTime )

--Loads Discount Rates
	--Excess Load
	DECLARE @LoadExperienceExcess int = 2
	--Premium Discount
	DECLARE @DiscountPremiumSectionsRate money = -0.01

	--Employees Discount
	DECLARE @DiscountRatePL money = 0
	DECLARE @DiscountRateEL money = 0
	SET @DiscountRateEL = ([dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfLoadDiscountsSelect](NULL ,'EmployeesELManual' ,@EmployeesELManual ,@PolicyStartDateTime) -1)
	IF @EmployeesELManual > 3
		SET @DiscountRatePL = @DiscountRateEL

	--No claims Discount
	DECLARE @ExperienceYears int = @Cinfo_YrsExp
	IF @ExperienceYears = 0
		SET @ExperienceYears = YEAR(@PolicyStartDateTime) - @CInfo_YrEstablished
	DECLARE @MostRecentClaimYears int = ISNULL( [dbo].[svfAgeInYears](@MostRecentClaim ,@PolicyStartDateTime) ,1000)
	DECLARE @NoClaimsLoadDiscountRate money = [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfLoadDiscountClaims] (@ExperienceYears,@MostRecentClaimYears,@PolicyStartDateTime) - 1

	--Postcode Weight
	SET @PostCode = REPLACE(@PostCode,' ','')
	DECLARE @PostcodeWeight decimal(6,4) = 1
	SET @PostcodeWeight = [dbo].[MCLIAB_TokioMarineHCC_SmallBusinessAndConsultantsLiability_svfLoadDiscountPostcode] (@PostCode ,@PolicyStartDateTime)
	DECLARE @PostcodeLoadDiscountPctRate money = @PostcodeWeight - 1

--Trade Rates
	DECLARE  @TradeELPLTable table
	(
		 [Trade] varchar(250)
		,[ReferTrade] varchar(250)
		,[ReferCInfo_PubLiabLimit] varchar(250)
		,[Refer_ReferFlag] varchar(250)
		,[ReferEmployeesPL] varchar(250)
		,[ReferEmployeeEL] varchar(250)
		,[TradeDescriptionInsurer] varchar(250)
		,[PL] money
		,[EL] money
		,[ExcessProperty] BIGINT
		,[ExcessHeat] BIGINT
		,[Endorsement] varchar(250)
	)
	INSERT INTO @TradeELPLTable
	SELECT * FROM [dbo].[MCLIAB_TokioMarineHCC_SmallBusinessandConsultantsLiability_tvfTrades] 
	(
		   @Cinfo_PrimaryRisk
		  ,@Cinfo_PrimaryRisk_ID
		  ,@PolicyStartDatetime
		  ,@CInfo_PubLiabLimit
		  ,@EmployeesPL
		  ,@EmployeesELManual
	)
	
	DECLARE @PLRate money
		,@ELRate money
		,@ExcessPropertyAmount bigint
		,@ExcessHeatAmount bigint


	SELECT
		 @PLRate =[PL]
		,@ELRate = [EL]
		,@ExcessPropertyAmount =[ExcessProperty]
		,@ExcessHeatAmount = [ExcessHeat]
	FROM
		@TradeELPLTable

	INSERT INTO @Endorsement SELECT [Endorsement] FROM @TradeELPLTable WHERE ISNULL([Endorsement],'') !='' 

--Calculate Premiums and Insert Breakdowns
	DECLARE 
		 @Premium numeric(18, 4) = 0
		,@BasePremium money = 0
		,@TotalBasePremium money = 0
		,@TotalPremium money = 0
		,@Section varchar(50) 
		,@PostcodeLoadDiscountPremium money = 0
		,@TotalPostcodeLoadDiscountPremium money = 0
		,@NoClaimsLoadDiscountPremium money = 0
		,@TotalNoClaimsDiscountPremium money = 0
		,@EmployeeDiscountPremium money = 0
		,@TotalEmployeeDiscountPremium money = 0
		,@TotalDiscountPremiumSections money = 0
		,@DiscountPremiumSectionsPremium money = 0

	SELECT	 @Section = 'Public Liability'
			,@Premium = @PLRate 
			,@BasePremium = @Premium

	INSERT INTO @Breakdown	VALUES(	':::')--Blank line
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

	SET @PostcodeLoadDiscountPremium = @Premium * @PostcodeLoadDiscountPctRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
	SET @Premium = @Premium + @PostcodeLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @EmployeeDiscountPremium = @Premium * @DiscountRatePL
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRatePL ,@Premium ,@EmployeeDiscountPremium))	
	SET @Premium = @Premium + @EmployeeDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
	SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @DiscountPremiumSectionsPremium = @Premium * @DiscountPremiumSectionsRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSectionsRate ,@Premium ,@DiscountPremiumSectionsPremium))	
	SET @Premium = @Premium + @DiscountPremiumSectionsPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	INSERT INTO @Breakdown	VALUES(	':::')--Blank line

	SET @TotalBasePremium = @TotalBasePremium + @BasePremium
	SET @TotalPremium = @TotalPremium + @Premium
	SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
	SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
	SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSectionsPremium
	SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium

	INSERT INTO @Premiums ([Name] ,[Value]) VALUES ('LIABPREM' ,@Premium)

	--ELPremium 
	SELECT	 @Section = 'Employers Liability'
			,@Premium = @ELRate * @EmployeesELManual
			,@BasePremium = @Premium

	INSERT INTO @Breakdown	VALUES(	':::')--Blank line
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
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
	SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @DiscountPremiumSectionsPremium = @Premium * @DiscountPremiumSectionsRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSectionsRate ,@Premium ,@DiscountPremiumSectionsPremium))	
	SET @Premium = @Premium + @DiscountPremiumSectionsPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	INSERT INTO @Breakdown	VALUES(	':::')--Blank line

	SET @TotalBasePremium = @TotalBasePremium + @BasePremium
	SET @TotalPremium = @TotalPremium + @Premium
	SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
	SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
	SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
	SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSectionsPremium

	INSERT INTO @Premiums ([Name] ,[Value])  VALUES ('EMPLPREM' ,@Premium)
	
	--Breakdown totals
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Base Premium' ,NULL ,NULL ,@TotalBasePremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Postcode Load Discount Premium' ,NULL ,NULL ,@TotalPostcodeLoadDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Employees Discount Premium' ,NULL ,NULL ,@TotalEmployeeDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total No Claims Discount Premium' ,NULL ,NULL ,@TotalNoClaimsDiscountPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Discount Premium Sections' ,NULL ,NULL ,@TotalDiscountPremiumSections))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium))

--Min Premium
	IF (@TotalPremium != 0) AND (@TotalPremium < @LimitPremiumRate_Min)
	BEGIN
		UPDATE @Premiums SET [Value] = ([value]/@TotalPremium)* @LimitPremiumRate_Min
		INSERT INTO @Breakdown	VALUES('Minimum Premium:::')
		INSERT INTO @Breakdown	SELECT ([dbo].[svfFormatBreakdownString](LEFT([Name],2) + ' Premium' ,NULL ,NULL ,[Value])) FROM @Premiums WHERE [Value] != 0
	END

--Referrals
	--Trade refers
	INSERT INTO @Refer
	SELECT [ReferTrade] FROM @TradeELPLTable WHERE [ReferTrade] IS NOT NULL
	UNION
	SELECT [ReferCInfo_PubLiabLimit] FROM @TradeELPLTable WHERE [ReferCInfo_PubLiabLimit] IS NOT NULL
	UNION
	SELECT [Refer_ReferFlag] FROM @TradeELPLTable WHERE [Refer_ReferFlag] IS NOT NULL
	UNION
	SELECT [ReferEmployeesPL] FROM @TradeELPLTable WHERE [ReferEmployeesPL] IS NOT NULL
	UNION
	SELECT [ReferEmployeeEL] FROM @TradeELPLTable WHERE [ReferEmployeeEL] IS NOT NULL

	IF @EmployeesPL > @LimitEmployeesPL_Max
		INSERT INTO @Refer VALUES ('Maximum 0f ' + CAST(@LimitEmployeesPL_Max AS varchar(3)) + ' Manual Employees')

	IF @EmployeesELNonManual > @LimitEmployeesNonManual_Max
		INSERT INTO @Refer VALUES ('Maximum 0f ' + CAST(@LimitEmployeesNonManual_Max AS varchar(3)) + ' Non Manual Employees')

	IF @ELRate = 0 AND (@EmployeesELManual > 0 OR @EmployeesELNonManual > 0)
		INSERT INTO @Refer VALUES ('No EL rates against this trade ')
		
	IF @CInfo_PrimaryRisk = 'Courier (Using Vehicles up to Max Laden Weight 3.5 Tonnes'
			INSERT INTO @Refer VALUES ('Cannot insure - Courier (Using Vehicles up to Max Laden Weight 3.5 Tonnes')
		
	IF @CInfo_PrimaryRisk = 'Market Trader'
			INSERT INTO @Refer VALUES ('Cannot insure - Market Trader')
	
	IF @LimitClaimAmount_Max < @LargestClaim
		INSERT INTO @Refer VALUES ('Proposer has made a Claim in excess of' + [dbo].[svfFormatMoneyString](@LimitClaimAmount_Max))

	IF @ToolsClaimInLastFiveYears = 1
		INSERT INTO @Refer VALUES ('Proposer has made a tools Claim in the last 5 years')

	IF @Count5Years > 1
		INSERT INTO @Refer VALUES ('Proposer has made ' + CAST(@Count5Years AS VARCHAR(2)) + ' Claims in the last 5 years')

	IF @CInfo_PrimaryRisk IN
	(
		'Car Valeter'
	)
	INSERT INTO @Refer VALUES( 'Trade ' + @CInfo_PrimaryRisk + ' not acceptable for Small Business and Consultants Liability')

--Declines
  /*4223138901*/
  IF(SUBSTRING(@PostCode,1,2) ='BT')
   INSERT INTO @Decline VALUES( 'New business for Postcode ' + @PostCode + ' cannot be covered')
   
--Endorsements
	IF @CInfo_PrimaryRisk IN ('Forklift Driving Training')
		INSERT INTO @Endorsement VALUES ('TOMSBA9E')
	IF @CInfo_PrimaryRisk IN ('Employment Agency' ,'Recruitment Consultancy')
		INSERT INTO @Endorsement VALUES ('DF2F9263')
	/* Trade is Building Management Consultancy or ﻿Surveyor of Buildings	*/
	IF @Cinfo_PrimaryRisk_ID IN ('3N0TV8K9', '3N0TVJN9')
		INSERT INTO @Endorsement VALUES ('TOMSBXMW')

	--INSERT INTO @Endorsement VALUES ('TOMSB002')

--Excess
	INSERT INTO @Excess
	SELECT * FROM [dbo].[MCLIAB_TokioMarineHCC_SmallBusinessandConsultantsLiability_tvfExcess](@ExperienceYears ,@ExcessPropertyAmount ,@PolicyStartDatetime)

--Product Details
	IF @NoClaimsLoadDiscountRate != 0
	INSERT INTO @ProductDetail VALUES  ('No Claims Discount = ' + [dbo].[svfFormatPCTRate](@NoClaimsLoadDiscountRate) + '%')

--Return Table
	DECLARE @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN
END
