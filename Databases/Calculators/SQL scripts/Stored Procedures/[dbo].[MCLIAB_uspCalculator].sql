USE [Calculators]
GO
/****** Object:  StoredProcedure [dbo].[MCLIAB_uspCalculator]    Script Date: 07/01/2025 08:11:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/******************************************************************************
-- Author:		System Generated
-- Date:        {Datetime}
-- Description: Boiler plate for translating wpd variables and returns can be regenerated apart from LOB level refers etc..
*******************************************************************************
-- Date			Who					Changes
-- 15/11/2024	Simon				Monday Ticket 7859939201: renewal invites refer with a referral message of - "Roll Over to Companion at Renewal"
									For new business, if the effective date is 01st Jan 2025 onwards refer "scheme is no longer available"

-- 28/11/2022	Linga		        Monday ticket 5407122787 : Changed from @EmployeesELManual > 0 to  @EmployeesELManual >= 0, to show EL options if either of Clerical or Work-Away Employees is 0

-- 15/12/2023	Linga        	    Monday ticket 5584020485: Added New Schemes TOLEDO - Small Business and Consultants, BXB Small Business and Consultants
                                    Made some changes related to Toledo - SB- New Schemes

-- 02/01/2025   Linga				Monday Ticket 8142413832: UK postcode Referral 
*******************************************************************************/

ALTER PROCEDURE[dbo].[MCLIAB_uspCalculator]
	 @RiskXML XML
    ,@PolicyStartDateTime datetime = NULL
	,@InceptionStartDateTime datetime = NULL
    ,@PolicyQuoteStage varchar(8)
    ,@PostCode varchar(12)
    ,@SchemeTableID int
	,@AgentName varchar(255)
    ,@SubAgentID char(32)
	,@OutputRisk bit = 0
	,@HistoryID int = NULL --Supplied If recalculating

AS
/*

    TRUNCATE TABLE [Transactor_Live].[dbo].[uspSchemeCommandDebug]
    SELECT * FROM [Transactor_Live].[dbo].[uspSchemeCommandDebug] WHERE [uspSchemeCommandText] LIKE '%MCLIAB_uspCalculator%'

	CREATE TABLE RiskXML (RiskXML xml);
	INSERT INTO RiskXML(RiskXML) values(@RiskXML);
*/

BEGIN
    SET NOCOUNT ON

	IF @PolicyStartDateTime = cast(getdate() as date)
		SET @PolicyStartDateTime = getdate()

	DECLARE  @Refer SchemeResultTableType
			,@Decline SchemeResultTableType
			,@Excess SchemeResultTableType
			,@Summary SchemeResultTableType
			,@Breakdown SchemeResultTableType
			,@ProductDetail SchemeResultTableType	
			,@Premium SchemeResultPremiumTableType
			,@Premium2 SchemeResultPremiumTableType
			,@Endorsement SchemeResultEndorsementTableType

--Risk Tables
	SET @RiskXML = REPLACE(REPLACE(cast(@RiskXML AS varchar(max)), '> ', '>'), ' <', '<');


--{RiskTables}
	DECLARE @CInfo CInfoTableType
	INSERT INTO @CInfo( [HistoryID] ,[PolicyDetailsID] ,[ERNExempt] ,[ERNRef] ,[TotalEmps] ,[Computers] ,[Mainframes] ,[Insurer] ,[Insurer_ID] ,[PubLiabLimit] ,[PubLiabLimit_ID] ,[PrimaryRisk] ,[PrimaryRisk_ID] ,[IncludeYN] ,[SubsidYN] ,[YrsExp] ,[Yrs] ,[YrEstablished] ,[WorkAwayEmp] ,[ClericalEmp] ,[WorkAwayDirec] ,[ClericalDirec] ,[TotalPandP] ,[CompStatus] ,[CompStatus_ID] ,[CovStart])
    SELECT
		  ISNULL(T.X.value('(./HistoryID[text()])[1]', 'money'),0) AS [HistoryID]
		 ,T.X.value('(./PolicyDetailsID[text()])[1]', 'varchar(32)') AS [PolicyDetailsID]
		 ,ISNULL(T.X.value('(./ERNExempt[text()])[1]', 'bit'),0) AS [ERNExempt]
		 ,T.X.value('(./ERNRef[text()])[1]', 'varchar(20)') AS [ERNRef]
		 ,ISNULL(T.X.value('(./TotalEmps[text()])[1]', 'money'),0) AS [TotalEmps]
		 ,ISNULL(T.X.value('(./Computers[text()])[1]', 'bit'),0) AS [Computers]
		 ,ISNULL(T.X.value('(./Mainframes[text()])[1]', 'bit'),0) AS [Mainframes]
		 ,[System_Insurer1].[INSURER_Debug] AS [Insurer]
		 ,T.X.value('(./Insurer[text()])[1]', 'varchar(8)') AS [Insurer_ID]
		 ,[LIST_MH_PUBLIAB1].[MH_PUBLIAB_Debug] AS [PubLiabLimit]
		 ,T.X.value('(./PubLiabLimit[text()])[1]', 'varchar(8)') AS [PubLiabLimit_ID]
		 ,[LIST_MH_TRADE1].[MH_TRADE_Debug] AS [PrimaryRisk]
		 ,T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)') AS [PrimaryRisk_ID]
		 ,ISNULL(T.X.value('(./IncludeYN[text()])[1]', 'bit'),0) AS [IncludeYN]
		 ,ISNULL(T.X.value('(./SubsidYN[text()])[1]', 'bit'),0) AS [SubsidYN]
		 ,ISNULL(T.X.value('(./YrsExp[text()])[1]', 'money'),0) AS [YrsExp]
		 ,ISNULL(T.X.value('(./Yrs[text()])[1]', 'money'),0) AS [Yrs]
		 ,ISNULL(T.X.value('(./YrEstablished[text()])[1]', 'money'),0) AS [YrEstablished]
		 ,ISNULL(T.X.value('(./WorkAwayEmp[text()])[1]', 'money'),0) AS [WorkAwayEmp]
		 ,ISNULL(T.X.value('(./ClericalEmp[text()])[1]', 'money'),0) AS [ClericalEmp]
		 ,ISNULL(T.X.value('(./WorkAwayDirec[text()])[1]', 'money'),0) AS [WorkAwayDirec]
		 ,ISNULL(T.X.value('(./ClericalDirec[text()])[1]', 'money'),0) AS [ClericalDirec]
		 ,ISNULL(T.X.value('(./TotalPandP[text()])[1]', 'money'),0) AS [TotalPandP]
		 ,[LIST_MH_COSTATUS1].[MH_COSTATUS_Debug] AS [CompStatus]
		 ,T.X.value('(./CompStatus[text()])[1]', 'varchar(8)') AS [CompStatus_ID]
		 ,CONVERT(datetime ,     T.X.value('(./CovStart[text()])[1]', 'varchar(30)'),103) AS [CovStart]
	FROM
		@RiskXML.nodes('(//CInfo)') AS T(x) --Lookup table
        JOIN [dbo].[System_Insurer] AS [System_Insurer1] ON [System_Insurer1].[INSURER_ID] = T.X.value('(./Insurer[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_PUBLIAB] AS [LIST_MH_PUBLIAB1] ON [LIST_MH_PUBLIAB1].[MH_PUBLIAB_ID] = T.X.value('(./PubLiabLimit[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_TRADE] AS [LIST_MH_TRADE1] ON [LIST_MH_TRADE1].[MH_TRADE_ID] = T.X.value('(./PrimaryRisk[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_COSTATUS] AS [LIST_MH_COSTATUS1] ON [LIST_MH_COSTATUS1].[MH_COSTATUS_ID] = T.X.value('(./CompStatus[text()])[1]', 'varchar(8)')

	DECLARE @Business AS BusinessTableType
	INSERT INTO @Business( [SafetyDetails] ,[Safety] ,[TribunalDetails] ,[Tribunal] ,[DisputeDetails] ,[Dispute] ,[RegDetails] ,[Regs] ,[DismissDetails] ,[DismissedStaff] ,[ClaimDetails] ,[Claim] ,[BusinessCover])
    SELECT
		 T.X.value('(./SafetyDetails[text()])[1]', 'varchar(100)') AS [SafetyDetails]
		 ,ISNULL(T.X.value('(./Safety[text()])[1]', 'bit'),0) AS [Safety]
		 ,T.X.value('(./TribunalDetails[text()])[1]', 'varchar(100)') AS [TribunalDetails]
		 ,ISNULL(T.X.value('(./Tribunal[text()])[1]', 'bit'),0) AS [Tribunal]
		 ,T.X.value('(./DisputeDetails[text()])[1]', 'varchar(100)') AS [DisputeDetails]
		 ,ISNULL(T.X.value('(./Dispute[text()])[1]', 'bit'),0) AS [Dispute]
		 ,T.X.value('(./RegDetails[text()])[1]', 'varchar(100)') AS [RegDetails]
		 ,ISNULL(T.X.value('(./Regs[text()])[1]', 'bit'),0) AS [Regs]
		 ,T.X.value('(./DismissDetails[text()])[1]', 'varchar(100)') AS [DismissDetails]
		 ,ISNULL(T.X.value('(./DismissedStaff[text()])[1]', 'bit'),0) AS [DismissedStaff]
		 ,T.X.value('(./ClaimDetails[text()])[1]', 'varchar(100)') AS [ClaimDetails]
		 ,ISNULL(T.X.value('(./Claim[text()])[1]', 'bit'),0) AS [Claim]
		 ,ISNULL(T.X.value('(./BusinessCover[text()])[1]', 'bit'),0) AS [BusinessCover]
	FROM
		@RiskXML.nodes('(//Business)') AS T(x) --Lookup table

	DECLARE @PandP AS PAndPTableType
	INSERT INTO @PandP( [Status] ,[Status_ID] ,[Surname] ,[Forename] ,[Title] ,[Title_ID])
    SELECT
		 [LIST_MH_P_STATUS1].[MH_P_STATUS_Debug] AS [Status]
		 ,T.X.value('(./Status[text()])[1]', 'varchar(8)') AS [Status_ID]
		 ,T.X.value('(./Surname[text()])[1]', 'varchar(50)') AS [Surname]
		 ,T.X.value('(./Forename[text()])[1]', 'varchar(50)') AS [Forename]
		 ,[LIST_TITLE1].[TITLE_Debug] AS [Title]
		 ,T.X.value('(./Title[text()])[1]', 'varchar(8)') AS [Title_ID]
	FROM
		@RiskXML.nodes('(//PandP)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_P_STATUS] AS [LIST_MH_P_STATUS1] ON [LIST_MH_P_STATUS1].[MH_P_STATUS_ID] = T.X.value('(./Status[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_TITLE] AS [LIST_TITLE1] ON [LIST_TITLE1].[TITLE_ID] = T.X.value('(./Title[text()])[1]', 'varchar(8)')

    DECLARE @Subsid AS SubsidTableType
	INSERT INTO @Subsid( [SubsidInsurer] ,[SubsidInsurer_ID] ,[SubsidERN] ,[SubsidName])
    SELECT
		  [System_Insurer2].[INSURER_Debug] AS [SubsidInsurer]
		 ,T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)') AS [SubsidInsurer_ID]
		 ,T.X.value('(./SubsidERN[text()])[1]', 'varchar(20)') AS [SubsidERN]
		 ,T.X.value('(./SubsidName[text()])[1]', 'varchar(200)') AS [SubsidName]
	FROM
		@RiskXML.nodes('(//Subsid)') AS T(x) --Lookup table
        JOIN [dbo].[System_Insurer] AS [System_Insurer2] ON [System_Insurer2].[INSURER_ID] = T.X.value('(./SubsidInsurer[text()])[1]', 'varchar(8)')

	DECLARE @AccIncom MCLIAB_AccIncomTableType;
	INSERT INTO @AccIncom( [PeopleNum] ,[IncomeCover] ,[IncomeCover_ID] ,[AccidentCover] ,[AccidentCover_ID] ,[CoverYN])
    SELECT
		ISNULL(T.X.value('(./PeopleNum[text()])[1]', 'money'),0) AS [PeopleNum]
		,[LIST_MH_PAIncomeProtectionLevel1].[MH_PAINCOMEPROTECTIONLEVEL_Debug] AS [IncomeCover]
		,T.X.value('(./IncomeCover[text()])[1]', 'varchar(8)') AS [IncomeCover_ID]
		,[LIST_MH_PersonalAccidentLevel1].[MH_PERSONALACCIDENTLEVEL_Debug] AS [AccidentCover]
		,T.X.value('(./AccidentCover[text()])[1]', 'varchar(8)') AS [AccidentCover_ID]
		,ISNULL(T.X.value('(./CoverYN[text()])[1]', 'bit'),0) AS [CoverYN]
	FROM
		@RiskXML.nodes('(//AccIncom)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_PAIncomeProtectionLevel] AS [LIST_MH_PAIncomeProtectionLevel1] ON [LIST_MH_PAIncomeProtectionLevel1].[MH_PAINCOMEPROTECTIONLEVEL_ID] = T.X.value('(./IncomeCover[text()])[1]', 'varchar(8)')
        JOIN [dbo].[LIST_MH_PersonalAccidentLevel] AS [LIST_MH_PersonalAccidentLevel1] ON [LIST_MH_PersonalAccidentLevel1].[MH_PERSONALACCIDENTLEVEL_ID] = T.X.value('(./AccidentCover[text()])[1]', 'varchar(8)')

	DECLARE @PAPeople MCLIAB_PAPeopleTableType;
	INSERT INTO @PAPeople( [Title] ,[Title_ID] ,[UKResidentYN] ,[DateOfBirth] ,[Surname] ,[Forenames])
    SELECT
		[LIST_TITLE2].[TITLE_Debug] AS [Title]
		,T.X.value('(./Title[text()])[1]', 'varchar(8)') AS [Title_ID]
		,ISNULL(T.X.value('(./UKResidentYN[text()])[1]', 'bit'),0) AS [UKResidentYN]
,CONVERT(datetime ,		T.X.value('(./DateOfBirth[text()])[1]', 'varchar(30)'),103) AS [DateOfBirth]
		,T.X.value('(./Surname[text()])[1]', 'varchar(50)') AS [Surname]
		,T.X.value('(./Forenames[text()])[1]', 'varchar(50)') AS [Forenames]
	FROM
		@RiskXML.nodes('(//PAPeople)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_TITLE] AS [LIST_TITLE2] ON [LIST_TITLE2].[TITLE_ID] = T.X.value('(./Title[text()])[1]', 'varchar(8)')

	DECLARE @ProfIndm MCLIAB_ProfIndmTableType;
	INSERT INTO @ProfIndm( [LawYN] ,[AccountancyYN] ,[FinancialYN] ,[ContractSI] ,[Turnover] ,[PILevel] ,[PILevel_ID] ,[PIYN])
    SELECT
		ISNULL(T.X.value('(./LawYN[text()])[1]', 'bit'),0) AS [LawYN]
		,ISNULL(T.X.value('(./AccountancyYN[text()])[1]', 'bit'),0) AS [AccountancyYN]
		,ISNULL(T.X.value('(./FinancialYN[text()])[1]', 'bit'),0) AS [FinancialYN]
		,ISNULL(T.X.value('(./ContractSI[text()])[1]', 'money'),0) AS [ContractSI]
		,ISNULL(T.X.value('(./Turnover[text()])[1]', 'money'),0) AS [Turnover]
		,[LIST_MH_ProfessionalIndemnityLevel1].[MH_PROFESSIONALINDEMNITYLEVEL_Debug] AS [PILevel]
		,T.X.value('(./PILevel[text()])[1]', 'varchar(8)') AS [PILevel_ID]
		,ISNULL(T.X.value('(./PIYN[text()])[1]', 'bit'),0) AS [PIYN]
	FROM
		@RiskXML.nodes('(//ProfIndm)') AS T(x) --Lookup table
        JOIN [dbo].[LIST_MH_ProfessionalIndemnityLevel] AS [LIST_MH_ProfessionalIndemnityLevel1] ON [LIST_MH_ProfessionalIndemnityLevel1].[MH_PROFESSIONALINDEMNITYLEVEL_ID] = T.X.value('(./PILevel[text()])[1]', 'varchar(8)')

	DECLARE @ClmDtail ClaimTableType
	INSERT INTO @ClmDtail ([Details] ,[Outstanding] ,[Paid] ,[Date] ,[Type])
	SELECT
		 T.X.value('(./Details[text()])[1]', 'varchar(500)')  AS [Details]	
		,T.X.value('(./Outstanding[text()])[1]', 'money') AS [Outstanding]	
		,T.X.value('(./Paid[text()])[1]', 'money') AS [Paid]	
		,convert(datetime ,T.X.value('(./Date[text()])[1]', 'varchar(100)'),103) AS [Date]
		,[CT].[MH_CLAIMTYPE_DEBUG] AS [Type]
	FROM
		@RiskXML.nodes('(//ClmDtail)') AS T(x)
		JOIN [dbo].[LIST_MH_CLAIMTYPE] AS [CT] ON [CT].[MH_CLAIMTYPE_ID] = T.X.value('(./Type[text()])[1]','varchar(8)')

		
	DECLARE @SchemeInsurer varchar(1000) = (SELECT DISTINCT [SI].[Insurer_Debug] FROM [dbo].[RM_Scheme] AS [S] JOIN [System_Insurer] AS [SI] ON [S].[Insurer_ID] = [SI].[Insurer_ID] WHERE [S].[SchemeTable_ID] = @SchemeTableID)


	DECLARE 
		 @PolicyDetailsID varchar(32)
	SELECT 
		 @PolicyDetailsID = PolicyDetailsID 
	FROM
		@CInfo
			
--Quote Stage
	DECLARE @PolicyQuoteStageMTA bit = 0
	IF @PolicyQuoteStage = 'MTA' 
		SET @PolicyQuoteStageMTA = 'True'
			
--Previous History ID
	DECLARE @PreviousPolicyHistoryID int 

	IF @PolicyQuoteStage IN ('MTA', 'REN')
	BEGIN
		DECLARE @PreviousPolicyQuoteStage varchar(3)
		SELECT TOP 1
			 @PreviousPolicyHistoryID = [ACV].[POLICY_DETAILS_HISTORY_ID]
			,@PreviousPolicyQuoteStage = MAX([ACV].[TRANSACTION_CODE_ID])
		FROM 
			[Transactor_Live].[dbo].[ACCOUNTS_CLIENT_VIEW] AS [ACV]
		WHERE 
			[ACV].[TRANSACTION_CODE_ID] IN ('NB','REN','XREN')
			AND [ACV].[POLICY_DETAILS_ID] = @POLICYDETAILSID
			AND (@HistoryID IS NULL OR [ACV].[POLICY_DETAILS_HISTORY_ID] < @HistoryID)
		GROUP BY			
			[ACV].[POLICY_DETAILS_HISTORY_ID]
		HAVING
			count(DISTINCT [ACV].[TRANSACTION_CODE_ID])=1			
		
		ORDER BY 
			[ACV].[POLICY_DETAILS_HISTORY_ID] DESC	
		
		SET @PolicyQuoteStage = 'REN'
		IF @PolicyQuoteStageMTA = 'True' AND @PreviousPolicyQuoteStage = 'NB'
			SET @PolicyQuoteStage = 'NB'
			
	END	

--Refers

	IF (SELECT CASE WHEN [C].[PrimaryRisk] = 'None' THEN 1 ELSE 0 END FROM @CInfo AS [C]) = 1
			INSERT INTO @Refer VALUES ('No Primary Trade has been selected.')

	--Renewal Invites (7859939201)
	INSERT INTO @Refer SELECT 'Roll Over to Companion at Renewal' FROM @AccIncom WHERE @SchemeTableID = 1370 AND @PolicyQuoteStage = 'REN';

	--New Business (7859939201)
	INSERT INTO @Refer SELECT 'Scheme is no longer available' FROM @AccIncom WHERE @SchemeTableID = 1370 AND @PolicyQuoteStage = 'NB' AND @PolicyStartDateTime >= '01 Jan 2025';

--Declines
	IF @SchemeTableID = 1370 AND @PolicyQuoteStage IN ('NB', 'MTA') AND (SELECT COUNT([C].[Type]) FROM @ClmDtail AS [C] WHERE [C].[Type] = 'EL – Personal Injury') > 0
		INSERT INTO @Decline VALUES ('Decline PI if any PI claims') 

	IF @SchemeTableID = 1370 AND (SELECT T.X.value('(./Convictions[text()])[1]', 'varchar(10)')  AS [Convicted] FROM @RiskXML.nodes('(//Assump)') AS T(x)) = '3MQT5MC7'
		INSERT INTO @Decline VALUES ('No Convictions Allowed')

	IF @SchemeTableID = 1370 AND (SELECT T.X.value('(./Bankrupt[text()])[1]', 'varchar(10)')  AS [Bankrupt] FROM @RiskXML.nodes('(//Assump)') AS T(x)) = '3MQT5MC7'
		INSERT INTO @Decline VALUES ('Bankrupt not allowed')

	IF @SchemeTableID = 1370 AND (SELECT T.X.value('(./Declined[text()])[1]', 'varchar(10)')  AS [Refused] FROM @RiskXML.nodes('(//Assump)') AS T(x)) = '3MQT5MC7'
		INSERT INTO @Decline VALUES ('Refused not allowed')

	IF @SchemeTableID = 1370 AND (SELECT T.X.value('(./Asbestos[text()])[1]', 'varchar(10)')  AS [Asbestos] FROM @RiskXML.nodes('(//Assump)') AS T(x)) = '3MQT5MC7'
		INSERT INTO @Decline VALUES ('Discharge of noxious materials not allowed')

    -- Decline invalid postcode (8142413832)
    IF([dbo].[svfValidateUKPostcode](@PostCode) = 0)
	        INSERT INTO @Decline VALUES ('Invalid Postcode')

--Insurer 
	IF (SELECT CASE WHEN @PolicyQuoteStage = 'NB' AND [C].[Insurer] = @SchemeInsurer THEN 1 ELSE 0 END FROM @CInfo AS [C]) = 1
			INSERT INTO @Refer VALUES ('Previous Insurer ' + @SchemeInsurer)

	--PA
	INSERT INTO @Refer
	SELECT 'This Scheme does not cover Personal Accident' FROM @AccIncom WHERE @SchemeTableID NOT IN (1309,1064, 1607) AND [CoverYN] = 1 

	--PI
	UNION SELECT 'This Scheme does not cover Professional Indemnity' FROM @ProfIndm WHERE @SchemeTableID NOT IN (1309,1064, 1607) AND [PIYN] = 1

--{AssumptionRefers}
--Assumptions	
	INSERT INTO @Refer([Message])
	SELECT [Message] FROM [dbo].[MCLIAB_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime ,@SchemeTableID);

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
    
	IF (@SchemeTableID NOT IN (1596, 1607))--Toledo
	BEGIN
	IF (SELECT [E].[EmployeesPL] FROM @EmployeeCounts AS [E]) IS NULL
			INSERT INTO @Decline VALUES ('No employees')	

	IF (SELECT [E].[EmployeesPL] FROM @EmployeeCounts AS [E]) = 0
			INSERT INTO @Decline VALUES ('You have not entered any manual workers')	
	END

	IF (SELECT CASE WHEN [C].[CompStatus] = 'Limited' AND  ([C].[WorkAwayDirec] + [C].[ClericalDirec]) = 0 THEN 1 ELSE 0 END FROM @CInfo AS [C] ) = 1
			INSERT INTO @Refer VALUES ('Limited Company: Total Number of Directors are 0')

	
--Debugging
	IF @OutputRisk = 1
	BEGIN
		IF (SELECT COUNT(*) FROM @CInfo) != 0 SELECT 'CInfo' AS [Table] ,* FROM @CInfo
		IF (SELECT COUNT(*) FROM @PandP) != 0 SELECT 'PandP' AS [Table] ,* FROM @PandP
		IF (SELECT COUNT(*) FROM @Business) != 0 SELECT 'BusSupp' AS [Table] ,* FROM @Business
		IF (SELECT COUNT(*) FROM @Subsid) != 0 SELECT 'Subsid' AS [Table] ,* FROM @Subsid
		IF (SELECT COUNT(*) FROM @AccIncom) != 0 SELECT 'AccIncom' AS [Table] ,* FROM @AccIncom
		IF (SELECT COUNT(*) FROM @PAPeople) != 0 SELECT 'PAPeople' AS [Table] ,* FROM @PAPeople
		IF (SELECT COUNT(*) FROM @ProfIndm) != 0 SELECT 'TrdDtail' AS [Table] ,* FROM @ProfIndm
		IF (SELECT COUNT(*) FROM @ClmDtail) != 0 SELECT 'ClmDtail' AS [Table] , * FROM @ClmDtail

		SELECT 'ClaimsSummary' AS [tvf] ,* FROM @ClaimsSummary
		IF (SELECT COUNT(*) FROM [dbo].[MLIAB_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime)) != 0 SELECT 'Assumptions' AS [tvf] ,[Message] FROM [dbo].[MLIAB_tvfReferredAssumptions](@RiskXML.query('./Assump') ,@PolicyStartDateTime);
		SELECT 'EmployeeCounts' AS [tvf] ,* FROM @EmployeeCounts
		SELECT @PolicyStartDateTime AS [PolicyStartDateTime],@PolicyQuoteStage AS [PolicyQuoteStage] ,@PostCode AS [Postcode] ,@SchemeTableID AS [SchemeTableID] ,@SchemeInsurer AS [SchemeInsurer]
	END		
		

--MCLIAB_tvfSchemeDispatcher
	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM [dbo].[MCLIAB_tvfSchemeDispatcher] (@SchemeTableID ,@PolicyDetailsID ,@PreviousPolicyHistoryID ,@PolicyStartDateTime ,@InceptionStartDateTime ,@PolicyQuoteStage ,@PostCode , @AgentName, @ClaimsSummary ,@EmployeeCounts ,@CInfo ,@PandP ,@Business ,@Subsid ,@AccIncom ,@PAPeople ,@ProfIndm ,@ClmDtail ,@PolicyQuoteStageMTA) FOR XML PATH(''))
 
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

	--INSERT INTO @Premium ([Name] ,[Value] ,[PartnerCommission] ,[AgentCommission] ,[SubAgentCommission])
	--SELECT	T.X.value('(./Name[text()])[1]', 'varchar(20)'),T.X.value('(./Value[text()])[1]', 'money'),0,0,0 FROM @SchemeResultsXML.nodes('(//Premium)') AS T(x) 

	INSERT INTO @Premium ([Name] ,[Value]) VALUES ('LIABPREM',0),('EMPLPREM',0),('PAASPREM',0),('PROFPREM',0)

	;WITH [V] AS
	(
		SELECT
			 T.X.value('(./Name[text()])[1]', 'varchar(20)') AS [Name]
			,T.X.value('(./Value[text()])[1]', 'money') AS [Value]
		FROM 
			@SchemeResultsXML.nodes('(//Premium)') AS T(x) 
	)
	UPDATE
		[P]
	SET 
		[P].[Value] = ISNULL([V].[Value],0)
	FROM
		@Premium AS [P]
		LEFT JOIN [V] ON [P].[Name] = [V].[Name]	

		DECLARE @PremiumTotal money = ISNULL((SELECT SUM([Value]) FROM @Premium),0)
		IF @PremiumTotal = 0
			INSERT INTO @Refer Values ('Premium Total cannot be £0.00')


--Remove PI Endorsment
	--Covea
	DELETE [E] FROM @Endorsement AS [E] CROSS JOIN 	@ProfIndm AS [P] WHERE [P].[PIYN] = 1 AND [E].[Message] = 'MMALIC39'

--Covid Endorsement
	--IF @SchemeTableID in (1485) --Square Peg
	--	INSERT INTO @Endorsement VALUES ('SQPSB001')

--Summary
	INSERT INTO @Summary([Message])	VALUES(	'Quote Date :' + CONVERT(varchar(11) ,GETDATE(),106))
	INSERT INTO @Summary([Message])	VALUES(	'Quote is valid for 30 days' )

--Product Details
	INSERT INTO @ProductDetail VALUES 
	 ('Sums Insured')
	,('Public Liability = ' + (SELECT PubLiabLimit FROM @CInfo))
	,('Employers Liability = ' + (SELECT CASE [Value] WHEN 0 THEN 'Not Taken' ELSE '£10,000,000' END FROM @Premium where [Name] = 'EMPLPREM' ))

--Return Values
	DECLARE @Endorsements varchar(255) 
	SELECT 
		@Endorsements = COALESCE(@Endorsements + ',','') + [Message] 
	FROM 
		@Endorsement
		
		
--Save Calculated Policy Scheme Details 
		
	DECLARE @SchemeDetails xml = (SELECT @SchemeResultsXML.query('(//SchemeDetails/*)') FOR XML PATH('SchemeDetails'))
	IF (SELECT @SchemeDetails.value('(count(SchemeDetails/*))','int')) >0
	BEGIN
		DECLARE @SchemePremiums xml = (SELECT @SchemeResultsXML.query('(//Premium)') FOR XML PATH('Premiums'))	
		DECLARE @RiskCheckSum int = (SELECT @SchemeDetails.value('(//RiskCheckSum[text()])[1]', 'int'))
		DECLARE @SchemePolicyDetailsID bigint 
		EXECUTE @SchemePolicyDetailsID = [dbo].[uspSchemePolicyDetailsInsert] 
		   @SchemeTableID
		  ,@PolicyDetailsID
		  ,@PolicyQuoteStage
		  ,@PolicyQuoteStageMTA
		  ,@PreviousPolicyHistoryID
		  ,@PolicyStartDateTime
		  ,@RiskCheckSum
		  ,@SchemePremiums
		  ,@SchemeDetails
		  ,@HistoryID
		  
		INSERT INTO @ProductDetail VALUES ('<SchemePolicyDetailsID>' + CAST(@SchemePolicyDetailsID AS varchar(11)) + '</SchemePolicyDetailsID>')
	END		



	DECLARE  @EmployeesELManual int = 0
	SELECT @EmployeesELManual = [EmployeesELManual]	FROM @EmployeeCounts			
		
	DECLARE @AccIncom_CoverYN bit = (SELECT [CoverYN] FROM @AccIncom)
	DECLARE @ProfIndmTable_PIYN bit = (SELECT [PIYN] FROM @ProfIndm)		
	
	INSERT INTO @Refer 
		  SELECT 'Public Liability cannot be £0.00'				FROM @Premium WHERE [Name] = 'LIABPREM' AND ISNULL([Value],0) = 0
	UNION SELECT 'Employees Liability cannot be £0.00'			FROM @Premium WHERE	[Name] = 'EMPLPREM' AND ISNULL([Value],0) = 0 AND (@EmployeesELManual > 0)		
	UNION SELECT 'Accident Income Cover cannot be £0.00'		FROM @Premium WHERE	[Name] = 'PAASPREM' AND ISNULL([Value],0) = 0 AND @AccIncom_CoverYN = 1		
	UNION SELECT 'Professional Indemnity Cover cannot be £0.00'	FROM @Premium WHERE	[Name] = 'PROFPREM' AND ISNULL([Value],0) = 0 AND @ProfIndmTable_PIYN = 1		


--Table Counts
	DECLARE @ReferCount int = (SELECT COUNT(*) FROM @Refer)
	DECLARE @DeclineCount int = (SELECT COUNT(*) FROM @Decline)
	
--Refer Premiums.
	IF @ReferCount > 0 
	BEGIN

		UPDATE
			@Premium 
		SET 
			[Value] = 
			CASE 
				WHEN [Name] = 'EMPLPREM' AND (CASE WHEN @SchemeTableID IN (1596, 1607) AND @EmployeesELManual > 0 THEN 1 
			                                  WHEN @SchemeTableID NOT IN (1596, 1607) AND @EmployeesELManual >= 0 THEN 1 
											  ELSE 0 
										      END) = 1 AND ISNULL([Value],0) = 0 THEN 1  /* Changed from @EmployeesELManual > 0 to  @EmployeesELManual >= 0*/
				WHEN [Name] = 'LIABPREM' AND ISNULL([Value],0) = 0 THEN 1
				WHEN [Name] = 'PAASPREM' AND @AccIncom_CoverYN = 1    AND ISNULL([Value],0) = 0 /*AND {predicate} */ THEN 1
				WHEN [Name] = 'PROFPREM' AND @ProfIndmTable_PIYN  = 1 AND ISNULL([Value],0) = 0 /*AND {predicate} */ THEN 1
				ELSE [Value]
			END
	END

/*
Rule Based commission and Premium adjustment
*/
	DECLARE 
		 @LOB varchar(255) = 'Small Business & Consultants Liability'
		,@Trade varchar(255) 
		,@SecondaryTrade varchar(255) 
		,@IndemnityLevel varchar(255) = (SELECT PubLiabLimit FROM @CInfo)
		,@EmployeeLevel varchar(255)  = (SELECT TotalEmployees FROM @EmployeeCounts)

		SELECT 
			 @Trade = [PrimaryRisk]
			,@IndemnityLevel = [PubLiabLimit]
			,@HistoryID = [HistoryID]
		FROM
			@CInfo

	SELECT @SchemeResultsXML = [dbo].[svfSchemeCommissionApportionment] (@SchemeTableID ,@AgentName ,@SubAgentID ,@PolicyQuoteStage ,@PolicyDetailsID ,@HistoryID ,@LOB ,@Trade ,@SecondaryTrade ,@IndemnityLevel ,@EmployeeLevel ,@Postcode ,@PolicyStartDateTime ,@Premium)

	INSERT INTO @ProductDetail
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//ProductDetail)') AS T(x) 

	INSERT INTO @Breakdown
	SELECT	T.X.value('(./Message[text()])[1]', 'varchar(1000)') FROM @SchemeResultsXML.nodes('(//Breakdown)') AS T(x) 

	INSERT INTO @Premium2
	SELECT	T.X.value('(./Name[text()])[1]', 'varchar(20)'),T.X.value('(./Value[text()])[1]', 'money') ,T.X.value('(./PartnerCommission[text()])[1]', 'money') ,T.X.value('(./AgentCommission[text()])[1]', 'money') ,T.X.value('(./SubAgentCommission[text()])[1]', 'money') FROM @SchemeResultsXML.nodes('(//Premium)') AS T(x) 

	IF @OutputRisk = 1
	BEGIN
		select * from @Refer 
		select * from @Decline 
		select * from @Excess 
		select * from @Summary 
		select * from @Breakdown 
		select * from @ProductDetail 
		select * from @Premium2 
		select * from @Endorsement
	END

	EXECUTE [dbo].[MLIAB_uspSchemeResults] @Refer ,@Decline ,@Excess ,@Summary ,@Breakdown ,@ProductDetail ,@Premium2 ,@Endorsement
	--INSERT INTO [Transactor_Support].[dbo].[TestResultsRefer] SELECT @PolicyDetailsID ,@HistoryID ,[Message] FROM @Refer	
END
