USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_Toledo_CAR_tvfCalculator]    Script Date: 21/01/2025 23:16:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
-- Author:		Linga
-- Date:        07-Dec-2023
-- Description: Return Scheme Information
*******************************************************************************/

ALTER FUNCTION [dbo].[MLIAB_Toledo_CAR_tvfCalculator]
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

--Claims Load
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
--Limits
	DECLARE	 @OwnPlantMaximumCover bigint
			,@HiredPlantMaximumCover bigint
			,@ContractWorkMaximumCover bigint
			,@ContractWorkMaximumEmployeeMinimum int
			,@OwnPlantMaximumEmployeeMinimum int
			,@Insurer [varchar] (30) = 'Toledo Insurance Solutions'
			,@LineOfBusiness [varchar] (30) = 'MLIAB'

	SET @OwnPlantMaximumCover = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_OwnPlantMacVal' ,'Max'	,@PolicyStartDateTime )
	SET @HiredPlantMaximumCover = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_HirPlantMacVal' ,'Max'	,@PolicyStartDateTime )
	SET @ContractWorkMaximumCover = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_MaxContractVal' ,'Max'	,@PolicyStartDateTime )
	SET @ContractWorkMaximumEmployeeMinimum = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_MaxContractValMaxEmployees' ,'Min'	,@PolicyStartDateTime )
	SET	@OwnPlantMaximumEmployeeMinimum = [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,'CAR_OwnPlantMacValMaxEmployees' ,'Min'	,@PolicyStartDateTime )

--Loads Discount Rates
	--No Claims Discount
	DECLARE @ExperienceYears int = @CInfo_YrsExp
	
	IF @ExperienceYears = 0
		SET @ExperienceYears = YEAR(@PolicyStartDateTime) - @CInfo_YrEstablished

	DECLARE @NCDYears int = CASE WHEN @ExperienceYears < @NoClaimYears THEN @ExperienceYears ELSE @NoClaimYears END
	
	IF @NCDYears >5
		SET @NCDYears = 5

	DECLARE @NoClaimsLoadDiscountPctRate numeric (5,2) = [dbo].[MLIAB_Toledo_CAR_svfLoadNoClaimsDiscount] (@NCDYears,@PolicyStartDateTime)-1

--Trade Rates
	DECLARE @TradeBand int = [dbo].[MLIAB_Toledo_CAR_svfTradeBand] (@TrdDtail_PrimaryRisk_ID ,@PolicyStartDateTime)
	DECLARE @SecondaryTradeBAnd int = [dbo].[MLIAB_Toledo_CAR_svfTradeBand] (@TrdDtail_SecondaryRisk_ID ,@PolicyStartDateTime)

	SET @TradeBand = CASE WHEN ISNULL(@SecondaryTradeBand,0) > ISNULL(@TradeBand,0) THEN @SecondaryTradeBand ELSE @TradeBand END

--Premiums
	DECLARE @Cover bigint =0
	DECLARE @Premium numeric(18, 4) = 0
	DECLARE @TotalBasePremium money = 0
	DECLARE @TotalPremium money = 0
	DECLARE @BasePremium money = 0
	DECLARE @TotalPostcodeLoadDiscountPremium money = 0
	DECLARE @TotalNoClaimsDiscountPremium money = 0
	DECLARE @Section varchar(50) 
	DECLARE @PostcodeLoadDiscountPremium money = 0
	DECLARE @NoClaimsLoadDiscountPremium money = 0

	DECLARE @ClaimsDiscountRate decimal(10,4)
	DECLARE @ClaimsLoadDiscountPremium money = 0
	DECLARE @TotalClaimsLoadDiscountPremium  money = 0
	DECLARE @ClaimsLoadReferFlag BIT 
	DECLARE @ClaimsLoadReferMonths int  
    DECLARE @ClaimsLoadReferSectionPremium money  

	IF @ContractWork = 1	
	BEGIN
		SET @Section = 'Contract Works '
		SELECT @Premium = [Premium] ,@Cover = [Cover] FROM [dbo].[MLIAB_Toledo_CAR_tvfRates] ('CW',@TradeBand,@EmployeesPL,@ContractWorkValue,@PolicystartDateTime)
		SET @BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +'x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		SET @NoClaimsLoadDiscountPremium = @Premium * ISNULL(@NoClaimsLoadDiscountPctRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +'NCD Premium' ,@NoClaimsLoadDiscountPctRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		--Claims Load
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
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium

		IF @ContractWorkValue > @ContractWorkMaximumCover 
			INSERT @Refer VALUES('Value of Contract Work exceeds ' +  [dbo].[svfFormatCoverString](@ContractWorkMaximumCover))
		--IF @TradeBand IS NULL
		--	INSERT @Refer VALUES('Trade ' + @TrdDtail_PrimaryRisk + ' not acceptable for Contract Work' )
		--IF @TrdDtail_SecondaryRisk != 'None' AND @SecondaryTradeBand IS NULL
		--	INSERT @Refer VALUES('Trade ' + @TrdDtail_SecondaryRisk + ' not acceptable for Contract Work' )
		
		IF @TradeBand IS NULL AND  @TrdDtail_SecondaryRisk != 'None' AND @SecondaryTradeBand IS NULL
		BEGIN
		  INSERT @Refer VALUES('Primary Risk Trade ' + @TrdDtail_PrimaryRisk + ' not acceptable for Contract Work' )
		  INSERT @Refer VALUES('Secondary Risk Trade ' + @TrdDtail_SecondaryRisk + ' not acceptable for Contract Work' )
		END
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
		SELECT @Premium = [Premium] ,@Cover = [Cover] FROM [dbo].[MLIAB_Toledo_CAR_tvfRates] ('OP',NULL,@EmployeesPL,@OwnPlantValue,@PolicystartDateTime)
		SET @BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		set @NoClaimsLoadDiscountPremium = 0
		SET @NoClaimsLoadDiscountPremium = @Premium * ISNULL(@NoClaimsLoadDiscountPctRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountPctRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		--Claims Load
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
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium

		IF @OwnPlantValue > @OwnPlantMaximumCover 
		    INSERT @Refer VALUES('Value of Own Plant and machinery exceeds £' +  CAST(@OwnPlantMaximumCover AS nvarchar(10)))	    
		--IF @TradeBand IS NULL
		--	INSERT @Refer VALUES('Trade ' + @TrdDtail_PrimaryRisk + ' not acceptable for Own Plant and machinery')	
		--IF @TrdDtail_SecondaryRisk != 'None' AND @SecondaryTradeBand IS NULL
		--	INSERT @Refer VALUES('Trade ' + @TrdDtail_SecondaryRisk + ' not acceptable for Own Plant') 	
		IF @TradeBand IS NULL AND  @TrdDtail_SecondaryRisk != 'None' AND @SecondaryTradeBand IS NULL
		BEGIN
		  INSERT @Refer VALUES('Primary Risk Trade ' + @TrdDtail_PrimaryRisk + ' not acceptable for Own Plant' )
		  INSERT @Refer VALUES('Secondary Risk Trade ' + @TrdDtail_SecondaryRisk + ' not acceptable for Own Plant' )
		END
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
		SELECT @Premium = [Premium] ,@Cover = [Cover] FROM [dbo].[MLIAB_Toledo_CAR_tvfRates] ('HP',NULL,@EmployeesPL,@HiredPlantValue,@PolicystartDateTime)
		SET @BasePremium = @Premium

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		set @NoClaimsLoadDiscountPremium = 0
		SET @NoClaimsLoadDiscountPremium = @Premium * ISNULL(@NoClaimsLoadDiscountPctRate,0)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' NCD Premium' ,@NoClaimsLoadDiscountPctRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
		SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		--Claims Load
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
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
		SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium

		IF @HiredPlantValue > @HiredPlantMaximumCover 
		    INSERT @Refer VALUES('Value of Hired in Plant exceeds £' +  CAST(@HiredPlantMaximumCover AS nvarchar(10)))	    
		--IF @TradeBand IS NULL
		--	INSERT @Refer VALUES('Trade ' + @TrdDtail_PrimaryRisk + ' not acceptable for Hired in Plant')	
		--IF @TrdDtail_SecondaryRisk != 'None' AND @SecondaryTradeBand IS NULL
		--	INSERT @Refer VALUES('Trade ' + @TrdDtail_SecondaryRisk + ' not acceptable for Hired in Plant')
		IF @TradeBand IS NULL AND  @TrdDtail_SecondaryRisk != 'None' AND @SecondaryTradeBand IS NULL
		BEGIN
		  INSERT @Refer VALUES('Primary Risk Trade ' + @TrdDtail_PrimaryRisk + ' not acceptable for Hired in Plant' )
		  INSERT @Refer VALUES('Secondary Risk Trade ' + @TrdDtail_SecondaryRisk + ' not acceptable for Hired in Plant' )
		END
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
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Claim Load/Discount Premium' ,NULL ,NULL ,@TotalClaimsLoadDiscountPremium))
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium))
		INSERT INTO @Breakdown	VALUES(	':::')--Blank line
	END

	IF(@ClaimsLoadReferFlag IS NOT NULL AND @ClaimsLoadReferFlag = 1)
	    INSERT INTO @Refer VALUES ('No Loading rule to a claim of '+ [dbo].[svfFormatMoneyString](@LargestClaim) +' per section premium of '+[dbo].[svfFormatMoneyString](@ClaimsLoadReferSectionPremium) + +' for a period of '+CAST(@ClaimsLoadReferMonths AS VARCHAR(10))+'months')
-- Endorsements
    IF(@OwnPlant = 1)
	BEGIN
		INSERT INTO @Endorsement Values ('TISTL054') 
	END
	--Excesses '{Excess Desc}:{ExcessVal000}:{List_Excess_Section.Excess_Section_ID}:{LIST_EXCESSTYPE.ExcessType_ID}'
	INSERT INTO @Excess 
	SELECT * FROM [dbo].[MLIAB_Toledo_CAR_tvfExcess](@ContractWork ,@OwnPlant ,@HiredPlant ,@PolicyStartDatetime)
--Return Table
	declare @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN
END
