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
-- Description: Return Scheme Information
*******************************************************************************/

CREATE PROCEDURE[dbo].[{LOBName}_uspCalculator]
	 @RiskXML XML
    ,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
    ,@SchemeTableID int
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
			,@Endorsement SchemeResultEndorsementTableType	
            ,@ClaimsSummary ClaimSummaryTableType

--Risk Tables
	SET @RiskXML = REPLACE(REPLACE(cast(@RiskXML AS varchar(max)), '> ', '>'), ' <', '<');

{RiskTables}
		
	DECLARE @SchemeInsurer varchar(1000) = (SELECT [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)

--Refers
	--Insurer 
	IF (SELECT CASE WHEN @PolicyQuoteStage = 'NB' AND [C].[Insurer] = @SchemeInsurer THEN 1 ELSE 0 END FROM {TableWithInsurerID} AS [C]) = 1
			INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)

	--Assumptions	
	INSERT INTO @Refer([Message])
	SELECT [Message] FROM [dbo].[{LOBName}_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime ,@SchemeTableID);

	--Claims
	DECLARE @ClaimsSummary ClaimSummaryTableType
    INSERT INTO @ClaimsSummary
	SELECT * FROM [dbo].[tvfClaimSummary](@RiskXML.query('./ClmSum') ,@PolicyStartDateTime )

	--Employees
	DECLARE @EmployeesPAndP int = (SELECT COUNT(*) FROM  @PandP WHERE [Status] IN ('Manual' ,'Work Away'))
	DECLARE @EmployeeCounts EmployeeCountsTableType
	INSERT INTO @EmployeeCounts
	SELECT [T].* FROM 
		@CInfo AS [C] 
		CROSS APPLY [dbo].[tvfEmployeeCounts]([C].[CompStatus] ,@EmployeesPAndP ,[C].[WorkAwayDirec] ,[C].[WorkAwayEmp] ,[C].[ClericalDirec] ,[C].[ClericalEmp] ,CASE WHEN [C].[CompStatus] LIKE 'Individual%' THEN 1 ELSE 0 END) AS [T]

	IF (SELECT [E].[EmployeesPL] FROM @EmployeeCounts AS [E]) IS NULL
			INSERT INTO @Decline VALUES ('No employees')	

	IF (SELECT [E].[EmployeesPL] FROM @EmployeeCounts AS [E]) = 0
			INSERT INTO @Decline VALUES ('You have not entered any manual workers')	

	IF (SELECT CASE WHEN [C].[CompStatus] = 'Limited' AND  ([C].[WorkAwayDirec] + [C].[ClericalDirec]) = 0 THEN 1 ELSE 0 END FROM @CInfo AS [C] ) = 1
			INSERT INTO @Refer VALUES ('Limited Company: Total Number of Directors are 0')

--Debugging
	IF @OutputRisk = 1
	BEGIN
{SelectRiskTables}
		SELECT * FROM @ClaimsSummary
		SELECT [Message] FROM [dbo].[MCLIAB_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime ,@SchemeTableID);
		SELECT * FROM @EmployeeCounts
		SELECT @PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode ,@SchemeTableID ,@SchemeInsurer
	END	

--tvfSchemeDispatcher
	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = [SchemeResultsXML] FROM [dbo].[{LOBName}_tvfSchemeDispatcher] (@SchemeTableID ,@VersionID ,@PolicyStartDateTime ,@PolicyQuoteStage ,@PostCode  ,@ClaimsSummary ,@EmployeeCounts ,{SchemeRiskTables})
 

--Shred Scheme results
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

	INSERT INTO @Premium
	SELECT	T.X.value('(./Name[text()])[1]', 'varchar(20)'),T.X.value('(./Value[text()])[1]', 'money') FROM @SchemeResultsXML.nodes('(//Premium)') AS T(x) 

--Table Counts
	DECLARE @ReferCount int = (SELECT COUNT(*) FROM @Refer)
	DECLARE @DeclineCount int = (SELECT COUNT(*) FROM @Decline)

--Summary
	INSERT INTO @Summary([Message])	VALUES(	'Quote Date :' + CONVERT(varchar(11) ,GETDATE(),106))
	INSERT INTO @Summary([Message])	VALUES(	'Quote is valid for 30 days' )

--Product Details		
	DECLARE @ExampleVariable int 
	INSERT INTO @ProductDetail([Message])	VALUES(	'Example Message = '+ [dbo].[svfFormatMoneyString](@ExampleVariable))

--Return Values
	DECLARE @Endorsements varchar(255) 
	SELECT 
		@Endorsements = COALESCE(@Endorsements + ',','') + [Message] 
	FROM 
		@Endorsement

--Refer Premiums.
	IF @ReferCount > 0 
	BEGIN
		DECLARE @EmployeesELManual int = 0
		SET @EmployeesELManual = (SELECT [EmployeesELManual] FROM @EmployeeCounts)

		UPDATE
			@Premium 
		SET 
			[Value] = 
			CASE 
				WHEN [Name] = 'ELPremium' AND @EmployeesELManual > 0 AND ISNULL([Value],0) = 0 THEN 1
				WHEN [Name] = 'PLPremium' AND ISNULL([Value],0) = 0 THEN 1
				ELSE [Value]
			END
	END


    --Pivot Return Table
{PivotTables}
	,[Premium] AS
	(
		SELECT {PremiumSectionList}
		FROM
		@Premium
		PIVOT
		(
		max([Value])
		FOR [Name] IN ({PremiumSectionList})
		) AS PivotTable
	)
	SELECT 
		* 
		,@Endorsements AS [Endorsement1]
		,CASE WHEN @ReferCount > 0 THEN 'True' ELSE 'False' END AS [Referral]
		,CASE WHEN @DeclineCount > 0 THEN 'True' ELSE 'False' END AS [Decline]		
	FROM 
		[Decline]
		FULL OUTER JOIN [Refer] ON 1 = 1
		FULL OUTER JOIN [ProductDetail] ON 1 = 1
		FULL OUTER JOIN [Breakdown] ON 1 = 1
		FULL OUTER JOIN [Excess] ON 1 = 1		
		FULL OUTER JOIN [Summary] ON 1 = 1			

END	

GO
";


    }
}

