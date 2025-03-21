USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MCLIAB_Toledo_SmallBusinessandConsultantsLiability_tvfCalculator]    Script Date: 20/01/2025 14:19:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		Linga
-- Date:        20-Dec-2023
-- Description: Return Scheme Information
*******************************************************************************/

-- Date			Who						Change
-- 28/06/2024	Jeremai Smith			6925107849 - Refer all Northern Ireland postcodes


ALTER FUNCTION [dbo].[MCLIAB_Toledo_SmallBusinessandConsultantsLiability_tvfCalculator]
(
     @PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
	,@AgentName varchar(255)
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
	DECLARE 
		 @Insurer [varchar] (30) = 'Toledo Insurance Solutions'
		,@LineOfBusiness [varchar] (30) = 'MCLIAB'

	DECLARE  
		 @LimitEmployersLiability_Max int		= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'EmployersLiability' ,'Max'	,@PolicyStartDateTime )
		,@LimitEmployeesPL_Max int				= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'EmployeesPL' ,'Max'	,@PolicyStartDateTime )
		,@LimitEmployeesNonManual_Max int		= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'EmployeesNonManual' ,'Max'	,@PolicyStartDateTime )
		,@LimitClaimAmount_Max int				= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'Claim' ,'Max'	,@PolicyStartDateTime )
		,@LimitPremiumRate_Min int 				= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'Premium' ,'Min'	,@PolicyStartDateTime )
		,@LimitClaimsInLastFiveYears_Max int	= [dbo].[svfLimitSelect](@SchemeTableID, @Insurer ,@LineOfBusiness ,'ClaimsInLastFiveYears' ,'Max'	,@PolicyStartDateTime )

--==Loads Discount Rates
	--Employees Discount
	DECLARE @DiscountRatePL money = 0
	DECLARE @DiscountRateEL money = 0
	SET @DiscountRateEL = ([dbo].[MCLIAB_Toledo_SmallBusinessandConsultantsLiability_svfLoadEmployeesDiscount] (@EmployeesELManual, @PolicyStartDateTime) - 1)
	IF @EmployeesELManual > 3
		SET @DiscountRatePL = @DiscountRateEL

	--No Claims Discount
	DECLARE @ExperienceYears int = @CInfo_YrsExp
	IF @ExperienceYears = 0
		SET @ExperienceYears = YEAR(@PolicyStartDateTime) - @CInfo_YrEstablished
	DECLARE @MostRecentClaimYears int = ISNULL( [dbo].[svfAgeInYears](@MostRecentClaim,@PolicyStartDateTime) ,1000)
	DECLARE @NoClaimsLoadDiscountRate money = [dbo].[MCLIAB_Toledo_SmallBusinessandConsultantsLiability_svfLoadNoClaimsDiscount] (@ExperienceYears,@MostRecentClaimYears,@PolicyStartDateTime) - 1

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
        ,[DeclineTrade] varchar(250)
	)
	INSERT INTO @TradeELPLTable
	SELECT * FROM [dbo].[MCLIAB_Toledo_SmallBusinessandConsultantsLiability_tvfTrades] 
	(
		   @Cinfo_PrimaryRisk
		  ,@Cinfo_PrimaryRisk_ID
		  ,@PolicyStartDatetime
		  ,@CInfo_PubLiabLimit
		  ,@EmployeesPL
		  ,@EmployeesELManual
		  ,@AgentName
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

	DECLARE @ClaimsDiscountRate decimal(10,4)
	DECLARE @ClaimsLoadDiscountPremium money = 0
	DECLARE @TotalClaimsLoadDiscountPremium  money = 0
	DECLARE @ClaimsLoadReferFlag BIT 
	DECLARE @ClaimsLoadReferMonths int  
    DECLARE @ClaimsLoadReferSectionPremium money  
	
	INSERT INTO @Endorsement SELECT [Endorsement] FROM @TradeELPLTable WHERE ISNULL([Endorsement],'') !='' 

--Calculate Premiums and Insert Breakdowns
	DECLARE 
		 @Premium numeric(18, 4) = 0
		,@EmpPremium numeric(18, 4) = 0
		,@ClericalEmpPremium numeric(18, 4) = 0
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
    IF (@Premium IS NOT NULL)
	BEGIN
	 	INSERT INTO @Breakdown	VALUES(	':::')--Blank line
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesPL AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

	SET @EmployeeDiscountPremium = @Premium * @DiscountRatePL
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRatePL ,@Premium ,@EmployeeDiscountPremium))	
	SET @Premium = @Premium + @EmployeeDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
	SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	IF(@ClaimsInLast5Years = 1)
	BEGIN
	SET @ClaimsLoadDiscountPremium = 0;
	SET @ClaimsDiscountRate =  [dbo].[MCLIAB_Toledo_SmallBusinessandConsultantsLiability_svfLoad_Claims_Discounts] (@LargestClaim, @MostRecentClaim, @Premium) 
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
	SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
	SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
	SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium

	INSERT INTO @Premiums ([Name] ,[Value]) VALUES ('LIABPREM' ,@Premium)

	END

	--ELPremium 
	SELECT	 @Section = 'Employers Liability'
			,@EmpPremium = @ELRate * @EmployeesELManual
            ,@ClericalEmpPremium = (@EmployeesELNonManual * [dbo].[MCLIAB_Toledo_SmallBusinessandConsultantsLiability_svfRate] ('Clerical Workers',@PolicyStartDateTime))
			,@Premium = @EmpPremium + @ClericalEmpPremium
			,@BasePremium = @Premium
    IF (@EmpPremium IS NOT NULL)
	BEGIN
	INSERT INTO @Breakdown	VALUES(	':::')--Blank line
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesELManual AS varchar(3)) + ' Employees' ,null ,null ,@EmpPremium))
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesELNonManual AS varchar(3)) + ' Clerical Employees' ,null ,@ClericalEmpPremium ,@Premium))


	SET @EmployeeDiscountPremium = @Premium * @DiscountRateEL
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Employee Discount Premium' ,@DiscountRateEL ,@Premium ,@EmployeeDiscountPremium))	
	SET @Premium = @Premium + @EmployeeDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	SET @NoClaimsLoadDiscountPremium = @Premium * @NoClaimsLoadDiscountRate
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' No Claims Discount Premium' ,@NoClaimsLoadDiscountRate ,@Premium ,@NoClaimsLoadDiscountPremium))	
	SET @Premium = @Premium + @NoClaimsLoadDiscountPremium
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

	IF(@ClaimsInLast5Years = 1)
	BEGIN
	SET @ClaimsLoadDiscountPremium = 0;
	SET @ClaimsDiscountRate =  [dbo].[MCLIAB_Toledo_SmallBusinessandConsultantsLiability_svfLoad_Claims_Discounts] (@LargestClaim, @MostRecentClaim, @Premium) 
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
	SET @TotalEmployeeDiscountPremium = @TotalEmployeeDiscountPremium + @EmployeeDiscountPremium
	SET @TotalNoClaimsDiscountPremium = @TotalNoClaimsDiscountPremium + @NoClaimsLoadDiscountPremium
	SET @TotalClaimsLoadDiscountPremium = @TotalClaimsLoadDiscountPremium + @ClaimsLoadDiscountPremium

	INSERT INTO @Premiums ([Name] ,[Value])  VALUES ('EMPLPREM' ,@Premium)
	
	END
	
	--Breakdown totals
	IF(@TotalBasePremium IS NOT NULL AND @TotalBasePremium != 0 ) INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Total Base Premium' ,NULL ,NULL ,@TotalBasePremium))
	IF(@TotalEmployeeDiscountPremium IS NOT NULL AND @TotalEmployeeDiscountPremium != 0) INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Total Employees Discount Premium' ,NULL ,NULL ,@TotalEmployeeDiscountPremium))
	IF(@TotalNoClaimsDiscountPremium IS NOT NULL AND @TotalNoClaimsDiscountPremium != 0) INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Total No Claims Discount Premium' ,NULL ,NULL ,@TotalNoClaimsDiscountPremium))
	IF(@TotalClaimsLoadDiscountPremium IS NOT NULL AND @TotalClaimsLoadDiscountPremium != 0) INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Total Claim Load/Discount Premium' ,NULL ,NULL ,@TotalClaimsLoadDiscountPremium))
	IF(@TotalPremium IS NOT NULL AND @TotalPremium != 0) INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium))


----Min Premium
--	IF (@TotalPremium != 0) AND (@TotalPremium < @LimitPremiumRate_Min)
--	BEGIN
--		UPDATE @Premiums SET [Value] = ([value]/@TotalPremium)* @LimitPremiumRate_Min
--		INSERT INTO @Breakdown	VALUES('Minimum Premium:::')
--		INSERT INTO @Breakdown	SELECT ([dbo].[svfFormatBreakdownString](LEFT([Name],2) + ' Premium' ,NULL ,NULL ,[Value])) FROM @Premiums WHERE [Value] != 0
--	END

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

	IF @Cinfo_PrimaryRisk_ID IS NULL
			INSERT INTO @Refer VALUES ('No Primary Trade has been selected.')
	IF @EmployeesPL = 0
			INSERT INTO @Refer VALUES ('No Manual Employees.')

	IF @EmployeesPL > 10
		INSERT INTO @Refer VALUES ('Maximum of 10 Manual Employees')

	IF @EmployeesELNonManual > 10
		INSERT INTO @Refer VALUES ('Maximum of 10 Non Manual Employees')

	IF @ELRate = 0 AND (@EmployeesELManual > 0 OR @EmployeesELNonManual > 0)
		INSERT INTO @Refer VALUES ('No EL rates against this trade ')

	IF @ClaimsInLast5Years > 1
		INSERT INTO @Refer VALUES ('Proposer has made ' + CAST(@ClaimsInLast5Years AS VARCHAR(2)) + ' Claims in the last 5 years')

	IF @LargestClaim > 10000
	  INSERT INTO @Refer VALUES ('Proposer has made a Claim in excess of £10,000')

	IF(@ClaimsLoadReferFlag IS NOT NULL AND @ClaimsLoadReferFlag = 1)
	    INSERT INTO @Refer VALUES ('No Loading rule to a claim of '+ [dbo].[svfFormatMoneyString](@LargestClaim) +' per section premium of '+[dbo].[svfFormatMoneyString](@ClaimsLoadReferSectionPremium) + +' for a period of '+CAST(@ClaimsLoadReferMonths AS VARCHAR(10))+' months')
	
	IF @ToolsClaimInLastFiveYears = 1
		INSERT INTO @Refer VALUES ('Proposer has made a tools Claim in the last 5 years')

	IF @Postcode LIKE 'BT%' INSERT INTO @Refer VALUES('Refer all BT postcodes');

--Decline
	INSERT INTO @Decline
			SELECT [DeclineTrade] FROM @TradeELPLTable WHERE [DeclineTrade] IS NOT NULL
   
--Endorsements
	INSERT INTO @Endorsement 
	SELECT [Token] FROM @TradeELPLTable CROSS APPLY [dbo].[tvfSplitStringByDelimiter]([Endorsement],',') WHERE ISNULL([Endorsement],'') !='' 

--Excess
	INSERT INTO @Excess
	SELECT * FROM [dbo].[MCLIAB_Toledo_SmallBusinessandConsultantsLiability_tvfExcess](@ExperienceYears ,@ExcessPropertyAmount ,@PolicyStartDatetime)

--Product Details
	IF @NoClaimsLoadDiscountRate != 0
	INSERT INTO @ProductDetail VALUES  ('No Claims Discount = ' + [dbo].[svfFormatPCTRate](@NoClaimsLoadDiscountRate) + '%')

--Return Table
	DECLARE @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN
END
