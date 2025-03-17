USE [Transactor_Live];

DECLARE
	 @SchemeName nvarchar(255) = 'Tokio Marine HCC Open Market - Turnover'
	,@SchemeFileName  nvarchar(12) =  'TMOTO001.wpd'
	,@ProductTypeID int = 306
	,@InsurerID varchar(50) = '459'
	,@NetRated bit = 0
	,@InternetAvailable bit = 1
	,@ParameterGroupName varchar(255) =  'Commercial Scheme Parameters' -- Gets the ID to insert in RM_SCHEME
	,@RangeGroupName varchar(255) -- NULL - procedure will create new
	,@CommissionGroupName varchar(255) -- NULL - procedure will create new
	,@RangePrefix char(5) = 'TMOTO'
	,@ErrorText varchar(4000) = ''
			
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
	
SELECT 	@ErrorText
GO


UPDATE 
	[C]
SET	
	 [C].[NB_Partner_Percent] = 20
	,[C].[MTA_Partner_Percent] = 20
	,[C].[REN_Partner_Percent] = 20
FROM 
	[dbo].[RM_Commission_Group] AS [CG]
 	JOIN [dbo].[RM_COMMISSION] AS [C] ON [C].[COMMISSION_GROUP_ID] =[CG].[COMMISSION_GROUP_ID]
WHERE 
	[CG].[Name] = 'Tokio Marine HCC Open Market - Turnover'
GO