USE [Calculators]
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create date: 18 Mar 2025
-- Description:	Increase or decrease rates for Covea Small Business and Consultants Liability (expires existing rows in the rate tables and inserts
--				new rows with all rates	increased or decreased by the amount specified in input parameters)
-- =============================================

ALTER PROCEDURE [dbo].[MLIAB_Covea_SmallBusiness_uspRateChange]
	 @PLRateChange decimal (5,3)
	,@ELRateChange decimal (5,3)
AS

/*

-- Set the increase or decrease as a decimal, for example:
-- 1.1 = 10% rate increase
-- 0.9 = 10% rate decrease
-- 0 = no change for this section (no records will be updated)

DECLARE @PLRateChange decimal (5,3) = 0.9 -- Public Liability
DECLARE @ELRateChange decimal (5,3) = 0.9 -- Employers Liability

EXEC [dbo].[MLIAB_Covea_SmallBusiness_uspRateChange] @PLRateChange, @ELRateChange

*/


-- =======
-- PL & EL
-- =======

IF ISNULL(@PLRateChange, 0) <> 0 OR ISNULL(@ELRateChange, 0) <> 0
BEGIN

	-- Expire current rows:

	UPDATE [dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL]
	SET [EndDatetime] = CONVERT(date, GETDATE())
	WHERE [EndDatetime] IS NULL;


	-- Insert new records:

	INSERT INTO [Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL](
		 [TradeID]
		,[TradeDescriptionInsurer]
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
		,[Endorsements]
		,[ELLimitText]
		,[PriceMatchCapPct]
		,[Refer]
		,[StartDatetime]
		,[EndDatetime]
		,[InsertDateTime]
		,[InsertUserID]
	)
	SELECT 
		 [TradeID]
		,[TradeDescriptionInsurer]
		,[LevelOfIndemnity]
		,ROUND([PL1] * @PLRateChange, 2)																			AS [PL1]
		,ROUND([PL2] * @PLRateChange, 2)																			AS [PL2]
		,ROUND([PL3] * @PLRateChange, 2)																			AS [PL3]
		,ROUND([PL4] * @PLRateChange, 2)																			AS [PL4]
		,ROUND([PL5] * @PLRateChange, 2)																			AS [PL5]
		,ROUND([PL6] * @PLRateChange, 2)																			AS [PL6]
		,ROUND([PL7] * @PLRateChange, 2)																			AS [PL7]
		,ROUND([PL8] * @PLRateChange, 2)																			AS [PL8]
		,ROUND([PL9] * @PLRateChange, 2)																			AS [PL9]
		,ROUND([PL10] * @PLRateChange, 2)																			AS [PL10]
		,ROUND([EL1] * @ELRateChange, 2)																			AS [EL1]
		,[ExcessProperty]
		,[Endorsements]
		,[ELLimitText]
		,[PriceMatchCapPct]
		,[Refer]
		,CONVERT(date, GETDATE())																					AS [StartDatetime]
		,NULL																										AS [EndDatetime]
		,GETDATE()																									AS [InsertDateTime]
		,CASE
			WHEN CHARINDEX('\', SYSTEM_USER) > 0 THEN SUBSTRING(SYSTEM_USER, CHARINDEX('\', SYSTEM_USER) +1, 30) 
			ELSE LEFT(SYSTEM_USER, 30)
		 END																										AS [InsertUserID]
	FROM [Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL]
	WHERE [EndDatetime]  = CONVERT(date, GETDATE())

END;

GO