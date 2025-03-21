USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLETPROP_Toledo_PropertyOwners_tvfCalculator]    Script Date: 10/03/2025 13:08:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		Jeremai Smith
-- Date:        28 Feb 2024
-- Description: Toledo Property Owners calculator based on copy of Companion Residential Unoccupied calculator
*******************************************************************************

-- Date			Who						Change
-- 04/04/2024	Jeremai Smith			Added voluntary excess logic so it displays on excess screen (Monday.com ticket 6338363234)
-- 04/04/2024	Jeremai Smith			Change No Claims Discount to calculate at Property level instead of top level (Monday.com ticket 6381224656)
-- 05/04/2024	Jeremai Smith			Replace Loss of Rent excess with endorsement TISPO27 (Monday.com ticket 6381214883)
-- 08/04/2024	Jeremai Smith			Enforce TGSL validation rules within the calculator as CAQ was returning a minimum premium when displaying
--										previous quotes, which actually forces a re-quote (Monday.com ticket 6391218680)
-- 12/04/2024	Jeremai Smith			Replace Cooking referral with endorsement TISFCEC (Monday.com ticket 6381576218)
-- 16/04/2024	Jeremai Smith			Remove top level No Claims Discount as it wasn't removed after changing to calculate at Property Level
--										(Monday.com ticket 6463908427, correction to 6381224656 above)
-- 17/04/2024	Jeremai Smith			Fix for no rate returned when property used for cooking trades, and added referral when a Property has no
--										rate instead of quoting £0 (Monday.com ticket 6464189919)
-- 07/10/2024   Linga		            Added Decline, if anything owner is occupied (Monday.com Ticket 7566329747)
-- 18/10/2024	Simon Mackness-Pettit	Changed decline of owners to refer (Monday.com ticket 7647344184)
-- 12/11/2024	Linga					Changes to PO Scheme (Monday.com Ticket 7567663564)
-- 12/02/2025	Linga					8462927749 - Toledo property - add TISPO28 for tenancy type of HMO
-- 10/03/2025	Simon					8637491742 - Rate and rule changes for Toledo PO schemes
*******************************************************************************/

ALTER FUNCTION [dbo].[MLETPROP_Toledo_PropertyOwners_tvfCalculator]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
	,@ClaimsSummary [dbo].[ClaimTableType] READONLY
	,@PropInfo [dbo].[MLETPROP_PropInfoTableType] READONLY
	,@PrpDtail [dbo].[MLETPROP_PrpDtailTableType] READONLY
	,@AddCover [dbo].[MLETPROP_AddCoverTableType] READONLY
	,@Business [dbo].[MLETPROP_BusinessTableType] READONLY
	,@Subsid [dbo].[MLETPROP_SubsidTableType] READONLY
	,@OCCDtail [dbo].[MLETPROP_OCCDtailTableType] READONLY
	,@Assump   [dbo].[MLETPROP_AssumpTableType] READONLY
)

/*

*/

RETURNS @SchemeResults TABLE 
(
	SchemeResultsXML xml
)
AS

BEGIN

	-- Table types:
	DECLARE  @Refer SchemeResultTableType
			,@Decline SchemeResultTableType
			,@Excess SchemeResultTableType
			,@Summary SchemeResultTableType
			,@Breakdown SchemeResultTableType
			,@ProductDetail SchemeResultTableType	
			,@Premiums SchemeResultPremiumTableType
			,@Endorsement SchemeResultEndorsementTableType
	;

	-- Rate, premium and limit variables:
	DECLARE @TotalBuildingsPremium money = 0;
	DECLARE @TotalContentsPremium money = 0;
	DECLARE @TotalPremium money = 0;
	DECLARE @BuildingMinimumPremium money = 0;
	DECLARE @ContentMinimumPremium money = 0;
	DECLARE @BuildingCoverRate decimal(10,4);
	DECLARE @ContentCoverRate decimal(10,4);
    DECLARE @LoadDiscountValue money = 0;
    DECLARE @LoadAmount money = 0;
	DECLARE @BuildingsLoadAmount money = 0;
	DECLARE @ContentsLoadAmount money = 0;
	DECLARE @BuildingSIOccupiedMin money = 0;
	DECLARE @BuildingSIOccupiedMax money = 0;
	DECLARE @BuildingSIUnoccupiedMin money = 0;
	DECLARE @BuildingSIUnoccupiedMax money = 0;
	DECLARE @ContentSIMin money = 0;
	DECLARE @ContentSIMax money = 0;
	DECLARE @ContentPercentSIMax decimal(10,2);
	DECLARE @ReferRateFlag bit;
	DECLARE @DeclineRateFlag bit;
	DECLARE @OccupancyBuildingsPremium money;
	DECLARE @PropertyBuildingsPremium money;
	DECLARE @PropertyContentsPremium money;
	DECLARE @BuildingsADLoad decimal(10,4);
	DECLARE @ContentsADLoad decimal(10,4);
	DECLARE @BuildingsADPremium money;
	DECLARE @ContentsADPremium money;
	DECLARE @BuildingRateType varchar(25); -- Will hold 'Residential', 'Offices', 'Retail' or 'Warehouse/Industrial' from [MLETPROP_Toledo_PropertyOwners_BuildingRateType]
	DECLARE @BuildingResiOrCommercial varchar(11); -- Will hold 'Residential' or 'Commercial' based on @BuildingRateType above
	DECLARE @OccupancyCoverType varchar(10); -- Will hold 'FLEEA Only', 'Unoccupied' or 'Occupied'
	
	-- Property Information variables:
	DECLARE @DateEstablished datetime;

	-- Property Details variables:
	DECLARE @PropertyPostCode varchar(12);
	DECLARE @PostCodeLookup varchar(8);
	DECLARE @PostCodePCArea varchar(2);
	DECLARE @PostCodeFloodBand tinyint;
	DECLARE @PostCodeTheftBand tinyint;
	DECLARE @PostCodeSubsBand tinyint;
	DECLARE @BuildingArea int;
	DECLARE @ContentsRating int;
    DECLARE @BuildingTypeID varchar(10);
	DECLARE @PropAcquiredDate datetime = NULL;
	DECLARE @Stories varchar(100);
	DECLARE @HolidayLet bit;
	DECLARE @SecondHome bit;
	DECLARE @OwnEntire bit;
	DECLARE @FlatsNum int;
	DECLARE @ConstructionYr int;
	DECLARE @WallConstructionID varchar(8);
	DECLARE @WallConstruction varchar(250);
	DECLARE @WallConstructionRefer bit;
	DECLARE @WallConstructionDecline bit;
    DECLARE @RoofConstructionID varchar(8);
	DECLARE @RoofConstruction varchar(250);
	DECLARE @RoofConstructionRefer bit;
	DECLARE @RoofConstructionDecline bit;
    DECLARE @ListedID varchar (8);
	DECLARE @BuildingWork bit;
	DECLARE @Sprinkler bit;
	DECLARE @FireSuppression bit;
	DECLARE @FireStation bit;
	DECLARE @FireAlarm bit;
    DECLARE @BusinessPurposes bit;
	DECLARE @BusActivitiesID varchar(8);
	DECLARE @BusActivities varchar(255);
	DECLARE @Cooking bit;
	DECLARE @Occupied bit;
	DECLARE @PropertyContainsUnoccupiedOccDtail bit;
	DECLARE @RiskContainsUnoccupiedOccDtail bit = 0;
	DECLARE @PropBoardedUp bit;
	DECLARE @Rentlosscover bit;
	DECLARE @RentIncome money;
	DECLARE @FireCover bit;
	DECLARE @BuildingSumInsured money = 0;
	DECLARE @RiskTotalBuildingSumInsured money = 0;
	DECLARE @Accidental bit;
	DECLARE @LandLordsCont bit;
	DECLARE @ContentSumInsured money = 0;
	DECLARE @ContentsNumIncrements int = 0;
	
	-- Occupancy Details variables:	
	DECLARE @OccupancyTypeID varchar(8);
	DECLARE @OccupancyType varchar(250);
	DECLARE @ValueOccupied money;
	DECLARE @ValueUnoccupied money;
	DECLARE @OccupancyValue money;
	DECLARE @PropertySumOfOccupancyValues money;
	
	-- Claims variables:
	DECLARE @NoClaimsPeriod int;
	DECLARE @EscapeWaterOilClaim int = 0;
	DECLARE @StormDamageClaim int = 0;

	-- Additional Cover variables
	DECLARE @ExcessYN bit;
	DECLARE @VolExcessAmount varchar(5);


	-- ==========
	-- Get limits (so table reads aren't repeated in every loop iteration)
	-- ==========

	-- Sum insured limits:

	SELECT @BuildingSIOccupiedMin = [Minimum]
		  ,@BuildingSIOccupiedMax = [Maximum]
	FROM [MLETPROP_Limit] WHERE	[Insurer] = 'Toledo Insurance Solutions' AND [LineOfBusiness] = 'Property Owners' AND [LimitType] = 'Buildings Sum Insured occupied'
	AND [EndDateTime] IS NULL;

	SELECT @BuildingSIUnoccupiedMin = [Minimum]
		  ,@BuildingSIUnoccupiedMax = [Maximum]
	FROM [MLETPROP_Limit] WHERE	[Insurer] = 'Toledo Insurance Solutions' AND [LineOfBusiness] = 'Property Owners' AND [LimitType] = 'Buildings Sum Insured unoccupied or mixed'
	AND [EndDateTime] IS NULL;

	SELECT @ContentSIMin = [Minimum]
		 , @ContentSIMax = [Maximum]
	FROM [MLETPROP_Limit] WHERE [Insurer] ='Toledo Insurance Solutions'  AND [LineOfBusiness] = 'Property Owners' AND [LimitType] = 'Contents Sum Insured per property'
	AND [EndDateTime] IS NULL;

	SELECT @ContentPercentSIMax = [Maximum]
	FROM [MLETPROP_Limit] WHERE [Insurer] ='Toledo Insurance Solutions'  AND [LineOfBusiness] = 'Property Owners' AND [LimitType] = 'Landlords contents percentage of total buildings sum insured'
	AND [EndDateTime] IS NULL;


	-- ====================================
	-- Select details from top level tables
	-- ====================================

	-- Property Information:

	SELECT
		@DateEstablished		= [Established]
	FROM
		@PropInfo
	;


	-- Claims:

	IF EXISTS (SELECT 1 FROM @ClaimsSummary WHERE [Type] IN ('Escape of Water', 'Escape of Oil'))
	SET @EscapeWaterOilClaim = 1;

	IF EXISTS (SELECT 1 FROM @ClaimsSummary WHERE [Type] = 'Storm Damage (excluding flood)')
	SET @StormDamageClaim = 1;
	

	-- Additional Cover:

	SELECT
		 @ExcessYN		 = [AC].[ExcessYN]
		,@VolExcessAmount = REPLACE([XS].[MH_LET_VOLXS_DEBUG], '£', '')
	FROM
		@AddCover AS [AC]
		LEFT JOIN [dbo].[LIST_MH_LET_VOLXS] AS [XS] ON [AC].[ExcessAmount_ID] = [XS].[MH_LET_VOLXS_ID]
	;

	DECLARE @PropertyNumber int = (SELECT COUNT([PropertyNum]) FROM @PrpDtail);

	IF @PropertyNumber >= (SELECT MIN([StartRange]) FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] WHERE [EndDateTime] IS NULL AND [LoadDiscountType] = 'Multi Property Discount') 
	BEGIN

		DECLARE @MultiPropDiscount money;

	    SELECT
			@MultiPropDiscount = ISNULL([LoadDiscountValue], 0)
		FROM
			[dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
		WHERE
			EndDateTime IS NULL
		AND
			[LoadDiscountType] = 'Multi Property Discount'
		AND
			@PropertyNumber BETWEEN [StartRange] AND [EndRange];

		INSERT INTO @Breakdown VALUES('Multi Property Discount Qualify ' + CAST(@MultiPropDiscount AS VARCHAR(7)) + '%');
		INSERT INTO @Breakdown VALUES(':::');--BLANK LINE	
	END

	-- =========================================
	-- Loop through each Property Details record
	-- =========================================

	DECLARE @PropertyCounter int = 0;
	DECLARE @OccupancyCounter int = 0;

	WHILE EXISTS (SELECT 1 FROM @PrpDtail WHERE [PropertyNum] > @PropertyCounter)
	BEGIN

		SET @PropertyCounter = @PropertyCounter + 1;

		-- Reset variables to prevent using previous value when no record found:
		SET @PropertyBuildingsPremium = 0;
		SET @PropertyContentsPremium = 0;
		SET @BuildingsADPremium = 0;
		SET @ContentsADPremium = 0;
		SET @PropertyContainsUnoccupiedOccDtail = 0;
		SET @PropertySumOfOccupancyValues = 0;


		SELECT TOP 1
			 @PostCodeLookup				= [PC].[PostCode]
			,@PostCodePCArea				= [PC].[PCArea]
			,@PostCodeFloodBand				= [PC].[FloodBand]
			,@PostCodeTheftBand				= [PC].[TheftBand]
			,@PostCodeSubsBand				= [PC].[SubsBand]
			,@BuildingArea					= CAST([PC].[BuildingsRating] AS INT)
			,@ContentsRating				= CAST([PC].[ContentsRating] AS INT)
			,@PropertyPostCode				= [PD].[Postcode]
			,@BuildingTypeID				= [PD].[BuildingType_ID]
			,@BuildingRateType				= [BRT].[RateType] -- 'Residential', 'Offices', 'Retail' or 'Warehouse/Industrial'
			,@BuildingResiOrCommercial		= CASE WHEN [BRT].[RateType] = 'Residential' THEN 'Residential' ELSE 'Commercial' END
			,@PropAcquiredDate				= [PD].[FiveyrsPlus]
			,@Stories						= [PD].[Stories]
			,@HolidayLet					= [PD].[HolidayLet]
			,@SecondHome					= [PD].[SecondHome]
			,@OwnEntire						= [PD].[OwnEntire]
			,@FlatsNum						= CAST([PD].[FlatsNum] AS INT)
			,@ConstructionYr				= CAST([PD].[ConstructYr] AS INT)
			,@WallConstructionID			= [PD].[WallConstruct_ID]
			,@WallConstruction				= [PD].[WallConstruct]
			,@RoofConstructionID			= [PD].[RoofConstruct_ID]
			,@RoofConstruction				= [PD].[RoofConstruct]
			,@ListedID						= [PD].[Listed_ID]
			,@BuildingWork					= [PD].[BuildingWork]
			,@Sprinkler						= [PD].[Sprinkler]
			,@FireSuppression				= [PD].[FireSuppression]
			,@FireStation					= [PD].[FireStation]
			,@FireAlarm						= [PD].[FireAlarm]
			,@BusinessPurposes				= [PD].[Business]
			,@BusActivitiesID				= [PD].[BusActivities_ID]
			,@BusActivities					= [PD].[BusActivities]
			,@Cooking						= [PD].[Cooking]
			,@Occupied						= [PD].[Occupied]
			,@PropBoardedUp					= [PD].[PropBoardedUp]
			,@Rentlosscover					= [PD].[rentlosscover]
			,@RentIncome					= [PD].[RentIncome]
			,@FireCover						= [PD].[FireCover]
			,@BuildingSumInsured			= [PD].[BuildingsSI] 
			,@RiskTotalBuildingSumInsured	= @RiskTotalBuildingSumInsured + [PD].[BuildingsSI] 
			,@Accidental					= [PD].[Accidental]
			,@BuildingsADLoad				= [BAD].[LoadDiscountValue]
			,@LandLordsCont					= [PD].[LandlordsCont]
			,@ContentSumInsured				= [PD].[LandlordsSI]
			,@ContentsADLoad				= [CAD].[LoadDiscountValue]
		FROM
			@PrpDtail AS [PD]
			LEFT JOIN [dbo].[MLETPROP_Toledo_Postcode] AS [PC] ON [PD].[Postcode] = [PC].[Postcode]
																 AND [PC].[EndDateTime] IS NULL
			LEFT JOIN [dbo].[MLETPROP_Toledo_PropertyOwners_BuildingRateType] AS [BRT] ON [PD].[BuildingType_ID] = [BRT].[BuildingTypeID]
																						AND ([PD].[Cooking] = [BRT].[CookingTrades] OR [BRT].[CookingTrades] IS NULL)
																						AND [BRT].[EndDateTime] IS NULL
			LEFT JOIN [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] AS [BAD] ON [PD].[Accidental] = 1
																				   AND [BAD].[LoadDiscountType] = 'Buildings Accidental Damage'
																				   AND [BAD].[EndDateTime] IS NULL
			LEFT JOIN [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] AS [CAD] ON [PD].[Accidental] = 1
																				   AND [CAD].[LoadDiscountType] = 'Contents Accidental Damage'
																				   AND [CAD].[EndDateTime] IS NULL
		WHERE
			[PD].[PropertyNum] = @PropertyCounter
		ORDER BY
			CASE WHEN [BRT].[CookingTrades] IS NOT NULL THEN 1 ELSE 2 END -- Selecting TOP 1. Prioritize where BuildingRateType table differentiates for cooking trades. Currently this is only for 'Commercial (Pubs, Restaurants, Hotels)'; all other building types will return a single row.
		;

		-- Insert Property header row into the breakdown:
		INSERT INTO @Breakdown
		VALUES([dbo].[svfFormatBreakdownString]('Building Area ' + CAST(@BuildingArea AS VARCHAR(100))
												+ CASE WHEN @LandlordsCont = 1 THEN ' Content Area ' + CAST(@ContentsRating AS VARCHAR(100)) ELSE '' END
												+ ' (Property ' + CAST(@PropertyCounter AS varchar) + ' ' + @PropertyPostCode + ')'
			   ,NULL, NULL, NULL));


		-- Loop through each Occupancy Details record and get rates
		-- --------------------------------------------------------

		SET @OccupancyCounter = 0;

		WHILE EXISTS (SELECT 1 FROM @OccDtail WHERE [PropertyNum] = @PropertyCounter AND [OccupancyNum] > @OccupancyCounter)
		BEGIN
			
			SET @OccupancyCounter = @OccupancyCounter + 1;

			-- Reset variables to prevent using previous value when no record found:
			SET @OccupancyTypeID = NULL;
			SET @OccupancyType = NULL;
			SET @ValueOccupied = 0;
			SET @ValueUnoccupied = 0;
			SET @OccupancyValue = 0;
			SET @BuildingCoverRate = 0;
			SET @OccupancyCoverType = NULL;
			SET @OccupancyBuildingsPremium = 0;


			-- Select Occupancy Details values:

			SELECT @OccupancyTypeID = [OD].[OccupancyType_ID]
				  ,@OccupancyType = [OD].[OccupancyType]
				  ,@ValueOccupied = [OD].[Occupied]
				  ,@ValueUnoccupied = [OD].[Unoccupied]
				  ,@OccupancyValue = ISNULL([OD].[Occupied], 0) + ISNULL([OD].[Unoccupied], 0)
				  ,@PropertyContainsUnoccupiedOccDtail = CASE WHEN [OD].[OccupancyType_ID] = '3MRG8416' THEN 1 ELSE @PropertyContainsUnoccupiedOccDtail END -- Resets for each property. If this record not unoccupied, preserve value from previous occupancy record which may have been unoccupied.
				  ,@RiskContainsUnoccupiedOccDtail = CASE WHEN [OD].[OccupancyType_ID] = '3MRG8416' THEN 1 ELSE @RiskContainsUnoccupiedOccDtail END -- Overall risk / quote level. If this record not unoccupied, preserve value from previous occupancy record which may have been unoccupied. Used for applying max building sum insured to total off all properties.
			FROM
				@OCCDtail AS [OD]
			WHERE
				[OD].[PropertyNum] = @PropertyCounter
				AND [OD].[OccupancyNum] = @OccupancyCounter
			;

			SET @PropertySumOfOccupancyValues = @PropertySumOfOccupancyValues + @OccupancyValue;


			-- Get the buildings rate:

			SELECT @OccupancyCoverType = CASE
											WHEN @FireCover = 1 THEN 'FLEEA Only'
											WHEN @OccupancyTypeID = '3MRG8416' THEN 'Unoccupied'
											ELSE 'Occupied'
										 END;

			SELECT @BuildingCoverRate = [RatePC] / 100
				  ,@ReferRateFlag = [Refer]
				  ,@DeclineRateFlag = [Decline]
			FROM [dbo].[MLETPROP_Toledo_PropertyOwners_BuildingRate]
			WHERE [BuildingArea] = @BuildingArea
			AND [OccupancyCoverType] = @OccupancyCoverType
			AND [RateType] = @BuildingRateType
			AND [EndDateTime] IS NULL;

			
			-- Calculate buildings premium for this occupancy record:

			IF @BuildingCoverRate IS NOT NULL
			SET @OccupancyBuildingsPremium = @OccupancyValue * @BuildingCoverRate;
			
			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + ISNULL(@OccupancyBuildingsPremium, 0);
			
			SET @TotalBuildingsPremium = @TotalBuildingsPremium + ISNULL(@OccupancyBuildingsPremium, 0);

			SET @TotalPremium = @TotalPremium + @OccupancyBuildingsPremium;

			INSERT INTO @Breakdown
			VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar)
													+ ' Occ. ' + CAST(@OccupancyCounter AS varchar) + ' (' + @OccupancyType + ')'
													+ ' Buildings base rate'
				   ,@BuildingCoverRate, @OccupancyBuildingsPremium, @TotalPremium));
			
			
			-- Occupancy loads:
			
			SET @LoadDiscountValue = 0;
			SET @LoadAmount = 0;

			IF @OccupancyTypeID IN ('3MRG8415', '3MRG8414', '3MRG8408') -- Students, Council Support, Asylum Seekers

			BEGIN
			
				SELECT @LoadDiscountValue = ISNULL([LoadDiscountValue], 0) FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
											WHERE [EndDateTime] IS NULL
											AND [LoadDiscountType] = CASE
																		WHEN @OccupancyTypeID = '3MRG8415' THEN 'Students'
																		WHEN @OccupancyTypeID = '3MRG8414' THEN 'DSS (Council Support)'
																		WHEN @OccupancyTypeID = '3MRG8408' THEN 'Asylum seekers'
																	 END;
				
				SET @LoadAmount = @OccupancyBuildingsPremium * (@LoadDiscountValue / 100);

				SET @OccupancyBuildingsPremium = @OccupancyBuildingsPremium + @LoadAmount;
			
				SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @LoadAmount;
			
				SET @TotalBuildingsPremium = @TotalBuildingsPremium + @LoadAmount;

				SET @TotalPremium = @TotalPremium + @LoadAmount;
				
				INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar)
																				+ ' Occ. ' + CAST(@OccupancyCounter AS varchar)
																				+' Occupancy Load for ' + @OccupancyType
											 ,(@LoadDiscountValue/100), @LoadAmount, @TotalPremium))

			END;-- End IF @OccupancyTypeID 


			-- Occupancy level referrals
			-- -------------------------
	
			IF @ReferRateFlag = 1
			INSERT INTO @Refer VALUES ('Refer building area for ' + @BuildingRateType + ' ' + @OccupancyCoverType);

			IF @Occupied = 1 AND @OccupancyTypeID = '3MRG8416' -- Unoccupied
			INSERT INTO @Refer VALUES ('Property ' + CAST(@PropertyCounter AS varchar) + ' fully occupied = Yes, but contains Unoccupied occupancy type'); -- This referral not specified in the requirements, but this needs to be correct so that the correct sum insured limit is used (there are separate limits for occupied and unoccupied or mixed)

			/*	8637491742	*/
			IF (@Accidental = 1 OR @LandLordsCont = 1) AND @OccupancyTypeID = '3MRG8415' --Students
			INSERT INTO @Refer VALUES ('Refer Accidental Damage for occupancy type ' + @OccupancyType);

			IF @FireCover = 1 AND @OccupancyTypeID <> '3MRG8416' -- Unoccupied
			INSERT INTO @Refer VALUES ('Property ' + CAST(@PropertyCounter AS varchar) + ' FLEEAPOL cover only available if property fully unoccupied');

			IF @OccupancyBuildingsPremium <= 0
			INSERT INTO @Refer VALUES ('No rates found for property ' + CAST(@PropertyCounter AS varchar) + ' occupancy type ' + @OccupancyType);

			/* Made a refer as per 7647344184 */
			IF(@OccupancyTypeID = 'OWNER001' AND @ValueOccupied > 0) -- anything owner is occupied
			INSERT INTO @Refer VALUES ('Refer because ''the owner occupies a part of the building''s value.''');

			-- Occupancy level declines
			-- ------------------------

			IF @DeclineRateFlag = 1
		    INSERT INTO @Decline VALUES ('Decline building area for ' + @BuildingRateType + ' ' + @OccupancyCoverType);

			-- Occupancy level excesses
			-- ------------------------

			-- View available excesses for the scheme:
			/*
			SELECT [XS].[Excess], [TOLXS].*
			FROM MLETPROP_Toledo_PropertyOwners_Excess AS [TOLXS]
			INNER JOIN [Excess] [XS] ON [TOLXS].[ExcessID] = [XS].ExcessID
			WHERE [TOLXS].[EndDateTime] IS NULL
			ORDER BY [XS].[Excess]
			*/
			
			-- Theft excess:
			IF @FireCover <> 1
			INSERT INTO @Excess 
			SELECT STUFF(REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level])
						 ,CHARINDEX(':', [XS].[Excess], 1) -- Find the position of first colon
						 ,0 -- Don't delete any characters
						 ,' for ' + @BuildingResiOrCommercial + ' ' + @OccupancyCoverType + ' property'	-- Insert this before the first colon
						)
			FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
			INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
			WHERE [XS].[ExcessID] = 2 AND [TOLXS].[Criteria] = 0 AND [TOLXS].[EndDateTime] IS NULL
			AND ((@OccupancyCoverType = 'Occupied' AND [TOLXS].[Occupied] = 1)
				 OR (@OccupancyCoverType = 'Unoccupied' AND [TOLXS].[Unoccupied] = 1) -- Cover not available for unoccupied but included for future changes
				)
			AND ((@BuildingResiOrCommercial = 'Residential' AND [TOLXS].[Residential] = 1)
				 OR (@BuildingResiOrCommercial = 'Commercial' AND [TOLXS].[Commercial] = 1)
				);

			-- Malicious Damage excess:
			IF @FireCover <> 1
			INSERT INTO @Excess 
			SELECT REPLACE(REPLACE([XS].[Excess], '{Excess}', [TOLXS].[Level]), 'of ', 'of ' + @BuildingResiOrCommercial + ' ')
			FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
			INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
			WHERE [XS].[ExcessID] = CASE @OccupancyCoverType WHEN 'Occupied' THEN 3 WHEN 'Unoccupied' THEN 4 END
			AND [TOLXS].[Criteria] = 0 AND [TOLXS].[EndDateTime] IS NULL
			AND ((@BuildingResiOrCommercial = 'Residential' AND [TOLXS].[Residential] = 1)
				OR (@BuildingResiOrCommercial = 'Commercial' AND [TOLXS].[Commercial] = 1)
				);

			-- Malicious Damage by tenants excess:
			IF @FireCover <> 1
			INSERT INTO @Excess 
			SELECT STUFF(REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level])
						 ,CHARINDEX(':', [XS].[Excess], 1) -- Find the position of first colon
						 ,0 -- Don't delete any characters
						 ,' for ' + @BuildingResiOrCommercial + ' ' + @OccupancyCoverType + ' property'	-- Insert this before the first colon
						)
			FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
			INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
			WHERE [XS].[ExcessID] = 5 AND [TOLXS].[Criteria] = 0 AND [TOLXS].[EndDateTime] IS NULL
			AND ((@OccupancyCoverType = 'Occupied' AND [TOLXS].[Occupied] = 1)
				 OR (@OccupancyCoverType = 'Unoccupied' AND [TOLXS].[Unoccupied] = 1) -- Cover not available for unoccupied but included for future changes
				)
			AND ((@BuildingResiOrCommercial = 'Residential' AND [TOLXS].[Residential] = 1)
				OR (@BuildingResiOrCommercial = 'Commercial' AND [TOLXS].[Commercial] = 1)
				);

			-- Escape of Water excess where no previous claim:
			IF @FireCover <> 1 AND @EscapeWaterOilClaim <> 1
			INSERT INTO @Excess 
			SELECT STUFF(REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level])
						 ,CHARINDEX(':', [XS].[Excess], 1) -- Find the position of first colon
						 ,0 -- Don't delete any characters
						 ,' for ' + @BuildingResiOrCommercial + ' ' + @OccupancyCoverType + ' property'	-- Insert this before the first colon
						)
			FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
			INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
			WHERE [XS].[ExcessID] = 6 AND [TOLXS].[Criteria] = 0 AND [TOLXS].[EndDateTime] IS NULL
			AND ((@OccupancyCoverType = 'Occupied' AND [TOLXS].[Occupied] = 1)
				 OR (@OccupancyCoverType = 'Unoccupied' AND [TOLXS].[Unoccupied] = 1) -- Cover not available for unoccupied but included for future changes
				)
			AND ((@BuildingResiOrCommercial = 'Residential' AND [TOLXS].[Residential] = 1)
				OR (@BuildingResiOrCommercial = 'Commercial' AND [TOLXS].[Commercial] = 1)
				);

			-- Standard excess plus voluntary excess:
			-- (Note, voluntary excess is being added here because when it was originally a standalone record it would be duplicated after going back and changing
			--  the voluntary excess amount and re-quoting. Seems like a bug in TGSL. (See Monday.com ticket 6338363234.)
			INSERT INTO @Excess 
			SELECT STUFF(REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level] +  ISNULL(CAST(@VolExcessAmount as int), 0))
						 ,CHARINDEX(':', [XS].[Excess], 1) -- Find the position of first colon
						 ,0 -- Don't delete any characters
						 ,' for ' + @BuildingResiOrCommercial + ' ' + @OccupancyCoverType + ' property'	
							+ CASE WHEN @VolExcessAmount > 0 THEN ' including £' + @VolExcessAmount + ' voluntary excess' ELSE '' END -- Insert this before the first colon
						)
			FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
			INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
			WHERE [XS].[ExcessID] = 35 AND [TOLXS].[Criteria] = 0 AND [TOLXS].[EndDateTime] IS NULL
			AND ((@OccupancyCoverType = 'Occupied' AND [TOLXS].[Occupied] = 1)
				 OR (@OccupancyCoverType = 'Unoccupied' AND [TOLXS].[Unoccupied] = 1)
				)
			AND ((@BuildingResiOrCommercial = 'Residential' AND [TOLXS].[Residential] = 1)
				OR (@BuildingResiOrCommercial = 'Commercial' AND [TOLXS].[Commercial] = 1)
				);
		
		END -- End looping through each Occupancy Details record
		--------------------------------------------------------
		/*7567663564*/
		-- Building Type Load for this property:
		SET @LoadDiscountValue = 0;
		SET @LoadAmount = 0;
		
		IF @BuildingTypeID IN ('HMO') 
		BEGIN
			
			SELECT @LoadDiscountValue = ISNULL([LoadDiscountValue], 0) 
			                            FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] 
										WHERE LoadDiscountType = 'HMO' AND EndDateTime IS NULL;
			
			SET @LoadAmount = @TotalBuildingsPremium * (@LoadDiscountValue / 100);
			
			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @LoadAmount;

			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @LoadAmount;

			SET @TotalPremium = @TotalPremium + @LoadAmount;

			INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar) + ' Building Type '''+@BuildingTypeID+''' load'
				,(@LoadDiscountValue/100), @LoadAmount, @TotalPremium)) 
		
		END -- Building Type Load

		-- Buildings accidental damage load for this property record:
		IF @Accidental = 1
		BEGIN

			SET @BuildingsADPremium = @PropertyBuildingsPremium * (@BuildingsADLoad / 100.00);

			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @BuildingsADPremium;

			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsADPremium;

			SET @TotalPremium = @TotalPremium + @BuildingsADPremium;

			INSERT INTO @Breakdown
			VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar) + ' Buildings Accidental Damage rate'
				,@BuildingsADLoad / 100, @BuildingsADPremium, @TotalPremium));

		END;

		
		-- Listed Building Load:
		SET @LoadDiscountValue = 0;
		SET @LoadAmount = 0;
		
		IF @ListedID IN ('3MRG7OA3', '5', '11', '12') -- Grade 2, Grade 2* Listed Building, Grade B Listed Building, Grade C(S) Listed Building 
		BEGIN
			
			SELECT @LoadDiscountValue = ISNULL([LoadDiscountValue], 0) FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
										WHERE [EndDateTime] IS NULL
										AND [LoadDiscountType] = CASE
																	WHEN @ListedID IN ('5', '11') THEN 'Grade 2* / B listed buildings'
																	WHEN @ListedID IN ('3MRG7OA3', '12') THEN 'Grade 2 / C listed buildings'
																 END;
			
			SET @LoadAmount = @TotalBuildingsPremium * (@LoadDiscountValue / 100);
			
			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @LoadAmount;

			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @LoadAmount;

			SET @TotalPremium = @TotalPremium + @LoadAmount;

			INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar) + ' listed building load'
				,(@LoadDiscountValue/100), @LoadAmount, @TotalPremium)) 
		
		END -- End if listed building


		-- Contents premium for this property record:
		IF @LandLordsCont = 1
		BEGIN

			SET @ContentsNumIncrements = CEILING(@ContentSumInsured / 100.00); -- Set the number of contents cover increments (rate is per £100 of sum insured). Ceiling rounds up to the next whole number so multiples of £100 are included in the correct band, e.g. £0 - £100 are one increment, £100.01 - £100 are two increments, etc. The increment is cast as decimal so decimal places are preserved in the calculation.
		
			SELECT @ContentCoverRate = [RateValue]
			FROM [dbo].[MLETPROP_Toledo_PropertyOwners_ContentsRate] WHERE [ContentsArea] = @ContentsRating AND EndDateTime IS NULL;
				
			SET @PropertyContentsPremium = @ContentsNumIncrements * @ContentCoverRate
				 
			SET @TotalContentsPremium = @TotalContentsPremium + ISNULL(@PropertyContentsPremium, 0);

			SET @TotalPremium = @TotalPremium + @PropertyContentsPremium;

			IF @PropertyContentsPremium < 25
			BEGIN
				SET @PropertyContentsPremium = 25
			END

			-- Insert breakdown:
			INSERT INTO @Breakdown
			VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar)
													+ ' Contents base rate'
				   ,@ContentCoverRate/100, @PropertyContentsPremium, @TotalPremium));
		
		END -- End IF @LandLordsCont = 1


		-- Contents accidental damage load for this property record:
		IF @LandLordsCont = 1 AND @Accidental = 1
		BEGIN

			SET @ContentsADPremium = @PropertyContentsPremium * (@ContentsADLoad / 100.00);

			SET @PropertyContentsPremium = @PropertyContentsPremium + @ContentsADPremium;

			SET @TotalContentsPremium = @TotalContentsPremium + @ContentsADPremium;

			SET @TotalPremium = @TotalPremium + @ContentsADPremium;

			INSERT INTO @Breakdown
			VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar) + ' Contents Accidental Damage rate'
				,@ContentsADLoad / 100, @ContentsADPremium, @TotalPremium));

		END; -- END IF @LandLordsCont = 1 AND @Accidental = 1
	
		-- Multiple occupancy load for this property record:
		/* 7567663564
		SET @LoadDiscountValue = 0;
		SET @LoadAmount = 0;
    
		IF @OccupancyCounter > 1
		BEGIN

			SELECT @LoadDiscountValue = [LoadDiscountValue]
			FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] WHERE LoadDiscountType = 'HMO' AND EndDateTime IS NULL;
			
			SET @BuildingsLoadAmount = @PropertyBuildingsPremium * (@LoadDiscountValue / 100);
			SET @ContentsLoadAmount = @PropertyContentsPremium * (@LoadDiscountValue / 100);
			SET @LoadAmount = @BuildingsLoadAmount + @ContentsLoadAmount;
		
			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @BuildingsLoadAmount;
			SET @PropertyContentsPremium = @PropertyContentsPremium + @ContentsLoadAmount;

			SET @TotalPremium = @TotalPremium + @LoadAmount
			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
			SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

			-- Insert breakdown:
			INSERT INTO @Breakdown
			VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar) + ' multiple occupancy load'
				   ,@LoadDiscountValue/100, @LoadAmount, @TotalPremium));
		
		END -- End IF @OccupancyCounter > 1
		*/
		-- Fire station discount for this property:
		
		SET @LoadDiscountValue = 0;
		SET @LoadAmount = 0;
    
		IF @FireStation = 1
		BEGIN

			SELECT @LoadDiscountValue = [LoadDiscountValue]
			FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] WHERE LoadDiscountType = 'Fire station under five miles' AND EndDateTime IS NULL;
			
			SET @BuildingsLoadAmount = @PropertyBuildingsPremium * (@LoadDiscountValue / 100);
			SET @ContentsLoadAmount = @PropertyContentsPremium * (@LoadDiscountValue / 100);
			SET @LoadAmount = @BuildingsLoadAmount + @ContentsLoadAmount;
		
			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @BuildingsLoadAmount;
			SET @PropertyContentsPremium = @PropertyContentsPremium + @ContentsLoadAmount;

			SET @TotalPremium = @TotalPremium + @LoadAmount
			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
			SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

			-- Insert breakdown:
			INSERT INTO @Breakdown
			VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar)
													+ ' discount for fire station under five miles'
				   ,@LoadDiscountValue/100, @LoadAmount, @TotalPremium));
		
		END -- End IF @FireStation = 1


		-- Fire alarm discount for this property:
		
		SET @LoadDiscountValue = 0;
		SET @LoadAmount = 0;
    
		IF @FireAlarm = 1
		BEGIN

			SELECT @LoadDiscountValue = [LoadDiscountValue]
			FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] WHERE LoadDiscountType = 'Fire alarm with monitored signalling' AND EndDateTime IS NULL;
			
			SET @BuildingsLoadAmount = @PropertyBuildingsPremium * (@LoadDiscountValue / 100);
			SET @ContentsLoadAmount = @PropertyContentsPremium * (@LoadDiscountValue / 100);
			SET @LoadAmount = @BuildingsLoadAmount + @ContentsLoadAmount;
		
			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @BuildingsLoadAmount;
			SET @PropertyContentsPremium = @PropertyContentsPremium + @ContentsLoadAmount;

			SET @TotalPremium = @TotalPremium + @LoadAmount
			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
			SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

			-- Insert breakdown:
			INSERT INTO @Breakdown
			VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar)
													+ ' discount for fire alarm with monitored signalling'
				   ,@LoadDiscountValue/100, @LoadAmount, @TotalPremium));
		
		END -- End IF @FireAlarm = 1


		-- Sprinkler discount for this property:
		
		SET @LoadDiscountValue = 0;
		SET @LoadAmount = 0;
    
		IF @Sprinkler = 1
		BEGIN

			SELECT @LoadDiscountValue = [LoadDiscountValue]
			FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] WHERE LoadDiscountType = 'Fully operational sprinklers' AND EndDateTime IS NULL;
			
			SET @BuildingsLoadAmount = @PropertyBuildingsPremium * (@LoadDiscountValue / 100);
			SET @ContentsLoadAmount = @PropertyContentsPremium * (@LoadDiscountValue / 100);
			SET @LoadAmount = @BuildingsLoadAmount + @ContentsLoadAmount;
		
			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @BuildingsLoadAmount;
			SET @PropertyContentsPremium = @PropertyContentsPremium + @ContentsLoadAmount;

			SET @TotalPremium = @TotalPremium + @LoadAmount
			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
			SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

			-- Insert breakdown:
			INSERT INTO @Breakdown
			VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar)
													+ ' discount for fully operational sprinklers'
				   ,@LoadDiscountValue/100, @LoadAmount, @TotalPremium));
		
		END -- End IF @Sprinkler = 1


		-- Fire suppression discount for this property:
		
		SET @LoadDiscountValue = 0;
		SET @LoadAmount = 0;
    
		IF @FireSuppression = 1
		BEGIN

			SELECT @LoadDiscountValue = [LoadDiscountValue]
			FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] WHERE LoadDiscountType = 'Fire suppression system' AND EndDateTime IS NULL;
			
			SET @BuildingsLoadAmount = @PropertyBuildingsPremium * (@LoadDiscountValue / 100);
			SET @ContentsLoadAmount = @PropertyContentsPremium * (@LoadDiscountValue / 100);
			SET @LoadAmount = @BuildingsLoadAmount + @ContentsLoadAmount;
		
			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @BuildingsLoadAmount;
			SET @PropertyContentsPremium = @PropertyContentsPremium + @ContentsLoadAmount;

			SET @TotalPremium = @TotalPremium + @LoadAmount
			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
			SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

			-- Insert breakdown:
			INSERT INTO @Breakdown
			VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar)
													+ ' discount for fire suppression system'
				   ,@LoadDiscountValue/100, @LoadAmount, @TotalPremium));
		
		END -- End IF @FireSuppression = 1


		-- No Claims Discount for this property:

		SET @LoadDiscountValue = 0;
		SET @LoadAmount = 0;
		SET @BuildingsLoadAmount = 0;
		SET @ContentsLoadAmount = 0;
	
		IF (SELECT COUNT(*) FROM @ClaimsSummary) > 0
		BEGIN
			SELECT @NoClaimsPeriod = [dbo].[svfAgeInYears](MAX([Date]),@PolicyStartDateTime) FROM @ClaimsSummary WHERE [Date] >= @PropAcquiredDate;
		END
		ELSE BEGIN
			SELECT @NoClaimsPeriod = [dbo].[svfAgeInYears](@PropAcquiredDate, @PolicyStartDateTime);
		END

		IF @NoClaimsPeriod > 0
		BEGIN
		
			SELECT TOP 1 @LoadDiscountValue = ISNULL([LoadDiscountValue], 0) FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
																			 WHERE [EndDateTime] IS NULL AND [LoadDiscountType] = 'No claims discount'
																			 AND ([StartRange] <= @NoClaimsPeriod AND ([EndRange] > @NoClaimsPeriod OR [EndRange] IS NULL));
		
			SET @BuildingsLoadAmount = @PropertyBuildingsPremium * (@LoadDiscountValue / 100);
			SET @ContentsLoadAmount = @PropertyContentsPremium * (@LoadDiscountValue / 100);
			SET @LoadAmount = @BuildingsLoadAmount + @ContentsLoadAmount;
		
			SET @PropertyBuildingsPremium = @PropertyBuildingsPremium + @BuildingsLoadAmount;
			SET @PropertyContentsPremium = @PropertyContentsPremium + @ContentsLoadAmount;

			SET @TotalPremium = @TotalPremium + @LoadAmount
			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
			SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

			INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Property ' + CAST(@PropertyCounter AS varchar) + ' No Claims Discount '
																		   + CAST(@NoClaimsPeriod AS VARCHAR(150)) + ' year' + CASE WHEN @NoClaimsPeriod >1 THEN 's' ELSE '' END
										 ,(@LoadDiscountValue/100), @LoadAmount, @TotalPremium))

		END -- END IF @NoClaimsPeriod > 0


		-- Property subtotal
		-- -----------------
		INSERT INTO @Breakdown
		VALUES([dbo].[svfFormatBreakdownString]('PROPERTY ' + CAST(@PropertyCounter AS varchar) + ' SUBTOTAL'
		,NULL, @PropertyBuildingsPremium + @PropertyContentsPremium, @TotalPremium));


		-- Add a blank line to the breakdown before next Property:
		INSERT INTO @Breakdown VALUES(':::') -- Blank Line


		-- Property level referrals
		-- ------------------------
	
		IF (@PostCodeLookup IS NULL OR @PostCodeLookup = '') AND (@PostCodePCArea IS NULL OR @PostCodePCArea = '')
		INSERT INTO @Refer VALUES ('No rates found for postcode '+ @PropertyPostCode);
		
		IF @OccupancyCounter <1
		INSERT INTO @Refer VALUES ('No occupancies entered for property ' + CAST(@PropertyCounter AS varchar))

		IF @FlatsNum <> @OccupancyCounter
		INSERT INTO @Refer VALUES ('The number of properties in the building should correspond to occupancy records.');

		IF @Occupied = 0 AND @PropertyContainsUnoccupiedOccDtail = 0
		INSERT INTO @Refer VALUES ('Property ' + CAST(@PropertyCounter AS varchar) + ' fully occupied = No, but no Unoccupied occupancy types'); -- This referral not specified in the requirements, but this needs to be correct so that the correct sum insured limit is used below (there are separate limits for occupied and unoccupied or mixed)
		
		IF @PropertySumOfOccupancyValues <> @BuildingSumInsured
		INSERT INTO @Refer VALUES ('Property ' + CAST(@PropertyCounter AS varchar) + ' sum of occupancy values does not equal building sum insured');

		IF @Occupied = 1 AND @BuildingSumInsured > @BuildingSIOccupiedMax
		INSERT INTO @Refer VALUES ('Buildings sum insured is greater than the maximum of £'+ CAST(@BuildingSIOccupiedMax AS VARCHAR));

		IF @Occupied = 0 AND @BuildingSumInsured > @BuildingSIUnoccupiedMax
		INSERT INTO @Refer VALUES ('Buildings sum insured is greater than the maximum of £'+ CAST(@BuildingSIUnoccupiedMax AS VARCHAR));

		IF @LandLordsCont = 1 AND (@ContentSumInsured < @ContentSIMin)
		INSERT INTO @Refer VALUES ('Content sum insured is below the minimum of '+ CAST(@ContentSIMin AS VARCHAR)); 
	
		IF @LandLordsCont = 1 AND (@ContentSumInsured > @ContentSIMax)
		INSERT INTO @Refer VALUES ('Content sum insured is greater than the maximum of '+ CAST(@ContentSIMax AS VARCHAR)); 

		IF @LandLordsCont = 1 AND (CAST(@ContentSumInsured as decimal(18,4)) / CAST(@BuildingSumInsured as decimal(18,4)) * 100 > @ContentPercentSIMax) -- Contents as a percentage of buildings sum insured (casting of decimals required so small decimals not lost)
		INSERT INTO @Refer VALUES ('Content sum insured percentage of building sum insured is greater than the maximum of '+ CAST(@ContentPercentSIMax AS VARCHAR) + '%'); 

		IF @PostCodeSubsBand >= 6
		INSERT INTO @Refer VALUES ('High subsidence risk');

		IF @PostCodeTheftBand >= 12
		INSERT INTO @Refer VALUES ('Refer due to Excessive theft risk');

		IF @PostCodeFloodBand >= 11
		INSERT INTO @Refer VALUES ('Refer due to Excessive flood risk');

		IF @BuildingWork = 1
		INSERT INTO @Refer VALUES ('Refer building work');

		IF @OwnEntire <> 1
		INSERT INTO @Refer VALUES ('Entire building not owned');

		IF @ConstructionYr < 1850
		INSERT INTO @Refer VALUES ('Year of construction prior to 1850');

		IF @HolidayLet = 1
		INSERT INTO @Refer VALUES ('Refer holiday lets');

		IF @RentIncome > @BuildingSumInsured / 10
		INSERT INTO @Refer VALUES ('Annual rent income greater than 10% of total buildings sum insured');

		
		-- Property level declines
		-- -----------------------

		IF @ListedID IN ('3MRG7OA2','7') -- Grade 1, Grade A Listed Building
		INSERT INTO @Decline VALUES ('Decline grade 1 / grade A listed buildings');
		
		IF @Occupied = 1 AND @BuildingSumInsured < @BuildingSIOccupiedMin
		INSERT INTO @Decline VALUES ('Buildings sum insured is below the minimum of £'+ CAST(@BuildingSIOccupiedMin AS VARCHAR));

		IF @Occupied = 0 AND @BuildingSumInsured < @BuildingSIUnoccupiedMin
		INSERT INTO @Decline VALUES ('Buildings sum insured is below the minimum of £'+ CAST(@BuildingSIUnoccupiedMin AS VARCHAR));

		IF @BusinessPurposes = 1 AND @BusActivitiesID <> 'OTHERACT'
		INSERT INTO @Decline VALUES ('Property ' + CAST(@PropertyCounter AS varchar) + ' ' + ISNULL (@BusActivities, 'business activities') + ' unacceptable');

		IF @BuildingTypeID = '3MRG7BB9'
		INSERT INTO @Decline VALUES ('Property ' + CAST(@PropertyCounter AS varchar) + ' decline Bed & Breakfast');

		
		-- Construction type refer / decline
		-- ---------------------------------

		SELECT @WallConstructionRefer = [Refer]
		 	 , @WallConstructionDecline = [Decline]
		FROM [dbo].[MLETPROP_Toledo_Construction]
		WHERE [WALL_CONSTRUCTION_ID] = @WallConstructionID AND [EndDateTime] IS NULL;
		
		SELECT @RoofConstructionRefer = [Refer]
		 	 , @RoofConstructionDecline = [Decline]
		FROM [dbo].[MLETPROP_Toledo_Construction]
		WHERE [ROOF_CONSTRUCTION_ID] = @RoofConstructionID AND [EndDateTime] IS NULL;

		IF @WallConstructionRefer = 1
		INSERT INTO @Refer VALUES ('Refer wall construction type ' + @WallConstruction);

		IF @RoofConstructionRefer = 1
		INSERT INTO @Refer VALUES ('Refer roof construction type ' + @RoofConstruction);

		IF @WallConstructionDecline = 1
		INSERT INTO @Decline VALUES ('Decline wall construction type ' + @WallConstruction);

		IF @RoofConstructionDecline = 1
		INSERT INTO @Decline VALUES ('Decline roof construction type ' + @RoofConstruction);


		-- Property level excesses
		-- -----------------------

		-- View available excesses for the scheme:
		/*
		SELECT [XS].[Excess], [TOLXS].*
		FROM MLETPROP_Toledo_PropertyOwners_Excess AS [TOLXS]
		INNER JOIN [Excess] [XS] ON [TOLXS].[ExcessID] = [XS].ExcessID
		WHERE [TOLXS].[EndDateTime] IS NULL
		ORDER BY [XS].[Excess]
		*/

		-- Subsidence excess:
		IF @FireCover <> 1
		INSERT INTO @Excess 
		--SELECT 'Property ' + CAST(@PropertyCounter AS varchar) + ' (' + @PropertyPostCode + ') ' + REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
		SELECT REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
		INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
		WHERE [XS].[ExcessID] = 1 AND [TOLXS].[Criteria] = 0 AND [TOLXS].[EndDateTime] IS NULL;

		-- Flood excess:
		IF  @FireCover <> 1 AND @PostCodeFloodBand = 10
		INSERT INTO @Excess 
		--SELECT 'Property ' + CAST(@PropertyCounter AS varchar) + ' (' + @PropertyPostCode + ') ' + REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
		SELECT REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
		INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
		WHERE [XS].[ExcessID] = 41 AND [TOLXS].[Criteria] = 1 AND [TOLXS].[EndDateTime] IS NULL;

		-- Felt or Flat roof excess:
		IF @FireCover <> 1 AND @RoofConstructionID IN ('FLAT894A', 'FLAT835E', 'FLATF301') -- Flat/Felt <30%, Flat/Felt 31-50%, Flat/Felt 51-100%
		INSERT INTO @Excess 
		--SELECT 'Property ' + CAST(@PropertyCounter AS varchar) + ' (' + @PropertyPostCode + ') ' + REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
		SELECT REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
		INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
		WHERE [XS].[ExcessID] = 46 AND [TOLXS].[Criteria] = 1 AND [TOLXS].[EndDateTime] IS NULL;
		
		-- Escape of Water and Oil excesses where previous claim:
		IF @FireCover <> 1 AND @EscapeWaterOilClaim = 1
		BEGIN
			INSERT INTO @Excess
			SELECT REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
			INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
			WHERE [XS].[ExcessID] = 6 AND [TOLXS].[Criteria] = 1 AND [TOLXS].[EndDateTime] IS NULL;	-- Escape of Water
	
			INSERT INTO @Excess
			SELECT REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
			INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
			WHERE [XS].[ExcessID] = 45 AND [TOLXS].[Criteria] = 1 AND [TOLXS].[EndDateTime] IS NULL; -- Escape of Oil
		END

		-- Storm Damage excess where previous claim:
		IF @FireCover <> 1 AND @StormDamageClaim = 1
		INSERT INTO @Excess
		SELECT REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
		INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
		WHERE [XS].[ExcessID] = 42 AND [TOLXS].[Criteria] = 1 AND [TOLXS].[EndDateTime] IS NULL;

				
		-- Property level endorsements
		-- ---------------------------

		IF @PostCodeFloodBand = 10
		INSERT INTO @Endorsement VALUES ('TISPO6'); -- Flood excess

		IF @SecondHome = 1 OR @PropertyContainsUnoccupiedOccDtail = 1
		INSERT INTO @Endorsement VALUES ('TISPO16'); -- Unoccupancy Warranty

		IF @RoofConstructionID IN ('FLAT894A', 'FLAT835E', 'FLATF301') -- Flat/Felt <30%, Flat/Felt 31-50%, Flat/Felt 51-100%
		INSERT INTO @Endorsement VALUES ('TISPO20'); -- Flat Roof Condition

		IF @PostCodeSubsBand >= 6
		INSERT INTO @Endorsement VALUES ('TISPO21'); -- Subsidence exclusion
		
		IF @BuildingTypeID IN ('068', '3MRG7BB8')	-- Office with Flat, Shop with Flat
		BEGIN
			INSERT INTO @Endorsement VALUES ('TISPO22') -- Shop fronts & Shop Front Glass Exclusion
			INSERT INTO @Endorsement VALUES ('TISPO23') -- Trade, Profession or Business Liability Exclusion
			INSERT INTO @Endorsement VALUES ('TISPO24') -- Loss of Rent
			INSERT INTO @Endorsement VALUES ('TISPO25') -- Non Domestic Contents
			INSERT INTO @Endorsement VALUES ('TISPO26') -- Business Contents Exclusion
		END;

		IF @Cooking = 1
		INSERT INTO @Endorsement VALUES ('TISFCEC'); -- Frying and Cooking Equipment Condition 

		/*8462927749*/
	    IF(@BuildingTypeID = 'HMO') INSERT INTO @Endorsement VALUES ('TISPO28');

	END -- End looping through Property Details records


	-- ===========================
	-- Top level loads / discounts
	-- ===========================
   
   	INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Loads/Discounts', NULL ,NULL ,NULL))
	INSERT INTO @Breakdown VALUES(':::') -- Blank Line

	-- Claim Loads:

	DECLARE @ClaimsLast3Yrs table ([ID] int identity(1,1), [Type] varchar(255), [TotalAmount] money, [LoadDiscountValue] money, [Refer] bit);
	DECLARE @ClaimCounter int = 1;
	DECLARE @ClaimType varchar(100);
	DECLARE @ClaimAmount int;

	INSERT INTO @ClaimsLast3Yrs ([Type], [TotalAmount], [LoadDiscountValue], [Refer])
	SELECT
		 [LD].[LoadDiscountType]
		,[Claim].[Paid] + [Claim].[Outstanding] AS [TotalAmount]
		,ISNULL([LD].[LoadDiscountValue], 0) AS [LoadDiscountValue]
		,ISNULL([LD].[Refer], 0) AS [Refer]
	FROM
		@ClaimsSummary AS [Claim]
		LEFT JOIN [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount] AS [LD] ON [LD].[StartRange] <= ([Claim].[Paid] + [Claim].[Outstanding])
																			  AND ([LD].[EndRange] >= ([Claim].[Paid] +[Claim].[Outstanding]) OR [LD].[EndRange] IS NULL)
																			  AND [LD].[EndDateTime] IS NULL
																			  AND [LD].[LoadDiscountType] = CASE
																												WHEN [Claim].[Type] = 'Other or Unknown' THEN 'Other'
																												ELSE [Claim].[Type]
																											END
	WHERE [Claim].[Date] BETWEEN DATEADD(YY,-3,GETDATE()) AND GETDATE();

	WHILE @ClaimCounter <= (SELECT COUNT(*) FROM @ClaimsLast3Yrs)
	BEGIN
		
		SET @ClaimAmount = 0;
		SET @LoadDiscountValue = 0;
		SET @LoadAmount = 0;
		SET @ReferRateFlag = NULL;

		SELECT 
			 @ClaimType = [Type]
			,@ClaimAmount = [TotalAmount]
			,@LoadDiscountValue = [LoadDiscountValue]
			,@ReferRateFlag = [Refer]
		FROM @ClaimsLast3Yrs
		WHERE [ID] = @ClaimCounter

		IF @ReferRateFlag = 1
		BEGIN
			INSERT INTO @Refer VALUES ('Refer £' + CAST(@ClaimAmount as varchar) + ' ' + @ClaimType + ' claim');
		END
		ELSE IF @LoadDiscountValue > 0
		BEGIN

			SET @LoadAmount = @TotalPremium * (@LoadDiscountValue / 100);
			SET @BuildingsLoadAmount = @TotalBuildingsPremium * (@LoadDiscountValue / 100);
			SET @ContentsLoadAmount = @TotalContentsPremium * (@LoadDiscountValue / 100);
		
			SET @TotalPremium = @TotalPremium + @LoadAmount
			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
			SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

			INSERT INTO @Breakdown SELECT [dbo].[svfFormatBreakdownString](@ClaimType + ' claim load'
			,(@LoadDiscountValue / 100), @LoadAmount, @TotalPremium)
		
		END
		
		SET @ClaimCounter = @ClaimCounter +1

	END;

	SET @ClaimCounter = @ClaimCounter -1 -- Remove the last increment (which would have found no claim ID and stopped the loop) as this variable is used to check the number of claims below


	IF (SELECT COUNT(*) FROM @ClaimsLast3Yrs WHERE [LoadDiscountValue] = 0 AND [Refer] <> 1) >= 2
	BEGIN

		SET @LoadAmount = @TotalPremium * 0.15;
		SET @BuildingsLoadAmount = @TotalBuildingsPremium * 0.15;
		SET @ContentsLoadAmount = @TotalContentsPremium * 0.15;
		
		SET @TotalPremium = @TotalPremium + @LoadAmount
		SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
		SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

		INSERT INTO @Breakdown SELECT [dbo].[svfFormatBreakdownString]('Claim load for 2+ claims without loadings', 0.15, @LoadAmount, @TotalPremium);
	END


	-- Voluntary Excess Discount:

	SET @LoadDiscountValue = 0;
    SET @LoadAmount = 0;
    
	IF @VolExcessAmount > '0'
    BEGIN
        
	    SELECT @LoadDiscountValue = ISNULL([LoadDiscountValue], 0) FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
																   WHERE EndDateTime IS NULL
																   AND [LoadDiscountType] = 'Voluntary excess'
																   AND [StartRange] = @VolExcessAmount;

		SET @LoadAmount = @TotalPremium * (@LoadDiscountValue / 100);
		SET @BuildingsLoadAmount = @TotalBuildingsPremium * (@LoadDiscountValue / 100);
		SET @ContentsLoadAmount = @TotalContentsPremium * (@LoadDiscountValue / 100);
		
		SET @TotalPremium = @TotalPremium + @LoadAmount
		SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
		SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

		INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Voluntary Excess £' + @VolExcessAmount + ' discount'
									 ,(@LoadDiscountValue/100), @LoadAmount, @TotalPremium))


	END -- IF @VolExcessAmount > '0'

	-- Multi Property Discount:
	SET @LoadDiscountValue = 0;
    SET @LoadAmount = 0;
	SET @ReferRateFlag = NULL;

	IF @PropertyCounter >= 3
    BEGIN

	    SELECT @LoadDiscountValue = ISNULL([LoadDiscountValue], 0)
			  ,@ReferRateFlag = ISNULL([Refer], 0)
		FROM [dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
		WHERE EndDateTime IS NULL
		AND [LoadDiscountType] = 'Multi Property Discount'
		AND @PropertyCounter BETWEEN [StartRange] AND [EndRange];

		IF @ReferRateFlag = 1
		BEGIN
			INSERT INTO @Refer VALUES ('Refer to underwriter for ' + CAST(@PropertyCounter AS varchar) + ' properties');
		END
		ELSE BEGIN

			SET @LoadAmount = @TotalPremium * (@LoadDiscountValue / 100);
			SET @BuildingsLoadAmount = @TotalBuildingsPremium * (@LoadDiscountValue / 100);
			SET @ContentsLoadAmount = @TotalContentsPremium * (@LoadDiscountValue / 100);
		
			SET @TotalPremium = @TotalPremium + @LoadAmount
			SET @TotalBuildingsPremium = @TotalBuildingsPremium + @BuildingsLoadAmount
			SET @TotalContentsPremium = @TotalContentsPremium + @ContentsLoadAmount

			INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Multi Property Discount ' + CAST(@PropertyCounter AS varchar) + ' properties'
										 ,(@LoadDiscountValue/100), @LoadAmount, @TotalPremium))
		
		END

	END -- IF @PropertyCounter >= 3

    -- =============
	-- Final premium
	-- =============
	
	-- Insert totals:

	INSERT INTO @Breakdown VALUES(':::');--BLANK LINE
	INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Buildings Total', NULL, NULL, @TotalBuildingsPremium ));
	INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Contents Total', NULL, NULL, @TotalContentsPremium ));
	INSERT INTO @Breakdown VALUES(':::');--BLANK LINE
	INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Total', NULL, NULL, @TotalPremium ));

	-- Building Total or Minimum Premium:

	SELECT @BuildingMinimumPremium = CAST([Value] AS money) FROM [dbo].[MLETPROP_Toledo_PropertyOwners_PremiumMinimum]
	WHERE [EndDateTime] is NULL AND [RateType] = CASE WHEN @FireCover = 1 THEN 'FLEEA only Cover' ELSE 'Full Cover' END;

	IF @TotalBuildingsPremium < @BuildingMinimumPremium
	BEGIN
		
		SET @TotalBuildingsPremium = @BuildingMinimumPremium;
		
		SET @TotalPremium = @TotalBuildingsPremium + @TotalContentsPremium;
		
		INSERT INTO @Breakdown VALUES(':::');--BLANK LINE
        INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Buildings Minimum Premium', NULL, NULL, @TotalBuildingsPremium));

	END;

	
	-- Contents Total or Minimum Premium:

	SELECT @ContentMinimumPremium = CAST([Value] AS money) FROM [dbo].[MLETPROP_Toledo_PropertyOwners_PremiumMinimum]
	WHERE [EndDateTime] is NULL AND [RateType] = 'Contents';

	IF @TotalContentsPremium > 0 AND @TotalContentsPremium < @ContentMinimumPremium
	BEGIN
		
		SET @TotalContentsPremium = @ContentMinimumPremium;

		SET @TotalPremium = @TotalBuildingsPremium + @TotalContentsPremium;
		
		INSERT INTO @Breakdown VALUES(':::');--BLANK LINE
        INSERT INTO @Breakdown VALUES([dbo].[svfFormatBreakdownString]('Contents Minimum Premium', NULL, NULL, @TotalContentsPremium));

	END;


	-- Insert premium sections:
 
    INSERT INTO @Premiums([Name],[Value]) VALUES ('BUILPREM', @TotalBuildingsPremium);
	INSERT INTO @Premiums([Name],[Value]) VALUES ('CONTPREM', @TotalContentsPremium);


	-- ===================
	-- Top level referrals
	-- ===================
    
	IF @PropertyCounter <1
	INSERT INTO @Refer VALUES ('No properties entered');

    IF (SELECT COUNT(*) FROM @ClaimsSummary WHERE ([Date] BETWEEN DATEADD(YY,-1,GETDATE()) AND GETDATE())) > 2
    INSERT INTO @Refer VALUES ('More than two claims in last 12 months');

    IF @ClaimCounter > 3
    INSERT INTO @Refer VALUES ('More than three claims in last three years');

	IF @RiskContainsUnoccupiedOccDtail = 0 AND @RiskTotalBuildingSumInsured > @BuildingSIOccupiedMax
	INSERT INTO @Refer VALUES ('Total buildings sum insured is greater than the maximum of £'+ CAST(@BuildingSIOccupiedMax AS VARCHAR));

	IF @RiskContainsUnoccupiedOccDtail = 1 AND @RiskTotalBuildingSumInsured > @BuildingSIUnoccupiedMax
	INSERT INTO @Refer VALUES ('Total buildings sum insured is greater than the maximum of £'+ CAST(@BuildingSIUnoccupiedMax AS VARCHAR));

	-- ==================
	-- Top level declines
	-- ==================

	-- Currently none

	
	-- ==================
	-- Top level excesses
	-- ==================
		
	-- Property Owners Liability excess:
	INSERT INTO @Excess 
	SELECT REPLACE([XS].[Excess],'{Excess}', [TOLXS].[Level]) FROM [MLETPROP_Toledo_PropertyOwners_Excess] [TOLXS]
	INNER JOIN [Excess] AS [XS] ON [TOLXS].[ExcessID] = [XS].[ExcessID]
	WHERE [XS].[ExcessID] = 10 AND [TOLXS].[Criteria] = 0 AND [TOLXS].[EndDateTime] IS NULL;
	

	-- =====================
	-- De-duplicate excesses
	-- =====================

	-- Remove duplicate excesses where multiple Property or Occupancy Details have produced the same excess:

	DELETE [E]
	FROM (SELECT ROW_NUMBER() OVER (PARTITION BY [Message] ORDER BY [Message]) AS [RowNum]
		  FROM @Excess
		  ) AS [E]
	WHERE [RowNum] > 1;

	
	-- ======================
	-- Top level endorsements
	-- ======================
    
	IF EXISTS (SELECT 1 FROM @ClaimsSummary WHERE [Type] = 'Flood')
    INSERT INTO @Endorsement VALUES ('TISPO2'); -- Flood exclusion
	
	IF EXISTS (SELECT 1 FROM @ClaimsSummary WHERE [Type] = 'Theft')
    INSERT INTO @Endorsement VALUES ('TISPO4'); -- Theft or attempted theft exclusion
	
	IF EXISTS (SELECT 1 FROM @ClaimsSummary WHERE [Type] = 'Storm Damage (excluding flood)')
    INSERT INTO @Endorsement VALUES ('TISPO7'); -- Storm Excess
	
	IF @EscapeWaterOilClaim = 1
    INSERT INTO @Endorsement VALUES ('TISPO8'); -- Water damage excess 

	IF @FireCover = 1
	INSERT INTO @Endorsement VALUES ('TISPO9'); -- Fire, lightning, earthquake, explosion and aircraft

	INSERT INTO @Endorsement VALUES ('TISPO10'); -- Minimum security clause applies at all times

	IF EXISTS (SELECT 1 FROM @Assump WHERE [HEATING_ID] = '3MQT5MC7') -- Disagree
    INSERT INTO @Endorsement  VALUES ('TISPO11'); -- Chimney Warranty

	INSERT INTO @Endorsement VALUES ('TISPO13'); -- Boundary wall exclusion applies at all times

	INSERT INTO @Endorsement VALUES ('TISPO14'); -- Electrical Inspection Warranty applies at all times

	INSERT INTO @Endorsement VALUES ('TISPO27'); -- Loss of Rent first two weeks applies at all times


	-- =================================================
	-- De-duplicate referrals, declines and endorsements (same messages may have been inserted from multiple occupancies / properties)
	-- =================================================

	DELETE [Refer] FROM
	(SELECT ROW_NUMBER() OVER(PARTITION BY [Message] ORDER BY [ID]) AS [RowNum] FROM @Refer) AS [Refer]
	WHERE [RowNum] > 1;

	DELETE [Decline] FROM
	(SELECT ROW_NUMBER() OVER(PARTITION BY [Message] ORDER BY [ID]) AS [RowNum] FROM @Decline) AS [Decline]
	WHERE [RowNum] > 1;

	DELETE [Endorsement] FROM
	(SELECT ROW_NUMBER() OVER(PARTITION BY [Message] ORDER BY [Message]) AS [RowNum] FROM @Endorsement) AS [Endorsement]
	WHERE [RowNum] > 1;
 
	-- ============
	-- Return Table
	-- ============

	DECLARE @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN

END