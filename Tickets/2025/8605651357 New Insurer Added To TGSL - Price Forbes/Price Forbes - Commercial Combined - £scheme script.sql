USE [Transactor_Live]
GO
-- ===========
-- ADD INSURER
-- ===========
IF NOT EXISTS (SELECT * FROM SYSTEM_INSURER WHERE INSURER_DEBUG LIKE 'Price Forbes')
BEGIN
INSERT INTO SYSTEM_INSURER (
	 [INSURER_ID]
	,[INSURER_DEBUG]
	,[REGISTERED_OFFICE]
	,[REGISTERED_IN]
	,[DELETED]
	,[POLARIS_ID]
	,[AGENCY_NUMBER]
	,[COVER_NOTE_PREFIX]
	,[COVER_NOTE_SUFFIX]
	,[GREEN_CARD]
	,[INSURER_ADDRESS]
	,[MC_PRODUCT]
	,[CV_PRODUCT]
	,[OSPV_PRODUCT]
	,[ADDRESS_ID]
	,[CONFIRMNCB]
	,[ABI_CODE]
	,[CODELIST81]
	,[BANK_DETAILS_ID]
	,[ABIVALUE]
)
VALUES('PRCEFRBS', 'Price Forbes', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0)
END
GO

-- ===========
-- ADD SCHEMES
-- ===========
--============================================================
-- 1. Commercial Combined
--============================================================
--SELECT * FROM [RM_PRODUCT] WHERE NAME LIKE '%Commercial%'
DECLARE
	 @SchemeName nvarchar(255) = 'Price Forbes - Commercial Combined'
	,@SchemeFileName  nvarchar(12) =  'POFCC001.wpd'
	,@ProductTypeID int = 222
	,@InsurerID varchar(50) = 'PRCEFRBS'
	,@NetRated bit = 0
	,@InternetAvailable bit = 1
	,@ParameterGroupName varchar(255) =  'Commercial Scheme Parameters' -- Gets the ID to insert in RM_SCHEME
	,@RangeGroupName varchar(255) -- NULL - procedure will create new
	,@CommissionGroupName varchar(255) -- NULL - procedure will create new
	,@RangePrefix char(5) = 'POFCC'
	,@ErrorText varchar(4000) = ''
    ,@AgentID varchar(MAX) = 'E2F376B621E14C1FB532CED74C7EDCE1,5208F39A498E4706A91BEEC84ED25686,83512274B9F14EBF9B4F81DE2591EC80' -- Constructaquote,Constructaquote.com, Moorhouse
						
		
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
GO


UPDATE 
	[C]
SET	
	 [C].[NB_Partner_Percent] = 10
	,[C].[MTA_Partner_Percent] = 10
	,[C].[REN_Partner_Percent] = 10
FROM 
	[dbo].[RM_Commission_Group] AS [CG]
 	JOIN [dbo].[RM_COMMISSION] AS [C] ON [C].[COMMISSION_GROUP_ID] =[CG].[COMMISSION_GROUP_ID]
WHERE 
	[CG].[Name] = 'Price Forbes - Commercial Combined'
GO


INSERT INTO [Product].[Content].[Scheme]
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
	,CONVERT(DATE, GETDATE())
FROM
	[RM_Scheme]
WHERE
	[Name] = 'Price Forbes - Commercial Combined'
GO
