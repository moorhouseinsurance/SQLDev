USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_AXA_TradesmanLiability_tvfCapAndCollar]    Script Date: 21/01/2025 23:06:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------
 -- Date		03 Aug 2020
 -- Author		D. Hostler
 -- Desc		Return Last bought historyID for a Policy
 ------------------------------------------------------------

ALTER FUNCTION  [dbo].[MLIAB_AXA_TradesmanLiability_tvfCapAndCollar]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
	,@InceptionStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
	,@ClaimsSummary ClaimSummaryTableType READONLY
	,@EmployeeCounts EmployeeCountsTableType READONLY
	,@TrdDtail MLIAB_TrdDtailTableType READONLY
	,@CInfo MLIAB_CInfoTableType READONLY
	,@PandP MLIAB_PandPTableType READONLY
	,@BusSupp MLIAB_BusSuppTableType READONLY
	,@Subsid MLIAB_SubsidTableType READONLY
	,@CAR MLIAB_CARTableType READONLY
	,@Claim ClaimTableType READONLY
)

RETURNS int
AS


BEGIN

	IF @PolicyQuoteStage  = 'REN'
	BEGIN
		DECLARE @PolicyDetailsID char(32) = (SELECT [PolicyDetailsID] FROM @TrdDtail)
		DECLARE @HistoryID int = [Transactor_Support].[dbo].[svfLastPurchasedHistoryID] (@PolicyDetailsID)
		DECLARE @PreviousRiskCheckSum bigint =  [Transactor_Support].[dbo].[svfRiskCheckSum] (@PolicyDetailsID ,@HistoryID)
		DECLARE @CurrentRiskCheckSum bigint = 
		(
			SELECT TOP 1 
			CHECKSUM(
				 [T].[PRIMARYRISK_ID]
				,[T].[SecondaryRisk_ID] 
				,ISNULL([C].[MANUALEMPS],0)
				,ISNULL([C].[MANUALDIRECTORS],0) 
				,ISNULL([C].[TOTALEMPLOYEES],0) 
				,ISNULL([C].[TOTALPANDP],0)
				,ISNULL([C].[NONMANUALEMPS],0)
				,ISNULL([C].[NONMANUDIREC],0)
				,ISNULL([C].[TEMPINSURANCE],0)
				,ISNULL([T].[PHASE],0) 
				,[T].[MAXDEPTH_ID] 
				,[C].[MAXHEIGHT_ID]
				,[C].[PUBLIABLIMIT_ID]  
				,[C].[TOOLVALUE_ID]  
				,ISNULL([C].[TOOLCOVER],0) 
				,ISNULL([C].[EMPLOYEETOOL],0) 
			)
			FROM 
				@TrdDtail AS [T]  
				CROSS APPLY @CInfo AS [C]
		)
    END  
	RETURN 1
END
