USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_AXA_TradesmanLiability_tvfCalculator]    Script Date: 14/01/2025 14:06:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		Devlin Hostler
-- Date:        11 Nov 2019
-- Description: Return Scheme Information
*******************************************************************************

-- Date			Who						Change
-- 27/07/2023	Linga        			Monday ticket 4876651196: Issue when quaoing tradesman
--										- Error: There is insufficient result space to convert a money value to varchar
--                                      - Findings: Getting above error while converting variable (@CInfo_ManDays) from money datatype to varchar in refer section.
--										- Solution: Increased the varchar datatype size from Varchar(3) to varchar(6) for @CInfo_ManDays

-- 02/10/2024   Linga                   Monday Ticket 6184978943: £10,000,000 PL limit on Axa Tradesman
--                                      - Solution: Added £1 premium  for £10,000,000, and excluded minimum premium check for £10,000,000
-- 15/11/2024	Simon					Monday Ticket 7859939201: NB premiums revert to £ scheme
-- 14/01/2025   Linga					Monday Ticket 8177482880: Changes to TL and Companion TL Scheme - Quarz & Solar
                                         -- Solution: Replaced [MLIAB_TrdDtailTableType] with new [MLIAB_TrdDtail_TableType] that contains the new fields

*******************************************************************************/

ALTER FUNCTION [dbo].[MLIAB_AXA_TradesmanLiability_tvfCalculator]
(
     @SchemeTableID int
    ,@PreviousPolicyHistoryID int
	,@PolicyStartDateTime datetime = NULL
	,@InceptionStartDateTime datetime = NULL
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
	,@Claim ClaimTableType READONLY
	,@PolicyQuoteStageMTA bit
)

/*

truncate table Transactor_live.dbo.uspSchemeCommandDebug
Select * from Transactor_live.dbo.uspSchemeCommandDebug WHERE uspSchemeCommandText LIKE '%MLIAB_uspCalculator%1325%'

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
			
	DECLARE	   @TrdDtail_SecondaryRisk varchar(250)
			  ,@TrdDtail_SecondaryRisk_ID varchar(8)
			  ,@TrdDtail_Phase bit
			  ,@TrdDtail_Paving bit
			  ,@TrdDtail_MaxDepthValue int
			  ,@TrdDtail_MaxDepth varchar(250)			  
			  ,@TrdDtail_PrimaryRisk varchar(250)
			  ,@TrdDtail_PrimaryRisk_ID varchar(8)
			  ,@TrdDtail_FixedMachinery bit
			  ,@TrdDtail_PresentInsurer varchar(250)
			  ,@TrdDtail_WorkshopPercent money
			  ,@TrdDtail_EmpsUsing money
			  ,@TrdDtail_EfficacyCover bit
			  ,@TrdDtail_CorgiReg bit
			  ,@TrdDtail_CavityWall bit		
			  ,@TrdDtail_Roofing bit	
			  ,@TrdDtail_Waterproofing bit
			  ,@TrdDtail_Solvent bit
			  ,@TrdDtail_Roadsurfacing  bit				    
			  ,@PolicyDetailsID char(32)
			  ,@HistoryID int

	SELECT	 @TrdDtail_SecondaryRisk = SecondaryRisk
			,@TrdDtail_SecondaryRisk_ID = SecondaryRisk_ID
			,@TrdDtail_Phase = Phase
			,@TrdDtail_Paving = Paving
			,@TrdDtail_MaxDepth = MaxDepth
			,@TrdDtail_MaxDepthValue = [dbo].[svfFormatNumber]([MaxDepth])
			,@TrdDtail_PrimaryRisk = PrimaryRisk
			,@TrdDtail_PrimaryRisk_ID = PrimaryRisk_ID
			,@TrdDtail_FixedMachinery = FixedMachinery
			,@TrdDtail_PresentInsurer = PresentInsurer
			,@TrdDtail_WorkshopPercent = WorkshopPercent
			,@TrdDtail_EmpsUsing = EmpsUsing
			,@TrdDtail_EfficacyCover = EfficacyCover
			,@TrdDtail_CorgiReg = CorgiReg
			,@TrdDtail_CavityWall = CavityWall
			,@TrdDtail_Roofing = Roofing
			,@TrdDtail_Waterproofing = Waterproofing
			,@TrdDtail_Solvent = Solvent
			,@TrdDtail_Roadsurfacing = Roadsurfacing			
			,@PolicyDetailsID = PolicyDetailsID
			,@HistoryID = HistoryID
	FROM
		@TrdDtail


	DECLARE	   @CInfo_PubLiabLimit varchar(250)
			  ,@CInfo_PubLiabLimitValue bigint
			  ,@CInfo_WorkSoley bit
			  ,@CInfo_Heat bit
			  ,@CInfo_MaxHeight varchar(250)
			  ,@CInfo_MaxHeightValue int		  
			  ,@CInfo_ToolCover bit		
			  ,@CInfo_ToolCoverValue int	
			  ,@CInfo_EmployeeTool bit
			  ,@CInfo_CompanyStatus varchar(250)
			  ,@CInfo_ManualWork bit
			  ,@CInfo_ManualDirectors money
			  ,@CInfo_YrsExp money
			  ,@CInfo_YrEstablished money
			  ,@CInfo_YRS int
			  ,@CInfo_ToolValue varchar(8)
			  ,@CInfo_TempInsurance bit
			  ,@CInfo_BonaFideWR money
			  ,@CInfo_Annualturnover money
			  ,@CInfo_NonManuDirec money
			  ,@CInfo_ManDays money
	SELECT	   @CInfo_PubLiabLimit = PubLiabLimit
			  ,@CInfo_PubLiabLimitValue = [dbo].[svfFormatNumber]([PubLiabLimit])
			  ,@CInfo_WorkSoley	   = WorkSoley
			  ,@CInfo_Heat		   = Heat
			  ,@CInfo_MaxHeight	   = MaxHeight
			  ,@CInfo_MaxHeightValue = [dbo].[svfFormatNumber]([MaxHeight])
			  ,@CInfo_ToolCover		= ToolCover
			  ,@CInfo_ToolCoverValue = [dbo].[svfFormatNumber]([ToolValue])
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
			  ,@CInfo_YRS = YRS
	FROM
		@CInfo

--Claims
	DECLARE  @ClaimsInLast5Years int
			,@MostRecentClaim datetime
			,@MostRecentToolsClaim datetime
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

	SET @EmployeesELManual = CASE WHEN @EmployeesELManual = 0 AND @CInfo_TempInsurance = 'True' THEN 1 ELSE @EmployeesELManual END

	--EmployeesTools
	DECLARE @EmployeesTools int
	IF @CInfo_ToolCover = 1 AND @CInfo_EmployeeTool = 1
			SET @EmployeesTools = @EmployeesPL
	IF @CInfo_ToolCover = 1 AND @CInfo_EmployeeTool = 0
			SET @EmployeesTools = CASE @CInfo_CompanyStatus WHEN 'Individual Trading As' THEN @CInfo_ManualWork WHEN 'Partnership' THEN @EmployeesPAndP ELSE @CInfo_ManualDirectors END

--Limits
	DECLARE @LineOfBusiness varchar(10) = 'MLIAB'
	DECLARE  @LimitPremiumToolsMin money = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness			,'PremiumTools'+@PolicyQuoteStage				,'Min'	,@PolicyStartDateTime )			
			,@LimitCInfo_AnnualturnoverMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness	,'CInfo_Annualturnover'		,'Max'	,@PolicyStartDateTime )
			,@LimitCoverToolsTotalMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness		,'CoverToolsTotal'			,'Max'	,@PolicyStartDateTime )		
			,@LimitCInfo_ToolCoverValueMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness	,'CInfo_ToolCoverValue'		,'Max'	,@PolicyStartDateTime )			
			,@LimitBackDatedDaysMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness			,'BackDatedDays'			,'Max'	,@PolicyStartDateTime )
			,@LimitFutureDatedDaysMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness		,'FutureDatedDays'		,'Max'	,@PolicyStartDateTime )
			,@LimitCInfo_PubLiabLimitMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness		,'CInfo_PubLiabLimit'		,'Max'	,@PolicyStartDateTime )
			,@LimitEmployeesMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness				,'Employees'				,'Max'	,@PolicyStartDateTime )
			,@LimitEmployeesPLMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness			,'EmployeesPL'				,'Max'	,@PolicyStartDateTime )
			,@LimitEmployeesELMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness			,'EmployeesEL'				,'Max'	,@PolicyStartDateTime )
			,@LimitCInfo_ManDaysMax int = [dbo].[svfLimitSelect]( @SchemeTableID,null ,@LineOfBusiness			,'CInfo_ManDays'			,'Max'	,@PolicyStartDateTime )
			,@LimitCInfo_BonaFideWRPercentMax money = [dbo].[svfLimitSelect]( @SchemeTableID,null,@LineOfBusiness ,'CInfo_BonaFideWRPercent'	,'Max'	,@PolicyStartDateTime )


	DECLARE @ChargeIPT bit = CASE WHEN @postcode like 'IM%' THEN 0 WHEN @postcode like 'GY%' THEN 0 WHEN @postcode like 'JE%' THEN 0 ELSE 1 END

--Loads Discount Rates
	--ERF
	--DECLARE @BusinessEstYears int = CASE WHEN @CInfo_YrsExp = 0 THEN YEAR(@PolicyStartDateTime) - @CInfo_YrEstablished ELSE @CInfo_YrsExp END

	DECLARE @BusinessEstYears int = YEAR(@PolicyStartDateTime) - @CInfo_YrEstablished 

	DECLARE @ERFTable TABLE
	(
		 [ERFType] nvarchar(10)
		,[ERFNumber] [int]
		,[ERFRelativity] [numeric](8,5)
		,[ERFMovement] int
		,[MovementType] int
		,[MaterialDamage3YearClaimValue] int
		,[ReferCSV] varchar(Max)
	) 
	INSERT INTO @ERFTable
	SELECT * FROM [dbo].[MLIAB_AXA_TradesmanLiability_tvfERF]  (@BusinessEstYears ,@PolicyDetailsID ,@PreviousPolicyHistoryID ,@PolicyQuoteStage ,@Claim ,@PolicyStartDateTime ,@InceptionStartDateTime ,@SchemeTableID)

	DECLARE @ERFRelativity		 [numeric](8,5) = (SELECT [ERFRelativity] FROM @ERFTable WHERE [ERFType] = 'ERF')
	DECLARE @ERFRelativityTools  [numeric](8,5) = (SELECT [ERFRelativity] FROM @ERFTable WHERE [ERFType] = 'Tools')

	
	
	--Postcode Weight
	DECLARE
		     @PostcodeAreaPL int
			,@PostcodeAreaEL int
			,@PostcodeAreaMD int
			,@PostcodeLoadDiscountWeightPL [numeric](8,5) = 1
			,@PostcodeLoadDiscountWeightEL [numeric](8,5) = 1
			,@PostcodeLoadDiscountWeightMD [numeric](8,5) = 1

	--Postcode rates not available yet.
	SELECT 
			 @PostcodeAreaPL = [AreaPL]
			,@PostcodeAreaEL = [AreaEL]
			,@PostcodeAreaMD = [AreaMD]
			,@PostcodeLoadDiscountWeightPL = [AreaRelativityPL]
			,@PostcodeLoadDiscountWeightEL = [AreaRelativityEL]
			,@PostcodeLoadDiscountWeightMD = [AreaRelativityMD]
	FROM [dbo].[MLIAB_AXA_TradesmanLiability_tvfPostCodeAreaRelativity] (@Postcode ,@PolicyStartDateTime)

--Rates

--Trade Rates
DECLARE
	 @Trade_ReferTrade varchar(512)
	,@Trade_Endorsement nvarchar(255)
	,@Trade_Excess int
	,@Trade_PLTradeName varchar(255)
	,@Trade_PLRate money
	,@Trade_PLIndemnityRelativityRate  numeric (8,5)
	,@Trade_PLEmployeeRelativityRate numeric (8,5)
	,@Trade_PLLoadDepth  money
	,@Trade_PLLoadPhase3 money
	,@Trade_PLLoadCorgi  money
	,@Trade_ELTradeName varchar(255)
	,@Trade_ELRate money
	,@Trade_ELEmployeeRelativityRate numeric (8,5)
	,@Trade_ELLoadDepth  money
	,@Trade_ELLoadHeight money

DECLARE @Trades [dbo].[SchemeTradeTableType]
INSERT INTO @Trades VALUES (@TrdDtail_PrimaryRisk_ID,@TrdDtail_PrimaryRisk),(@TrdDtail_SecondaryRisk_ID,@TrdDtail_SecondaryRisk) 

SELECT 
	 @Trade_ReferTrade =	ReferTrade 
	,@Trade_Endorsement =	Endorsement 
	,@Trade_Excess =		Excess 
	,@Trade_PLTradeName =	PLTradeName 
	,@Trade_PLRate =		PLRate 
	,@Trade_PLIndemnityRelativityRate = PLIndemnityRelativityRate
	,@Trade_PLEmployeeRelativityRate  = PLEmployeeRelativityRate
	,@Trade_PLLoadDepth =	PLLoadDepth 
	,@Trade_PLLoadPhase3 =	PLLoadPhase3
	,@Trade_PLLoadCorgi =	PLLoadCorgi 
	,@Trade_ELTradeName =	ELTradeName 
	,@Trade_ELRate =		ELRate 
	,@Trade_ELEmployeeRelativityRate = ELEmployeeRelativityRate
	,@Trade_ELLoadDepth =	ELLoadDepth 
	,@Trade_ELLoadHeight =	ELLoadHeight
FROM [dbo].[MLIAB_AXA_TradesmanLiability_tvfTrades] 
(
	 @Trades
	,@CInfo_PubLiabLimitValue
	,@EmployeesPL
	,@EmployeesELManual
	,@SchemeTableID
	,@TrdDtail_MaxDepthValue
	,@TrdDtail_Phase 
	,@TrdDtail_CorgiReg
	,@CInfo_MaxHeightValue
	,@CInfo_Heat
	,@TrdDtail_EfficacyCover	
	,@PolicyQuoteStage 
	,@PolicyStartDateTime
)

--Tools
	DECLARE @CoverToolsTotal int = @EmployeesTools * @CInfo_ToolCoverValue 
	DECLARE @RateTools numeric(8,4) = [dbo].[MLIAB_AXA_TradesmanLiability_svfTools](@CoverToolsTotal ,@PolicyQuoteStage ,@PolicyStartDateTime)

--Clerical EL
	DECLARE @RateType [varchar](40) = 'ELClerical'
	DECLARE @ELClericalRate money = [dbo].[svfRate] (@SchemeTableID ,@RateType ,@PolicyStartDateTime)

--IF (SELECT  [WrittenRA] FROM @Cinfo) =1
--BEGIN
/*
	INSERT INTO @Refer VALUES ('Trade_PLRate:' 						+ CAST(@Trade_PLRate AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_PLIndemnityRelativityRate:' 	+ CAST(@Trade_PLIndemnityRelativityRate AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_PLEmployeeRelativityRate:' 	+ CAST(@Trade_PLEmployeeRelativityRate AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_PLLoadDepth:' 				+ CAST(@Trade_PLLoadDepth AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_PLLoadPhase3:' 				+ CAST(@Trade_PLLoadPhase3 AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_PLLoadCorgi:' 				+ CAST(@Trade_PLLoadCorgi AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_ELTradeName:' 				+ CAST(@Trade_ELTradeName AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_ELRate:'  					+ CAST(@Trade_ELRate AS varchar(30)))
	INSERT INTO @Refer VALUES ('ELClericalRate:'  					+ CAST(@ELClericalRate AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_ELEmployeeRelativityRate:'  	+ CAST(@Trade_ELEmployeeRelativityRate AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_ELLoadDepth:' 				+ CAST(@Trade_ELLoadDepth AS varchar(30)))
	INSERT INTO @Refer VALUES ('Trade_ELLoadHeight:' 				+ CAST(@Trade_ELLoadHeight AS varchar(30)))
	INSERT INTO @Refer VALUES ('RateTools:' 						+ CAST(@RateTools AS varchar(30)))
	INSERT INTO @Refer VALUES ('PostcodeLoadDiscountWeightPL:'		+ CAST(@PostcodeLoadDiscountWeightPL AS varchar(30)))
	INSERT INTO @Refer VALUES ('PostcodeLoadDiscountWeightEL:' 		+ CAST(@PostcodeLoadDiscountWeightEL AS varchar(30)))
	INSERT INTO @Refer VALUES ('PostcodeLoadDiscountWeightMD:' 		+ CAST(@PostcodeLoadDiscountWeightMD AS varchar(30)))
	INSERT INTO @Refer VALUES ('ERFRelativity:' 					+ CAST( @ERFRelativity AS varchar(30)))
	INSERT INTO @Refer VALUES ('ERFRelativityTools:'				+ CAST( @ERFRelativityTools AS varchar(30)))
*/
--END

--Calculate Premiums and Insert Breakdowns
	DECLARE @Premium numeric(18, 4) = 0
	DECLARE @BasePremium money = 0
	DECLARE @TotalBasePremium money = 0
	DECLARE @TotalPremium money = 0

	DECLARE @Section varchar(50) 
	DECLARE @IndemnityLoadDiscountPremium		money = 0
	DECLARE @TotalIndemnityLoadDiscountPremium	money = 0
	DECLARE @EmployeeLoadDiscountPremium		money = 0
	DECLARE @TotalEmployeeLoadDiscountPremium	money = 0
	DECLARE @PostcodeLoadDiscountPremium		money = 0
	DECLARE @TotalPostcodeLoadDiscountPremium	money = 0
	DECLARE @ERFLoadDiscountPremium				money = 0
	DECLARE @TotalERFLoadDiscountPremium		money = 0
	DECLARE @DepthLoadDiscountPremium			money = 0
	DECLARE @TotalDepthLoadDiscountPremium		money = 0
	DECLARE @Phase3LoadDiscountPremium			money = 0
	DECLARE @TotalPhase3LoadDiscountPremium		money = 0
	DECLARE @CorgiLoadDiscountPremium			money = 0
	DECLARE @TotalCorgiLoadDiscountPremium		money = 0
	DECLARE @HeightLoadDiscountPremium			money = 0
	DECLARE @TotalHeightLoadDiscountPremium		money = 0
	DECLARE @MinimumLoadDiscountPremium			money = 0
	DECLARE @TotalMinimumLoadDiscountPremium	money = 0
	DECLARE @MinimumPremium money = 0			

	INSERT INTO @ProductDetail	VALUES(	'Sums Insured')

	SELECT	 @Section = 'Public Liability'
	IF(@CInfo_PubLiabLimitValue = 10000000)
	BEGIN
	   SET @Premium = 1.00;
	END
	ELSE
	BEGIN
	   SET @Premium = @Trade_PLRate 
	END

	--New Business (7859939201)
	IF(@SchemeTableID = 1325 AND @PolicyQuoteStage = 'NB' AND @PolicyStartDateTime >= '01 Jan 2025')
	BEGIN
	   SET @Premium = 0.01;
	END
	ELSE
	BEGIN
	   SET @Premium = @Trade_PLRate 
	END

    SET @BasePremium = @Premium

	INSERT INTO @Breakdown	VALUES(	':::')--Blank line
	INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section ,null ,null ,@Premium))

	IF @PostcodeLoadDiscountWeightPL != 1
	BEGIN
		SET @PostcodeLoadDiscountPremium = @Premium * (@PostcodeLoadDiscountWeightPL-1)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,(@PostcodeLoadDiscountWeightPL-1) ,@Premium ,@PostcodeLoadDiscountPremium))	
		SET @Premium = @Premium + @PostcodeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
	END

	IF @Trade_PLIndemnityRelativityRate != 1
	BEGIN
		SET @IndemnityLoadDiscountPremium = @Premium * (@Trade_PLIndemnityRelativityRate-1)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Indemnity Load/Discount Premium' ,(@Trade_PLIndemnityRelativityRate-1) ,@Premium ,@IndemnityLoadDiscountPremium))	
		SET @Premium = @Premium + @IndemnityLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
	END

	IF @Trade_PLEmployeeRelativityRate != 1
	BEGIN
		SET @EmployeeLoadDiscountPremium = @Premium * (@Trade_PLEmployeeRelativityRate-1)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' '+ CAST(@EmployeesPL AS varchar(3)) +' Employees Load/Discount Premium' ,(@Trade_PLEmployeeRelativityRate-1) ,@Premium ,@EmployeeLoadDiscountPremium))	
		SET @Premium = @Premium + @EmployeeLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
	END

	IF @Trade_PLLoadDepth != 1
	BEGIN
		SET @DepthLoadDiscountPremium = @Premium * (@Trade_PLLoadDepth-1)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Depth Load/Discount Premium' ,(@Trade_PLLoadDepth-1) ,@Premium ,@DepthLoadDiscountPremium))	
		SET @Premium = @Premium + @DepthLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
	END

	IF @Trade_PLLoadPhase3 != 1
	BEGIN
		SET @Phase3LoadDiscountPremium = @Premium * (@Trade_PLLoadPhase3-1)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Phase3 Load/Discount Premium' ,(@Trade_PLLoadPhase3-1) ,@Premium ,@Phase3LoadDiscountPremium))	
		SET @Premium = @Premium + @Phase3LoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
	END

	IF @Trade_PLLoadCorgi != 1
	BEGIN
		SET @CorgiLoadDiscountPremium = @Premium * (@Trade_PLLoadCorgi-1)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Corgi Load/Discount Premium' ,(@Trade_PLLoadCorgi-1) ,@Premium ,@CorgiLoadDiscountPremium))	
		SET @Premium = @Premium + @CorgiLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
	END

	IF @ERFRelativity != 1
	BEGIN
		SET @ERFLoadDiscountPremium = @Premium * (@ERFRelativity-1)
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' ERF Load/Discount Premium' ,(@ERFRelativity-1) ,@Premium ,@ERFLoadDiscountPremium))	
		SET @Premium = @Premium + @ERFLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
	END


	INSERT INTO @Breakdown	VALUES(	':::')--Blank line

	SET @TotalBasePremium = @TotalBasePremium + @BasePremium
	SET @TotalPremium = @TotalPremium + @Premium
	SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
	SET @TotalIndemnityLoadDiscountPremium = @TotalIndemnityLoadDiscountPremium + @IndemnityLoadDiscountPremium
	SET @TotalEmployeeLoadDiscountPremium = @TotalEmployeeLoadDiscountPremium + @EmployeeLoadDiscountPremium
	SET @TotalDepthLoadDiscountPremium = @TotalDepthLoadDiscountPremium + @DepthLoadDiscountPremium
	SET @TotalPhase3LoadDiscountPremium = @TotalPhase3LoadDiscountPremium + @Phase3LoadDiscountPremium
	SET @TotalCorgiLoadDiscountPremium = @TotalCorgiLoadDiscountPremium + @CorgiLoadDiscountPremium
	SET @TotalHeightLoadDiscountPremium = @TotalHeightLoadDiscountPremium + @HeightLoadDiscountPremium
	SET @TotalERFLoadDiscountPremium = @TotalERFLoadDiscountPremium + @ERFLoadDiscountPremium
	
	INSERT INTO @Premiums([Name],[Value]) VALUES ('LIABPREM',@Premium)

	--ELPremium 
	IF @EmployeesELManual != 0 OR @EmployeesELNonManual != 0
	BEGIN
		SET @BasePremium = 0
		SET @PostcodeLoadDiscountPremium = 0
		SET @IndemnityLoadDiscountPremium = 0
		SET @EmployeeLoadDiscountPremium = 0
		SET @DepthLoadDiscountPremium = 0
		SET @Phase3LoadDiscountPremium = 0
		SET @CorgiLoadDiscountPremium = 0
		SET @HeightLoadDiscountPremium = 0
		SET @ERFLoadDiscountPremium = 0

		IF @EmployeesELManual != 0 
		BEGIN
			SELECT	 @Section = 'Employee Liability'
	        IF(@CInfo_PubLiabLimitValue = 10000000)
	        BEGIN
	           SET @Premium = 1.00;
	        END
	        ELSE
	        BEGIN
	           SET @Premium = @Trade_ELRate 
	        END

			--New Business (7859939201)
			IF(@SchemeTableID = 1325 AND @PolicyQuoteStage = 'NB' AND @PolicyStartDateTime >= '01 Jan 2025')
			BEGIN
			   SET @Premium = 0.01;
			END
			ELSE
			BEGIN
			   SET @Premium = @Trade_ELRate 
			END

			SET @BasePremium = @Premium

			INSERT INTO @Breakdown	VALUES(	':::')--Blank line
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section ,null ,null ,@Premium))

			IF @Trade_ELEmployeeRelativityRate != 1
			BEGIN
				SET @EmployeeLoadDiscountPremium = @Premium * (@Trade_ELEmployeeRelativityRate-1)
				INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' ' + CAST(@EmployeesELManual AS varchar(3)) +' Employees Load/Discount Premium' ,(@Trade_ELEmployeeRelativityRate-1) ,@Premium ,@EmployeeLoadDiscountPremium))	
				SET @Premium = @Premium + @EmployeeLoadDiscountPremium
				INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
			END
		END

		IF @EmployeesELManual = 0 AND @EmployeesELNonManual != 0
		BEGIN
			SELECT	 @Section = 'Employee Liability-Clerical '
			IF(@CInfo_PubLiabLimitValue = 10000000)
	        BEGIN
	           SET @Premium = 1.00;
	        END
	        ELSE
	        BEGIN
	           SET @Premium = @ELClericalRate * @EmployeesELNonManual 
	        END

			--New Business (7859939201)
			IF(@SchemeTableID = 1325 AND @PolicyQuoteStage = 'NB' AND @PolicyStartDateTime >= '01 Jan 2025')
			BEGIN
			   SET @Premium = 0.01;
			END
			ELSE
			BEGIN
			   SET @Premium = @ELClericalRate * @EmployeesELNonManual  
			END

			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesELNonManual AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		END

		IF @PostcodeLoadDiscountWeightEL != 1
		BEGIN
			SET @PostcodeLoadDiscountPremium = @Premium * (@PostcodeLoadDiscountWeightEL-1)
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,(@PostcodeLoadDiscountWeightEL-1) ,@Premium ,@PostcodeLoadDiscountPremium))	
			SET @Premium = @Premium + @PostcodeLoadDiscountPremium
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		END

		IF @Trade_ELLoadDepth != 1
		BEGIN
			SET @DepthLoadDiscountPremium = @Premium * (@Trade_ELLoadDepth-1)
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Depth Load/Discount Premium' ,(@Trade_ELLoadDepth-1) ,@Premium ,@DepthLoadDiscountPremium))	
			SET @Premium = @Premium + @DepthLoadDiscountPremium
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		END

		IF @Trade_ELLoadHeight != 1
		BEGIN
			SET @HeightLoadDiscountPremium = @Premium * (@Trade_ELLoadHeight-1)
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Height Load/Discount Premium' ,(@Trade_ELLoadHeight-1) ,@Premium ,@HeightLoadDiscountPremium))	
			SET @Premium = @Premium + @HeightLoadDiscountPremium
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		END

		IF @ERFRelativity != 1
		BEGIN
			SET @ERFLoadDiscountPremium = @Premium * (@ERFRelativity-1)
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' ERF Load/Discount Premium' ,(@ERFRelativity-1) ,@Premium ,@ERFLoadDiscountPremium))	
			SET @Premium = @Premium + @ERFLoadDiscountPremium
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		END


		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium
		SET @TotalPremium = @TotalPremium + @Premium
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium	+ @PostcodeLoadDiscountPremium
		SET @TotalIndemnityLoadDiscountPremium = @TotalIndemnityLoadDiscountPremium + @IndemnityLoadDiscountPremium
		SET @TotalEmployeeLoadDiscountPremium = @TotalEmployeeLoadDiscountPremium	+ @EmployeeLoadDiscountPremium
		SET @TotalDepthLoadDiscountPremium = @TotalDepthLoadDiscountPremium			+ @DepthLoadDiscountPremium
		SET @TotalPhase3LoadDiscountPremium = @TotalPhase3LoadDiscountPremium		+ @Phase3LoadDiscountPremium
		SET @TotalCorgiLoadDiscountPremium = @TotalCorgiLoadDiscountPremium			+ @CorgiLoadDiscountPremium
		SET @TotalHeightLoadDiscountPremium = @TotalHeightLoadDiscountPremium		+ @HeightLoadDiscountPremium
		SET @TotalERFLoadDiscountPremium = @TotalERFLoadDiscountPremium				+ @ERFLoadDiscountPremium
	
		IF @Section = 'Employee Liability-Clerical '
		BEGIN
			INSERT INTO @Premiums([Name],[Value]) VALUES ('NONMPREM',@Premium)
		END
		ELSE
		BEGIN
			INSERT INTO @Premiums([Name],[Value]) VALUES ('EMPLPREM',@Premium)
		END

	END

	--ToolsPremium 

	IF @CInfo_ToolCover = 'True'
	BEGIN	
		SET @BasePremium = 0
		SET @PostcodeLoadDiscountPremium = 0
		SET @IndemnityLoadDiscountPremium = 0
		SET @EmployeeLoadDiscountPremium = 0
		SET @DepthLoadDiscountPremium = 0
		SET @Phase3LoadDiscountPremium = 0
		SET @CorgiLoadDiscountPremium = 0
		SET @HeightLoadDiscountPremium = 0
		SET @ERFLoadDiscountPremium = 0
		SET @MinimumLoadDiscountPremium = 0

		SELECT	 @Section = 'Tools'
		IF(@CInfo_PubLiabLimitValue = 10000000)
	    BEGIN
	       SET @Premium = 1.00;
		   SET @BasePremium = @Premium
		   SET @MinimumPremium = 0
	    END
	    ELSE
	    BEGIN
	       SET @Premium = @RateTools * @EmployeesTools * @CInfo_ToolCoverValue 
		   SET @BasePremium = @Premium
		   SET @MinimumPremium = @LimitPremiumToolsMin
	    END

		--New Business (7859939201)
		IF(@SchemeTableID = 1325 AND @PolicyQuoteStage = 'NB' AND @PolicyStartDateTime >= '01 Jan 2025')
		BEGIN
	       SET @Premium = 0.01;
		   SET @BasePremium = @Premium
		   SET @MinimumPremium = 0
		END
		ELSE
		BEGIN
	       SET @Premium = @RateTools * @EmployeesTools * @CInfo_ToolCoverValue 
		   SET @BasePremium = @Premium
		   SET @MinimumPremium = @LimitPremiumToolsMin  
		END

		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' x ' + CAST(@EmployeesTools AS varchar(3)) + ' Employees' ,null ,null ,@Premium))

		IF @PostcodeLoadDiscountWeightMD != 1
		BEGIN
			SET @PostcodeLoadDiscountPremium = @Premium * (@PostcodeLoadDiscountWeightMD-1)
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Postcode Load/Discount Premium' ,(@PostcodeLoadDiscountWeightMD-1) ,@Premium ,@PostcodeLoadDiscountPremium))	
			SET @Premium = @Premium + @PostcodeLoadDiscountPremium
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		END

		IF @ERFRelativityTools != 1
		BEGIN
			SET @ERFLoadDiscountPremium = @Premium * (@ERFRelativityTools-1)
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' ERF Load/Discount Premium' ,(@ERFRelativityTools-1) ,@Premium ,@ERFLoadDiscountPremium))	
			SET @Premium = @Premium + @ERFLoadDiscountPremium
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))
		END

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line

		--Min Premium
		IF (@Premium != 0) AND (@CInfo_PubLiabLimitValue <> 10000000) AND (@Premium < @MinimumPremium)
		BEGIN
			SET @MinimumLoadDiscountPremium = @MinimumPremium - @Premium
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' Minimum Premium Load',NULL ,@MinimumPremium ,@MinimumLoadDiscountPremium))
			SET @Premium = @Premium + @MinimumLoadDiscountPremium
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))			
		END	

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium
		SET @TotalPremium = @TotalPremium + @Premium
		SET @TotalPostcodeLoadDiscountPremium = @TotalPostcodeLoadDiscountPremium + @PostcodeLoadDiscountPremium
		SET @TotalIndemnityLoadDiscountPremium = @TotalIndemnityLoadDiscountPremium + @IndemnityLoadDiscountPremium
		SET @TotalEmployeeLoadDiscountPremium = @TotalEmployeeLoadDiscountPremium + @EmployeeLoadDiscountPremium
		SET @TotalDepthLoadDiscountPremium = @TotalDepthLoadDiscountPremium + @DepthLoadDiscountPremium
		SET @TotalPhase3LoadDiscountPremium = @TotalPhase3LoadDiscountPremium + @Phase3LoadDiscountPremium
		SET @TotalCorgiLoadDiscountPremium = @TotalCorgiLoadDiscountPremium + @CorgiLoadDiscountPremium
		SET @TotalHeightLoadDiscountPremium = @TotalHeightLoadDiscountPremium + @HeightLoadDiscountPremium
		SET @TotalERFLoadDiscountPremium = @TotalERFLoadDiscountPremium + @ERFLoadDiscountPremium
		SET @TotalMinimumLoadDiscountPremium = @TotalMinimumLoadDiscountPremium + @MinimumLoadDiscountPremium			

		INSERT INTO @Premiums([Name],[Value]) VALUES ('TOOLPREM',@Premium)

	END
	
	--Breakdown totals
	IF @TotalBasePremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Base Premium' ,NULL ,NULL ,@TotalBasePremium))
	IF @TotalPostcodeLoadDiscountPremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Postcode Load/Discount' ,NULL ,NULL ,@TotalPostcodeLoadDiscountPremium))
	IF @TotalIndemnityLoadDiscountPremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Indemnity Load/Discount' ,NULL ,NULL ,@TotalIndemnityLoadDiscountPremium))
	IF @TotalEmployeeLoadDiscountPremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Employee Load/Discount' ,NULL ,NULL ,@TotalEmployeeLoadDiscountPremium))
	IF @TotalDepthLoadDiscountPremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Depth Load/Discount' ,NULL ,NULL ,@TotalDepthLoadDiscountPremium))
	IF @TotalPhase3LoadDiscountPremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Phase3 Load/Discount' ,NULL ,NULL ,@TotalPhase3LoadDiscountPremium))
	IF @TotalCorgiLoadDiscountPremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Corgi Load/Discount' ,NULL ,NULL ,@TotalCorgiLoadDiscountPremium))
	IF @TotalHeightLoadDiscountPremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Height Load/Discount' ,NULL ,NULL ,@TotalHeightLoadDiscountPremium))
	IF @TotalERFLoadDiscountPremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total ERF Load/Discount' ,NULL ,NULL ,@TotalERFLoadDiscountPremium))
	IF @TotalMinimumLoadDiscountPremium != 0	
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Minimum Premium Load' ,NULL ,NULL ,@TotalMinimumLoadDiscountPremium))		
	IF @TotalBasePremium != 0
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium))


--Referrals
	--Trade referrals
	INSERT INTO @Refer
	SELECT [Token] FROM [Shared].[dbo].[tvfSplitStringByDelimiter](@Trade_ReferTrade,'|') WHERE ISNULL(@Trade_ReferTrade,'') !='' 

--???From Dans calc check this
	IF @CInfo_ToolCover = 1 AND @CInfo_EmployeeTool = 0 AND @NonEmployeeManual = 0
		INSERT INTO @Refer	VALUES('Tools selected but no one working manually who is not an employee.')
		
	--ANother dodgey from Dan to check
	IF @TrdDtail_CavityWall = 1 AND 'Cavity Wall Insulation' IN (SELECT [TradeName] FROM @Trades)
		INSERT INTO @Refer	VALUES('Cavity wall')
		
	IF REPLACE(@Postcode,' ','') LIKE 'SE19%' OR @Postcode LIKE 'E144%' OR @Postcode LIKE 'E145%'
		INSERT INTO @Refer VALUES ('Shard')		
		

	IF (@PolicyQuoteStage = 'NB' AND @PolicyQuoteStageMTA = 0) 
	BEGIN
		IF @PostcodeAreaPL = 999 
			INSERT INTO @Refer	VALUES('Postcode Sector for postcode ' + @PostCode + ' Is not acceptable for Public Liability')	
		IF (@EmployeesELManual != 0 OR @EmployeesELNonManual != 0) AND @PostcodeAreaEL = 999
			INSERT INTO @Refer	VALUES('Postcode Sector for postcode ' + @PostCode + ' Is not acceptable for Employers Liability')	
		IF @CInfo_ToolCover = 'True' AND @PostcodeAreaMD = 999
			INSERT INTO @Refer	VALUES('Postcode Sector for postcode ' + @PostCode + ' Is not acceptable for Tools cover')	
	END
	
	IF @TrdDtail_Roofing = 1
		INSERT INTO @Refer VALUES ('Roofing')
		
	IF @TrdDtail_Waterproofing = 1
		INSERT INTO @Refer VALUES ('Water Proofing')
		
	IF @TrdDtail_Solvent = 1
		INSERT INTO @Refer VALUES ('Solvent')		

	IF @TrdDtail_Roadsurfacing = 1
		INSERT INTO @Refer VALUES ('Road Surfacing')

		
	IF @PolicyQuoteStage = 'NB' AND @PolicyStartDateTime >= getdate() + @LimitFutureDatedDaysMax
		INSERT INTO @Refer	VALUES('Quote date Exceeds maximum of ' + CAST( @LimitFutureDatedDaysMax AS VARCHAR(10)) + ' days in the future')
		
	IF @PolicyQuoteStage = 'NB' AND @PolicyQuoteStageMTA = 0 AND @PolicyStartDateTime <= getdate() - @LimitBackDatedDaysMax
		INSERT INTO @Refer	VALUES('Quote date Exceeds maximum of ' + CAST( @LimitBackDatedDaysMax AS VARCHAR(10)) + ' days in the past')	
	
	IF @TrdDtail_PrimaryRisk = 'None'
		INSERT INTO @Refer	VALUES('No Trade Entered')
		
	IF @CInfo_PubLiabLimitValue > @LimitCInfo_PubLiabLimitMax
		INSERT INTO @Refer	VALUES('Level of Indemnity ' + @CInfo_PubLiabLimit + ' Exceeds maximum of ' + dbo.svfFormatMoneyString(@LimitCInfo_PubLiabLimitMax))

	IF @TotalEmployees > @LimitEmployeesMax
		INSERT INTO @Refer	VALUES('Total Employees '+ Cast(@TotalEmployees AS varchar(3)) + ' Exceeds maximum of ' + Cast(@LimitEmployeesMax AS varchar(3)))

	IF @EmployeesPL > @LimitEmployeesPLMax
		INSERT INTO @Refer	VALUES('Manual Employees '+ Cast(@EmployeesPL AS varchar(3)) + ' Exceeds maximum of ' + Cast(@LimitEmployeesPLMax AS varchar(3)))

	IF @EmployeesELManual > @LimitEmployeesELMax
		INSERT INTO @Refer	VALUES('Manual Employees '+ Cast(@EmployeesELManual AS varchar(3)) + ' Exceeds maximum of ' + Cast(@LimitEmployeesELMax AS varchar(3)))
		
	IF @CInfo_ManDays > @LimitCInfo_ManDaysMax
		INSERT INTO @Refer	VALUES('Temporary Employee days '+ Cast(@CInfo_ManDays AS varchar(6)) + ' Exceeds maximum of ' + Cast(@LimitCInfo_ManDaysMax AS varchar(6)))

	IF @CInfo_BonaFideWR > @CInfo_AnnualTurnover * @LimitCInfo_BonaFideWRPercentMax
		INSERT INTO @Refer	VALUES('Bonafide Wage Roll ' + dbo.svfFormatMoneyString(@CInfo_BonaFideWR) + ' Exceeds Limit of ' + dbo.svfFormatMoneyString(@CInfo_AnnualTurnover * @LimitCInfo_BonaFideWRPercentMax) + ' (' + dbo.svfFormatPCTRate(@LimitCInfo_BonaFideWRPercentMax) + '% of estimated annual turnover ' +  dbo.svfFormatMoneyString(@CInfo_AnnualTurnover) + ')')

	IF @CInfo_Annualturnover > @LimitCInfo_AnnualturnoverMax 
		INSERT INTO @Refer	VALUES('Turnover '+ dbo.svfFormatMoneyString(@CInfo_Annualturnover) + ' Exceeds maximum of ' + dbo.svfFormatMoneyString(@LimitCInfo_AnnualturnoverMax))

	IF @CoverToolsTotal > @LimitCoverToolsTotalMax
		INSERT INTO @Refer	VALUES('Total Tool Cover '+ dbo.svfFormatMoneyString(@CoverToolsTotal) + ' Exceeds maximum of ' + dbo.svfFormatMoneyString(@LimitCoverToolsTotalMax))

	IF @CInfo_ToolCoverValue > @LimitCInfo_ToolCoverValueMax
		INSERT INTO @Refer	VALUES('Tool cover per person '+ dbo.svfFormatMoneyString(@CInfo_ToolCoverValue ) + ' Exceeds maximum of ' + dbo.svfFormatMoneyString(@LimitCInfo_ToolCoverValueMax))

	IF @CInfo_CompanyStatus = 'Individual Trading As' AND @CInfo_Manualwork = 0
		INSERT INTO @Refer	VALUES('Manual Work Answer No - Individual Trading')

	IF NULLIF(@CInfo_BonaFideWR, 0) / NULLIF(@CInfo_Annualturnover, 0) * 100 > 25
		INSERT INTO @Refer VALUES ('BonaFide greater than 25% of turnover')

	IF @PolicyQuoteStage IN ('NB', 'MTA') AND @TotalEmployees > 10
		INSERT INTO @Refer VALUES ('Total employees greater than 10')

	IF @PostCode like 'BT%' --(Refer for Covea)
		INSERT INTO @Decline VALUES ('Northern Ireland Risks must be declined')

	-- AXA New Business / Renewal, 2 Trades Selected
	--IF @PolicyQuoteStage IN ('NB', 'REN') AND COUNT(@TrdDtail_PrimaryRisk_ID) = 1 AND @TrdDtail_SecondaryRisk_ID NOT IN ('3N10P642')
		--INSERT INTO @Decline VALUES ('New Business with 2 trades selected')

	-- New Business / Renewal, Mixed Trades
	--IF @PolicyQuoteStage IN ('NB', 'REN') AND (SELECT [Family] FROM [Calculators].[dbo].[MLIAB_AXA_TradesmanLiability_TradePLEL] WHERE TradeID = @TrdDtail_PrimaryRisk_ID AND [EndDateTime] IS NULL) != (CASE WHEN @TrdDtail_SecondaryRisk_ID = '3N10P642' THEN (SELECT [Family] FROM [Calculators].[dbo].[MLIAB_AXA_TradesmanLiability_TradePLEL] WHERE TradeID = @TrdDtail_PrimaryRisk_ID AND [EndDateTime] IS NULL) ELSE (SELECT [Family] FROM [Calculators].[dbo].[MLIAB_AXA_TradesmanLiability_TradePLEL] WHERE TradeID = @TrdDtail_SecondaryRisk_ID AND [EndDateTime] IS NULL) END)
	--	INSERT INTO @Decline VALUES ('Mixed trades not allowed')

	IF @CInfo_Annualturnover > 500000
		INSERT INTO @Refer VALUES ('Turnover is greater than 500,000')

	--IF @CInfo_BonaFideWR / @CInfo_Annualturnover * 100 < 25
		--INSERT INTO @Decline VALUES ('BonaFide must be greater than 25%')

	--IF @PolicyQuoteStage IN ('NB', 'MTA') AND @TotalEmployees < 10
		--INSERT INTO @Decline VALUES ('Total employees less than 10')

	IF @PolicyQuoteStage IN ('REN') AND @TotalEmployees > 10
		INSERT INTO @Decline VALUES ('Total employees greater than 10')

	IF @TrdDtail_MaxDepthValue > 5
		INSERT INTO @Refer VALUES ('Depth is greater than 5 meters')

	--Claim Refers
	INSERT INTO @Refer
	SELECT 
		[Token]
	FROM
		@ERFTable [E]
		CROSS APPLY [Shared].[dbo].[tvfSplitStringByDelimiter]([ReferCSV],'|') WHERE [E].[ERFType] = 'ERF' AND ISNULL([ReferCSV],'') !=''
	

--Endorsements

	INSERT INTO @Endorsement 
	SELECT [Token] FROM [dbo].[tvfSplitStringByDelimiter](@Trade_Endorsement,',')
	
	IF (@CInfo_ToolCover = 1 OR (SELECT COUNT(*) FROM @CAR WHERE [Contractsworks] = 1 OR [coverplant] = 1 OR [coverhireplant] = 1) != 0) AND (SELECT COUNT(*) FROM @Endorsement WHERE [Message] = 'AXTL0DE2') = 0
	BEGIN
		INSERT INTO @Endorsement VALUES ('43CJP840') 
	END

	IF @TrdDtail_PrimaryRisk = 'Fencing Contractor'
		INSERT INTO @Endorsement VALUES ('AXTL0503')

	INSERT INTO @Endorsement VALUES ('AXTL0503')

	IF @TrdDtail_MaxDepthValue > 5
		INSERT INTO @Endorsement VALUES ('AXTL0506')

/*	
--Excesses '{Excess Desc}:{ExcessVal000}:{List_Excess_Section.Excess_Section_ID}:{LIST_EXCESSTYPE.ExcessType_ID}'
*/
	INSERT INTO @Excess 
	VALUES ('Standard Excess:'+CAST(@Trade_Excess AS varchar(10)) +':4:4')

	INSERT INTO @Excess 
	SELECT ('﻿﻿Tools 10% of each and every claim subject to a minimum of £100 and maximum of £500:100:4:4') WHERE @CInfo_ToolCover = 'True'



--Return Table


	DECLARE
	     @ERFNumber int
		,@ERFNumberTools int
		,@ERFMovementType int
		,@ERFMovement int
		,@ERFMovementTools int
		,@ERFMovementTypeTools int
		,@MaterialDamage3YearClaimValue int
		
	SELECT 
		 @ERFNumber = [ERFNumber]
		,@ERFMovement = [ERFMovement]
		,@ERFMovementType = [MovementType]
		,@MaterialDamage3YearClaimValue = [MaterialDamage3YearClaimValue]
	FROM 
		@ERFTable WHERE [ERFType] = 'ERF'
		
	SELECT 
		 @ERFNumberTools = [ERFNumber]
		,@ERFMovementTools = [ERFMovement]
		,@ERFMovementTypeTools = [MovementType]
	FROM 
		@ERFTable WHERE [ERFType] = 'Tools'
	
	DECLARE
		 @PremiumPL money = (SELECT [Value] FROM @Premiums WHERE [Name] = 'LIABPREM')
		,@PremiumEL money = (SELECT [Value] FROM @Premiums WHERE [Name] = 'EMPLPREM')
		,@PremiumTools money = (SELECT [Value] FROM @Premiums WHERE [Name] = 'TOOLPREM')
		,@PremiumNonManualEL money = (SELECT [Value] FROM @Premiums WHERE [Name] = 'NONMPREM')
		

	DECLARE @SchemeDetails TABLE
	(
		 [PreviousPolicyHistoryID] int
		,[PLPremium] money
		,[ELPremium] money
		,[TOOLPremium] money
		,[NonManualPremium] money	
		,[PostcodeAreaPL] int
		,[PostcodeAreaEL] int
		,[PostcodeAreaMD] int			 
		,[ERFNumber] int
		,[ERFMovementType] int
		,[ERFMovement] int
		,[ERFNumberTools] int 			
		,[ERFMovementTypeTools] int
		,[ERFMovementTools] int
		,[MaterialDamage3YearClaimValue] int
		,[PLRate] money	
		,[PLIndemnityRelativityRate]  numeric (8,5)
		,[PLEmployeeRelativityRate]  numeric (8,5)
		,[PLLoadDepth] money
		,[PLLoadPhase3] money
		,[PLLoadCorgi] money
		,[ELRate] money		
		,[ELEmployeeRelativityRate] numeric (8,5)
		,[ELLoadDepth] money
		,[ELLoadHeight] money
		,[ToolsRate] money			
		,[PostcodeLoadDiscountWeightPL][numeric](8,5)
		,[PostcodeLoadDiscountWeightEL][numeric](8,5)
		,[PostcodeLoadDiscountWeightMD][numeric](8,5)
		,[ERFRelativity] [numeric](8,5)
		,[ERFRelativityTools] [numeric](8,5)			
	)
	INSERT INTO @SchemeDetails
	VALUES
	(
		 @PreviousPolicyHistoryID 
		,@PremiumPL
		,@PremiumEL
		,@PremiumTools
		,@PremiumNonManualEL		 
		,@PostcodeAreaPL
		,@PostcodeAreaEL
		,@PostcodeAreaMD
		,@ERFNumber
		,@ERFMovementType
		,@ERFMovement
		,@ERFNumberTools
		,@ERFMovementTypeTools
		,@ERFMovementTools
		,@MaterialDamage3YearClaimValue
		,@Trade_PLRate
		,@Trade_PLIndemnityRelativityRate
		,@Trade_PLEmployeeRelativityRate	
		,@Trade_PLLoadDepth
		,@Trade_PLLoadPhase3
		,@Trade_PLLoadCorgi
		,@Trade_ELRate		
		,@Trade_ELEmployeeRelativityRate		
		,@Trade_ELLoadDepth
		,@Trade_ELLoadHeight	
		,@RateTools 							
		,@PostcodeLoadDiscountWeightPL
		,@PostcodeLoadDiscountWeightEL
		,@PostcodeLoadDiscountWeightMD
		,@ERFRelativity
		,@ERFRelativityTools					
	)

	DECLARE @SchemeDetailsXML xml = (SELECT * FROM @SchemeDetails FOR XML PATH('SchemeDetails'))

	DECLARE @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults VALUES (@SchemeDetailsXML),(@SchemeResultsXML)

	RETURN
END
