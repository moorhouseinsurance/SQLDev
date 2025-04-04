USE [Product]
GO
/****** Object:  UserDefinedFunction [QuestionSet].[tvfProductPolicyAnswer]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Name:    [dbo].[tvfProductPolicyAnswer] 
-- Author:  Devlin Hostler
-- date:    26 Nov 2010
-- Description: Returns the Answer set for a product as a single table
*******************************************************************************/
CREATE Function [QuestionSet].[tvfProductPolicyAnswer] 
(
	 @Product_id char(32)
	,@Insured_Party_ID char(32)
	,@Insured_Party_History_ID int
	,@Policy_Details_ID char(32)
	,@PolicyDetailsHistory_ID int
)
RETURNS @Returntable Table 
(

	 PrimaryKeyID varchar(32)
	,TableName varchar(50)	
	,FieldName varchar(50)
	,FieldValue varchar(4000)
)
AS

/*
DECLARE @Product_ID char(32)
DECLARE @Insured_Party_ID char(32)
DECLARE @Insured_Party_History_ID int
DECLARE @Policy_Details_ID char(32)
DECLARE @PolicyDetailsHistory_ID int

SET @Policy_Details_ID = 'D5D447BE1AEF49A4B30C77C59D30FF2F'
SET @PolicyDetailsHistory_ID = 1
SET @Product_ID = 'DD5B021CFDA44734957203889344C09E'
SET @Insured_Party_ID = '0EE1D8449B1843F09F23CE5C5EEEBEE9'
SET @Insured_Party_History_ID = 1


SELECT * FROM [QuestionSet].[tvfProductPolicyAnswer](@Product_ID,@Insured_Party_ID,@Insured_Party_History_ID,@Policy_Details_ID,@PolicyDetailsHistory_ID)

SELECT [T].[Policy_Details_ID],[T].[History_ID],count(*) FROM [dbo].[USER_MLIAB_CLMSUM] AS [T] JOIN [dbo].[USER_MLIAB_CLMDTAIL] AS [T1] ON [T1].[MLIAB_CLMSUM_ID] = [T].[MLIAB_CLMSUM_ID]
group by [T].[Policy_Details_ID],[T].[History_ID]
having count(*) > 1 order by count(*) desc


*/
BEGIN


	DECLARE @XML xml


SELECT @xml = 
(
	SELECT
	(
	
		SELECT TOP 1 @Insured_Party_ID AS [INSURED_PARTY_ID] ,@Insured_Party_History_ID AS [HISTORY_ID] ,[COMPANY] ,[TITLE_ID] ,[FORENAME] ,[SURNAME] ,[DOB] ,[COMPANYCONTACTNAME] ,[DATEESTABLISHED] ,[EMAIL]
		FROM [dbo].[CUSTOMER_INSURED_PARTY] AS [T]WITH(NOLOCK) WHERE [T].[INSURED_PARTY_ID] = @Insured_Party_ID  AND [T].[HISTORY_ID] = @Insured_Party_History_ID
		FOR	XML PATH('CUSTOMER_INSURED_PARTY'), TYPE					
	)
	,
	(
		SELECT TOP 1 [ADDRESS_ID] ,[POSTCODE] ,[HOUSE] ,[STREET] ,[LOCALITY] ,[CITY] ,[COUNTY]
		FROM [dbo].[CUSTOMER_CLIENT_ADDRESS] AS [T] WHERE [T].[INSURED_PARTY_ID] = @Insured_Party_ID  AND [T].[HISTORY_ID] = @Insured_Party_History_ID
		FOR	XML PATH('CUSTOMER_CLIENT_ADDRESS'), TYPE				
			
	)

	,
	(
		SELECT [TELEPHONE_ID] ,[TELEPHONENUMBER] ,[EXTENSION],[TELEPHONE_TYPE_ID] ,[EXDIRECTORYYN]
		FROM [dbo].[CUSTOMER_TELEPHONE] AS [T] WHERE [T].[INSURED_PARTY_ID] = @Insured_Party_ID  AND [T].[HISTORY_ID] = @Insured_Party_History_ID
		FOR	XML PATH('CUSTOMER_TELEPHONE'), TYPE								
	)		
	FOR XML PATH (''), ELEMENTS XSINIL		
)		

INSERT INTO @Returntable
SELECT		
	 --CASE WHEN xTable.n.value('(./*[1])', 'VARCHAR(MAX)') = @Policy_Details_ID THEN NULL ELSE xTable.n.value('(./*[1])', 'VARCHAR(MAX)') END AS [PrimaryKeyID]	
	 xTable.n.value('(./*[1])', 'VARCHAR(MAX)') AS [PrimaryKeyID]		
	,xTable.n.value('local-name(.)', 'VARCHAR(MAX)') AS [TableName]
	,[Fields].[FieldName]
	,[Fields].[FieldValue]
FROM		
	@XML.nodes('/*') AS xTable(n)
	CROSS APPLY	
	(
		SELECT 
			 xField.n.value('local-name(.)' , 'VARCHAR(MAX)') AS [FieldName]
			,xField.n.value('.', 'VARCHAR(MAX)') AS [FieldValue]
		FROM	
			xTable.n.nodes('./*') AS xField(n)
	) AS [Fields]

	IF @Product_ID = 'A0E84546FD3E460884820F867CF62804' --Business Support
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MBUS_MAINSCRE] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MBUS_MAINSCRE'), TYPE
			)

			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END


	IF @Product_ID = 'DD5B021CFDA44734957203889344C09E' --Tradesmans Liability
	BEGIN
		SELECT @xml =
		(
			SELECT 
			(
				SELECT Top 1 * FROM [dbo].[USER_MLIAB_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLIAB_ASSUMP'), TYPE
			)
			,		
			(
				SELECT Top 1 * FROM [dbo].[USER_MLIAB_BUSSUPP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLIAB_BUSSUPP'), TYPE
			)
			,
			(
				SELECT Top 1 * FROM [dbo].[USER_MLIAB_CINFO] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLIAB_CINFO'), TYPE
			)		
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MLIAB_CLMSUM] AS [T] JOIN [dbo].[USER_MLIAB_CLMDTAIL] AS [T1] ON [T1].[MLIAB_CLMSUM_ID] = [T].[MLIAB_CLMSUM_ID]   WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLIAB_CLMDTAIL'), TYPE
			)
			,		
			(
				SELECT Top 1 * FROM [dbo].[USER_MLIAB_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLIAB_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MLIAB_CINFO] AS [T] JOIN [dbo].[USER_MLIAB_PANDP] AS [T1] ON [T1].[MLIAB_CINFO_ID] = [T].[MLIAB_CINFO_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLIAB_PANDP'), TYPE
			)
			,
			(
				SELECT Top 1 * FROM [dbo].[USER_MLIAB_TRDDTAIL] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLIAB_TRDDTAIL'), TYPE
			)		
			,
			(
				SELECT Top 1 * FROM [dbo].[USER_MLIAB_CAR] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLIAB_CAR'), TYPE
			)	
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END

	IF @Product_ID = 'B39873D2146C466D8C00B21D1104D5DC' --Small Business and Consultancey
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MCLIAB_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCLIAB_ASSUMP'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MCLIAB_CINFO] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCLIAB_CINFO'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCLIAB_CLMSUM] AS [T] JOIN [dbo].[USER_MCLIAB_CLMDTAIL] AS [T1] ON [T1].[MCLIAB_CLMSUM_ID] = [T].[MCLIAB_CLMSUM_ID]   WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCLIAB_CLMDTAIL'), TYPE
			)
			,		
			(
				SELECT Top 1 * FROM [dbo].[USER_MCLIAB_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCLIAB_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCLIAB_CINFO] AS [T] JOIN [dbo].[USER_MCLIAB_PANDP] AS [T1] ON [T1].[MCLIAB_CINFO_ID] = [T].[MCLIAB_CINFO_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCLIAB_PANDP'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END

	IF @Product_ID = '4318A62733AD444DBBA0AB2A586D5021' --Professional Indemnity
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MPROIND_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_ASSUMP'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_BUSINESS] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_BUSINESS'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_CLIENTDT] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_CLIENTDT'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MPROIND_CLMSUM] AS [T] JOIN [dbo].[USER_MPROIND_CLMDTAIL] AS [T1] ON [T1].[MPROIND_CLMSUM_ID] = [T].[MPROIND_CLMSUM_ID]   WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_CLMDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDBROKRS] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDBROKRS'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDCONSTR] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDCONSTR'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDESTATE] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDESTATE'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDINTDES] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDINTDES'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDIT] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDIT'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDLNDSUR] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDLNDSUR'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDMNGMNT] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDMNGMNT'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDMRKTNG] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDMRKTNG'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDSURVEY] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDSURVEY'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDTAXCON] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDTAXCON'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TDWILL] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TDWILL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MPROIND_TRDDTAIL] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MPROIND_TRDDTAIL'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END	
	
	IF @Product_ID = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' --Shop
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MSHOP_COMPANY] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MSHOP_COMPANY'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MSHOP_COMPANY] AS [T] JOIN [dbo].[USER_MSHOP_PANDP] AS [T1] ON [T1].[MSHOP_COMPANY_ID] = [T].[MSHOP_COMPANY_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MSHOP_PANDP'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MSHOP_ADDRESS] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MSHOP_ADDRESS'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MSHOP_PREMISES] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MSHOP_PREMISES'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MSHOP_CVRDTAIL] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MSHOP_CVRDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MSHOP_OPTCVR] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MSHOP_OPTCVR'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MSHOP_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MSHOP_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MSHOP_CLMSUM] AS [T] JOIN [dbo].[USER_MSHOP_CLMDTAIL] AS [T1] ON [T1].[MSHOP_CLMSUM_ID] = [T].[MSHOP_CLMSUM_ID]   WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLIAB_CLMDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MSHOP_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MSHOP_ASSUMP'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END	
	
	IF @Product_ID = '904B4440FE0B49FEA2CDBAEC11E113E0' --Let Property
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MLETPROP_PROPINFO] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLETPROP_PROPINFO'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MLETPROP_PROPINFO] AS [T] JOIN [dbo].[USER_MLETPROP_PRPDTAIL] AS [T1] ON [T1].[MLETPROP_PROPINFO_ID] = [T].[MLETPROP_PROPINFO_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLETPROP_PRPDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MLETPROP_ADDCOVER] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLETPROP_ADDCOVER'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MLETPROP_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLETPROP_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MLETPROP_CLMSUM] AS [T] JOIN [dbo].[USER_MLETPROP_CLMDTAIL] AS [T1] ON [T1].[MLETPROP_CLMSUM_ID] = [T].[MLETPROP_CLMSUM_ID]   WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLETPROP_CLMDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MLETPROP_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLETPROP_ASSUMP'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END	
	
	IF @Product_ID = '11166D0F357946DDB6D4E64CBD07BDE3' --GIT
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MGTRAN_POLINFO] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MGTRAN_POLINFO'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MGTRAN_POLINFO] AS [T] JOIN [dbo].[USER_MGTRAN_VEHDTAIL] AS [T1] ON [T1].[MGTRAN_POLINFO_ID] = [T].[MGTRAN_POLINFO_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MGTRAN_VEHDTAIL'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MGTRAN_POLINFO] AS [T] JOIN [dbo].[USER_MGTRAN_TRLDTAIL] AS [T1] ON [T1].[MGTRAN_POLINFO_ID] = [T].[MGTRAN_POLINFO_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MGTRAN_TRLDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MGTRAN_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MGTRAN_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MGTRAN_CLMSUM] AS [T] JOIN [dbo].[USER_MGTRAN_CLMDTAIL] AS [T1] ON [T1].[MGTRAN_CLMSUM_ID] = [T].[MGTRAN_CLMSUM_ID]   WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MGTRAN_CLMDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MGTRAN_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MGTRAN_ASSUMP'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END	
	
	IF @Product_ID = 'A6BC5EAC4F0244F4A66877E71C0968B5' --COURIER
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MCOURIER_PTVINFO] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOURIER_PTVINFO'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCOURIER_PTVINFO] AS [T] JOIN [dbo].[USER_MCOURIER_VEHDTAIL] AS [T1] ON [T1].[MCOURIER_PTVINFO_ID] = [T].[MCOURIER_PTVINFO_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOURIER_VEHDTAIL'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCOURIER_PTVINFO] AS [T] JOIN [dbo].[USER_MCOURIER_PANDP] AS [T1] ON [T1].[MCOURIER_PTVINFO_ID] = [T].[MCOURIER_PTVINFO_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOURIER_PANDP'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MCOURIER_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOURIER_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCOURIER_CLMSUM] AS [T] JOIN [dbo].[USER_MCOURIER_CLMDTAIL] AS [T1] ON [T1].[MCOURIER_CLMSUM_ID] = [T].[MCOURIER_CLMSUM_ID]   WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOURIER_CLMDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MCOURIER_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOURIER_ASSUMP'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END	
	
	IF @Product_ID = 'E7432392130E4E84B1D863C01891C42F' --CAR
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MCARISK_TCCINFO] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCARISK_TCCINFO'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCARISK_TCCINFO] AS [T] JOIN [dbo].[USER_MCARISK_PANDPS] AS [T1] ON [T1].[MCARISK_TCCINFO_ID] = [T].[MCARISK_TCCINFO_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCARISK_PANDPS'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MCARISK_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCARISK_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCARISK_CLMSUM] AS [T] JOIN [dbo].[USER_MCARISK_CLMDTAIL] AS [T1] ON [T1].[MCARISK_CLMSUM_ID] = [T].[MCARISK_CLMSUM_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCARISK_CLMDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MCARISK_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCARISK_ASSUMP'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END	
	
	IF @Product_ID = '381847D7AE1541E095ABF7FF0188F519' --Hauliers
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MHAUL_VEHCOVER] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MHAUL_VEHCOVER'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MHAUL_VEHCOVER] AS [T] JOIN [dbo].[USER_MHAUL_VEHDTAIL] AS [T1] ON [T1].[MHAUL_VEHCOVER_ID] = [T].[MHAUL_VEHCOVER_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MHAUL_VEHDTAIL'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MHAUL_PLCYINFO] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MHAUL_PLCYINFO'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MHAUL_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MHAUL_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MHAUL_CLMSUM] AS [T] JOIN [dbo].[USER_MHAUL_CLMDTAIL] AS [T1] ON [T1].[MHAUL_CLMSUM_ID] = [T].[MHAUL_CLMSUM_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MHAUL_CLMDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MHAUL_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MHAUL_ASSUMP'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END	
	
	IF @Product_ID = '3C885E4C613B4B1FB279C313E43ABC1E' --Office
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MCOMMOFF_PDETAILS] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOMMOFF_PDETAILS'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCOMMOFF_PDETAILS] AS [T] JOIN [dbo].[USER_MCOMMOFF_PANDP] AS [T1] ON [T1].[MCOMMOFF_PDETAILS_ID] = [T].[MCOMMOFF_PDETAILS_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOMMOFF_PANDP'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MCOMMOFF_ADDRESS] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOMMOFF_ADDRESS'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MCOMMOFF_SECURITY] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOMMOFF_SECURITY'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MCOMMOFF_COVDTAIL] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOMMOFF_COVDTAIL'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MCOMMOFF_ADDCOVER] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOMMOFF_ADDCOVER'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MCOMMOFF_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOMMOFF_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCOMMOFF_CLMSUM] AS [T] JOIN [dbo].[USER_MCOMMOFF_CLMDTAIL] AS [T1] ON [T1].[MCOMMOFF_CLMSUM_ID] = [T].[MCOMMOFF_CLMSUM_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOMMOFF_CLMDTAIL'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MCOMMOFF_CLMSUM] AS [T] JOIN [dbo].[USER_MCOMMOFF_CLMDTAIL] AS [T1] ON [T1].[MCOMMOFF_CLMSUM_ID] = [T].[MCOMMOFF_CLMSUM_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MCOMMOFF_CLMDTAIL'), TYPE
			)
			,	
			(
				SELECT * FROM [dbo].[USER_MKEYCARE_MKEYCARE] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MKEYCARE_MKEYCARE'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END	
	
	IF @Product_ID = 'D3637A1323EE44979683AAFF53D9E02A' --Introducer Lead Capture
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MIAR_CompInfo] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MIAR_CompInfo'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END		
	

	
	IF @Product_ID = '8989E4213E3F4584AAF2AD991E46DC61' --Landlord in Residence and Tenants Contents
	BEGIN
		SELECT @xml =
		(
			SELECT
			(
				SELECT * FROM [dbo].[USER_MLRTC_ADDCOVER] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLRTC_ADDCOVER'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MLRTC_ASSUMP] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLRTC_ASSUMP'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MLRTC_CLMSUM] AS [T] JOIN [dbo].[USER_MLRTC_CLMDTAIL] AS [T1] ON [T1].[MLRTC_CLMSUM_ID] = [T].[MLRTC_CLMSUM_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLRTC_CLMDTAIL'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MLRTC_CLMSUM] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLRTC_CLMSUM'), TYPE
			)
			,
			(
				SELECT [T1].* FROM [dbo].[USER_MLRTC_ADDCOVER] AS [T] JOIN [dbo].[USER_MLRTC_ITMCNTNS] AS [T1] ON [T1].[MLRTC_ADDCOVER_ID] = [T].[MLRTC_ADDCOVER_ID] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLRTC_ITMCNTNS'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MLRTC_OCCPANCY] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLRTC_OCCPANCY'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MLRTC_PROPINFO] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLRTC_PROPINFO'), TYPE
			)
			,
			(
				SELECT * FROM [dbo].[USER_MLRTC_PRPDTAIL] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH('USER_MLRTC_PRPDTAIL'), TYPE
			)
			FOR XML PATH (''), ELEMENTS XSINIL
		)
	END	

	/*Insert New LOB tables Here*/
		
		
				

	INSERT INTO @Returntable
	SELECT		
		 --CASE WHEN xTable.n.value('(./*[1])', 'VARCHAR(MAX)') = @Policy_Details_ID THEN NULL ELSE xTable.n.value('(./*[1])', 'VARCHAR(MAX)') END AS [PrimaryKeyID]	
		 xTable.n.value('(./*[1])', 'VARCHAR(MAX)') AS [PrimaryKeyID]		
		,xTable.n.value('local-name(.)', 'VARCHAR(MAX)') AS [TableName]
		,[Fields].[FieldName]
		,[Fields].[FieldValue]
	FROM		
		@XML.nodes('/*') AS xTable(n)
		CROSS APPLY	
		(
			SELECT 
				 xField.n.value('local-name(.)' , 'VARCHAR(MAX)') AS [FieldName]
				,xField.n.value('.', 'VARCHAR(MAX)') AS [FieldValue]
			FROM	
				xTable.n.nodes('./*') AS xField(n)
		) AS [Fields]

	RETURN
END


GO
