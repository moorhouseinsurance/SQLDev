USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MCLIAB_Covea_ProfessionalIndemnity_tvfCalculator]    Script Date: 14/02/2025 09:54:05 ******/
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
-- 20/02/2025	Simon					Added min premium of £48 to PI (8475358221)
*******************************************************************************/

ALTER FUNCTION [dbo].[MCLIAB_Covea_ProfessionalIndemnity_tvfCalculator]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
	,@ProfIndm [dbo].[MCLIAB_ProfIndmTableType] READONLY
	,@CInfo CInfoTableType READONLY
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
		DECLARE	   @CInfo_PrimaryRisk varchar(250)
				  ,@CInfo_PrimaryRisk_ID varchar(8)

		SELECT	 @CInfo_PrimaryRisk = PrimaryRisk
				,@CInfo_PrimaryRisk_ID = PrimaryRisk_ID
		FROM
			@CInfo



		DECLARE 
			 @Insurer [varchar] (30) = 'Covea Insurance'
			,@LineOfBusiness [varchar] (30) = 'MLIAB'
			,@LimitType [varchar](40) = 'CInfo_AnnualTurnover_PI'
			,@MinOrMax char(3) = 'Max'

		DECLARE  @CInfo_AnnualTurnover_PI_Max int = (SELECT [dbo].[svfLimitSelect](NULL ,@Insurer ,@LineOfBusiness ,@LimitType ,@MinOrMax ,@PolicyStartDateTime ))

		SET @LineOfBusiness = 'MCLIAB'
		SET @LimitType  = 'ProfIndm_ContractSI'
		DECLARE  @ProfIndm_ContractSI_Max int = (SELECT [dbo].[svfLimitSelect](NULL ,@Insurer ,@LineOfBusiness ,@LimitType ,@MinOrMax ,@PolicyStartDateTime ))
		
		DECLARE	 @RateCategoryID int 
				,@ProfIndm_Turnover money = (Select [TurnOver] FROM @ProfIndm)
				,@PILimit int =(SELECT [dbo].[svfFormatNumber]([PILevel]) FROM @ProfIndm)
				,@PIYN bit = (SELECT [PIYN] FROM @ProfIndm)
				,@Rate numeric(18,9)

		DECLARE @TradeTable table
		(
			 [Trade] varchar(250)
			,[Decline_NoRating] varchar(250)
			,[Profesional] bit
			,[RateCategoryID] int
		)
 
		INSERT INTO @TradeTable
		SELECT * FROM [dbo].[MCLIAB_Covea_ProfessionalIndemnity_tvfTradeCategory] (@CInfo_PrimaryRisk ,@CInfo_PrimaryRisk_ID ,@PolicyStartDateTime )

		SET @RateCategoryID = (SELECT MAX([RateCategoryID]) FROM @TradeTable)

		SET @Rate = [dbo].[MLIAB_Covea_ProfessionalIndemnity_svfRate] (@RateCategoryID ,@ProfIndm_Turnover ,@PILimit ,@PolicystartDateTime)

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
					,@Premium = @Rate 

			SET @Premium = @Premium * @ProfIndm_Turnover
			
			/*	8475358221 - Set PI Premium to 48 if calculated is under	*/
			IF @SchemeTableID IN (1064, 1309, 1310) AND @Insurer = 'Covea Insurance' AND @Premium < @MinPIPremium
			BEGIN
				SET @Premium = @MinPIPremium
			END
			
			INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + ' ' + cast(@Rate as varchar(20)) + ' x ' +[dbo].[svfFormatMoneyString](@ProfIndm_Turnover) + ' Turnover' ,null ,null ,@Premium))
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
		SELECT 'Turnover of ' +  [dbo].[svfFormatMoneyString]([Turnover]) + ' excedes maximum of ' + [dbo].[svfFormatMoneyString](@CInfo_AnnualTurnover_PI_Max)
		FROM 
			@ProfIndm
		WHERE
			 [Turnover] > @CInfo_AnnualTurnover_PI_Max


		INSERT INTO @Refer 
		SELECT 'Largest Contract Value of ' +  [dbo].[svfFormatMoneyString]([ContractSI]) + ' excedes maximum of ' + [dbo].[svfFormatMoneyString](	@ProfIndm_ContractSI_Max)
		FROM 
			@ProfIndm
		WHERE
			[ContractSI] > @ProfIndm_ContractSI_Max

		INSERT INTO @Decline
		SELECT 'Answered Yes to : Other than as an introducer, have or do you intend to carry out any investment or financial services work' 
		FROM @ProfIndm WHERE [FinancialYN] = 1;

		INSERT INTO @Decline
		SELECT 'Answered Yes to : Have you or do you intend to carry out work involving accountancy, tax advice, mergers, acquisitions, insolvencies, liquidations or receiverships?' 
		FROM @ProfIndm WHERE [AccountancyYN] = 1;

		INSERT INTO @Decline
		SELECT 'Answered Yes to : Have you or do you intend to carry out work involving employment law, health and safety law or immigration law?' 
		FROM @ProfIndm WHERE [LawYN] = 1;

		--Trade refers
		INSERT INTO @Decline SELECT [Decline_NoRating] FROM @TradeTable WHERE [Decline_NoRating] IS NOT NULL
		
		-- Excess
		INSERT INTO @Excess 
		SELECT
			REPLACE([E].[Excess] ,'{Excess}' ,CAST([SE].[Level] AS VARCHAR(10)))
		FROM 
			[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_Excess] AS [SE]
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
