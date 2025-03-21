USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspSchemeContractorsPlantAndEquipmentTokioMarineKiln]    Script Date: 09/01/2025 09:29:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		Devlin Hostler
-- date:        28 Feb 2017
-- Description: Return CAR Information Tokio Marine Kiln - Contractors Plant and Equipment
*******************************************************************************

-- Date			Who						Change
-- 12/04/2022	Jeremai Smith			Monday ticket 2534326536:
--											- Refer all claims
--											- All BT postcodes to refer
--											- Additional 25% load if only Hired in Plant selected
--											- Added endorsement TMKCAR09 when Own Plant selected
-- 20/05/2022	Simon M.Pettit			Monday ticket 2677036257
--											- Removed Covid-19 Endorsment 
-- 11/07/2022	Jeremai Smith			Added PremiumMinimumOwnPlantIsolation and PremiumMinimumHiredInPlantIsolation calculations to set higher minimum premium
--										if only one section taken in isolation (Monday ticket 92913554322).
-- 17/02/2023	Jeremai Smith			Refer if cover selected but £0 entered as we can't calculate a premium and this was preventing the minimum premium
--										for the coverage being applied, resulting in a massive discount! (Monday ticket 3998455974)
-- 16/03/2023	Linga 			        Monday ticket 4106384029:
--											- Removed endorsement TMKCAR05
-- 25/05/2023   Linga					Monday Ticket 4479005882: Trade Removal Stand Alone CAR / CPE
--											- Declining Trades for Companion CAR and CPE schemes
-- 11/12/2023   Simon					Monday Ticket 5661407062: Trade Removal Stand Alone CPE
--											- Declining Trades for Companion CPE scheme
-- 02/01/2025   Linga				    Monday Ticket 8142413832: UK postcode Referral
-- 07/01/2025   Linga                   Monday Ticket 8154652828: Update endorsements on Companion CAR and CPE schemes
*******************************************************************************/

ALTER PROCEDURE [dbo].[uspSchemeContractorsPlantAndEquipmentTokioMarineKiln]
	 @Postcode nvarchar(12)
	,@PolicyStartDateTime datetime
	,@ClaimsValue numeric(18,2) = 0
	,@ClaimsCount int = 0
	,@ClaimsLargestValue money = 0	
	,@AssumpDemolition nvarchar(8)
	,@AssumpAircraft nvarchar(8)
	,@AssumpNuclear nvarchar(8)
	,@AssumpTidalWaters nvarchar(8)
	,@AssumpAsbestos nvarchar(8)
	,@AssumpDeclined nvarchar(8)
	,@AssumpBankrupt nvarchar(8)
	,@AssumpCriminal nvarchar(8)
	,@OwnPlantAndTools bit = NULL	
	,@OwnPlantAndToolsValue money  = 0
	,@HiredPlant bit
	,@HiredPlantSingleItemMaxValue money = 0
	,@HiredPlant12MonthHireCharges money = 0
	,@HiredPlantTotalValue money = 0
	,@ContractWork bit
	,@ContractWorkValue money = 0
	,@Turnover money = 0
	,@EmployeesManual nvarchar(8)
	,@CompanyStatus nvarchar(8)
	,@PrimaryTradeID nvarchar(8)
	,@SecondaryTradeID nvarchar(8)
	,@InsurerID  nvarchar(8)
	,@EmployeesPAndP money = 0
	,@EmployeesToolCoverYN bit
	,@EmployeeToolsTotalValue money = 0
	,@EmployeeToolsMaxIndividualValue money = 0
	,@DepthMax nvarchar(8)
	,@HeightMax  nvarchar(8)
	,@Contract12MonthYN bit
	,@ContractMaxLengthMonths int = 0
	,@TotalLosses money = 0
	,@ClaimAge int = 0
	,@TotalPremium money = null OUT
	,@SuppressResults bit = 'false'	
AS

/*

uspSchemeContractorsPlantAndEquipmentTokioMarineKiln 
 @Postcode = 'CF11 7AE'
,@PolicyStartDateTime = '2017-03-03'
,@ClaimsValue = 0
,@ClaimsCount = 0
,@ClaimsLargestValue = 0
,@AssumpDemolition = '3MQT5MC6'
,@AssumpAircraft = '3MQT5MC6'
,@AssumpNuclear = '3MQT5MC6'
,@AssumpTidalWaters = '3MQT5MC6'
,@AssumpAsbestos = '3MQT5MC6'
,@AssumpDeclined = '3MQT5MC6'
,@AssumpBankrupt = '3MQT5MC6'
,@AssumpCriminal = '3MQT5MC6'
,@OwnPlantAndTools = 'false'
,@OwnPlantAndToolsValue = '75000'
,@HiredPlant = 'true'
,@HiredPlantSingleItemMaxValue = '40000'
,@HiredPlant12MonthHireCharges = '5000'
,@HiredPlantTotalValue = '12000'
,@ContractWork = 'true'
,@ContractWorkValue = '100000'
,@Turnover = '200000'
,@EmployeesManual = '3MRJ4JK8'
,@CompanyStatus = '3MQQN2I3'
,@PrimaryTradeID = '3N0TV8G9'
,@SecondaryTradeID = '3N10P642'
,@InsurerID = '159'
,@EmployeesPAndP = '1'
,@EmployeesToolCoverYN = 'false'
,@EmployeeToolsTotalValue = '9000'
,@EmployeeToolsMaxIndividualValue = '400'
,@DepthMax = '3MQQ2RP4'
,@HeightMax = '3N6C7CI6'
,@Contract12MonthYN = 'false'
,@ContractMaxLengthMonths = 12
,@TotalLosses  = 0
,@TotalPremium = NULL

SELECT * FROM uspSchemeCommandDebug WHERE uspSchemeCommandText LIKE '%spSchemeContractorsPlantAndEquipmentTokioMarineKiln%'
 
*/


DECLARE @LossRatio money = 0

--Limits
DECLARE  @LowClaimMaximum bigint
		,@LossRatioMaximum numeric(18,5)
		,@PremiumMinimumOwnPlant int
		,@PremiumMinimumOwnPlantIsolation int
		,@PremiumMinimumHiredInPlant int
		,@PremiumMinimumHiredInPlantIsolation int
		,@ContractWorkPeriodMonthsMaximum int

			
SELECT TOP 1
	 @LowClaimMaximum						= [LowClaimMaximum]
	,@LossRatioMaximum						= [LossRatioMaximum]
	,@PremiumMinimumOwnPlant				= [PremiumMinimumOwnPlant]
	,@PremiumMinimumOwnPlantIsolation		= [PremiumMinimumOwnPlantIsolation]
	,@PremiumMinimumHiredInPlant			= [PremiumMinimumHiredInPlant]
	,@PremiumMinimumHiredInPlantIsolation	= [PremiumMinimumHiredInPlantIsolation]
	,@ContractWorkPeriodMonthsMaximum		= [ContractWorkPeriodMonthsMaximum]
	
FROM 
	[dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnLimits]
WHERE
	@PolicystartDateTime >= [StartDatetime] 
ORDER BY
	[StartDatetime] DESC

-- Call the procedure recursively to calculate the premium and work out loss ratio:
-- Commented out as all claims now refer, so this is redundant
/*
IF @TotalLosses > @LowClaimMaximum AND @TotalPremium IS NULL
BEGIN
	SET @TotalPremium = 0
	DECLARE  @TempTotalLosses money = @TotalLosses
			,@TempClaimsLargestValue money = @ClaimsLargestValue
	SET @TotalLosses = 0
	SET @ClaimsLargestValue = 0
	SET @SuppressResults  = 'true'
	EXEC [dbo].[uspSchemeContractorsPlantAndEquipmentTokioMarineKiln]  @Postcode ,@PolicyStartDateTime ,@ClaimsValue ,@ClaimsCount ,@ClaimsLargestValue ,@AssumpDemolition ,@AssumpAircraft ,@AssumpNuclear ,@AssumpTidalWaters ,@AssumpAsbestos ,@AssumpDeclined ,@AssumpBankrupt ,@AssumpCriminal ,@OwnPlantAndTools ,@OwnPlantAndToolsValue ,@HiredPlant ,@HiredPlantSingleItemMaxValue ,@HiredPlant12MonthHireCharges ,@HiredPlantTotalValue ,@ContractWork ,@ContractWorkValue ,@Turnover ,@EmployeesManual ,@CompanyStatus ,@PrimaryTradeID ,@SecondaryTradeID ,@InsurerID ,@EmployeesPAndP ,@EmployeesToolCoverYN ,@EmployeeToolsTotalValue ,@EmployeeToolsMaxIndividualValue ,@DepthMax ,@HeightMax ,@Contract12MonthYN ,@ContractMaxLengthMonths ,@TotalLosses ,@ClaimAge ,@TotalPremium OUT , @SuppressResults
	SET @SuppressResults = 'false'
	SET @TotalLosses = @TempTotalLosses
	SET @ClaimsLargestValue = @TempClaimsLargestValue
		
	IF @TotalPremium != 0
	BEGIN
		SET @LossRatio = @TotalLosses/(@TotalPremium*3)
	END
END
*/

DECLARE 
	 @OwnPlantAndToolsPremium numeric (18,2) = 0
	,@HiredInPlantPremium numeric (18,2) = 0
	,@Endorsements nvarchar(255)

DECLARE @Refer table
(
	 [ReferID] int IDENTITY (1,1)
	,[ReferMessage] nvarchar(2000)
)		

DECLARE @Decline table
(
	 [DeclineID] int IDENTITY (1,1)
	,[DeclineMessage] nvarchar(2000)
)	
	
DECLARE @Excess table
(
	 [ExcessID] int IDENTITY (1,1)
	,[ExcessMessage] nvarchar(2000)
)	
	
DECLARE @Summary table
(
	 [SummaryID] int IDENTITY (1,1)
	,[SummaryMessage] nvarchar(2000)
)	
	
DECLARE @Breakdown table
(
	 [BreakdownID] int IDENTITY (1,1)
	,[BreakdownMessage] nvarchar(2000)
)	
	
DECLARE @ProductDetails table
(
	 [ProductDetailsID] int IDENTITY (1,1)
	,[ProductDetailsMessage] nvarchar(2000)
)


-- Claim refers
IF @TotalLosses > 0
	INSERT INTO @Refer([ReferMessage])	VALUES('Refer any risk with a claim')	

--IF @LossRatio > @LossRatioMaximum
--	INSERT INTO @Refer([ReferMessage])	VALUES('Loss ratio of '+cast(@LossRatio as nvarchar(10)) + ' Exceeds maximum of '+cast(@LossRatioMaximum as nvarchar(10)))		

--IF @ClaimAge > 0 AND @ClaimAge <= 3
--INSERT INTO @Refer([ReferMessage])	VALUES('Claim exists within the last three years')
	
INSERT INTO @Summary([SummaryMessage])	VALUES(	'Section Name				= Sum Insured x Rate x Section Load (optional) x Primary Trade Load x Secondary Trade Load x Post Code Load = Section Premium (Or Minimum Premium)')


--Postcode
DECLARE @LoadPostcodeWeight money = 1
IF @Postcode LIKE 'BT%'
BEGIN
	SET @LoadPostcodeWeight = 1.5
	INSERT INTO @Refer([ReferMessage])	VALUES('Refer all BT postcodes')
END


--Trades
DECLARE @PrimaryTradeUnrated nvarchar(255)
DECLARE @SecondaryTradeUnrated nvarchar(255)

SELECT TOP 1
	@PrimaryTradeUnrated = CASE WHEN [T].[TradeID] IS NULL OR [T].[Refer] = 1 THEN [L].[MH_Trade_Debug] ELSE NULL END
FROM
	[dbo].[List_MH_Trade] AS [L]
	LEFT JOIN [SchemeContractorsPlantAndEquipmentTokioMarineKilnTrade] AS [T] ON [L].[MH_Trade_ID] = [T].[TradeID] AND @PolicystartDateTime >= [StartDatetime]
WHERE
	[L].[MH_Trade_ID] = @PrimaryTradeID
	AND @PolicyStartDateTime <= ISNULL([T].[EndDateTime] , @PolicyStartDateTime)
ORDER BY [T].[StartDatetime] DESC

SELECT TOP 1
	@SecondaryTradeUnrated = CASE WHEN [T].[TradeID] IS NULL OR [T].[Refer] = 1 THEN [L].[MH_Trade_Debug] ELSE NULL END
FROM
	[dbo].[List_MH_Trade] AS [L]
	LEFT JOIN [SchemeContractorsPlantAndEquipmentTokioMarineKilnTrade] AS [T] ON [L].[MH_Trade_ID] = [T].[TradeID] AND @PolicystartDateTime >= [StartDatetime] AND @SecondaryTradeID != '3N10P642'
WHERE
	[L].[MH_Trade_ID] = @SecondaryTradeID
	AND @PolicyStartDateTime <= ISNULL([T].[EndDateTime] , @PolicyStartDateTime)
	AND @SecondaryTradeID != '3N10P642'
ORDER BY [T].[StartDatetime] DESC

IF @PrimaryTradeUnrated IS NOT NULL
	INSERT INTO @Refer([ReferMessage])	VALUES(@PrimaryTradeUnrated + ' is not an acceptable trade for Contractors Plant and Equipment')
IF @SecondaryTradeUnrated IS NOT NULL
	INSERT INTO @Refer([ReferMessage])	VALUES(@SecondaryTradeUnrated + ' is not an acceptable trade for Contractors Plant and Equipment')

DECLARE @PrimaryTradeLoad numeric(18,5)
DECLARE @SecondaryTradeLoad numeric(18,5)	
DECLARE @PrimaryTradeEndorsements nvarchar(100)
DECLARE @SecondaryTradeEndorsements nvarchar(100)
DECLARE @PrimaryTradeName nvarchar(255)
DECLARE @SecondaryTradeName nvarchar(255)			
DECLARE @PrimaryMaxDepth int
DECLARE @SecondaryMaxDepth int	
DECLARE @PrimaryMaxHeight int
DECLARE @SecondaryMaxHeight int	
	
SELECT TOP 1
	 @PrimaryTradeEndorsements = ISNULL([T].[Endorsements],'')
	,@PrimaryTradeLoad = [T].[Load]
	,@PrimaryMaxDepth = [T].[MaxDepth]
	,@PrimaryTradeName = [L].[MH_Trade_Debug]	
	,@PrimaryMaxHeight	= [T].[MaxHeight]
FROM
	[dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnTrade] AS [T]
	JOIN [dbo].[List_MH_Trade] AS [L] ON [L].[MH_Trade_ID] = [T].[TradeID]
WHERE
	@PolicystartDateTime >= [StartDatetime] 
	AND [TradeID] = @PrimaryTradeID
	AND @PolicyStartDateTime <= ISNULL([T].[EndDateTime] , @PolicyStartDateTime)
ORDER BY
	[StartDatetime] DESC			
	
SELECT TOP 1
	 @SecondaryTradeEndorsements = ISNULL([T].[Endorsements],'')
	,@SecondaryTradeLoad = [T].[Load]
	,@SecondaryMaxDepth = [T].[MaxDepth]
	,@SecondaryTradeName = [L].[MH_Trade_Debug]
	,@SecondaryMaxHeight = [T].[MaxHeight]		 
FROM
	[dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnTrade] AS [T]
	JOIN [dbo].[List_MH_Trade] AS [L] ON [L].[MH_Trade_ID] = [T].[TradeID]		
WHERE
	@PolicystartDateTime >= [StartDatetime] 
	AND [TradeID] = @SecondaryTradeID
	AND @PolicyStartDateTime <= ISNULL([T].[EndDateTime] , @PolicyStartDateTime)
	AND @SecondaryTradeID != '3N10P642'
ORDER BY
	[StartDatetime] DESC	
		
SET @Endorsements = @PrimaryTradeEndorsements + ISNULL(',' + @SecondaryTradeEndorsements ,'')

SET @SecondaryTradeLoad = ISNULL(@SecondaryTradeLoad,1)
					
IF @OwnPlantAndTools = 1  
BEGIN

	IF @OwnPlantAndToolsValue <= 0
	INSERT INTO @Refer([ReferMessage])	VALUES('£0 Cover unavailable')

	DECLARE  @OwnPlantMaximumCover bigint
			,@OwnPlantRate numeric(18,5)

	SELECT TOP 1
			@OwnPlantMaximumCover = [CoverEndRange]
	FROM 
		[dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnRate]
	WHERE
		@PolicystartDateTime >= [StartDatetime] 
		AND [SectionType] = 'OP'
	ORDER BY
		 [StartDatetime] DESC
		,[CoverEndRange] DESC	

	SELECT TOP 1
		@OwnPlantRate = 
			CASE
			WHEN @TotalLosses = 0 THEN [ClaimFreeRate]
			WHEN @TotalLosses <= @LowClaimMaximum THEN [ClaimLowRate]
			--WHEN @LossRatio <= @LossRatioMaximum THEN [ClaimLossRatioRate]
			ELSE [ClaimLossRatioRate]
		END			 
	FROM
		[dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnRate]
	WHERE
		[SectionType] = 'OP'
		AND @OwnPlantAndToolsValue >[CoverStartRange]
		AND @OwnPlantAndToolsValue <=[CoverEndRange]
		AND @PolicystartDateTime >= [StartDatetime] 
	ORDER BY
		[StartDatetime] DESC	
			
	SET @OwnPlantAndToolsPremium = @OwnPlantAndToolsValue * @OwnPlantRate * @PrimaryTradeLoad * @SecondaryTradeLoad * @LoadPostcodeWeight
	SET @OwnPlantAndToolsPremium = CASE
										WHEN @OwnPlantAndToolsPremium < @PremiumMinimumOwnPlantIsolation AND @HiredPlant = 0 THEN @PremiumMinimumOwnPlantIsolation
										WHEN @OwnPlantAndToolsPremium < @PremiumMinimumOwnPlant THEN @PremiumMinimumOwnPlant
										WHEN @OwnPlantAndToolsPremium IS NULL THEN @PremiumMinimumOwnPlant -- Premium will be NULL if £0 value entered. This will refer, but this line will show the minimum premium in the breakdown if cotinuing past the refer.
										ELSE @OwnPlantAndToolsPremium
								   END
									
	IF @OwnPlantAndToolsPremium > 0
	BEGIN
		INSERT INTO @Summary([SummaryMessage])	VALUES(	'Section 2 (Own Plant, Machinery and Tools)	= ' 
		+ [dbo].[svfFormatMoneyString](@OwnPlantAndToolsValue) 
		+ ' x ' + CAST(@OwnPlantRate AS nvarchar(10)) 
		+ ' x ' + CAST(@PrimaryTradeLoad AS nvarchar(10))
		+ ' x ' + CAST(@SecondaryTradeLoad AS nvarchar(10))
		+ ' x ' + CAST(@LoadPostcodeWeight AS nvarchar(10))
		+ '		= ' +  [dbo].[svfFormatMoneyString](@OwnPlantAndToolsPremium) 
		+ CASE @OwnPlantAndToolsPremium WHEN @PremiumMinimumOwnPlant THEN '(Min)' ELSE '' END)
			
		INSERT INTO @Breakdown([BreakdownMessage])	VALUES(	'Section 2 (Own Plant, Machinery and Tools):::'+ CAST(@OwnPlantAndToolsPremium AS nvarchar(10)))			
		INSERT INTO @ProductDetails([ProductDetailsMessage])	VALUES(	'Section 2 (Own Plant, Machinery and Tools) = '+ [dbo].[svfFormatMoneyString](@OwnPlantAndToolsValue))					
		INSERT INTO @Excess ([ExcessMessage]) SELECT [Excess] FROM [dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnExcess] WHERE [Section] = 'OP' AND [Obsolete] = 0
	END
		
	IF @OwnPlantAndToolsValue > @OwnPlantMaximumCover 
		INSERT INTO @Refer([ReferMessage])	VALUES('Value exceeds maximum sum insured for Own Plant and Machinery ' + [dbo].[svfFormatMoneyString](@OwnPlantMaximumCover))
	/*8154652828
	SET @Endorsements = @Endorsements + ',TMKCAR09'
	*/

END

IF @HiredPlant = 1
BEGIN

	IF @HiredPlant12MonthHireCharges <= 0
	INSERT INTO @Refer([ReferMessage])	VALUES('£0 Cover unavailable')

	DECLARE	 @HiredPlantMaximumCover bigint
			,@HiredInPlantLoadingMax bigint
			,@HiredInPlantLoading numeric(18,5)
			,@HiredPlantRate numeric(18,5)
		
	SELECT TOP 1
		@HiredPlantMaximumCover = [CoverEndRange]
	FROM 
		[dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnRate]
	WHERE
		@PolicystartDateTime >= [StartDatetime] 
		AND [SectionType] = 'HP'
	ORDER BY
			[StartDatetime] DESC
		,[CoverEndRange] DESC		    
		
	SELECT TOP 1
		@HiredPlantRate = 
			CASE
			WHEN @TotalLosses = 0 THEN [ClaimFreeRate]
			WHEN @TotalLosses <= @LowClaimMaximum THEN [ClaimLowRate]
			--WHEN @LossRatio <= @LossRatioMaximum THEN [ClaimLossRatioRate]
			ELSE [ClaimLossRatioRate]
		END				 
	FROM
		[dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnRate]
	WHERE
		[SectionType] = 'HP'
		AND @HiredPlant12MonthHireCharges >[CoverStartRange]
		AND @HiredPlant12MonthHireCharges <=[CoverEndRange]
		AND @PolicystartDateTime >= [StartDatetime] 
	ORDER BY
		[StartDatetime] DESC	


	-- Additional 25% load if only Hired in Plant selected:
	IF @ContractWork <> 1 AND @OwnPlantAndTools <> 1 AND @EmployeesToolCoverYN <> 1
	BEGIN
		SET @HiredPlantRate = (@HiredPlantRate * 0.25) + @HiredPlantRate
	END

	SELECT TOP 1
		@HiredInPlantLoadingMax = [CoverEndRange]
	FROM
		[dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnHiredInPlantAOALoading]
	WHERE
		@PolicystartDateTime >= [StartDatetime] 
	ORDER BY
		 [StartDatetime] DESC
		,[CoverEndRange] DESC
			
	SELECT TOP 1
		@HiredInPlantLoading = [Loading]
	FROM
		[dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnHiredInPlantAOALoading]
	WHERE
		@PolicystartDateTime >= [StartDatetime] 
		AND @HiredPlantTotalValue >[CoverStartRange]
		AND @HiredPlantTotalValue <=[CoverEndRange]			
	ORDER BY
		 [StartDatetime] DESC
		,[CoverEndRange] DESC

	SET @HiredInPlantPremium = @HiredPlant12MonthHireCharges * @HiredPlantRate * @PrimaryTradeLoad * @SecondaryTradeLoad * @HiredInPlantLoading * @LoadPostcodeWeight
	SET @HiredInPlantPremium = CASE
									WHEN @HiredInPlantPremium < @PremiumMinimumHiredInPlantIsolation AND @OwnPlantAndTools = 0 THEN @PremiumMinimumHiredInPlantIsolation
									WHEN @HiredInPlantPremium < @PremiumMinimumHiredInPlant THEN @PremiumMinimumHiredInPlant
									WHEN @HiredInPlantPremium IS NULL THEN @PremiumMinimumHiredInPlant -- Premium will be NULL if £0 value entered. This will refer, but this line will show the minimum premium in the breakdown if cotinuing past the refer.
									ELSE @HiredInPlantPremium
							   END

	IF @HiredInPlantPremium > 0
	BEGIN
		INSERT INTO @Summary([SummaryMessage])	VALUES(	'Section 3 (Hired In Plant)			= ' 
		+ [dbo].[svfFormatMoneyString](@HiredPlant12MonthHireCharges) 
		+ ' x ' + CAST(@HiredPlantRate AS nvarchar(10)) 
		+ ' x ' + CAST(@PrimaryTradeLoad AS nvarchar(10))
		+ ' x ' + CAST(@SecondaryTradeLoad AS nvarchar(10))
		+ ' x ' + CAST(@HiredInPlantLoading AS nvarchar(10))
		+ ' x ' + CAST(@LoadPostcodeWeight AS nvarchar(10))
		+ '	= ' +  [dbo].[svfFormatMoneyString](@HiredInPlantPremium) 
		+ CASE @HiredInPlantPremium WHEN @PremiumMinimumHiredInPlant THEN '(Min)' ELSE '' END)
			
		INSERT INTO @Breakdown([BreakdownMessage])	VALUES(	'Section 3 (Hired In Plant):::'+ CAST(@HiredInPlantPremium AS nvarchar(10)))			
		INSERT INTO @ProductDetails([ProductDetailsMessage])	VALUES(	'Section 3 (Hired In Plant) ='+ [dbo].[svfFormatMoneyString](@HiredPlant12MonthHireCharges))					
		INSERT INTO @Excess ([ExcessMessage]) SELECT [Excess] FROM [dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnExcess] WHERE [Section] = 'HP' AND [Obsolete] = 0
	END						
			
	IF @HiredPlant12MonthHireCharges > @HiredPlantMaximumCover 
		INSERT INTO @Refer([ReferMessage])	VALUES('Value for Hired in Plant Annual Hire Charges exceeds maximum sum insured of ' + [dbo].[svfFormatMoneyString](@HiredPlantMaximumCover))
			
	IF @HiredPlantTotalValue > @HiredInPlantLoadingMax 
		INSERT INTO @Refer([ReferMessage])	VALUES('Total value of hired in plant cannot exceed  ' + [dbo].[svfFormatMoneyString](@HiredInPlantLoadingMax))	
			
	IF @HiredPlantSingleItemMaxValue > @HiredPlantTotalValue
		INSERT INTO @Refer([ReferMessage])	VALUES('Single item limit of hired in plant cannot exceed total value of hired in plant')

	--- Ticket 4106384029 /*8154652828*/
	SET @Endorsements = @Endorsements + ',TMKCAR05'
													
END	
	
IF @EmployeesToolCoverYN = 1
	INSERT INTO @Refer([ReferMessage])	VALUES('Employees Tools Cover is not available')
IF @ContractWork = 1
	INSERT INTO @Refer([ReferMessage])	VALUES('Contract Works Cover is not available')
IF @OwnPlantAndTools = 0 AND @HiredPlant = 0
	INSERT INTO @Refer([ReferMessage])	VALUES('No acceptable Cover chosen')

INSERT INTO @Summary([SummaryMessage])	VALUES(	'Loss Ratio = ' + CAST(@LossRatio AS varchar(10)))
INSERT INTO @Summary([SummaryMessage])	VALUES(	'Total Losses = ' + CAST(@TotalLosses AS varchar(10)))
		
DECLARE  @Agree nchar(16) = '3MQT5MC6'
		,@TradeIDNone nchar(16) = '3N10P642'
	
IF @AssumpDemolition != @Agree 
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Disagree to "You do not carry out any demolition work other than as part of a building contract"')
IF @AssumpAircraft != @Agree 
	INSERT INTO @Refer([ReferMessage])	VALUES( ' Disagree to "You do not work on aircraft, hovercraft, aerospace systems, watercraft, railways, underground or underwater"')
IF @AssumpNuclear != @Agree 
	INSERT INTO @Refer([ReferMessage])	VALUES( ' Disagree to "You do not work on power stations, nuclear installation or establishments, refineries, bulk storage or premises in oil, gas or chemical industries or offshore structures"')
IF @AssumpTidalWaters != @Agree 
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Disagree to "You do not carry out work over or adjacent to tidal waters"')
IF @AssumpAsbestos != @Agree 
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Disagree to "You do not work with silica, asbestos or substances containing asbestos nor do you work with acids, gases, explosives, radioactive or similar dangerous liquids or chemicals"')
IF @AssumpDeclined != @Agree 
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Disagree to "No proprietor, proposer, director or partner of the business or practice ever had a proposal refused or declined, had an insurance cancelled, or had special terms imposed on an insurance')
IF @AssumpBankrupt != @Agree 
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Disagree to "No proposer, director or partner of the business or practice has ever been declared Bankrupt/insolvent, or the subject of bankruptcy proceedings, or been the subject of a County Court Judgement (or the Scottish equivalent)"')
IF @AssumpCriminal != @Agree 
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Disagree to "You nor any partner or director ever been convicted for any criminal offence involving dishonesty, arson, theft or wilful damage or for a breach of any statute relating to health and safety at work or has any prosecution pending or outstanding"')
IF @InsurerID in ('459')
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Present Insurer is Tokio Marine Kiln')
IF @PrimaryTradeID = @TradeIDNone
	INSERT INTO @Refer([ReferMessage])	VALUES( 'No Primary Trade has been selected')		
IF @ContractMaxLengthMonths > @ContractWorkPeriodMonthsMaximum
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Maximum contract length is 12 Months')

DECLARE @WorkDepth int

SELECT 
	@WorkDepth = CAST(REPLACE([D].[MH_MAXDEPTH_DEBUG],'+','') AS int)
FROM
	[dbo].[List_MH_MaxDepth] AS [D]
WHERE
	[D].[MH_MAXDEPTH_ID] = @DepthMax

IF 	@WorkDepth > @PrimaryMaxDepth
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Maximum Depth for ' + @PrimaryTradeName + ' is ' + CAST(@PrimaryMaxDepth AS VARCHAR(3)) + 'Metres' )

IF 	@WorkDepth > @SecondaryMaxDepth
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Maximum Depth for ' + @SecondaryTradeName + ' is ' + CAST(@SecondaryMaxDepth AS VARCHAR(3)) + 'Metres' )

DECLARE @WorkHeight int

SELECT
	@WorkHeight = CAST(REPLACE(CASE WHEN [H].[MH_MAXHEIGHT_DEBUG] LIKE 'Over%' THEN '1000' ELSE [H].[MH_MAXHEIGHT_DEBUG] END ,'+','') AS int)
FROM 
	[dbo].[LIST_MH_MAXHEIGHT] AS [H]
WHERE 
	[H].[MH_MAXHEIGHT_ID] = @HeightMax
			
IF 	@WorkHeight > @PrimaryMaxHeight
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Maximum Height for ' + @PrimaryTradeName + ' is ' + CAST(@PrimaryMaxHeight AS VARCHAR(3)) + 'Metres' )

IF 	@WorkHeight > @SecondaryMaxHeight
	INSERT INTO @Refer([ReferMessage])	VALUES( 'Maximum Height for ' + @SecondaryTradeName + ' is ' + CAST(@SecondaryMaxHeight AS VARCHAR(3)) + 'Metres' )			

--Declines

-- Decline invalid postcode (8142413832)
IF([dbo].[svfValidateUKPostcode](@PostCode) = 0)
	  INSERT INTO @Decline VALUES ('Invalid Postcode');

IF(@PrimaryTradeID IN ('D20DDE3B','BDF1B3E4','6341AE33','3N0TVFH9','3N0TVIF5','A39AA2C0','CBFC3A2F','G4316HJ3','4B5E4684', '3N0TVIF3', '3N0TVIF4'))
BEGIN
    DECLARE @TradeName varchar(100);
    SELECT  @TradeName = MH_TRADE_DEBUG FROM [dbo].[LIST_MH_TRADE] WHERE MH_TRADE_ID = @PrimaryTradeID;
	INSERT INTO @Decline([DeclineMessage]) VALUES ('Decline Trade: '+ @TradeName);
END
ELSE
BEGIN
IF ( @SecondaryTradeID IN ('D20DDE3B','BDF1B3E4','6341AE33','3N0TVFH9','3N0TVIF5','A39AA2C0','CBFC3A2F','G4316HJ3','4B5E4684', '3N0TVIF3', '3N0TVIF4'))
BEGIN
    DECLARE @SecondaryTrade varchar(100);
    SELECT  @SecondaryTrade = MH_TRADE_DEBUG FROM [dbo].[LIST_MH_TRADE] WHERE MH_TRADE_ID = @SecondaryTradeID;
	INSERT INTO @Decline([DeclineMessage]) VALUES ('Decline Secondary Trade: '+ @SecondaryTrade);
END
END
	
DECLARE @ReferCount int = (SELECT COUNT(*) FROM @Refer)
DECLARE @DeclineCount int = (SELECT COUNT(*) FROM @Decline)
SET @TotalPremium =  ISNULL(@OwnPlantAndToolsPremium,0) + ISNULL(@HiredInPlantPremium,0)
	
INSERT INTO @Excess ([ExcessMessage]) SELECT [Excess] FROM [dbo].[SchemeContractorsPlantAndEquipmentTokioMarineKilnExcess] WHERE [Section] = 'GN' AND [TradeID] IN (@PrimaryTradeID ,@SecondaryTradeID)	AND [Obsolete] = 0	
	
--Return Values
IF @SuppressResults = 'False'
BEGIN
	;WITH [Refer] AS
	(
		SELECT [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30]
		FROM
		@Refer
		PIVOT
		(
		max([ReferMessage])
		FOR [ReferID] in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30])
		) AS PivotTable
	)
	,[Decline] AS
	(
		SELECT [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30]
		FROM
		@Decline
		PIVOT
		(
		max([DeclineMessage])
		FOR [DeclineID] in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30])
		) AS PivotTable
	)
	,[Breakdown] AS
	(
		SELECT [1],[2],[3],[4]
		FROM
		@Breakdown
		PIVOT
		(
		max([BreakdownMessage])
		FOR [BreakdownID] in ([1],[2],[3],[4])
		) AS PivotTable
	)	
	,[ProductDetails] AS
	(
		SELECT [1],[2],[3],[4],[5]
		FROM
		@ProductDetails
		PIVOT
		(
		max([ProductDetailsMessage])
		FOR [ProductDetailsID] in ([1],[2],[3],[4],[5])
		) AS PivotTable
	)
	,[Excess] AS
	(
		SELECT [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
		FROM
		@Excess
		PIVOT
		(
		max([ExcessMessage])
		FOR [ExcessID] in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
		) AS PivotTable
	)
	,[Summary] AS
	(
		SELECT [1],[2],[3],[4],[5],[6],[7]
		FROM
		@Summary
		PIVOT
		(
		max([SummaryMessage])
		FOR [SummaryID] in ([1],[2],[3],[4],[5],[6],[7])
		) AS PivotTable
	)	

	SELECT 
		* 
		,@Endorsements
		,ISNULL(@OwnPlantAndToolsPremium,0) AS [OwnPlantAndToolsPremium]
		,ISNULL(@HiredInPlantPremium,0) AS [HiredInPlantPremium]
		,CASE WHEN @ReferCount > 0 THEN 'True' ELSE 'False' END AS [Referral]
		,CASE WHEN @DeclineCount > 0 THEN 'True' ELSE 'False' END AS [Decline]
	FROM 
		[Refer]
		FULL OUTER JOIN [Decline] on 1 = 1
		FULL OUTER JOIN [Breakdown] ON 1 = 1
		FULL OUTER JOIN [ProductDetails] ON 1 = 1
		FULL OUTER JOIN [Excess] ON 1 = 1
		FULL OUTER JOIN [Summary] ON 1 =1		
END

