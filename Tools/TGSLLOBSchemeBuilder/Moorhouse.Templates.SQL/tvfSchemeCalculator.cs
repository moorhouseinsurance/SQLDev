using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Moorhouse.Templates.SQL
{
    public class tvfSchemeCalculator
    {
        public static string functionBody = @"

/******************************************************************************
-- Author:		System Generated
-- Date:        {Datetime}
-- Description: Return Scheme Information
*******************************************************************************/

ALTER FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfCalculator]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
	,@AgentID char(32)
	,@RiskXML XML
	,@ClaimsSummary [dbo].[ClaimYearsSummaryTableType] READONLY
	,@EmployeeCounts [dbo].[EmployeeCountsTableType] READONLY
{RiskTableParameters}
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
			
	INSERT INTO @Premiums VALUES {PremiumList};


--Assign required risk table values to variables
--e.g.
--	DECLARE	@TrdDtail_SecondaryRisk varchar(250) = SELECT @TrdDtail_SecondaryRisk = SecondaryRisk FROM @TrdDtail

--Assign required Claims table values to variables
--e.g.
--	DECLARE  @ClaimsInLast5Years int = (SELECT [Count5Years] FROM @ClaimsSummary)

--Assign required Employee table values to variables
--e.g.
--	DECLARE @EmployeesELManual int = (SELECT [EmployeesELManual] FROM @EmployeeCounts)

--Assign required Limit table values to variables
--e.g.
--	DECLARE  @LimitEmployersLiability int = (SELECT [dbo].[svfLimitSelect]( @Insurer ,@LineOfBusiness ,'EmployersLiability' ,'Max'	,@PolicyStartDateTime ))
	
--Assign required Load Discount table values to variables
--e.g.
--	DECLARE @DiscountRateEL money = (SELECT [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLoadDiscountEmployees] (@EmployeesELManual, @PolicyStartDateTime)) - 1

--Assign required Rate table values to variables
--e.g.
--	DECLARE @RateFixedMachinery int = (SELECT([dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfRate] ('FixedMachinery',@PolicyStartDateTime))


--Calculate Premium Sections and Insert Breakdowns
	DECLARE @Premium numeric(18, 4) = 0
	DECLARE @BasePremium money = 0
	DECLARE @TotalBasePremium money = 0
	DECLARE @TotalPremium money = 0
	DECLARE @PremiumSection char(8)
	DECLARE @Section varchar(50) 
--e.g.
/*
	SELECT	 @Section = 'Public Liability '
			,@PremiumSection = 'LIABPREM'
			,@Premium = @PLRate 

	IF @ClientDt_PubLiab = 1
	BEGIN
		SET @Premium = @Premium * @ClientDt_NumOfEmpsValue
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section + [dbo].[svfFormatMoneyString](@PLRate) + ' x ' + @ClientDt_NumOfEmps + ' Employees' ,null ,null ,@Premium))
		SET @BasePremium = @Premium

		SET @AgentLoadDiscountPremium = @Premium * @AgentLoadDiscountPercent
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString](@Section +' Agent Load/Discount' ,@AgentLoadDiscountPercent ,@Premium ,@AgentLoadDiscountPremium))	
		SET @Premium = @Premium + @AgentLoadDiscountPremium
		INSERT INTO @Breakdown	VALUES([dbo].[svfFormatBreakdownString]('Subtotal' ,NULL ,NULL ,@Premium))

		INSERT INTO @Breakdown	VALUES(	':::')--Blank line
		UPDATE @Premiums SET [Value] = ISNULL(@Premium,0) WHERE [Name] = @PremiumSection

		SET @TotalBasePremium = @TotalBasePremium + @BasePremium
		SET @TotalPremium = @TotalPremium + @Premium
		SET @TotalAgentLoadDiscountPremium = @TotalAgentLoadDiscountPremium + @AgentLoadDiscountPremium
	END
*/
	
--Insert Breakdown totals
--e.g.
/*
	INSERT INTO @Breakdown ([Message])	VALUES([dbo].[svfFormatBreakdownString]('Total Base Premium' ,NULL ,NULL ,@TotalBasePremium))
	INSERT INTO @Breakdown ([Message])	VALUES([dbo].[svfFormatBreakdownString]('Total No Claims Discount Premium' ,NULL ,NULL ,@TotalNoClaimsDiscountPremium))
	INSERT INTO @Breakdown ([Message] ,[Summary])	VALUES([dbo].[svfFormatBreakdownString]('Total Premium' ,NULL ,NULL ,@TotalPremium) ,1)

*/

--Min Premium
/* e.g.
	IF (@TotalPremium != 0) AND (@TotalPremium < @LimitPremiumRateMin)
	BEGIN
		UPDATE @Premiums SET [Value] = ([value]/@TotalPremium)* @LimitPremiumRateMin
		INSERT INTO @Breakdown ([Message])	VALUES('Minimum Premium:::')
		--INSERT INTO @Breakdown ([Message])	SELECT ([dbo].[svfFormatBreakdownString](CASE [NAME] WHEN 'LIABPREM' THEN 'Public Liability' WHEN 'EMPLPREM' THEN 'Employers Liability' WHEN 'TOOLPREM' THEN 'Tools' WHEN 'FXMCPREM' THEN 'Fixed Machinery' END + ' Premium' ,NULL ,NULL ,[Value])) FROM @Premiums WHERE [Value] != 0
		INSERT INTO @Breakdown ([Message] ,[Summary])	VALUES([dbo].[svfFormatBreakdownString]('Minimum Premium' ,NULL ,NULL ,@LimitPremiumRateMin) ,1)
	END
*/

--Binary Refer Declines
	INSERT INTO @Refer 
	SELECT [Message] FROM [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfReferOrDecline](@ClientDt_RiskTrade ,@RiskXml ,@PolicyStartDateTime ) WHERE [ReferDecline] = 'Refer'
	INSERT INTO @Decline 
	SELECT [Message] FROM [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfReferOrDecline](@ClientDt_RiskTrade ,@RiskXml ,@PolicyStartDateTime ) WHERE [ReferDecline] = 'Decline'	

--Refers
/* e.g.
	IF @CInfo_TempInsurance= 'True' AND @CInfo_ManDays > @CInfo_ManDaysLimitMax
	 	INSERT INTO @Refer VALUES ('More than ' + CAST(@CInfo_ManDaysLimitMax AS varchar(3)) +' days for temporary employees is not acceptable') 
*/

--Declines
/* e.g.
    DECLARE @SomeValue int ,@someothervalue int
	IF @SomeValue != @SomeOtherValue
		INSERT INTO @Decline([DeclineMessage])	VALUES( 'Cannot quote')
*/	

--Endorsements
/* e.g.
	INSERT INTO @Endorsement 
	SELECT [Token] FROM @TradeELPLTable CROSS APPLY [dbo].[tvfSplitStringByDelimiter]([Endorsement],',') WHERE ISNULL([Endorsement],'') !='' 
	
	IF @TrdDtail_FixedMachinery = 1
		DELETE FROM @Endorsement WHERE [Message] = 'MMALIA14'
*/

--Excesses '{Excess Desc}:{ExcessVal000}:{List_Excess_Section.Excess_Section_ID}:{LIST_EXCESSTYPE.ExcessType_ID}'
/* e.g.
	INSERT INTO @Excess 
	SELECT * FROM [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfExcess](@ExperienceYears ,@ExcessPropertyAmount ,@ExcessHeatAmount ,@CInfo_ToolCover ,@PolicyStartDatetime)
*/

--Product Details	
--e.g.
--	INSERT INTO @ProductDetail	VALUES(	'No Claims Discount = '+ CAST(@NoClaimsLoadDiscountRate*100 AS VARCHAR(10)) + '%')

--Policy Document Name
/* e.g.
    DECLARE @PolicyDocumentName Varchar(100) =	'Policy Wording Document Freelancer '
												+ CASE @TurnoverOrFeeRated WHEN 'Turnover' THEN 'Design & Construct ' ELSE '' END
												+ @ClientDt_CoverType
												+' Policy Wording'
												+ CASE @ClientDt_PubLiab WHEN 1 THEN ' Inc Liability' ELSE '' END
												+ '.pdf'

	INSERT INTO @ProductDetail
	VALUES (@PolicyDocumentName),(' ')
*/

--Return Table
	declare @SchemeResultsXML xml = [dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement)
	INSERT INTO @SchemeResults values (@SchemeResultsXML)

	RETURN
END

";

        public static string PremiumListValue = @",('{PremiumSection}',0)";

    }
}
