USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_Covea_ProfessionalIndemnity_tvfCalculator]    Script Date: 20/02/2025 09:09:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
-- Author:		D. Hostler
-- Date:        31 Mar 2020
-- Description: Return Scheme Information
*******************************************************************************
-- Date			Who						Change
-- 16/09/2024   Linga                   Monday Ticket 6184964279: £10,000,000 PL Covea Rate - Added £1 premium rates for £10,000,000
-- 14/01/2025   Linga					Monday Ticket 8177482880: Changes to TL and Companion TL Scheme - Quarz & Solar
                                         -- Solution: Replaced [MLIAB_TrdDtailTableType] with new [MLIAB_TrdDtail_TableType] that contains the new fields
-- 20/02/2025	Simon					Added min premium of £48 to PI (8475358221)

*******************************************************************************/

ALTER FUNCTION [dbo].[MLIAB_Covea_ProfessionalIndemnity_tvfCalculator]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
	,@ProfIndm [dbo].[MLIAB_ProfIndmTableType] READONLY
	,@CInfo MLIAB_CInfoTableType READONLY
	,@TrdDtail MLIAB_TrdDtail_TableType READONLY
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
			
	INSERT INTO @Premiums ([Name] ,[Value]) VALUES ('PROFPREM',0);

	IF (SELECT [PIYN] FROM @ProfIndm) = 1
	BEGIN

		--Assign required Limit table values to variables
		DECLARE	   @TrdDtail_SecondaryRisk varchar(250)
				  ,@TrdDtail_SecondaryRisk_ID varchar(8)
				  ,@TrdDtail_Phase bit
				  ,@TrdDtail_Paving bit
				  ,@TrdDtail_MaxDepth varchar(250)
				  ,@TrdDtail_PrimaryRisk varchar(250)
				  ,@TrdDtail_PrimaryRisk_ID varchar(8)
				  ,@TrdDtail_FixedMachinery bit

		SELECT	 @TrdDtail_SecondaryRisk = SecondaryRisk
				,@TrdDtail_SecondaryRisk_ID = SecondaryRisk_ID
				,@TrdDtail_Phase = Phase
				,@TrdDtail_Paving = Paving
				,@TrdDtail_MaxDepth = MaxDepth
				,@TrdDtail_PrimaryRisk = PrimaryRisk
				,@TrdDtail_PrimaryRisk_ID = PrimaryRisk_ID
				,@TrdDtail_FixedMachinery = FixedMachinery
		FROM
			@TrdDtail

		DECLARE	   @CInfo_WorkSoley bit
				  ,@CInfo_Heat bit
				  ,@CInfo_MaxHeight varchar(250)
				  ,@CInfo_PubLiabLimitValue bigint = 0

		SELECT	   @CInfo_WorkSoley	   = WorkSoley
				  ,@CInfo_Heat		   = Heat
				  ,@CInfo_MaxHeight	   = MaxHeight
				  ,@CInfo_PubLiabLimitValue =  [dbo].[svfFormatNumber]([PubLiabLimit])
		FROM
			@CInfo


		DECLARE 
			 @Insurer [varchar] (30) = 'Covea Insurance'
			,@LineOfBusiness [varchar] (30) = 'MLIAB'
			,@LimitType [varchar](40) = 'CInfo_AnnualTurnover_PI'
			,@MinOrMax char(3) = 'Max'

		DECLARE  @CInfo_AnnualTurnover_PI_Max int = (SELECT [dbo].[svfLimitSelect]( NULL ,@Insurer ,@LineOfBusiness ,@LimitType ,@MinOrMax ,@PolicyStartDateTime ))
	
		DECLARE	 @RateCategoryID int 
				,@Turnover money = (Select [AnnualTurnOver] FROM @CInfo)
				,@PILimit int =(SELECT [dbo].[svfFormatNumber]([PILevel]) FROM @ProfIndm)
				,@PIYN bit = (SELECT [PIYN] FROM @ProfIndm)
				,@Rate numeric(18,9)

		DECLARE @TradeTable table
		(
			 [Trade] varchar(250)
			,[Decline_NoRating] varchar(250)
			,[ReferCInfo_WorkSoley] varchar(250)
			,[ReferTrdDtail_Phase] varchar(250)
			,[ReferCInfo_Heat] varchar(250)
			,[ReferTrdDtail_Paving] varchar(250)
			,[ReferCInfo_MaxHeight] varchar(250)
			,[ReferTrdDtail_MaxDepth] varchar(250)
			,[TradeDescriptionInsurer] varchar(250)
			,[RateCategoryID] int
		)
 
		INSERT INTO @TradeTable
		SELECT * FROM [dbo].[MLIAB_Covea_ProfessionalIndemnity_tvfTradeCategory] (@TrdDtail_PrimaryRisk ,@TrdDtail_PrimaryRisk_ID ,@PolicyStartDateTime ,@CInfo_WorkSoley ,@TrdDtail_Phase ,@CInfo_Heat ,@TrdDtail_Paving ,@CInfo_MaxHeight ,@TrdDtail_MaxDepth )
		IF @TrdDtail_SecondaryRisk != 'None'
			INSERT INTO @TradeTable
			SELECT * FROM [dbo].[MLIAB_Covea_ProfessionalIndemnity_tvfTradeCategory] (@TrdDtail_SecondaryRisk ,@TrdDtail_SecondaryRisk_ID ,@PolicyStartDateTime ,@CInfo_WorkSoley ,@TrdDtail_Phase ,@CInfo_Heat ,@TrdDtail_Paving ,@CInfo_MaxHeight ,@TrdDtail_MaxDepth )

		SET @RateCategoryID = (SELECT MAX([RateCategoryID]) FROM @TradeTable)
		SET @Rate = [dbo].[MLIAB_Covea_ProfessionalIndemnity_svfRate] (@RateCategoryID ,@Turnover ,@PILimit ,@PolicystartDateTime)

	--Calculate Premium Sections and Insert Breakdowns
		DECLARE @Premium numeric(18, 9) = 0
		DECLARE @BasePremium money = 0
		DECLARE @TotalBasePremium money = 0
		DECLARE @TotalPremium money = 0
		DECLARE @PremiumSection char(8)
		DECLARE @Section varchar(50)  
		DECLARE @MinPIPremium numeric(18, 9) = (SELECT [Minimum] FROM [Calculators].[dbo].[Limit] WHERE Insurer = @Insurer AND LineOfBusiness = @LineOfBusiness AND [LimitType] = 'Professional Indemnity Premium' AND [EndDateTime] IS NULL)

		IF @PIYN = 1
		BEGIN
			SELECT	 @Section = 'Professional Indemnity'
					,@PremiumSection = 'PROFPREM'
					,@Premium = (CASE WHEN @CInfo_PubLiabLimitValue = 10000000 THEN 1.00
					                  ELSE @Rate 
								 END)

            IF(@CInfo_PubLiabLimitValue = 10000000)
			BEGIN
			    INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' for ' +[dbo].[svfFormatMoneyString](@Turnover) + ' Turnover' ,null ,null ,@Premium))
			END
			ELSE
			BEGIN
			    SET @Premium = @Premium * @Turnover

			/*	8475358221 - Set PI Premium to 48 if calculated is under	*/
			IF @SchemeTableID IN (1311, 1312, 878) AND @Insurer = 'Covea Insurance' AND @Premium < @MinPIPremium
			BEGIN
				SET @Premium = @MinPIPremium
			END

			    INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' ' + cast(@Rate as varchar(20)) + ' x ' +[dbo].[svfFormatMoneyString](@Turnover) + ' Turnover' ,null ,null ,@Premium))
			END

			SET @BasePremium = @Premium

			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

			INSERT INTO @Breakdown	VALUES(	':::')--Blank line
			UPDATE @Premiums SET [Value] = ISNULL(@Premium,0) WHERE [Name] = @PremiumSection

			SET @TotalBasePremium = @TotalBasePremium + @BasePremium
			SET @TotalPremium = @TotalPremium + @Premium

		END
	
	--Insert Breakdown totals
		INSERT INTO @Breakdown ([Message])	VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium))

	--Refers

		INSERT INTO @Refer 
		SELECT 'Turnover of ' +  [dbo].[svfFormatMoneyString]([AnnualTurnover]) + ' excedes maximum of ' + [dbo].[svfFormatMoneyString](@CInfo_AnnualTurnover_PI_Max)
		FROM 
			@CInfo
		WHERE
			 [AnnualTurnover] > @CInfo_AnnualTurnover_PI_Max

		INSERT INTO @Refer 
		SELECT 'Turnover must be supplied for Professional Indemnity Cover'	FROM @CInfo	WHERE [AnnualTurnover] = 0
	
		IF ISNULL(@Premium ,0)= 0.0
		INSERT INTO @Refer VALUES('Professional Indemnity Premium calculated as £0.00')
				 			 		
		--Trade refers
		INSERT INTO @Refer
				SELECT [ReferCInfo_WorkSoley] FROM @TradeTable WHERE [ReferCInfo_WorkSoley] IS NOT NULL
		UNION	SELECT [ReferTrdDtail_Phase] FROM @TradeTable WHERE [ReferTrdDtail_Phase] IS NOT NULL
		UNION	SELECT [ReferCInfo_Heat] FROM @TradeTable WHERE [ReferCInfo_Heat] IS NOT NULL
		UNION	SELECT [ReferTrdDtail_Paving] FROM @TradeTable WHERE [ReferCInfo_Heat] IS NOT NULL
		UNION	SELECT [ReferCInfo_MaxHeight] FROM @TradeTable WHERE [ReferCInfo_MaxHeight] IS NOT NULL
		UNION	SELECT [ReferTrdDtail_MaxDepth] FROM @TradeTable WHERE [ReferTrdDtail_MaxDepth] IS NOT NULL

		INSERT INTO @Decline SELECT [Decline_NoRating] FROM @TradeTable WHERE [Decline_NoRating] IS NOT NULL
	
		-- Excess
		INSERT INTO @Excess 
		SELECT
			REPLACE([E].[Excess] ,'{Excess}' ,CAST([SE].[Level] AS VARCHAR(10)))
		FROM 
			[dbo].[MLIAB_Covea_TradesmanLiability_Excess] AS [SE]
			JOIN [dbo].[Excess] AS [E] ON [SE].[ExcessID] = [E].[ExcessID]
		WHERE
			[SE].[StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([EndDatetime] ,@PolicyStartDateTime +1)
			AND [E].[ExcessID] = 36

	END
--Return Table
	declare @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN
END
