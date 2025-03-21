USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_tvfTrades]    Script Date: 18/03/2025 16:33:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--========================================
-- Author:	Created by DHostler 
-- Create date: 15-Mar-2010
-- Description: Return Trade details rates and Refers.
-- =============================================

-- Date			Who						Change
-- 24/01/2024	Jeremai Smith			Added DeclineTradeNB (Monday.com ticket 5903075954)
-- 08/10/2024   Linga                   Added IsMinPremAppl  (Monday.com Ticket 6185012180)
-- 18/03/2025	Simon					Added PL11-15 (8720586881)


ALTER FUNCTION [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_tvfTrades]
(
	 @Trade varchar(250)
	,@TradeID varchar(8)
    ,@PolicyQuoteStage varchar(8)
    ,@PolicyQuoteStageMTA bit
	,@PolicyStartDateTime datetime
	,@CInfo_PubLiabLimit varchar(20)
	,@CInfo_WorkSoley bit
	,@TrdDtail_Phase bit
	,@CInfo_Heat bit
	,@TrdDtail_Paving bit
	,@CInfo_MaxHeight varchar(20)
	,@TrdDtail_MaxDepth varchar(20)
	,@EmployeesPL  int
	,@EmployeesELManual int
)
Returns @ReturnTable table
(
	 [Trade] varchar(250)
	,[ReferTrade] varchar(250)
	,[Refer_ReferFlag] varchar(250)
	,[ReferCInfo_PubLiabLimit] varchar(250)
	,[ReferCInfo_WorkSoley] varchar(250)
	,[ReferTrdDtail_Phase] varchar(250)
	,[ReferCInfo_Heat] varchar(250)
	,[ReferTrdDtail_Paving] varchar(250)
	,[ReferCInfo_MaxHeight] varchar(250)
	,[ReferTrdDtail_MaxDepth] varchar(250)
	,[ReferEmployeesPL] varchar(250)
	,[ReferEmployeeEL] varchar(250)
	,[TradeDescriptionInsurer] varchar(250)
	,[ReferBuilder] varchar(250)
	,[PL] money
	,[EL] money
	,[ExcessProperty] BIGINT
	,[ExcessHeat] BIGINT
	,[Endorsement] varchar(250)
	,[DeclineTrade] varchar(250)
	,[DeclineTradeNB] varchar(250)
    ,[IsMinPremAppl] BIT
)
AS

/*

SELECT * FROM [MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL] WHERE EL1 = 0 = 'TRUE'

DECLARE
   @Trade varchar(250) = 'Builder'
  ,@TradeID varchar(8) ='3N0TV8G9'
  ,@PolicyQuoteStage varchar(8) = 2
  ,@PolicyQuoteStageMTA bit = 0
  ,@PolicyStartDateTime datetime = '19 Mar 2025'
  ,@CInfo_PubLiabLimit varchar(20) = '£1,000,000'
  ,@CInfo_WorkSoley bit = 0
  ,@TrdDtail_Phase bit = 0
  ,@CInfo_Heat bit = 0
  ,@TrdDtail_Paving bit = 0
  ,@CInfo_MaxHeight varchar(20) = '5'
  ,@TrdDtail_MaxDepth varchar(20) = '0'
  ,@EmployeesPL int = 15
  ,@EmployeesELManual int = 1
  
SELECT * FROM [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_tvfTrades] 
	(
		 @Trade
		,@TradeID
		,@PolicyQuoteStage
		,@PolicyQuoteStageMTA
		,@PolicyStartDateTime
		,@CInfo_PubLiabLimit
		,@CInfo_WorkSoley
		,@TrdDtail_Phase
		,@CInfo_Heat
		,@TrdDtail_Paving
		,@CInfo_MaxHeight
		,@TrdDtail_MaxDepth
		,@EmployeesPL
		,@EmployeesELManual
	 )
GO

*/

BEGIN

	DECLARE @AdditionalTradeLookup VARCHAR(12) = 'Standard'

	IF @Trade = 'Bricklayer'
	BEGIN
		SET @AdditionalTradeLookup = 'BLD15MAX'
		IF @CInfo_MaxHeight = 'Over 15' 
			SET @AdditionalTradeLookup = 'STANDARD'
	END

	IF @TradeID IN ('3N0TV8G9' ,'3N0TV8H9', '3N0TV8J9') -- 'Builder', 'Builder (Private Dwellings, Offices & Shops) - Alteration & Repair', 'Builder (Private Dwellings, Offices & Shops) - New Build'
	BEGIN
		IF @CInfo_WorkSoley = 1
		SET @AdditionalTradeLookup = 'BLDPREMREST'
		ELSE BEGIN
			SET @AdditionalTradeLookup = 'BLD15MAX'
			IF @CInfo_MaxHeight = 'Over 15' 
				SET @AdditionalTradeLookup = 'STANDARD'
		END
	END

	;WITH [R] AS
	(
		SELECT [T].* 
				,CASE WHEN  @CInfo_PubLiabLimit = [T].[LevelOfIndemnity] THEN 1 ELSE 0 END AS [CInfo_PubLiabLimit_OK]
				,CASE WHEN (@CInfo_WorkSoley = [T].[QuestionPDH] OR [T].[QuestionPDHRequired] = 'False') THEN 1 ELSE 0 END AS [CInfo_WorkSoley_OK]
				,CASE WHEN (@TrdDtail_Phase = [T].[Question3Phase] OR [T].[Question3PhaseRequired] = 'False') THEN 1 ELSE 0 END AS [TrdDtail_Phase_OK]
				,CASE WHEN (@CInfo_Heat = [T].[QuestionHeat]	OR [T].[QuestionHeatRequired] = 'False') THEN 1 ELSE 0 END AS [CInfo_Heat]
				,CASE WHEN (@TrdDtail_Paving = [T].[QuestionPaving] OR [T].[QuestionPavingRequired] = 'False') THEN 1 ELSE 0 END AS [TrdDtail_Paving_OK]
				,CASE WHEN (LEN(@CInfo_MaxHeight) <= LEN(CAST([T].[QuestionMaximumHeightMax] AS varchar(10))) AND [dbo].[svfFormatNumber](@CInfo_MaxHeight) <= [dbo].[svfFormatNumber]([T].[QuestionMaximumHeightMax])) OR ([T].[QuestionMaximumHeightMax] = 0 AND [T].[QuestionMaximumHeightMin] = 0)  THEN 1 ELSE 0 END AS [CInfo_MaxHeight_OK]
				,CASE WHEN ([dbo].[svfStripNonNumericCharacters](@TrdDtail_MaxDepth)  BETWEEN [T].[QuestionMaximumDepthMIN] AND [T].[QuestionMaximumDepthMax]) OR ([T].[QuestionMaximumDepthMIN]  = 0 AND  [T].[QuestionMaximumDepthMax] = 0 AND [T].[QuestionPavingRequired] = 0)  THEN 1 ELSE 0 END AS [TrdDtail_MaxDepth_OK]
				,CASE @EmployeesPL 
					WHEN 0 THEN 0
					WHEN 1 THEN [T].[PL1]
					WHEN 2 THEN [T].[PL2]
					WHEN 3 THEN [T].[PL3]
					WHEN 4 THEN [T].[PL4]		
					WHEN 5 THEN [T].[PL5]
					WHEN 6 THEN [T].[PL6]
					WHEN 7 THEN [T].[PL7]
					WHEN 8 THEN [T].[PL8]
					WHEN 9 THEN [T].[PL9]
					WHEN 10 THEN [T].[PL10]
					WHEN 11 THEN [T].[PL11]
					WHEN 12 THEN [T].[PL12]
					WHEN 13 THEN [T].[PL13]
					WHEN 14 THEN [T].[PL14]
					WHEN 15 THEN [T].[PL15]
					ELSE 0
				 END AS [PL]
				 ,[EL1] AS [EL]
		FROM
			[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL] AS [T]
			LEFT JOIN [dbo].[BusinessTransactionType] AS [BTT] ON [T].[BusinessTransactionTypeID] = [BTT].[BusinessTransactionTypeID] 
		WHERE
			[T].[TradeID] = @TradeID
			AND [T].[AdditionalTradeLookup] = @AdditionalTradeLookup
			AND [StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([EndDatetime] , @PolicyStartDateTime + 1)
			AND ([T].[BusinessTransactionTypeID] IS NULL OR [BTT].[TGSLReference] = @PolicyQuoteStage)
	)
	,[R1] AS
	(
		SELECT TOP 1
			*
		FROM
			[R]
		ORDER BY
			 [CInfo_PubLiabLimit_OK] DESC
			,([CInfo_WorkSoley_OK] 
			+[TrdDtail_Phase_OK] 
			+[CInfo_Heat] 
			+[TrdDtail_Paving_OK]
			+[CInfo_MaxHeight_OK] 
			+[TrdDtail_MaxDepth_OK]) DESC
			,[BusinessTransactionTypeID] DESC
			,[PL] ASC
	)
	INSERT INTO @ReturnTable
	SELECT 
		@Trade
		,NULL AS [ReferTrade]
		,CASE WHEN [Refer] = 1 AND @PolicyQuoteStageMTA = 0 THEN 'Refer to Underwriting before continuing for trade ' + @Trade END AS [Refer_ReferFlag]
		,CASE WHEN [CInfo_PubLiabLimit_OK] = 1 THEN NULL ELSE 'Level of Indemnity ' + @CInfo_PubLiabLimit + ' not available for ' + @Trade  END AS [ReferCInfo_PubLiabLimit]
		,CASE WHEN [CInfo_WorkSoley_OK] = 1 THEN NULL ELSE 'Working Solely on Private dwellings ' + CASE WHEN [QuestionPDH] = 0 THEN 'cannot be selected ' ELSE 'must be selected ' END + 'for '+ @Trade + ' in combination with your other answers'   END AS [ReferCInfo_WorkSoley]
		,CASE WHEN [TrdDtail_Phase_OK] = 1 THEN NULL  ELSE 'Three phase ' + CASE WHEN [Question3phase] = 0 THEN 'cannot be selected' ELSE 'must be selected ' END + 'for '+ @Trade + ' in combination with your other answers'    END AS [ReferTrdDtail_Phase]
		,CASE WHEN [CInfo_Heat] = 1 THEN NULL  ELSE 'Heat use ' + CASE WHEN [QuestionHeat] = 0 THEN 'cannnot be selected' ELSE 'must be selected ' END + 'for '+ @Trade + ' in combination with your other answers'    END AS [ReferCInfo_Heat]
		,CASE WHEN [TrdDtail_Paving_OK] = 1 THEN NULL  ELSE 'Working on Paves ,drives or patios ' + CASE WHEN [QuestionPaving] = 0 THEN 'cannnot be selected' ELSE 'must be selected ' END + 'for '+ @Trade + ' in combination with your other answers'    END AS [ReferTrdDtail_Paving]
		,CASE WHEN [CInfo_MaxHeight_OK] = 1 THEN NULL ELSE 'Maximum Height level ' + @CInfo_MaxHeight + 'm must be ' + CAST([QuestionMaximumHeightMax] AS varchar(10)) +  'm or less for '+ @Trade + 'in combination with your other answers' END AS [ReferCInfo_MaxHeight]
		,CASE WHEN [TrdDtail_MaxDepth_OK] = 1 THEN NULL ELSE 'Maximum depth of ' + @TrdDtail_MaxDepth + 'm is not within an acceptable range for '+ @Trade + ' in combination with your other answers' END AS [ReferTrdDtail_MaxDepth]
		,CASE WHEN ISNULL([PL],0) != 0 THEN NULL ELSE 'No Public Liability rates available for ' + CAST(@EmployeesPL AS varchar(2)) + ' employees for '+ @Trade END AS [ReferEmployeesPL]
		,CASE WHEN ISNULL([EL],0) = 0  AND @EmployeesELManual != 0 THEN 'No Employee Liability rates available for ' + @Trade  ELSE NULL   END AS [ReferEmployeesEL]
		,CASE WHEN @Trade LIKE 'Builder%' AND @CInfo_MaxHeight = 'Over 15' AND @CInfo_WorkSoley = 1 THEN 'Premises Restriction and over height Limit for '+ @Trade END AS [ReferBuilder]
		,[TradeDescriptionInsurer]
		,[PL]
		,[EL]
		,[ExcessProperty]
		,[ExcessHeat]
		,[Endorsement]
		,CASE WHEN [Decline] = 1 AND @PolicyQuoteStageMTA = 0  THEN 'Declined. Trade ' + @Trade + ' is no longer rated' END AS [DeclineTrade]
		,CASE WHEN [DeclineNB] = 1 AND @PolicyQuoteStage = 'NB'  THEN 'Decline all ' + @Trade + ' trade for New Business' END AS [DeclineTradeNB]
		,[IsMinPremAppl]
	FROM
		[R1]

	IF @@rowcount = 0
	INSERT INTO @ReturnTable ([Trade] ,[ReferTrade]) VALUES (@Trade ,'Trade ' + @Trade +' is not currently rated')

    RETURN
    
END
