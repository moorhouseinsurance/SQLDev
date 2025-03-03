USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[MLIAB_AXA_TradesmanLiability_svfRiskChecksum]    Script Date: 14/01/2025 14:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
-- Author:		Devlin Hostler
-- Date:        09 Sep 2020
-- Description: Return Risk Checksum
*******************************************************************************
-- Date			Who						Change
-- 14/01/2025   Linga					Monday Ticket 8177482880: Changes to TL and Companion TL Scheme - Quarz & Solar
                                         -- Solution: Replaced [MLIAB_TrdDtailTableType] with new [MLIAB_TrdDtail_TableType] that contains the new fields

*******************************************************************************/
ALTER FUNCTION [dbo].[MLIAB_AXA_TradesmanLiability_svfRiskChecksum]
(
	 @PolicyQuoteStage varchar(3)
    ,@PolicyStartDateTime datetime = NULL
	,@InceptionStartDateTime datetime = NULL
	,@EmployeeCounts EmployeeCountsTableType READONLY
	,@TrdDtail MLIAB_TrdDtail_TableType READONLY
	,@CInfo MLIAB_CInfoTableType READONLY
	,@CAR MLIAB_CARTableType READONLY
	,@SchemeResultsXMLRenewal dbo.SchemeResultsXMLTableType READONLY
)

/*

truncate table Transactor_live.dbo.uspSchemeCommandDebug
Select * from Transactor_live.dbo.uspSchemeCommandDebug WHERE uspSchemeCommandText LIKE '%MLIAB_uspCalculator%1325%'

*/
RETURNS int

BEGIN	
	
	DECLARE		
		 @TrdDtail_PrimaryRisk varchar(250)		
		,@TrdDtail_SecondaryRisk varchar(250)
		,@TrdDtail_Phase bit
		,@TrdDtail_MaxDepthValue int 
		,@TrdDtail_CorgiReg bit   
	SELECT	 
		 @TrdDtail_PrimaryRisk = PrimaryRisk
		,@TrdDtail_SecondaryRisk = SecondaryRisk
		,@TrdDtail_Phase = Phase
		,@TrdDtail_MaxDepthValue = [dbo].[svfFormatNumber]([MaxDepth])
		,@TrdDtail_CorgiReg = CorgiReg
	FROM
		@TrdDtail

	DECLARE	   
		 @CInfo_PubLiabLimit varchar(250)
		,@CInfo_MaxHeight varchar(250) 
		,@CInfo_ToolCoverValue int	
		,@CInfo_EmployeeTool bit
		,@CInfo_ToolValue varchar(8)					
		,@CInfo_YrsExp money
		,@CInfo_YrEstablished money
		,@CInfo_TempInsurance bit
		,@CInfo_BonaFideWR money
		,@CInfo_Annualturnover money
	SELECT	   
		 @CInfo_PubLiabLimit	= PubLiabLimit
		,@CInfo_MaxHeight		= MaxHeight
		,@CInfo_ToolCoverValue	= [dbo].[svfFormatNumber]([ToolValue])
		,@CInfo_EmployeeTool	= EmployeeTool
		,@CInfo_ToolValue		= ToolValue			
		,@CInfo_YrsExp			= YrsExp		 
		,@CInfo_YrEstablished	= YrEstablished	 
		,@CInfo_TempInsurance	= TempInsurance	
		,@CInfo_BonaFideWR		= BonaFideWR	
		,@CInfo_Annualturnover	= Annualturnover
	FROM
		@CInfo

	DECLARE  
		 @ContractWork bit
		,@OwnPlant bit
		,@HiredPlant bit
		,@ContractWorkValue  varchar(250) 
		,@OwnPlantValue  varchar(250) 
		,@HiredPlantValue  varchar(250) 
		,@HiredPlantCharges  varchar(250) 

	SELECT
		 @ContractWork		= [Contractsworks]
		,@OwnPlant			= [coverplant]
		,@HiredPlant		= [coverhireplant]
		,@ContractWorkValue	= [MaxContractVal]
		,@OwnPlantValue		= [OwnPlantMacVal] 
		,@HiredPlantValue	= [HirPlantMacVal]
		,@HiredPlantCharges	= [HireChargeVal]
	FROM
		@CAR

--Employees
	DECLARE
		 @EmployeesELManual int
		,@EmployeesELNonManual int
		,@EmployeesPL int
	SELECT
		 @EmployeesELManual =		[EmployeesELManual]
		,@EmployeesELNonManual =	[EmployeesELNonManual]
		,@EmployeesPL =				[EmployeesPL]
	FROM
		@EmployeeCounts

	DECLARE @SchemeResultsXML xml
	SELECT  @SchemeResultsXML = (SELECT [SchemeResultsXML] FROM @SchemeResultsXMLRenewal FOR XML PATH(''))

	DECLARE 
		 @PreviousHistoryID int
		,@ERFMovement int 
		,@PostcodeAreaPL [numeric](5,3)
		,@PostcodeAreaEL [numeric](5,3)
		,@PostcodeAreaMD [numeric](5,3)
	
	SELECT 
		 @PostcodeAreaPL = T.X.value('(./PostcodeAreaPL[text()])[1]', 'int')		
		,@PostcodeAreaEL = T.X.value('(./PostcodeAreaEL[text()])[1]', 'int')		
		,@PostcodeAreaMD = T.X.value('(./PostcodeAreaMD[text()])[1]', 'int')		
	FROM
		@SchemeResultsXML.nodes('(//SchemeDetails)') AS T(x)

	DECLARE @CheckSum int = CHECKSUM(
		 @TrdDtail_PrimaryRisk
		,@TrdDtail_SecondaryRisk
		,@TrdDtail_Phase
		,@TrdDtail_MaxDepthValue
		,@TrdDtail_CorgiReg 
		,@CInfo_PubLiabLimit
		,@CInfo_MaxHeight
		,@CInfo_ToolCoverValue
		,@CInfo_EmployeeTool
		,@CInfo_ToolValue				
		,@CInfo_TempInsurance
		,@CInfo_BonaFideWR
		,@CInfo_Annualturnover
		,@ContractWork
		,@OwnPlant
		,@HiredPlant
		,@ContractWorkValue
		,@OwnPlantValue
		,@HiredPlantValue
		,@HiredPlantCharges
		,@EmployeesELManual
		,@EmployeesELNonManual
		,@EmployeesPL
		,@PostcodeAreaPL
		,@PostcodeAreaEL
		,@PostcodeAreaMD
	)
	
	RETURN @CheckSum
END
