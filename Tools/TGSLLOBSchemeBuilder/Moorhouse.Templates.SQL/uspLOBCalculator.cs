using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Moorhouse.Templates.SQL
{
    public class LOBCalculator
    {
        public static string ProcedureBody = @"
DROP PROCEDURE [dbo].[{LOBName}_uspCalculator]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Author:		System Generated
-- Date:        {Datetime}
-- Description: Boiler plate for translating wpd variables and returns can be regenerated apart from LOB level refers etc..
*******************************************************************************/

CREATE PROCEDURE[dbo].[{LOBName}_uspCalculator]
	 @RiskXML XML
    ,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
    ,@SchemeTableID int
	,@AgentName varchar(255)
    ,@SubAgentID char(32)
	,@OutputRisk bit = 0
AS
/*

    TRUNCATE TABLE [Transactor_Live].[dbo].[uspSchemeCommandDebug]
    SELECT * FROM [Transactor_Live].[dbo].[uspSchemeCommandDebug] WHERE [uspSchemeCommandText] LIKE '%{LOBName}_uspCalculator%'

	CREATE TABLE RiskXML (RiskXML xml);
	INSERT INTO RiskXML(RiskXML) values(@RiskXML);
*/

BEGIN
    SET NOCOUNT ON

	DECLARE  @Refer SchemeResultTableType
			,@Decline SchemeResultTableType
			,@Excess SchemeResultTableType
			,@Summary SchemeResultTableType
			,@Breakdown SchemeResultTableType
			,@ProductDetail SchemeResultTableType	
			,@Premium SchemeResultPremiumTableType
			,@Premium2 SchemeResultPremiumTableType
			,@Endorsement SchemeResultEndorsementTableType	

	-- PolicyStartDatetime:
	
	IF @PolicyStartDateTime = cast(getdate() AS date)
		SET @PolicyStartDatetime = getdate()

	
	-- Risk Tables:

	SET @RiskXML = REPLACE(REPLACE(cast(@RiskXML AS varchar(max)), '> ', '>'), ' <', '<');

{RiskTables}
	DECLARE @SchemeInsurer varchar(1000) = (SELECT [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)

	-- AgentID:

	DECLARE @AgentID char(32) = (SELECT [Agent_ID] FROM [RM_Agent] WHERE [Name] = @AgentName)

	
	-- Claims:
	
	DECLARE @ClaimsSummary [dbo].[ClaimSummaryTableType]
    INSERT INTO @ClaimsSummary
	SELECT * FROM [dbo].[tvfClaimSummary](@RiskXML.query('./ClmSum'), @PolicyStartDateTime )

	
	-- Employees:
	DECLARE @EmployeeCounts EmployeeCountsTableType

	-- Refers:

	--Insurer 
	--IF (SELECT CASE WHEN @PolicyQuoteStage = 'NB' AND [C].[Insurer] = @SchemeInsurer THEN 1 ELSE 0 END FROM {TableWithInsurerID} AS [C]) = 1
			--INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)


	-- Assumptions:
	
	INSERT INTO @Refer([Message])
	SELECT [Message] FROM [dbo].[{LOBName}_tvfReferredAssumptions](@RiskXML.query('./Assump'), @PolicyStartDateTime);


	-- Debugging:
	
IF @OutputRisk = 1
	BEGIN
{SelectRiskTables}
		SELECT * FROM @ClaimsSummary
		SELECT [Message] FROM [dbo].[{LOBName}_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);
		SELECT @PolicyStartDateTime AS [PolicyStartDateTime] ,@PolicyQuoteStage AS [PolicyQuoteStage] ,@PostCode AS [Postcode] ,@SchemeTableID AS [SchemeTableID] ,@SchemeInsurer AS [SchemeInsurer]
	END	


	--{LOBName}_tvfSchemeDispatcher:

	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM [dbo].[{LOBName}_tvfSchemeDispatcher] (@SchemeTableID, @PolicyStartDateTime, @PolicyQuoteStage, @PostCode, @AgentID, @ClaimsSummary, @EmployeeCounts, @RiskXML{RiskTablesList}) FOR XML PATH(''))
 

	-- Shred Scheme results:

	INSERT INTO @Decline
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(2000)') FROM @SchemeResultsXML.nodes('(//Decline)') AS T(x) 

	INSERT INTO @Refer
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(2000)') FROM @SchemeResultsXML.nodes('(//Refer)') AS T(x) 

	INSERT INTO @ProductDetail
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//ProductDetail)') AS T(x) 

	INSERT INTO @Breakdown
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Breakdown)') AS T(x) 

	INSERT INTO @Excess
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Excess)') AS T(x) 

	INSERT INTO @Summary
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Summary)') AS T(x) 

	INSERT INTO @Endorsement
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(50)') FROM @SchemeResultsXML.nodes('(//Endorsement)') AS T(x) 

	INSERT INTO @Premium ([Name] ,[Value] ,[PartnerCommission] ,[AgentCommission] ,[SubAgentCommission])
	SELECT	T.X.value('(./Name[text()])[1]', 'varchar(20)'),T.X.value('(./Value[text()])[1]', 'money'),0,0,0 FROM @SchemeResultsXML.nodes('(//Premium)') AS T(x) 

	
	-- Table Counts:

	DECLARE @ReferCount int = (SELECT COUNT(*) FROM @Refer)
	DECLARE @DeclineCount int = (SELECT COUNT(*) FROM @Decline)

	
	-- Summary:

	INSERT INTO @Summary([Message])	VALUES(	'Quote Date :' + CONVERT(varchar(11) ,GETDATE(),106))
	INSERT INTO @Summary([Message])	VALUES(	'Quote is valid for 30 days' )

	
	-- Product Details:
	
	--DECLARE @ExampleVariable int 
	--INSERT INTO @ProductDetail([Message])	VALUES(	'Example Message = '+ [dbo].[svfFormatMoneyString](@ExampleVariable))


	-- Endorsements:
	
	DECLARE @Endorsements varchar(255) 
	SELECT 
		@Endorsements = COALESCE(@Endorsements + ',','') + [Message] 
	FROM 
		@Endorsement

";


		public static string ProcedureBodyRTPResults = @"
	-- Rule Based commission and Premium adjustment:

	DECLARE 
		 @PolicyDetailsID varchar(32)
		,@HistoryID int
		,@LOB varchar(255) = 'Professional Indemnity'
		,@Trade varchar(255) 
		,@SecondaryTrade varchar(255) = 'None' 
		,@IndemnityLevel varchar(255) = @ClientDt_LimitOfIndem
		,@EmployeeLevel varchar(255)  = @ClientDt_NumOfEmps

		SELECT 
			 @PolicyDetailsID = '' --PolicyDetailsID 
			,@HistoryID = 1 -- HistoryID
			,@Trade = [RiskTrade]
		FROM
			@ClientDt

	SELECT @SchemeResultsXML = [dbo].[svfSchemeCommissionApportionment] (@SchemeTableID ,@AgentName ,@SubAgentID ,@PolicyQuoteStage ,@PolicyDetailsID ,@HistoryID ,@LOB ,@Trade ,@SecondaryTrade ,@IndemnityLevel ,@EmployeeLevel ,@Postcode ,@PolicyStartDateTime ,@Premium)

	INSERT INTO @ProductDetail
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//ProductDetail)') AS T(x) 

	INSERT INTO @Breakdown
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Breakdown)') AS T(x) 

	INSERT INTO @Premium2
	SELECT	T.X.value('(./Name[text()])[1]', 'varchar(20)'),T.X.value('(./Value[text()])[1]', 'money') ,ISNULL(T.X.value('(./PartnerCommission[text()])[1]', 'money'),0) ,ISNULL(T.X.value('(./AgentCommission[text()])[1]', 'money'),0) ,ISNULL(T.X.value('(./SubAgentCommission[text()])[1]', 'money'),0) FROM @SchemeResultsXML.nodes('(//Premium)') AS T(x) 
	
	--SELECT * FROM @Premium2
	EXECUTE [dbo].[uspSchemeResults] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium2 ,@Endorsement
END	

GO
";

		public static string ProcedureBodyResults = @"
	EXECUTE [dbo].[uspSchemeResults] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium ,@Endorsement
END	

GO
";


		public static string RiskTableTypeCreate = @"CREATE TYPE {LOBName}_{FormName}TableType AS TABLE
        (
{Tablecolumns}	
        )
";

        public static string RiskTableDeclare = "\t" + @"DECLARE @{FormName} {LOBName}_{FormName}TableType;
";

        public static string RiskTableInsert = "\t" + @"INSERT INTO @{FormName}({AnswerNames})
    SELECT
{SelectColumns}" + "\t" +@"FROM
		@RiskXML.nodes('(//{FormName})') AS T(x) --Lookup table
{SelectJoinListClause}
";

        public static string RiskTableColumn = @"        ,[{AnswerName}] {ColumnType}
";

        public static string SelectColumnXPath = @"T.X.value('(./{AnswerName}[text()])[1]', '{Datatype}')";

        public static string SelectColumnXPathIsNULL = @"ISNULL(T.X.value('(./{AnswerName}[text()])[1]', '{Datatype}'),0)";

        public static string SelectColumn = "\t\t" +@",{SelectColumnXPath} AS [{AnswerName}]
";

        public static string SelectJoinListClause = @"        JOIN [dbo].[{ListTableName}] AS [{ListTableAlias}] ON [{ListTableAlias}].[{ListColumnName}] = {SelectColumn}";

        public static string SelectListColumn = "\t\t" +@",[{ListTableAlias}].[{ListColumnName}_Debug] AS [{AnswerName}]
";

        public static string SelectRiskTable = "\t\t" +@"SELECT * FROM @{FormName};";

    }
}

