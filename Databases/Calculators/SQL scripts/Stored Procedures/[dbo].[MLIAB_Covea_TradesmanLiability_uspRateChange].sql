USE [Calculators]
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create date: 28 Feb 2025
-- Description:	Increase or decrease rates for Covea Tradesman Liability (expires existing rows in the rate tables and inserts new rows with all rates
--				increased or decreased by the amount specified in input parameters)
-- =============================================

ALTER PROCEDURE [dbo].[MLIAB_Covea_TradesmanLiability_uspRateChange]
	 @PLRateChange decimal (5,3)
	,@ELRateChange decimal (5,3)
	,@CARRateChange decimal (5,3)
	,@ToolsRateChange decimal (5,3)
	,@FixedMachineryRateChange decimal (5,3)
	,@PIRateChange decimal (5,3)
	,@PARateChange decimal (5,3)
AS

/*

-- Set the increase or decrease as a decimal, for example:
-- 1.1 = 10% rate increase
-- 0.9 = 10% rate decrease
-- 0 = no change for this section (no records will be updated)

DECLARE @PLRateChange decimal (5,3) = 0.9 -- Public Liability
DECLARE @ELRateChange decimal (5,3) = 0.9 -- Employers Liability
DECLARE @CARRateChange decimal (5,3) = 0.9 -- Contractors All Risks
DECLARE @ToolsRateChange decimal (5,3) = 0.9 -- Tools
DECLARE @FixedMachineryRateChange decimal (5,3) = 0.9 -- Fixed Machinery
DECLARE @PIRateChange decimal (5,3) = 0.9 -- Professional Indemnity
DECLARE @PARateChange decimal (5,3) = 0.9 -- Personal Accident

EXEC [dbo].[MLIAB_Covea_TradesmanLiability_uspRateChange] @PLRateChange, @ELRateChange, @CARRateChange, @ToolsRateChange, @FixedMachineryRateChange, @PIRateChange, @PARateChange

*/


-- =======
-- PL & EL
-- =======

IF ISNULL(@PLRateChange, 0) <> 0 OR ISNULL(@ELRateChange, 0) <> 0
BEGIN

	-- Expire current rows:

	UPDATE [dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
	SET [EndDatetime] = CONVERT(date, GETDATE())
	WHERE [EndDatetime] IS NULL
	AND NOT ([PL1] = 1 AND [PL2] = 1 AND [PL3] = 1 AND [PL4] = 1 AND [PL5] = 1 AND [PL6] = 1 AND [PL7] = 1 AND [PL8] = 1 AND [PL9] = 1 AND [PL10] = 1 AND [EL1] = 1) -- £10m indemnity rates are set to £1 so they act like a pound scheme; no need to update these


	-- Insert new records:

	INSERT INTO [dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL](
		 [TradeDescriptionInsurer]
		,[TradeID]
		,[LevelOfIndemnity]
		,[PL1]
		,[PL2]
		,[PL3]
		,[PL4]
		,[PL5]
		,[PL6]
		,[PL7]
		,[PL8]
		,[PL9]
		,[PL10]
		,[EL1]
		,[ExcessProperty]
		,[ExcessHeat]
		,[Endorsement]
		,[QuestionHeat]
		,[Question3Phase]
		,[Question3PhaseRequired]
		,[QuestionPDH]
		,[QuestionPDHRequired]
		,[QuestionMaximumDepthMin]
		,[QuestionMaximumDepthMax]
		,[QuestionHeatRequired]
		,[QuestionMaximumHeightMin]
		,[QuestionMaximumHeightMax]
		,[QuestionPaving]
		,[QuestionPavingRequired]
		,[Refer]
		,[PriceMatchCapPct]
		,[StartDatetime]
		,[EndDatetime]
		,[IsMinPremAppl]
	)SELECT 
		 [TradeDescriptionInsurer]
		,[TradeID]
		,[LevelOfIndemnity]
		,CASE [PL1] WHEN 1 THEN 1 ELSE ROUND([PL1] * @PLRateChange, 2) END											AS [PL1]
		,CASE [PL2] WHEN 1 THEN 1 ELSE ROUND([PL2] * @PLRateChange, 2) END											AS [PL2]
		,CASE [PL3] WHEN 1 THEN 1 ELSE ROUND([PL3] * @PLRateChange, 2) END											AS [PL3]
		,CASE [PL4] WHEN 1 THEN 1 ELSE ROUND([PL4] * @PLRateChange, 2) END											AS [PL4]
		,CASE [PL5] WHEN 1 THEN 1 ELSE ROUND([PL5] * @PLRateChange, 2) END											AS [PL5]
		,CASE [PL6] WHEN 1 THEN 1 ELSE ROUND([PL6] * @PLRateChange, 2) END											AS [PL6]
		,CASE [PL7] WHEN 1 THEN 1 ELSE ROUND([PL7] * @PLRateChange, 2) END											AS [PL7]
		,CASE [PL8] WHEN 1 THEN 1 ELSE ROUND([PL8] * @PLRateChange, 2) END											AS [PL8]
		,CASE [PL9] WHEN 1 THEN 1 ELSE ROUND([PL9] * @PLRateChange, 2) END											AS [PL9]
		,CASE [PL10] WHEN 1 THEN 1 ELSE ROUND([PL10] * @PLRateChange, 2) END										AS [PL10]
		,CASE [EL1] WHEN 1 THEN 1 ELSE ROUND([EL1] * @ELRateChange, 2) END											AS [EL1]
		,[ExcessProperty]
		,[ExcessHeat]
		,[Endorsement]
		,[QuestionHeat]
		,[Question3Phase]
		,[Question3PhaseRequired]
		,[QuestionPDH]
		,[QuestionPDHRequired]
		,[QuestionMaximumDepthMin]
		,[QuestionMaximumDepthMax]
		,[QuestionHeatRequired]
		,[QuestionMaximumHeightMin]
		,[QuestionMaximumHeightMax]
		,[QuestionPaving]
		,[QuestionPavingRequired]
		,[Refer]
		,[PriceMatchCapPct]
		,CONVERT(date, GETDATE())																					AS [StartDatetime]
		,NULL																										AS [EndDatetime]
		,[IsMinPremAppl]
	FROM
		[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
	WHERE
		[EndDatetime] = CONVERT(date, GETDATE())

END;


-- ===
-- CAR
-- ===

IF ISNULL(@CARRateChange, 0) <> 0
BEGIN

	-- Expire current rows:

	UPDATE [dbo].[MLIAB_Covea_CAR_Rates]
	SET [EndDatetime] = CONVERT(date, GETDATE())
	WHERE [EndDateTime] IS NULL
	AND [Premium] <> 0


	-- Insert new records:

	INSERT INTO [dbo].[MLIAB_Covea_CAR_Rates](
		 [CoverType]
		,[CoverStartRange]
		,[CoverEndRange]
		,[TradeBand]
		,[EmployeesPL]
		,[Premium]
		,[StartDateTime]
		,[EndDateTime]
		,[InsertDateTime]
		,[UserID]
	)
	SELECT 
		 [CoverType]
		,[CoverStartRange]
		,[CoverEndRange]
		,[TradeBand]
		,[EmployeesPL]
		,ROUND([Premium] * @CARRateChange, 2)																		AS [Premium]
		,CONVERT(date, GETDATE())																					AS [StartDateTime]
		,NULL																										AS [EndDateTime]
		,GETDATE()																									AS [InsertDateTime]
		,CASE
			WHEN CHARINDEX('\', SYSTEM_USER) > 0 THEN SUBSTRING(SYSTEM_USER, CHARINDEX('\', SYSTEM_USER) +1, 30) 
			ELSE LEFT(SYSTEM_USER, 30)
		 END																										AS [UserID]
	FROM
		[dbo].[MLIAB_Covea_CAR_Rates]
	WHERE
		[EndDatetime] = CONVERT(date, GETDATE())

END;


-- =====
-- Tools
-- =====

IF ISNULL(@ToolsRateChange, 0) <> 0
BEGIN

	-- Expire current rows:

	UPDATE [dbo].[MLIAB_Covea_TradesmanLiability_RatesTools] 
	SET [EndDatetime] = CONVERT(date, GETDATE())
	WHERE [EndDatetime] IS NULL;


	-- Insert new records:

	INSERT INTO [dbo].[MLIAB_Covea_TradesmanLiability_RatesTools] (
		 [SumsInsuredRangeMin]
		,[SumsInsuredRangeMax]
		,[PremiumStandardPlus]
		,[StartDatetime]
		,[EndDatetime]
	)
	SELECT
		 [SumsInsuredRangeMin]
		,[SumsInsuredRangeMax]
		,ROUND([PremiumStandardPlus] * @ToolsRateChange, 2)															AS [PremiumStandardPlus]
		,CONVERT(date, GETDATE())																					AS [StartDatetime]
		,NULL																										AS [EndDatetime]
	FROM
		[dbo].[MLIAB_Covea_TradesmanLiability_RatesTools]
	WHERE
		[EndDatetime] = CONVERT(date, GETDATE())

END;


-- ===============
-- Fixed Machinery
-- ===============

IF ISNULL(@FixedMachineryRateChange, 0) <> 0
BEGIN

	-- Expire current rows:

	UPDATE [dbo].[MLIAB_Covea_TradesmanLiability_Rate]
	SET [EndDatetime] = CONVERT(date, GETDATE())
	WHERE [EndDatetime] IS NULL;


	-- Insert new records:

	INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_Rate](
		 [TypeName]
		,[Value]
		,[StartDatetime]
		,[EndDatetime]
	)
	SELECT
		 [TypeName]
		,ROUND([Value] * @FixedMachineryRateChange, 2)																AS [Value]
		,CONVERT(date, GETDATE())																					AS [StartDatetime]
		,NULL																										AS [EndDatetime]
	FROM
		[dbo].[MLIAB_Covea_TradesmanLiability_Rate]
	WHERE
		[EndDatetime] = CONVERT(date, GETDATE())

END;


-- ======================
-- Professional Indemnity
-- ======================

IF ISNULL(@PIRateChange, 0) <> 0
BEGIN

	-- Expire current rows:

	UPDATE [dbo].[MLIAB_Covea_ProfessionalIndemnity_Rate]
	SET [EndDatetime] = CONVERT(date, GETDATE())
	WHERE [EndDatetime] IS NULL;


	-- Insert new records:

	INSERT INTO [dbo].[MLIAB_Covea_ProfessionalIndemnity_Rate](
		 [RatingGroupID]
		,[TurnoverStartRange]
		,[TurnoverEndRange]
		,[PILimit]
		,[Rate]
		,[StartDateTime]
		,[EndDateTime]
		,[InsertDateTime]
		,[InsertUserID]
		,[UpdateDateTime]
		,[UpdateUserID]
	)
	SELECT
		 [RatingGroupID]
		,[TurnoverStartRange]
		,[TurnoverEndRange]
		,[PILimit]
		,ROUND([Rate] * @PIRateChange, 8)																			AS [Rate]
		,CONVERT(date, GETDATE())																					AS [StartDateTime]
		,NULL																										AS [EndDateTime]
		,GETDATE()																									AS [InsertDateTime]
		,CASE
			WHEN CHARINDEX('\', SYSTEM_USER) > 0 THEN SUBSTRING(SYSTEM_USER, CHARINDEX('\', SYSTEM_USER) +1, 30) 
			ELSE LEFT(SYSTEM_USER, 30)
		 END																										AS [InsertUserID]
		,GETDATE()																									AS [UpdateDateTime]
		,CASE
			WHEN CHARINDEX('\', SYSTEM_USER) > 0 THEN SUBSTRING(SYSTEM_USER, CHARINDEX('\', SYSTEM_USER) +1, 30) 
			ELSE LEFT(SYSTEM_USER, 30)
		 END																										AS [UpdateUserID]
	FROM
		[dbo].[MLIAB_Covea_ProfessionalIndemnity_Rate]
	WHERE
		[EndDatetime] = CONVERT(date, GETDATE())

END;


-- =================
-- Personal Accident
-- =================

IF ISNULL(@PARateChange, 0) <> 0
BEGIN

	-- Expire current rows:

	SELECT * FROM [dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates]
	WHERE [EndDatetime] IS NULL;

	UPDATE [dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates]
	SET [EndDatetime] = CONVERT(date, GETDATE())
	WHERE [EndDatetime] IS NULL;


	-- Insert new records:

	INSERT INTO [dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates](
		 [CoverType]
		,[CoverLevel]
		,[Premium]
		,[StartDateTime]
		,[EndDateTime]
		,[InsertDateTime]
		,[InsertUserID]
		,[UpdateDateTime]
		,[UpdateUserID]
	)
	SELECT
		 [CoverType]
		,[CoverLevel]
		,ROUND([Premium] * @PARateChange, 4)																		AS [Premium]
		,CONVERT(date, GETDATE())																					AS [StartDateTime]
		,NULL																										AS [EndDateTime]
		,GETDATE()																									AS [InsertDateTime]
		,CASE
			WHEN CHARINDEX('\', SYSTEM_USER) > 0 THEN SUBSTRING(SYSTEM_USER, CHARINDEX('\', SYSTEM_USER) +1, 10) 
			ELSE LEFT(SYSTEM_USER, 10)
		 END																										AS [InsertUserID]
		,GETDATE()																									AS [UpdateDateTime]
		,CASE
			WHEN CHARINDEX('\', SYSTEM_USER) > 0 THEN SUBSTRING(SYSTEM_USER, CHARINDEX('\', SYSTEM_USER) +1, 10) 
			ELSE LEFT(SYSTEM_USER, 10)
		 END																										AS [UpdateUserID]
	FROM
		[dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates]
	WHERE
		[EndDatetime] = CONVERT(date, GETDATE())

END;

GO