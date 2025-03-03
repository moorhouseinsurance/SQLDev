USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_TokioMarineHCC_CAR_tvfCalculator]    Script Date: 14/01/2025 14:28:22 ******/
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
-- 08/10/2024   Linga                   Added £ Premium for Lift Installation, Lift Maintenance  (Monday.com Ticket 6185012180)
-- 14/01/2025   Linga					Monday Ticket 8177482880: Changes to TL and Companion TL Scheme - Quarz & Solar
                                         -- Solution: Replaced [MLIAB_TrdDtailTableType] with new [MLIAB_TrdDtail_TableType] that contains the new fields

******************************************************************************/

ALTER FUNCTION [dbo].[MLIAB_TokioMarineHCC_CAR_tvfCalculator]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
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

truncate table uspSchemeCommandDebug
Select * from uspSchemeCommandDebug WHERE uspSchemeCommandText LIKE '%MLIAB_%'_CAR_tvfCalculator%'

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

	INSERT INTO @Premiums ([Name] ,[Value]) VALUES ('CWRKPREM',0),('PLMAPREM',0),('HIPLPREM',0)	

	DECLARE	   @TrdDtail_PrimaryRisk varchar(250)
			  ,@TrdDtail_PrimaryRisk_ID varchar(8)
			  ,@TrdDtail_SecondaryRisk varchar(250)
			  ,@TrdDtail_SecondaryRisk_ID varchar(8)
			  ,@TrdDtail_Phase bit

	SELECT	 @TrdDtail_PrimaryRisk = PrimaryRisk
			,@TrdDtail_PrimaryRisk_ID = PrimaryRisk_ID
			,@TrdDtail_SecondaryRisk = SecondaryRisk
			,@TrdDtail_SecondaryRisk_ID = SecondaryRisk_ID
			,@TrdDtail_Phase = Phase
	FROM
		@TrdDtail


	DECLARE	   @CInfo_YrEstablished money
			  ,@CInfo_YrsExp money
			  ,@CInfo_WorkSoley bit
			  ,@CInfo_Heat bit
			  ,@CInfo_MaxHeight varchar(250)

	SELECT	   @CInfo_WorkSoley			= WorkSoley
			  ,@CInfo_Heat				= Heat
			  ,@CInfo_YrEstablished		= YrEstablished	 
			  ,@CInfo_YrsExp			= YrsExp
			  ,@CInfo_MaxHeight			= MaxHeight
	FROM
		@CInfo

	DECLARE @ContractWork bit
	DECLARE @OwnPlant bit
	DECLARE @HiredPlant bit
	DECLARE @ContractWorkValue numeric (18,2)
	DECLARE @OwnPlantValue numeric (18,2)
	DECLARE @HiredPlantValue numeric (18,2)

	SELECT
		 @ContractWork		= [Contractsworks]
		,@OwnPlant			= [coverplant]
		,@HiredPlant		= [coverhireplant]
		,@ContractWorkValue	= CASE WHEN [MaxContractVal] LIKE 'More%' THEN [dbo].[svfFormatNumber]([MaxContractVal]) + 1 ELSE [dbo].[svfFormatNumber]([MaxContractVal]) END 
		,@OwnPlantValue		= CASE WHEN [OwnPlantMacVal] LIKE 'More%' THEN [dbo].[svfFormatNumber]([OwnPlantMacVal]) + 1 ELSE [dbo].[svfFormatNumber]([OwnPlantMacVal]) END 
		,@HiredPlantValue	= CASE WHEN [HirPlantMacVal] LIKE 'More%' THEN [dbo].[svfFormatNumber]([HirPlantMacVal]) + 1 ELSE [dbo].[svfFormatNumber]([HirPlantMacVal]) END 
	FROM
		@CAR

	DECLARE @EmployeesPL int = ISNULL((SELECT [EmployeesPL] FROM	@EmployeeCounts),0)
	DECLARE @NoClaimYears int = ISNULL((SELECT [NoClaimYears] FROM	@ClaimsSummary),5)

--Limits
	DECLARE	 @OwnPlantMaximumCover bigint
			,@HiredPlantMaximumCover bigint
			,@ContractWorkMaximumCover bigint
			,@ContractWorkMaximumEmployeeMinimum int
			,@OwnPlantMaximumEmployeeMinimum int
			,@Insurer [varchar] (30) = 'TokioMarineHCC'
			,@LineOfBusiness [varchar] (30) = 'MLIAB'

	SET @OwnPlantMaximumCover = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_OwnPlantMacVal' ,'Max'	,@PolicyStartDateTime )
	SET @HiredPlantMaximumCover = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_HirPlantMacVal' ,'Max'	,@PolicyStartDateTime )
	SET @ContractWorkMaximumCover = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_MaxContractVal' ,'Max'	,@PolicyStartDateTime )
	SET @ContractWorkMaximumEmployeeMinimum = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_MaxContractValMaxEmployees' ,'Min'	,@PolicyStartDateTime )
	SET	@OwnPlantMaximumEmployeeMinimum = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_OwnPlantMacValMaxEmployees' ,'Min'	,@PolicyStartDateTime )

--Loads Discount Rates

	--Section Discount
	DECLARE @LoadDiscountRatePremiumSections money = 0 ---0.01
	SET @LoadDiscountRatePremiumSections = ([dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_svfLoadDiscountsSelect](NULL ,'Section' ,NULL ,@PolicyStartDateTime) -1)

	--No Claims Discount
	DECLARE @ExperienceYears int = @CInfo_YrsExp
	IF @ExperienceYears = 0
		SET @ExperienceYears = YEAR(@PolicyStartDateTime) - @CInfo_YrEstablished

	DECLARE @NCDYears int = CASE WHEN @ExperienceYears < @NoClaimYears THEN @ExperienceYears ELSE @NoClaimYears END

	DECLARE @NoClaimsLoadDiscountPctRate numeric (5,2) = [dbo].[MLIAB_TokioMarineHCC_CAR_svfLoadDiscountClaims] (@NCDYears,@PolicyStartDateTime)-1

	--PostCode
	DECLARE @PostcodeLoadDiscountPctRate money = [dbo].[MLIAB_TokioMarineHCC_CAR_svfLoadDiscountPostcode] (@Postcode,@PolicyStartDateTime)-1

--Trade Rates
	DECLARE @TradeBand int = [dbo].[MLIAB_TokioMarineHCC_CAR_svfTradeBand] (@TrdDtail_PrimaryRisk_ID ,@PolicyStartDateTime ,@CInfo_WorkSoley ,@TrdDtail_Phase ,@CInfo_Heat ,@CInfo_MaxHeight)
	DECLARE @SecondaryTradeBAnd int = [dbo].[MLIAB_TokioMarineHCC_CAR_svfTradeBand] (@TrdDtail_SecondaryRisk_ID ,@PolicyStartDateTime ,@CInfo_WorkSoley ,@TrdDtail_Phase ,@CInfo_Heat ,@CInfo_MaxHeight)

	SET @TradeBand = CASE WHEN @SecondaryTradeBand > @TradeBand THEN @SecondaryTradeBand ELSE @TradeBand END

--Premiums
	DECLARE 
		 @Cover bigint =0
		,@Premium numeric(18, 4) = 0
		,@TotalBasePremium money = 0
		,@TotalPremium money = 0
		,@BasePremium money = 0
		,@TotalPostcodeLoadDiscountPremium money = 0
		,@TotalNoClaimsDiscountPremium money = 0
		,@Section varchar(50) 
		,@PostcodeLoadDiscountPremium money = 0
		,@NoClaimsLoadDiscountPremium money = 0
		,@DiscountPremiumSections money = 0
		,@TotalDiscountPremiumSections money = 0

	IF @ContractWork = 1	
	BEGIN
		SET @Section = 'Contract Works '
		IF (@TrdDtail_PrimaryRisk_ID IN ('3N0TVFQ9','3N0TVFR9') OR @TrdDtail_SecondaryRisk_ID IN ('3N0TVFQ9','3N0TVFR9'))
		BEGIN
		SELECT @Premium = 1.00;
		END
		ELSE 
		BEGIN
		SELECT @Premium = [Premium] ,@Cover = [Cover] FROM [dbo].[MLIAB_TokioMarineHCC_CAR_tvfRates] ('CW',@TradeBand,@EmployeesPL,@ContractWorkValue,@PolicystartDateTime)
		END
		SET @BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +'x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		SET @PostcodeLoadDiscountPremium = @Premium * @PostcodeLoadDiscountPctRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +'Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountPctRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +'NCD Premium' ,@NoClaimsLoadDiscountPctRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @DiscountPremiumSections = @Premium * @LoadDiscountRatePremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSections ,@Premium ,@DiscountPremiumSections))	
		SET @Premium = @Premium + @DiscountPremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium
		SET @TotalPremium = @TotalPremium + @Premium
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections

		IF @ContractWorkValue > @ContractWorkMaximumCover 
			INSERT @Refer VALUES('Value of Contract Work exceeds ' +  [dbo].[svfFormatCoverString](@ContractWorkMaximumCover))
		IF @TradeBand IS NULL
			INSERT @Refer VALUES('Trade ' + @TrdDtail_PrimaryRisk + ' not acceptable for Contract Work' )
		IF @TrdDtail_SecondaryRisk != 'None' AND @SecondaryTradeBand IS NULL
			INSERT @Refer VALUES('Trade ' + @TrdDtail_SecondaryRisk + ' not acceptable for Contract Work' )
		IF @Cover = @ContractWorkMaximumCover AND @EmployeesPL < @ContractWorkMaximumEmployeeMinimum
			INSERT @Refer  VALUES('Number of employees needs to be ' + CAST(@ContractWorkMaximumEmployeeMinimum AS nvarchar(2)) + ' or more for Contract Work limit of £' + CAST(@ContractWorkMaximumCover AS nvarchar(10)))						
		IF @Premium = 0
			INSERT @Refer  VALUES('No Contract Work rates for this cover level and number of employees')

		INSERT INTO @ProductDetail VALUES (@Section + ' = ' + ISNULL([dbo].[svfFormatCoverString](@Cover),'N/A'))
	END
	UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'CWRKPREM' 

	SET @Premium = 0
	SET @Cover = 0
	IF @OwnPlant = 1	
	BEGIN	
		SET @Section = 'Own Plant'
		IF (@TrdDtail_PrimaryRisk_ID IN ('3N0TVFQ9','3N0TVFR9') OR @TrdDtail_SecondaryRisk_ID IN ('3N0TVFQ9','3N0TVFR9'))
		BEGIN
		SELECT @Premium = 1.00;
		END
		ELSE
		BEGIN
		SELECT @Premium = [Premium] ,@Cover = [Cover] FROM [dbo].MLIAB_TokioMarineHCC_CAR_tvfRates ('OP',NULL,@EmployeesPL,@OwnPlantValue,@PolicystartDateTime)
		END
		SET @BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		set @PostcodeLoadDiscountPremium = 0
		SET @PostcodeLoadDiscountPremium = @Premium * @PostcodeLoadDiscountPctRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		set @NoClaimsLoadDiscountPremium = 0
		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountPctRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountPctRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @DiscountPremiumSections = @Premium * @LoadDiscountRatePremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSections ,@Premium ,@DiscountPremiumSections))	
		SET @Premium = @Premium + @DiscountPremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium
		SET @TotalPremium = @TotalPremium + @Premium
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections


		IF @OwnPlantValue > @OwnPlantMaximumCover 
		    INSERT @Refer VALUES('Value of Own Plant and machinery exceeds £' +  CAST(@OwnPlantMaximumCover AS nvarchar(10)))	    
		IF @TradeBand IS NULL
			INSERT @Refer VALUES('Trade ' + @TrdDtail_PrimaryRisk + ' not acceptable for Own Plant and machinery')	
		IF @TrdDtail_SecondaryRisk != 'None' AND @SecondaryTradeBand IS NULL
			INSERT @Refer VALUES('Trade ' + @TrdDtail_SecondaryRisk + ' not acceptable for Own Plant') 					
		IF @Cover = @OwnPlantMaximumCover AND @EmployeesPL < @OwnPlantMaximumEmployeeMinimum
			INSERT @Refer VALUES('Number of employees needs to be ' + CAST(@OwnPlantMaximumEmployeeMinimum AS nvarchar(2)) + ' or more for Own Plant and machinery limit of £' + CAST(@OwnPlantMaximumCover AS nvarchar(10)))		
		IF @Premium = 0
			INSERT @Refer VALUES('No Own Plant and machinery rates for this cover level and number of employees')

		INSERT INTO @ProductDetail VALUES (@Section + ' = ' + ISNULL([dbo].[svfFormatCoverString](@Cover),'N/A'))
			
	END	
	UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'PLMAPREM'

	SET @Premium = 0
	SET @Cover = 0
	IF @HiredPlant = 1	
	BEGIN	
		SET @Section = 'Hired Plant'
		IF (@TrdDtail_PrimaryRisk_ID IN ('3N0TVFQ9','3N0TVFR9') OR @TrdDtail_SecondaryRisk_ID IN ('3N0TVFQ9','3N0TVFR9'))
		BEGIN
		SELECT @Premium = 1.00;
		END
		ELSE
		BEGIN
		SELECT @Premium = [Premium] ,@Cover = [Cover] FROM [dbo].MLIAB_TokioMarineHCC_CAR_tvfRates ('HP',NULL,@EmployeesPL,@HiredPlantValue,@PolicystartDateTime)
		END
		SET @BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		set @PostcodeLoadDiscountPremium = 0
		SET @PostcodeLoadDiscountPremium = @Premium * @PostcodeLoadDiscountPctRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,@PostcodeLoadDiscountPctRate ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		set @NoClaimsLoadDiscountPremium = 0
		SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountPctRate
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountPctRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		SET @DiscountPremiumSections = @Premium * @LoadDiscountRatePremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Discount Premium Sections' ,@DiscountPremiumSections ,@Premium ,@DiscountPremiumSections))	
		SET @Premium = @Premium + @DiscountPremiumSections
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium
		SET @TotalPremium = @TotalPremium + @Premium
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalDiscountPremiumSections = @TotalDiscountPremiumSections + @DiscountPremiumSections

		IF @HiredPlantValue > @HiredPlantMaximumCover 
		    INSERT @Refer VALUES('Value of Hired in Plant exceeds £' +  CAST(@HiredPlantMaximumCover AS nvarchar(10)))	    
		IF @TradeBand IS NULL
			INSERT @Refer VALUES('Trade ' + @TrdDtail_PrimaryRisk + ' not acceptable for Hired in Plant')	
		IF @TrdDtail_SecondaryRisk != 'None' AND @SecondaryTradeBand IS NULL
			INSERT @Refer VALUES('Trade ' + @TrdDtail_SecondaryRisk + ' not acceptable for Hired in Plant') 		
		IF @Premium = 0
			INSERT @Refer VALUES('No Hired in Plant rates for this cover level and number of employees')

		INSERT INTO @ProductDetail VALUES (@Section + ' = ' + ISNULL([dbo].[svfFormatCoverString](@Cover),'N/A'))
	END
	UPDATE @Premiums SET [Value] = @Premium WHERE [Name] = 'HIPLPREM'

	--Breakdown totals
	IF @TotalPremium != 0
	BEGIN
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Base Premium' ,NULL ,NULL ,@TotalBasePremium))
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Postcode Load Discount Premium' ,NULL ,NULL ,@TotalPostcodeLoadDiscountPremium))
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total No Claims Discount Premium' ,NULL ,NULL ,@TotalNoClaimsDiscountPremium))
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Discount Premium Sections' ,NULL ,NULL ,@TotalDiscountPremiumSections))	
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium))
	END

	--Endorsements
	IF @HiredPlant = 1 OR @OwnPlant = 1
		INSERT INTO @Endorsement VALUES ('455KG7B9')

--Return Table
	declare @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN
END
