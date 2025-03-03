USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_Covea_TradesmanLiability_tvfTrades]    Script Date: 10/02/2025 07:31:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**************************************************************************
-- Author:	Created by DHostler 
-- Create date: 15-Mar-2010
-- Description: Return Trade details rates and Refers.
-- =======================================

-- Date			Who						Change
-- 16/09/2024   Linga                   Monday Ticket 6184964279: £10,000,000 PL Covea Rate - added new field [IsMinPremAppl]
-- 08/01/2025   Linga				    Monday Ticket 8177661129: Covea endorsement 20 - Applied extra filter to fetch the right data for Landscape Gardner
*******************************************************************************/

ALTER FUNCTION [dbo].[MLIAB_Covea_TradesmanLiability_tvfTrades]
(
	 @Trade varchar(250)
	,@TradeID varchar(8)
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
	,[IsMinPremAppl] BIT
)
AS

/*

SELECT * FROM [MLIAB_Covea_TradesmanLiability_TradePLEL] WHERE EL1 = 0 = 'TRUE'

DECLARE
   @Trade varchar(250) = 'Pipeline Consultancy'
  ,@TradeID varchar(8) ='AE0C3B05'
  ,@VersionID int = 1
  ,@CInfo_PubLiabLimit varchar(20) = '£10,000,000'
  ,@CInfo_WorkSoley bit = 1
  ,@TrdDtail_Phase bit = 1
  ,@CInfo_Heat bit = 1
  ,@TrdDtail_Paving bit = 1
  ,@CInfo_MaxHeight varchar(20) = '0'
  ,@TrdDtail_MaxDepth varchar(20) = '1'
  ,@EmployeesPL int = 12
  ,@EmployeesELManual int = 1
  
SELECT * FROM [dbo].[MLIAB_Covea_TradesmanLiability_tvfTrades] 
(
	   @Trade
	  ,@TradeID
	  ,@VersionID
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

	;WITH [R] AS
	(
		SELECT [T].* 
				,CASE WHEN  @CInfo_PubLiabLimit = [T].[LevelOfIndemnity] THEN 1 ELSE 0 END AS [CInfo_PubLiabLimit_OK]
				,CASE WHEN (@CInfo_WorkSoley = [T].[QuestionPDH] OR [T].[QuestionPDHRequired] = 'False') THEN 1 ELSE 0 END AS [CInfo_WorkSoley_OK]
				,CASE WHEN (@TrdDtail_Phase = [T].[Question3Phase] OR [T].[Question3PhaseRequired] = 'False') THEN 1 ELSE 0 END AS [TrdDtail_Phase_OK]
				,CASE WHEN (@CInfo_Heat = [T].[QuestionHeat]	OR [T].[QuestionHeatRequired] = 'False') THEN 1 ELSE 0 END AS [CInfo_Heat]
				,CASE WHEN (@TrdDtail_Paving = [T].[QuestionPaving] OR [T].[QuestionPavingRequired] = 'False') THEN 1 ELSE 0 END AS [TrdDtail_Paving_OK]
				,CASE WHEN ([dbo].[svfFormatNumber](@CInfo_MaxHeight)  BETWEEN [T].[QuestionMaximumHeightMin] AND [T].[QuestionMaximumHeightMax]) AND LEN(@CInfo_MaxHeight) <= LEN(CAST([T].[QuestionMaximumHeightMax] AS varchar(10))) OR ([T].[QuestionMaximumHeightMax] = 0 AND [T].[QuestionMaximumHeightMin] = 0)  THEN 1 ELSE 0 END AS [CInfo_MaxHeight_OK]
				,CASE WHEN ([dbo].[svfStripNonNumericCharacters](@TrdDtail_MaxDepth)  BETWEEN [T].[QuestionMaximumDepthMIN] AND [T].[QuestionMaximumDepthMax]) OR ([T].[QuestionMaximumDepthMIN]  = 0 AND  [T].[QuestionMaximumDepthMax] = 0)  THEN 1 ELSE 0 END AS [TrdDtail_MaxDepth_OK]
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
					ELSE 0
				 END AS [PL]
				 ,[EL1] AS [EL]
		FROM
			[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL] AS [T]
		WHERE ( @TradeID NOT IN ('3N0TVFI9') /*8177661129*/
			    AND [T].[TradeID] = @TradeID
			    AND [T].[StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([T].[EndDatetime] , @PolicyStartDateTime + 1)
			  )
		OR   (
		        @TradeID IN ('3N0TVFI9') /*8177661129*/
			    AND [T].[TradeID] = @TradeID
				AND [T].[QuestionPaving] = @TrdDtail_Paving
			    AND [T].[StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([T].[EndDatetime] , @PolicyStartDateTime + 1)
			 )
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
			,[PL] ASC
	)
	INSERT INTO @ReturnTable
	SELECT 
		@Trade
		,NULL AS [ReferTrade]
		,CASE WHEN [Refer] = 1 THEN 'Refer to Underwriting before continuing for trade ' + @Trade END AS [Refer_ReferFlag]
		,CASE WHEN [CInfo_PubLiabLimit_OK] = 1 THEN NULL ELSE 'Level of Indemnity ' + @CInfo_PubLiabLimit + ' not available for ' + @Trade  END AS [ReferCInfo_PubLiabLimit]
		,CASE WHEN [CInfo_WorkSoley_OK] = 1 THEN NULL ELSE 'Working Solely on Private dwellings ' + CASE WHEN [QuestionPDH] = 0 THEN 'cannot be selected ' ELSE 'must be selected ' END + 'for '+ @Trade + ' in combination with your other answers'   END AS [ReferCInfo_WorkSoley]
		,CASE WHEN [TrdDtail_Phase_OK] = 1 THEN NULL  ELSE 'Three phase ' + CASE WHEN [Question3phase] = 0 THEN 'cannot be selected' ELSE 'must be selected ' END + 'for '+ @Trade + ' in combination with your other answers'    END AS [ReferTrdDtail_Phase]
		,CASE WHEN [CInfo_Heat] = 1 THEN NULL  ELSE 'Heat use ' + CASE WHEN [QuestionHeat] = 0 THEN 'cannnot be selected' ELSE 'must be selected ' END + 'for '+ @Trade + ' in combination with your other answers'    END AS [ReferCInfo_Heat]
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
		,[IsMinPremAppl]
	FROM
		[R1]

	IF @@rowcount = 0
	BEGIN
		IF EXISTS (SELECT 1 FROM [dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL]
				   WHERE [TradeID] = @TradeID
				   AND [StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([EndDatetime] , @PolicyStartDateTime + 1))
			INSERT INTO @ReturnTable ([Trade] ,[ReferTrade]) VALUES (@Trade ,'Please quote trade ' + @Trade +' under Small Business question set')
		ELSE
			INSERT INTO @ReturnTable ([Trade] ,[ReferTrade]) VALUES (@Trade ,'Trade ' + @Trade +' is not currently rated')
	END

    RETURN
    
END
