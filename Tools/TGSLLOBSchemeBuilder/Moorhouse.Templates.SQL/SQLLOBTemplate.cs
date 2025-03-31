using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TGSLLOBSchemeBuilder.Templates.SQL
{
    public static class LOB
    {

        public static string TableLimit = @"IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Limit]') AND type in (N'U'))
	DROP TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Limit]


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Limit](
	[LimitID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Insurer] [varchar] (30),
	[LineOfBusiness] [varchar] (30),
	[LimitType] [varchar](30) NULL,
	[Minimum] [decimal](4, 2) NULL,
	[Maximum] [decimal](4, 2) NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[InsertDateTime] [datetime] NULL,
	[UserID] [varchar](10) NULL
) ON [PRIMARY]
GO
";

        public static string svfLOBLimitSelect = @"IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLimitSelect]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLimitSelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -----------------------------------------------------------
 -- Date		24 Jul 2018
 -- Author		D. Hostler
 -- Desc		Return Limit from generic table
 ------------------------------------------------------------

CREATE FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLimitSelect]
(
	 @Insurer [varchar] (8)
	,@LineOfBusiness [varchar] (30)
	,@LimitType [varchar](30) 
	,@MinOrMax char(3)
	,@PolicyStartDateTime datetime
)
Returns decimal(4,2)
AS
/*

DECLARE @Insurer [varchar] (8) = '{Insurer}'
	,@LineOfBusiness [varchar] (30) = '{LineOfBusiness}'
	,@LimitType [varchar](30) = ''
	,@MinOrMax char(3) = 'Min'
	,@PolicyStartDateTime datetime = getdate()

	SELECT [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_{Insurer}_{LineOfBusiness}_svfLimitSelect]( @Insurer ,@LineOfBusiness ,@LimitType	,@MinOrMax	,@PolicyStartDateTime )

*/
BEGIN
	DECLARE @Limit decimal(4,2);

	SELECT top 1
		@Limit = CASE WHEN @MinOrMax = 'Min' THEN [L].[Minimum] ELSE [L].[Maximum] END
	FROM
		[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Limit] AS [L]
	WHERE
			([L].[Insurer] = @Insurer OR [L].[Insurer] IS NULL)
		AND ([L].[LineOfBusiness] = @LineOfBusiness OR [L].[LineOfBusiness] IS NULL)
		AND ([L].[LimitType] = @LimitType OR [L].[LimitType] IS NULL)
        AND [StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([EndDatetime] ,@PolicyStartDateTime +1)
	ORDER BY 
		 [L].[Insurer] DESC
		,[L].[LineOfBusiness] DESC
		,[L].[LimitType] DESC
		
	RETURN @Limit
END
GO
";

        public static string TableLOBLimitInsert = @"INSERT INTO [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Limit] ([Insurer] ,[LineOfBusiness] ,[LimitType] ,[Minimum] ,[Maximum] ,[StartDateTime] ,[EndDateTime] ,[InsertDateTime] ,[UserID])
VALUES( '{Insurer}' ,'{LineOfBusiness}' ,'{LimitType}' ,NULL ,NULL ,'{RateStartDateTime}' ,NULL ,GETDATE() ,'System');

";

        public static string TableLOBAssumptions = @"IF EXISTS(SELECT* FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Assumption]') AND type in (N'U'))
	DROP TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Assumption]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Assumption]
(
	[AssumptionID] [int] IDENTITY(1,1) PRIMARY KEY,
    [AssumptionName] varchar(20),
	[Agree][varchar](8) NULL,
	[Text][varchar](8000) NULL,
	[StartDateTime][datetime]NULL,
	[EndDateTime][datetime]NULL,
	[InsertDateTime][datetime]NULL,
	[UserID][varchar](10) NULL
) ON [PRIMARY]
GO
";

        public static string tvfLOBReferredAssumptions = @"IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfReferredAssumptions]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfReferredAssumptions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -----------------------------------------------------------
 -- Date		24 Jul 2018
 -- Author D.Hostler
 -- Desc Return Referred Assumptions
 ------------------------------------------------------------

CREATE FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfReferredAssumptions]
(
	  @AssumptionXML xml
    , @PolicyStartDateTime datetime
)
Returns @Message table
(
    [Message] varchar(8000)
)
AS
/*

	DECLARE	 @AssumptionXML xml = '<Assump><Assumption1>a1</Assumption1><Assumption2>a2</Assumption2><Assumption3>a3</Assumption3></Assump>'
			,@PolicyStartDateTime datetime = GETDATE()

	SELECT * FROM [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfReferredAssumptions](@AssumptionXML	,@PolicyStartDateTime )

*/
BEGIN

    DECLARE @Agree varchar(8) = '3MQT5MC6'			

	DECLARE @Assumption table
    (
         [AssumptionName] varchar(20)
		,[Agree] varchar(8)
	)

	INSERT INTO @Assumption([AssumptionName], [Agree])
    SELECT
        T.X.value('local-name(.)','varchar(100)')
		,T.X.value('.','varchar(100)') 
	FROM
        @AssumptionXML.nodes('(./Assump/*)') AS T(x)

    INSERT INTO @Message
    SELECT
        CASE WHEN [A].[Agree] != @Agree THEN 'Disagree' ELSE 'Agree' END + ' to Assumption : ' + [ALOB].[Text] AS [Message]
    FROM
        @Assumption AS [A]
        JOIN [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Assumption] AS [ALOB] ON [A].[AssumptionName] = [ALOB].[AssumptionName]
    WHERE
        [A].[Agree] != [ALOB].[Agree]
		AND [ALOB].[StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([ALOB].[EndDatetime] ,@PolicyStartDateTime +1)
    RETURN
END
GO
";

        public static string TableLOBAssumptionInsert = @"INSERT INTO [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Assumption] ([AssumptionName] ,[Agree] ,[Text] ,[StartDateTime] ,[EndDateTime] ,[InsertDateTime] ,[UserID])
VALUES ( '{AnswerColumnName}' ,'3MQT5MC6'	,'{QuestionText}' ,'{RateStartDateTime}' ,NULL ,GETDATE() ,'System' );

";

        public static string tvfLOBClaims = @"
IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfClaims]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfClaims]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -----------------------------------------------------------
 -- Date		24 Jul 2018
 -- Author D.Hostler
 -- Desc Return  Claims Data
 ------------------------------------------------------------

CREATE FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfclaims]
(
	  @ClaimXML xml
    , @PolicyStartDateTime datetime
)
Returns @ClaimReturn table
(
     [SumOutstanding5Years] money
	,[SumOutstanding3Years] money
	,[SumPaid5Years] money
	,[SumPaid3Years] money
	,[Count3Years] int
	,[Count5Years] int
)
AS
/*

	DECLARE	 @ClaimXML xml = '<ClmSum><ClmDtail><Details>Details1</Details><Outstanding>1</Outstanding><Paid>1</Paid><Date>01 Jan 2018</Date><Type>3MQT5GL2</Type></ClmDtail>
<ClmDtail><Details>Details2</Details><Outstanding>2</Outstanding><Paid>2</Paid><Date>02 Jan 2018</Date><Type>3MQT5GL3</Type></ClmDtail>
<ClmDtail><Details>Details3</Details><Outstanding>3</Outstanding><Paid>3</Paid><Date>03 Jan 2018</Date><Type>3MQT5GM4</Type></ClmDtail></ClmSum>'
			,@PolicyStartDateTime datetime = GETDATE()

	SELECT * FROM [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfClaims](@ClaimXML	,@PolicyStartDateTime )

*/
BEGIN

	DECLARE @Claim table
    (
		 [Details] varchar(500)
		,[Outstanding] money
		,[Paid] money
		,[Date] datetime
		,[Type] varchar(255)
	)

	INSERT INTO @Claim( [Details] ,[Outstanding] ,[Paid]  ,[Date] ,[Type])
	SELECT
		 T.X.value('(./Details[text()])[1]', 'varchar(500)')  AS [Details]	
		,T.X.value('(./Outstanding[text()])[1]', 'money') AS [Outstanding]	
		,T.X.value('(./Paid[text()])[1]', 'money') AS [Paid]	
		,convert(datetime ,T.X.value('(./Date[text()])[1]', 'varchar(100)'),103) AS [Date]
		,[CT].[MH_CLAIMTYPE_DEBUG] AS [Type]
	FROM
		@ClaimXML.nodes('(//ClmDtail)') AS T(x)
		JOIN [dbo].[LIST_MH_CLAIMTYPE] AS [CT] ON [CT].[MH_CLAIMTYPE_ID] = T.X.value('(./Type[text()])[1]','varchar(8)')

   INSERT INTO @ClaimReturn
   SELECT
		 SUM(CASE WHEN [dbo].[svfAgeInYears]([Date] ,@PolicyStartDateTime) < 5 THEN [Outstanding] ELSE 0 END)	AS [SumOutstanding5Years]
		,SUM(CASE WHEN [dbo].[svfAgeInYears]([Date] ,@PolicyStartDateTime) < 3 THEN [Outstanding] ELSE 0 END)	AS [SumOutstanding3Years]
		,SUM(CASE WHEN [dbo].[svfAgeInYears]([Date] ,@PolicyStartDateTime) < 5 THEN [Paid] ELSE 0 END)			AS [SumPaid5Years]
		,SUM(CASE WHEN [dbo].[svfAgeInYears]([Date] ,@PolicyStartDateTime) < 3 THEN [Outstanding] ELSE 0 END)	AS [SumPaid3Years]
		,COUNT(CASE WHEN [dbo].[svfAgeInYears]([Date] ,@PolicyStartDateTime) < 3 THEN 1 ELSE 0 END)				AS [Count3Years]
		,COUNT(CASE WHEN [dbo].[svfAgeInYears]([Date] ,@PolicyStartDateTime) < 5 THEN 1 ELSE 0 END)				AS [Count5Years]
	FROM
		@Claim

    RETURN
END
GO

";

        public static string CalculatorXMLTable = @"   DECLARE @{FormName} table
	(
{Tablecolumns}	)

	INSERT INTO @{FormName}({AnswerNames})
    SELECT
{SelectColumns}FROM
		@RiskXML.nodes('(//{FormName})') AS T(x) --Lookup table
{SelectJoinListClause}
";

        public static string CalculatorXMLTableColumn = @"        ,[{AnswerName}] {ColumnType}
";

        public static string SelectColumnXPath = @"T.X.value('(./{AnswerName}[text()])[1]', '{Datatype}')";

        public static string SelectColumnXPathIsNULL = @"ISNULL(T.X.value('(./{AnswerName}[text()])[1]', '{Datatype}'),0)";

        public static string SelectColumn = @"     ,{SelectColumnXPath} AS [{AnswerName}]
";
        public static string SelectIntColumn = @"     ,ROUND(T.X.value('(./{AnswerName}[text()])[1]', '{Datatype}'),0) AS [{AnswerName}]
";

        public static string SelectListColumn = @"     ,[{ListTableAlias}].[{ListColumnName}_Debug] AS [{AnswerName}]
";
        public static string SelectJoinListClause = @"        JOIN [dbo].[{ListTableName}] AS [{ListTableAlias}] ON [{ListTableAlias}].[{ListColumnName}] = {SelectColumn}";


        public static string uspCalculator = @"DROP PROCEDURE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator]
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

CREATE PROCEDURE[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator]
	 @RiskXML XML
    ,@PolicyStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
    ,@SchemeTableID int

 AS
/*

truncate table uspSchemeCommandDebug
Select * from uspSchemeCommandDebug WHERE uspSchemeCommandText LIKE '%{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator%'

	CREATE TABLE RiskXML (RiskXML xml);
	INSERT INTO RiskXML(RiskXML) values(@RiskXML);
*/

BEGIN
    SET NOCOUNT ON


    DECLARE @Refer table
    (
         [ReferID] int IDENTITY (1,1)
		,[ReferMessage] nvarchar(2000)
	)		
	
	DECLARE @Decline table
    (
         [DeclineID] int IDENTITY (1,1)
		,[DeclineMessage] nvarchar(2000)
	)		
	
	DECLARE @Excess table
    (
         [ExcessID] int IDENTITY (1,1)
		,[ExcessMessage] nvarchar(2000)
	)	
	
	DECLARE @Summary table
    (
         [SummaryID] int IDENTITY (1,1)
		,[SummaryMessage] nvarchar(2000)
	)	
	
	DECLARE @Breakdown table
    (
         [BreakdownID] int IDENTITY (1,1)
		,[BreakdownMessage] nvarchar(2000)
	)	
	
	DECLARE @ProductDetail table
    (
         [ProductDetailID] int IDENTITY (1,1)
		,[ProductDetailMessage] nvarchar(2000)
	)

	DECLARE @Endorsement table
    (
         [EndorsementMessage] varchar(50)
	)	

{DeclarePremiumSections}

--Debug
--INSERT INTO @Decline(DeclineMessage) Values('@PolicyStartDateTime: ' +CONVERT(varchar(100),@PolicyStartDateTime,106))

--Risk Tables
	SET @RiskXML = REPLACE(REPLACE(cast(@RiskXML AS varchar(max)), '> ', '>'), ' <', '<');

{RiskTables}

--Limits

{Limits}

--Loads and Discounts

{LoadDiscount}

--Get Postcode Groups
--Get Exceses
--Get Rates
{Rates}

--Calculate Premiums and Insert Breakdowns

	DECLARE @SI int = 100000
    DECLARE @PremiumRateable decimal(10,2) = @SI/100
	INSERT INTO @Breakdown([BreakdownMessage])	VALUES([dbo].[svfFormatBreakdownString]('Sum Insured Rateable' ,0.01 ,@SI ,@PremiumRateable))	
	INSERT INTO @Breakdown([BreakdownMessage])	VALUES(	':::')--Blank line

--Min Premium


--Referrals
    DECLARE @SomePredicate bit = 'False'
	IF @SomePredicate = 'False'
	INSERT INTO @Refer([ReferMessage]) VALUES ('This circumstance is not allowed')
		
{AssumptionRefers}

--Declines
    DECLARE @SomeValue int ,@someothervalue int
	IF @SomeValue != @SomeOtherValue
		INSERT INTO @Decline([DeclineMessage])	VALUES( 'Cannot quote')	

--Endorsements
DECLARE @EndorsementID varchar(8) = 'ABC123'
	IF @SomePredicate = 'True'
		INSERT INTO @Endorsement VALUES (@EndorsementID)

{Excesses}

--Table Counts
	DECLARE @ReferCount int = (SELECT COUNT(*) FROM @Refer)
	DECLARE @DeclineCount int = (SELECT COUNT(*) FROM @Decline)

--Summary
	INSERT INTO @Summary([SummaryMessage])	VALUES(	'Quote Date :' + CONVERT(varchar(11) ,GETDATE(),106))
	INSERT INTO @Summary([SummaryMessage])	VALUES(	'Quote is valid for 30 days' )

--Product Details		
	DECLARE @ExampleVariable int 
	INSERT INTO @ProductDetail([ProductDetailMessage])	VALUES(	'Example Message = '+ [dbo].[svfFormatMoneyString](@ExampleVariable))

--Return Values
	DECLARE @Endorsements varchar(255) 
	SELECT 
		@Endorsements = COALESCE(@Endorsements + ',','') + [EndorsementMessage] 
	FROM 
		@Endorsement

--Pivot Return Table
{PivotTables}
	SELECT 
		* 
		,@Endorsements AS [Endorsement1]
{PremiumSections}
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



        public static string uspCalculatorExcesses = @"--Excesses '{Excess Desc}:{ExcessVal000}:{List_Excess_Section.Excess_Section_ID}:{LIST_EXCESSTYPE.ExcessType_ID}'
	DECLARE @Table_VlntryXS varchar(8)
	INSERT INTO @Excess ([ExcessMessage])
	SELECT
 		REPLACE([E].[Excess] ,'{Level}' , CAST(CASE WHEN [E].[Voluntary] = 0 THEN [LOBE].[Level] ELSE @Table_VlntryXS END AS varchar(10)))
	FROM 
		[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Excess] AS [LOBE]
		JOIN [dbo].[Excess] AS [E] ON [LOBE].[ExcessID] = [E].[ExcessID]
	WHERE
	    [StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([EndDatetime] ,@PolicyStartDateTime +1)
";		
        public static string uspCalculatorAssumptionRefers = @"--Assumptions	
	INSERT INTO @Refer([ReferMessage])
	SELECT [Message] FROM [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);
";
        public static string uspCalculatorDeclarePremiumSections = @"        DECLARE @{PremiumSection} money
";
        public static string uspCalculatorReturnPremiumSections = @"        ,ISNULL(@{PremiumSection},0) AS [{PremiumSection}]
";

public static string uspCalculatorLimits = @"DECLARE  @{LimitType}_Min {DataType}  = [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLimitSelect]('{Insurer}' ,'{LineOfBusiness}' ,'{LimitType}' ,'Min' ,@PolicyStartDateTime);
DECLARE  @{LimitType}_Max {DataType}  = [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLimitSelect]('{Insurer}' ,'{LineOfBusiness}' ,'{LimitType}' ,'Max' ,@PolicyStartDateTime);
";




        public static string TableLoadDiscount = @"DROP TABLE[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_LoadDiscount]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_LoadDiscount]
(
	[LoadDiscountID] [int] IDENTITY(1,1) PRIMARY KEY,
    [RateType] [varchar](25) NULL,
	[LoadDiscountType] [varchar](100) NULL,
	[StartRange] [int] NULL,
	[EndRange] [int] NULL,
    [LoadDiscountValue] [decimal](4, 2) NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[InsertDateTime] [datetime] NULL,
	[UserID] [varchar](10) NULL
) ON[PRIMARY]
GO
";

        public static string svfLoadDiscountSelect = @"DROP FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLoadDiscountsSelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -----------------------------------------------------------
 -- Date		14 Feb 2018
 -- Author D.Hostler
 -- Desc Return loading/Discount from generic rate table
 ------------------------------------------------------------

CREATE FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLoadDiscountsSelect]
(
	 @RateType varchar(25) = NULL
	,@LoadDiscountType varchar(100) = NULL
	,@RangelookupValue int = NULL
	,@PolicyStartDateTime datetime = NULL
)
Returns decimal(4,2)
AS

/*
	DECLARE
		 @RateType varchar(25) ='Contents'
		,@LoadDiscountType varchar(100) = 'ClaimPremiumLoadPct'
		,@RangelookupValue int = 400
		,@PolicyStartDateTime datetime = getdate()

		SELECT [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLoadDiscountsSelect](@RateType ,@LoadDiscountType ,@RangelookupValue ,@PolicyStartDateTime)

*/

BEGIN

    DECLARE @LoadDiscount decimal(4,2) = 0;

	SELECT top 1
		@LoadDiscount = [LoadDiscountValue]
    FROM
        [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_LoadDiscount]

    WHERE
        ([RateType] = @RateType OR[RateType] IS NULL)
        AND([LoadDiscountType] = @LoadDiscountType OR[LoadDiscountType] IS NULL)
        AND([StartRange] <= @RangelookupValue OR [StartRange] IS NULL)
        AND([EndRange] > @RangelookupValue OR [EndRange] IS NULL)
		AND [StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([EndDatetime] ,@PolicyStartDateTime +1)

    RETURN @LoadDiscount
END
GO
";

        public static string TableDataLoadDiscount = @"--Example Insert
INSERT INTO [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_LoadDiscount] ([RateType], [LoadDiscountType], [StartRange], [EndRange], [LoadDiscountValue], [StartDateTime], [EndDateTime], [InsertDateTime], [UserID]) 
VALUES(N'Buildings', N'VoluntaryExcess', 150, 400,-16.00, '01 Jan 1900', NULL, '{RateStartDateTime}', N'System');
";


        public static string CalculatorLoadDiscount = @"DECLARE @RateType varchar(25) ='Buildings'
		,@LoadDiscountType varchar(100) = 'VoluntaryExcess'
		,@RangelookupValue int = 400

        DECLARE @LoadDiscount decimal(4,2) = [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfLoadDiscountsSelect](@RateType ,@LoadDiscountType ,@RangelookupValue ,@PolicyStartDateTime)
";


        public static string TableRate = @"DROP TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Rate]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Rate]
(
	[RateID] [int] IDENTITY(1,1) PRIMARY KEY,
	[RateType] [varchar](40) NULL,
	[RateGroup] [varchar](2) NULL,
	[RateValue] [decimal](10, 4) NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[InsertDateTime] [datetime] NULL,
	[UserID] [varchar](10) NULL
) ON [PRIMARY]
GO
";

        public static string svfRateSelect = @"IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfRateSelect]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfRateSelect]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -----------------------------------------------------------
 -- Date		20 Feb 2018
 -- Author		D. Hostler
 -- Desc		Return Rate from generic rate table
 ------------------------------------------------------------

CREATE FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfRateSelect]
(
	 @RateType varchar(40) = NULL
	,@RateGroup varchar(2) = NULL
	,@PolicyStartDateTime datetime = NULL
)
Returns decimal(10,4)
AS
/*
	DECLARE	 @RateType varchar(40) = 'ItmCntns_RplcmntCostSITotal_LimitMax'
			,@RateGroup varchar(2) --= 7
		    ,@PolicyStartDateTime datetime =  getdate()

		SELECT [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfRateSelect](@RateType ,@RateGroup ,@PolicyStartDateTime)

*/
BEGIN
	DECLARE @Rate decimal(10,4) = 0;

	SELECT top 1
		@Rate = [RateValue]
	FROM
		[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Rate]
	WHERE
			([RateType] = @RateType OR [RateType] IS NULL)
		AND ([RateGroup] = @RateGroup OR [RateGroup] IS NULL)
		AND [StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([EndDatetime] ,@PolicyStartDateTime +1)
	RETURN @Rate
END
";
        public static string TableDataRate = @"INSERT [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Rate] ([RateType], [RateGroup], [RateValue], [StartDateTime], [EndDateTime], [InsertDateTime], [UserID]) VALUES (N'RateType1', N'1', 1, '{RateStartDateTime}', NULL, GETDATE(), N'System');
";

        public static string CalculatorRate = @"		SET @RateType = 'RateType1'
		DECLARE	@RateGroup varchar(2) = '1'

		DECLARE @RateValue decimal(10,4) = [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_svfRateSelect](@RateType ,@RateGroup ,@PolicyStartDateTime)
";



        public static string TableExcess_LOB = @"DROP TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Excess]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Excess](
	[ProductExcessID] [int] IDENTITY(1,1) PRIMARY KEY,
	[ExcessID] [int] NOT NULL,
	[Level] [int] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[InsertDateTime] [datetime] NULL,
	[UserID] [varchar](10) NULL
) ON [PRIMARY]
GO
";

		public static string TableExcess_Scheme = @"DROP TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Excess]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Excess](
	[SchemeExcessID] [int] IDENTITY(1,1) PRIMARY KEY,
	[ExcessID] [int] NOT NULL,
	[Level] [int] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[InsertDateTime] [datetime] NULL,
	[UserID] [varchar](10) NULL
) ON [PRIMARY]
GO
";

		public static string TableDataExcess = @"INSERT [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Excess] ([ExcessID], [Level], [StartDateTime], [EndDateTime], [InsertDateTime], [UserID]) VALUES (1, 1000, '{RateStartDateTime}', NULL, GETDATE(), N'Dev');
";

		public static string CalculatorPivotTable = @",[{ReturnTable}] AS
	(
		SELECT {TableColumns}
		FROM
		@{ReturnTable}
		PIVOT
		(
		max([{ReturnTable}Message])
		FOR [{ReturnTable}ID] IN ({TableColumns})
		) AS PivotTable
	)
";

        public static string TableDataListEndorsement = @"INSERT [dbo].[List_Endorsement] ([ENDORSEMENT_ID], [ENDORSEMENT_CODE_ID], [ENDORSEMENT_CODE_DEBUG], [ENDORSEMENT_CODE_TEXT], [DELETED], [PRODUCTTYPE], [PORTFOLIOKEY], [INSURER_ID], [ABIVALUE], [ENDORS_LINKTYPE_ID]) VALUES (N'', N'', N'', N'', 0, N'{ProductTypeID}', N'154', N'{InsurerID}', 0, N'POLICYENDORS')
";




        public static string TableTrade = @"DROP TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Trade]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Trade](
	[TradeID] int IDENTITY(1,1) PRIMARY KEY,
	[MH_Trade_ID] varchar(8),
	[TradeDescriptionInsurer] varchar(120) ,
    [Endorsements] varchar(250),
    [TradeExcess] varchar(250),
	[StartDateTime] datetime NULL,
	[EndDateTime] datetime NULL,
	[InsertDateTime] datetime NULL,
	[UserID] varchar(10) NULL
) ON [PRIMARY]
GO
";
        public static string SynonymCreate = @"CREATE SYNONYM [dbo].[{ListTableName}] FOR [Transactor_Live].[dbo].[{ListTableName}];";


        public static string AddSchemeScript = @"DECLARE
	 @SchemeName nvarchar(255) = '{SchemeName}'
	,@SchemeFileName  nvarchar(12) =  '{wpdFileName}'
	,@ProductTypeID int = {ProductTypeID}
	,@InsurerID varchar(50) = '{InsurerID}'
	,@NetRated bit = 0
	,@InternetAvailable bit = {InternetAvailable}
	,@ParameterGroupName varchar(255) =  'Commercial Scheme Parameters' --'Business Support Scheme'
	,@RangeGroupName varchar(255)
	,@CommissionGroupName varchar(255) 
	,@RangePrefix char(5) = '{RangePrefix}'
	,@ErrorText varchar(4000) = ''
	,@AgentID varchar(MAX) = '{SchemeLinkAgents}'
			
EXEC [dbo].[uspSchemeDefaultInsert] 
	 @SchemeName
	,@SchemeFileName
	,@ProductTypeID
	,@InsurerID
	,@NetRated
	,@InternetAvailable
	,@ParameterGroupName
	,@RangeGroupName
	,@CommissionGroupName
	,@RangePrefix 
	,@ErrorText OUTPUT
	,@AgentID
	
SELECT 	@ErrorText
;

UPDATE 
	[C]
SET	
	 [C].[NB_Partner_Percent] = {CommissionPercent}
	,[C].[MTA_Partner_Percent] = {CommissionPercent}
	,[C].[REN_Partner_Percent] = {CommissionPercent}
FROM 
	[dbo].[RM_Commission_Group] AS [CG]
 	JOIN [dbo].[RM_COMMISSION] AS [C] ON [C].[COMMISSION_GROUP_ID] =[CG].[COMMISSION_GROUP_ID]
WHERE 
	[CG].[Name] = '{SchemeName}'
;
	

INSERT INTO [Product]. [Content].[Scheme]
(
	[SchemeID]
	,[InsurerID]
	,[Name]
	,[ImportantInformation]
	,[StartDateTime]
)
SELECT
	 [Scheme_ID]
	,[Insurer_ID]
	,[Name]
	,''
	,'{RateStartDateTime}'
FROM
	[RM_Scheme]
WHERE
	[Name] = '{SchemeName}'
;
";

        public static string tvfTrade = @"DROP FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfTrades]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-----------------------------------------------------------
-- Author:		System Generated
-- Create date: {Datetime}
-- Desc			Return Trades
 ------------------------------------------------------------

CREATE FUNCTION [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfTrades]
(
	  @MH_Trade_ID varchar(8)
    , @PolicyStartDateTime datetime
)
Returns @Trade table
(
	 [TradeDescriptionInsurer]		varchar(120)
	,[Endorsements]		varchar(250)
	,[TradeExcess]		varchar(250)
)
AS
/*

	DECLARE	 @MH_Trade_ID varchar(8) = 'D5F7B30A'
			,@PolicyStartDateTime datetime = GETDATE()

	SELECT * FROM [dbo].[MPROIND_tvfTrades](@MH_Trade_ID ,@PolicyStartDateTime )

*/
BEGIN

	INSERT INTO @Trade
	
    SELECT
         [TradeDescriptionInsurer]
        ,[Endorsements]
        ,[TradeExcess]
    FROM
        [Calculators].[dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_Trade]
    WHERE
		[MH_Trade_ID] = @MH_Trade_ID
		AND [StartDatetime] <= @PolicyStartDateTime AND @PolicyStartDateTime < ISNULL([EndDatetime] ,@PolicyStartDateTime +1)

    RETURN
    
END
";

        public static string tvfLOBRiskBordereaux = @"

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		System Generated
-- Create date: {Datetime}
-- Description:	Risk Bordereaux
-- =============================================
CREATE FUNCTION [dbo].[{LOBName}_tvfReportRiskBordereaux]
(
	 @POLICY_DETAILS_ID [char](32)
	,@POLICY_DETAILS_HISTORY_ID [int]
)
RETURNS @RiskBordereaux TABLE 
(
{RiskBordereauxTableDefinition}
}
AS
/* 

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @POLICY_DETAILS_ID [char](32) = ''
	,@POLICY_DETAILS_HISTORY_ID [int] = 1

	SELECT * FROM [dbo].[{LOBName}_tvfReportBordereaux](@POLICY_DETAILS_ID, @POLICY_DETAILS_HISTORY_ID)

*/
BEGIN

	INSERT INTO @Bordereaux
	SELECT
{tvfReportRiskBordereauxSelectList}
	FROM
{tvfReportRiskBordereauxTableList}	
	WHERE 
{tvfReportRiskBordereauxCriteriaList}
		
	RETURN
END
GO
";

        public static string LOBRiskView = @"
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		System Generated
-- Create date: {Datetime}
-- Description:	Risk View
-- =============================================
CREATE VIEW [dbo].[{LOBName}_LOBRiskView]

AS
/* 

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @POLICY_DETAILS_ID [char](32) = ''
	,@POLICY_DETAILS_HISTORY_ID [int] = 1

	SELECT * FROM [dbo].[{LOBName}_LOBRiskView] WHERE [Policy_Details_ID] = @POLICY_DETAILS_ID AND HISTORY_ID = @POLICY_DETAILS_HISTORY_ID

*/
    SELECT
{LOBRiskViewSelectList}
	FROM
{LOBRiskViewJoinList}	

GO
";

        public static string LOBRiskViewSelectColumn = @"       ,[{TableName}].[{AnswerName}] AS [{FormName}_{AnswerName}]
";

        public static string LOBRiskViewSelectJoinClause = @"       LEFT JOIN [{TableName}] ON  [{TableName}].[Policy_Details_ID] = [{DrivingTable}].[Policy_Details_ID] AND [{TableName}].[History_ID] = [{DrivingTable}].[History_ID] 
";

        public static string LOBRiskViewSelectListColumn = @"       ,[{ListTableAlias}].[{ListColumnName}_Debug] AS [{AnswerName}]
";

        public static string LOBRiskViewSelectJoinListClause = @"       LEFT JOIN [dbo].[{ListTableName}] AS [{ListTableAlias}] ON [{ListTableAlias}].[{ListColumnName}] = [{TableName}].[{AnswerColumnName}]";

        public static string CalculatorXMLTableAsVariables = @" {Tablecolumns}
    SELECT
    {SelectColumns}
    FROM
		@RiskXML.nodes('(//{FormName})') AS T(x) --Lookup table
{SelectJoinListClause}

    SELECT
{SelectVariables}
";
        public static string SelectColumnAsVariable = @"        ,@{FormName}_{AnswerName} = {SelectColumnXPath}
";

        public static string CalculatorXMLDeclareVariable = @"        ,@{FormName}_{AnswerName} {ColumnType}
";

        public static string SelectListColumnAsVariable = @"        ,@{FormName}_{AnswerName} = [{ListTableAlias}].[{ListColumnName}_Debug]
";

        public static string SelectVariables = @"        ,@{FormName}_{AnswerName} AS [{FormName}_{AnswerName}]
";
    }
}
