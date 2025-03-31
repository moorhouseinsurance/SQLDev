using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Moorhouse.Templates.SQL
{
    public class tvfSchemeDispatcher
    {

        public static string functionBody = @"
/******************************************************************************
-- Author:		
-- Date:        {Datetime}
-- Description: Abstraction level for calling Schemes so won't get wiped on LOB change regeneration.
*******************************************************************************/
ALTER FUNCTION [dbo].[{LOBName}_tvfSchemeDispatcher]
(
     @SchemeTableID int
	,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
	,@AgentID char(32)
	,@ClaimsSummary [dbo].[ClaimYearsSummaryTableType] READONLY
	,@EmployeeCounts [dbo].[EmployeeCountsTableType] READONLY
	,@RiskXML XML
{RiskTableParameters}
)
RETURNS @SchemeResults TABLE 
(
	SchemeResultsXML xml
)
AS
/*
	SELECT * FROM [dbo].[{LOBName}_tvfSchemeDispatcher] 
    (
         @SchemeTableID
	    ,@PolicyStartDateTime
        ,@PolicyQuoteStage
        ,@PostCode
	    ,@AgentID
	    ,@ClaimsSummary
	    ,@EmployeeCounts
	    ,@RiskXML XML
{RiskTablesListEOL}
    )
*/
BEGIN
	IF @SchemeTableID = {SchemeTableID}
	BEGIN
		INSERT INTO @SchemeResults
		SELECT [SchemeResultsXML]
		FROM [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfCalculator](@SchemeTableID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode ,@ClaimsSummary ,@EmployeeCounts{RiskTablesList})
	END

	--Refer Scheme
	IF @SchemeTableID in ()  
	BEGIN
		DECLARE  @Refer SchemeResultTableType
				,@Decline SchemeResultTableType
				,@Excess SchemeResultTableType
				,@Summary SchemeResultTableType
				,@Breakdown SchemeResultTableType
				,@ProductDetail SchemeResultTableType	
				,@Premiums SchemeResultPremiumTableType
				,@Endorsement SchemeResultEndorsementTableType
			
		INSERT INTO @Premiums ([Name] ,[Value]) VALUES {PremiumSectionDefaultValue}	
		INSERT INTO @Refer VALUES('Automatic Referral')
		INSERT INTO @SchemeResults values ([dbo].[svfSchemeResultsXML](@Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premiums ,@Endorsement))
	END
	RETURN 
END
";

        public static string RiskTableParameter = "\t" + @",@{FormName} [dbo].[{LOBName}_{FormName}TableType] READONLY
";
		public static string PremiumSectionDefaultValue = "('{PremiumSection}',1),";

	}
}

