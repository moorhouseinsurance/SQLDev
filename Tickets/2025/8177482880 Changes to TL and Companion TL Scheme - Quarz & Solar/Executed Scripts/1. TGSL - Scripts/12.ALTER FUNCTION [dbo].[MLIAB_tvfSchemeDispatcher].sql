USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_tvfSchemeDispatcher]    Script Date: 14/01/2025 15:11:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/******************************************************************************
-- Author:		D. Hostler
-- Date:        29 Nov 2017
-- Description: Abstraction level for calling Schemes so won't get wiped on LOB change regeneration.
*******************************************************************************
-- Date			Who						Change
-- 15/12/2023	Linga        			Monday ticket 5584020485: Added New Scheme Toledo- Tradesman lIability
-- 09/07/2024	Linga        			Monday ticket 6988234190: Added New £ Scheme Corin Underwriting Limited -  Tradesman lIability
-- 16/09/2024   Linga                   Monday Ticket 6184964279: £10,000,000 PL Covea Rate - Added New input parameter @CInfo for MLIAB_Covea_PersonalAccidentAndIncomeProtection_tvfCalculator
--                                      to filter the level of indemnity
-- 18/12/2024	Simon					Defaulted Axa NB quotes to pound scheme 7859939201
-- 14/01/2025   Linga					Monday Ticket 8177482880: Changes to TL and Companion TL Scheme - Quarz & Solar
                                         -- Solution: Replaced [MLIAB_TrdDtailTableType] with new [MLIAB_TrdDtail_TableType] that contains the new fields

*******************************************************************************/
ALTER FUNCTION [dbo].[MLIAB_tvfSchemeDispatcher]
(
     @SchemeTableID int
    ,@PolicyDetailsID char(32)
    ,@PreviousPolicyHistoryID int
	,@PolicyStartDateTime datetime = NULL
	,@InceptionStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
	,@PolicyQuoteStageMTA bit    
    ,@PostCode varchar(12)
	,@AgentName varchar(255)
	,@ClaimsSummary ClaimSummaryTableType READONLY
	,@EmployeeCounts EmployeeCountsTableType READONLY
	,@TrdDtail MLIAB_TrdDtail_TableType READONLY
	,@CInfo MLIAB_CInfoTableType READONLY
	,@PandP MLIAB_PandPTableType READONLY
	,@BusSupp MLIAB_BusSuppTableType READONLY
	,@Subsid MLIAB_SubsidTableType READONLY
	,@CAR MLIAB_CARTableType READONLY
	,@AccIncom [dbo].[MLIAB_AccIncomTableType] READONLY
	,@PAPeople [dbo].[MLIAB_PAPeopleTableType] READONLY
	,@ProfIndm [dbo].[MLIAB_ProfIndmTableType] READONLY
	,@Claim ClaimTableType READONLY

)
RETURNS @SchemeResults TABLE 
(
	SchemeResultsXML xml
)
AS
/*
	SELECT * FROM [dbo].[MLIAB_tvfSchemeDispatcher] 
    (
         @SchemeTableID
	    ,@PolicyStartDateTime
		,@InceptionStartDateTime
        ,@PolicyQuoteStage
        ,@PostCode
	    ,@AgentID
        ,@BreakdownSummary
	    ,@ClaimsSummary
	    ,@EmployeeCounts
	    ,@RiskXML XML
		,@TrdDtail
		,@CInfo
		,@PandP
		,@BusSupp
		,@Subsid
		,@CAR
		,@AccIncom
		,@PAPeople
		,@ProfIndm
		,@Claim ClaimTableType
    )
*/
BEGIN

	DECLARE  @Refer SchemeResultTableType
			,@Decline SchemeResultTableType
			,@Excess SchemeResultTableType
			,@Summary SchemeResultTableType
			,@Breakdown SchemeResultTableType
			,@ProductDetail SchemeResultTableType	
			,@Premiums SchemeResultPremiumTableType
			,@Endorsement SchemeResultEndorsementTableType

	IF @SchemeTableID in (1325) --AXA
	BEGIN

		IF @PolicyQuoteStage = 'NB'
		BEGIN
			INSERT INTO @Premiums ([Name], [Value]) VALUES ('LIABPREM', 0.01), ('EMPLPREM', 0.01), ('PAASPREM', 0.01), ('PROFPREM', 0.01)
			INSERT INTO @Refer VALUES('Automatic Referral')
			INSERT INTO @SchemeResults values ([dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement))
		END
		ELSE
		BEGIN
			DECLARE @SchemeResults1 dbo.SchemeResultsXMLTableType
				
			INSERT INTO @SchemeResults1
			SELECT [SchemeResultsXML]
			FROM [dbo].[MLIAB_AXA_TradesmanLiability_tvfCalculator](@SchemeTableID ,@PreviousPolicyHistoryID ,@PolicyStartDateTime ,@InceptionStartDateTime ,@PolicyQuoteStage ,@PostCode  ,@ClaimsSummary ,@EmployeeCounts ,@TrdDtail ,@CInfo ,@PandP ,@BusSupp ,@Subsid ,@CAR ,@Claim ,@PolicyQuoteStageMTA)

			DECLARE @SchemeDetailsXML xml = (SELECT top 1 [SchemeResultsXML] FROM @SchemeResults1)
			INSERT INTO @SchemeResults1
			SELECT [SchemeResultsXML]
			FROM [dbo].[MLIAB_AXA_CAR_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@CInfo ,@CAR ,@SchemeDetailsXML ,@Postcode, @PolicyQuoteStageMTA)
		
			DECLARE @Checksum int = [dbo].[MLIAB_AXA_TradesmanLiability_svfRiskChecksum] (@PolicyQuoteStage ,@PolicyStartDateTime  ,@InceptionStartDateTime ,@EmployeeCounts ,@TrdDtail ,@CInfo ,@CAR ,@SchemeResults1)

			INSERT INTO @SchemeResults
			SELECT [SchemeResultsXML]
			FROM [dbo].[MLIAB_AXA_tvfCapAndCollar](@PolicyDetailsID ,@PreviousPolicyHistoryID ,@PolicyQuoteStage ,@PolicyStartDateTime ,@InceptionStartDateTime ,@SchemeResults1 ,@CheckSum)
		END

	END

	IF @SchemeTableID in (878)
	BEGIN
		INSERT INTO @SchemeResults
		SELECT [SchemeResultsXML]
		FROM [dbo].[MLIAB_Covea_TradesmanLiability_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode  ,@ClaimsSummary ,@EmployeeCounts ,@TrdDtail ,@CInfo ,@PandP ,@BusSupp ,@Subsid ,@CAR)

		UNION ALL SELECT [SchemeResultsXML]
		FROM [dbo].[MLIAB_Covea_CAR_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode  ,@ClaimsSummary ,@EmployeeCounts ,@TrdDtail ,@CInfo ,@PandP ,@BusSupp ,@Subsid ,@CAR)

		UNION ALL SELECT [SchemeResultsXML]
		FROM [dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@CInfo, @AccIncom ,@PAPeople ,@EmployeeCounts)

		UNION ALL SELECT [SchemeResultsXML]
		FROM [dbo].[MLIAB_Covea_ProfessionalIndemnity_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@ProfIndm ,@CInfo ,@TrdDtail)

	END

	IF @SchemeTableID in (1448,1484) --Companion - Tradesman Liability & Square Peg - Contractors All Risks
	BEGIN
		INSERT INTO @SchemeResults
		SELECT [SchemeResultsXML]
		FROM [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PolicyQuoteStageMTA ,@PostCode  ,@ClaimsSummary ,@EmployeeCounts ,@TrdDtail ,@CInfo ,@PandP ,@BusSupp ,@Subsid ,@CAR)

		UNION ALL SELECT [SchemeResultsXML]
		FROM [dbo].[MLIAB_TokioMarineHCC_CAR_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode  ,@ClaimsSummary ,@EmployeeCounts ,@TrdDtail ,@CInfo ,@PandP ,@BusSupp ,@Subsid ,@CAR)
	END

	IF @SchemeTableID in (1595, 1606) --Toledo - Tradesman Liability, BXB Tradesman Liability
	BEGIN
		INSERT INTO @SchemeResults
		SELECT [SchemeResultsXML]
		FROM [dbo].[MLIAB_Toledo_TradesmanLiability_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PolicyQuoteStageMTA ,@PostCode  , @AgentName, @ClaimsSummary ,@EmployeeCounts ,@TrdDtail ,@CInfo ,@PandP ,@BusSupp ,@Subsid ,@CAR)

		UNION ALL SELECT [SchemeResultsXML]
		FROM [dbo].[MLIAB_Toledo_CAR_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode  ,@ClaimsSummary ,@EmployeeCounts ,@TrdDtail ,@CInfo ,@PandP ,@BusSupp ,@Subsid ,@CAR)
	END

	--Refer Scheme
	IF @SchemeTableID in (1479,1488,1492, 1654) --Chapman & Stacey ,Square Peg ,Towergate, Corin Underwriting Limited
	BEGIN
		INSERT INTO @Refer VALUES('Automatic Referral')
		INSERT INTO @SchemeResults values ([dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement))
	END
	RETURN 
END
;
