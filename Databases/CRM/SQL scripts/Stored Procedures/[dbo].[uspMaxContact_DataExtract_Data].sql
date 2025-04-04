USE [CRM]
GO
/****** Object:  StoredProcedure [dbo].[uspMaxContact_DataExtract_Data]    Script Date: 27/03/2025 10:03:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Simon Mackness-Pettit
-- Create Date: 09 Aug 2024
-- Description: Exract of campaign data for the MaxContact Dialler
-- =============================================

-- Date			Who						Change

ALTER PROCEDURE [dbo].[uspMaxContact_DataExtract_Data]
	 @RunDate	DATETIME --Usually todays date

AS

--    TEST HARNESS
--    To test this procedure, copy the whole commented section into a new query window, remove the lines
--    marked START and FINISH and run the statement

/* -- START

DECLARE @RunDate DATETIME

SET @RunDate = GETDATE()

EXEC [dbo].[uspMaxContact_DataExtract_Data] @RunDate

*/ -- FINISH

DECLARE @CampaignData AS TABLE
(
	[Campaign Type] VARCHAR(30)
	,[Last_Name] VARCHAR(120)
	,[First_Name] VARCHAR(120)
	,[Title] VARCHAR(10)
	,[Client Name] VARCHAR(140)
	,[Other Telephone] VARCHAR(20)
	,[Mobile Telephone] VARCHAR(30)
	,[Customer ID] VARCHAR(60)
	,[Customer Postcode] VARCHAR(10)
	,[Customer Email] VARCHAR(120)
	,[Agent] VARCHAR(60)
	,[Client Reference] VARCHAR(25)
	,[Company Name] VARCHAR(255)
	,[Client name/contact] VARCHAR(140)
	,[Other TPS Flag] VARCHAR(20)
	,[Mobile TPS Flag] INT
	,[Live Client Flag] VARCHAR(1)
	,[OGI Live Client Flag] VARCHAR(1)
	,[TradeList] VARCHAR(1)
	,[ProspectProduct1 Type] VARCHAR(60)
	,[ProspectProduct2 Type] VARCHAR(60)
	,[ProspectProduct2 Next Quote Due Date] DATETIME
	,[ProspectProduct3 Type] VARCHAR(60)
	,[ProspectProduct3 Next Quote Due Date] DATETIME
	,[ProspectProduct4 Type] VARCHAR(60)
	,[ProspectProduct4 Next Quote Due Date] DATETIME
	,[InsertDateTime] DATETIME
	,[UpdateDateTime] DATETIME
	,[Data Source] VARCHAR(1)
	,[ProspectProduct1 Next Quote Due Date] DATETIME
	,[TierGroup] VARCHAR(8)
	,[Trade] VARCHAR(160)
	,[CRMEntityStatus] VARCHAR(8)
	,[LiveProduct2 Expiry date] DATETIME
	,[LiveProduct2 Expiry Month] NVARCHAR(30)
	,[LiveProduct3 Expiry date] DATETIME
	,[LiveProduct3 Type] VARCHAR(60)
	,[LiveProduct3 Expiry Month] NVARCHAR(30)
	,[LiveProduct4 Expiry date] DATETIME
	,[LiveProduct4 Expiry Month] NVARCHAR(30)
	,[LiveProduct5 Type] VARCHAR(60)
	,[LiveProduct5 Expiry date] DATETIME
	,[LiveProduct5 Expiry Month] NVARCHAR(30)
	,[LiveProduct6 Type] VARCHAR(60)
	,[LiveProduct6 Expiry date] DATETIME
	,[LiveProduct6 Expiry Month] NVARCHAR(30)
	,[LiveProduct4 Type] VARCHAR(60)
	,[AutoCCDecline] VARCHAR(1)
	,[LiveProduct1 Type] VARCHAR(60)
	,[LiveProduct1 Expiry date] DATETIME
	,[LiveProduct1 Expiry Month] NVARCHAR(30)
	,[LiveProduct2 Type] VARCHAR(60)
)

INSERT INTO @CampaignData ([Campaign Type], [Last_Name], [First_Name], [Title], [Client Name], [Other Telephone], [Mobile Telephone], [Customer ID], [Customer Postcode], [Customer Email], [Agent], [Client Reference], [Company Name], [Client name/contact], [Other TPS Flag], [Mobile TPS Flag], [Live Client Flag], [OGI Live Client Flag], [TradeList], [ProspectProduct1 Type], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [ProspectProduct4 Next Quote Due Date], [InsertDateTime], [UpdateDateTime], [Data Source], [ProspectProduct1 Next Quote Due Date], [TierGroup], [Trade], [CRMEntityStatus])
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Title]
		,[Client Name]
		,[Other Telephone]
		,[Mobile Telephone]
		,[Customer ID]
		,[Customer Postcode]
		,[Customer Email]
		,[Agent]
		,[Client Reference]
		,[Company Name]
		,[Client name/contact]
		,[Other TPS Flag]
		,[Mobile TPS Flag]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[ProspectProduct1 Type]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[ProspectProduct4 Next Quote Due Date]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Data Source]
		,[ProspectProduct1 Next Quote Due Date]
		,[TierGroup]
		,[Trade]
		,[CRMEntityStatus]
	FROM
		(
			SELECT
				'SMEPot A' AS [Campaign Type]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,[MHDATA].[Agent]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
				,[MHDATA].[InsertDateTime]
				,[MHDATA].[UpdateDateTime]
				,NULL AS [Data Source]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[Trade]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
			FROM 
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[TradeList] = 'A'
			AND
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] > DATEADD(DAY, -365, @RunDate)
					AND
						[MHDATA].[ProspectProduct1 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					AND
						[MHDATA].[ProspectProduct1 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] > DATEADD(DAY, -365, @RunDate)
					AND
						[MHDATA].[ProspectProduct2 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					AND
						[MHDATA].[ProspectProduct2 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] > DATEADD(DAY, -365, @RunDate)
					AND
						[MHDATA].[ProspectProduct3 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					AND
						[MHDATA].[ProspectProduct3 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] > DATEADD(DAY, -365, @RunDate)
					AND
						[MHDATA].[ProspectProduct4 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					AND
						[MHDATA].[ProspectProduct4 Status] <> ''
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'N'
			AND
				(
					[MHDATA].[Mobile Telephone] IN ('', '0')
				OR
					[MHDATA].[Other Telephone] IN ('', '0')
				)
		) AS [Load];

INSERT INTO @CampaignData ([Campaign Type], [Last_Name], [First_Name], [Title], [Client Name], [Other Telephone], [Mobile Telephone], [Customer ID], [Customer Postcode], [Customer Email], [Data Source], [ProspectProduct1 Next Quote Due Date], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [TierGroup], [CRMEntityStatus], [Client Reference], [Company Name], [Client name/contact], [Other TPS Flag], [Mobile TPS Flag], [Live Client Flag], [OGI Live Client Flag], [TradeList], [Trade], [Agent], [ProspectProduct1 Type], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [ProspectProduct4 Next Quote Due Date], [UpdateDateTime], [InsertDateTime])
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Title]
		,[Client Name]
		,[Other Telephone]
		,[Mobile Telephone]
		,[Customer ID]
		,[Customer Postcode]
		,[Customer Email]
		,[Data Source]
		,[ProspectProduct1 Next Quote Due Date]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[TierGroup]
		,[CRMEntityStatus]
		,[Client Reference]
		,[Company Name]
		,[Client name/contact]
		,[Other TPS Flag]
		,[Mobile TPS Flag]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[Trade]
		,[Agent]
		,[ProspectProduct1 Type]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[ProspectProduct4 Next Quote Due Date]
		,[UpdateDateTime]
		,[InsertDateTime]
	FROM
		(
			SELECT
				'SMEPot B' AS [Campaign Type]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,NULL AS [Data Source]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[Trade]
				,[MHDATA].[Agent]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
				,[MHDATA].[UpdateDateTime]
				,[MHDATA].[InsertDateTime]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[TradeList] = 'A'
			AND
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND DATEADD(DAY, -366, @RunDate)
					AND
						[MHDATA].[ProspectProduct1 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					AND
						[MHDATA].[ProspectProduct1 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND DATEADD(DAY, -366, @RunDate)
					AND
						[MHDATA].[ProspectProduct2 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					AND
						[MHDATA].[ProspectProduct2 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND DATEADD(DAY, -366, @RunDate)
					AND
						[MHDATA].[ProspectProduct3 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					AND
						[MHDATA].[ProspectProduct3 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND DATEADD(DAY, -366, @RunDate)
					AND
						[MHDATA].[ProspectProduct4 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					AND
						[MHDATA].[ProspectProduct4 Status] <> ''
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'N'

			AND
				(
					[MHDATA].[Mobile Telephone] NOT IN ('', '0')
				OR
					[MHDATA].[Other Telephone] NOT IN ('', '0')
				)
			AND
				[MHDATA].[Mobile TPS Flag] <> 1
			AND
				[MHDATA].[Other TPS Flag] <> 1
		) AS [Load];

INSERT INTO @CampaignData ([Campaign Type], [Last_Name], [First_Name], [Title], [Client Name], [Other Telephone], [Mobile Telephone], [Customer ID], [Customer Postcode], [Customer Email], [Company Name], [Client name/contact], [Other TPS Flag], [Mobile TPS Flag], [Live Client Flag], [OGI Live Client Flag], [TradeList], [Trade], [Agent], [ProspectProduct1 Type], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [ProspectProduct4 Next Quote Due Date], [InsertDateTime], [UpdateDateTime], [Data Source], [ProspectProduct1 Next Quote Due Date], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [TierGroup], [Client Reference], [CRMEntityStatus])
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Title]
		,[Client Name]
		,[Other Telephone]
		,[Mobile Telephone]
		,[Customer ID]
		,[Customer Postcode]
		,[Customer Email]
		,[Company Name]
		,[Client name/contact]
		,[Other TPS Flag]
		,[Mobile TPS Flag]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[Trade]
		,[Agent]
		,[ProspectProduct1 Type]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[ProspectProduct4 Next Quote Due Date]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Data Source]
		,[ProspectProduct1 Next Quote Due Date]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[TierGroup]
		,[Client Reference]
		,[CRMEntityStatus]
	FROM
		(
			SELECT
				'SMEPot C' AS [Campaign Type]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[Trade]
				,[MHDATA].[Agent]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
				,[MHDATA].[InsertDateTime]
				,[MHDATA].[UpdateDateTime]
				,NULL AS [Data Source]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[Client Reference]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[TradeList] = 'B'
			AND
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND @RunDate
					AND
						[MHDATA].[ProspectProduct1 Status] NOT IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND @RunDate
					AND
						[MHDATA].[ProspectProduct2 Status] NOT IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND @RunDate
					AND
						[MHDATA].[ProspectProduct3 Status] NOT IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND @RunDate
					AND
						[MHDATA].[ProspectProduct4 Status] NOT IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'N'
			AND
				(
					[MHDATA].[Mobile Telephone] NOT IN ('', '0')
				OR
					[MHDATA].[Other Telephone] NOT IN ('', '0')
				)
			AND
				[MHDATA].[Mobile TPS Flag] <> 1
			AND
				[MHDATA].[Other TPS Flag] <> 1
		) AS [Load];

INSERT INTO @CampaignData ([Campaign Type], [Customer Postcode], [Customer ID], [Mobile Telephone], [Other Telephone], [Client Name], [Title], [First_Name], [Last_Name], [Customer Email], [ProspectProduct1 Next Quote Due Date], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [TierGroup], [CRMEntityStatus], [Client Reference], [Company Name], [Client name/contact], [UpdateDateTime], [Other TPS Flag], [Live Client Flag], [OGI Live Client Flag], [TradeList], [Trade], [Agent], [ProspectProduct1 Type], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [Mobile TPS Flag], [InsertDateTime], [Data Source], [ProspectProduct4 Next Quote Due Date])
	SELECT
		[Campaign Type]
		,[Customer Postcode]
		,[Customer ID]
		,[Mobile Telephone]
		,[Other Telephone]
		,[Client Name]
		,[Title]
		,[First_Name]
		,[Last_Name]
		,[Customer Email]
		,[ProspectProduct1 Next Quote Due Date]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[TierGroup]
		,[CRMEntityStatus]
		,[Client Reference]
		,[Company Name]
		,[Client name/contact]
		,[UpdateDateTime]
		,[Other TPS Flag]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[Trade]
		,[Agent]
		,[ProspectProduct1 Type]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[Mobile TPS Flag]
		,[InsertDateTime]
		,[Data Source]
		,[ProspectProduct4 Next Quote Due Date]
	FROM
		(
			SELECT
				'SMEPot D' AS [Campaign Type]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[UpdateDateTime]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[Trade]
				,[MHDATA].[Agent]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[InsertDateTime]
				,NULL AS [Data Source]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'Y'
			AND
				(
					[MHDATA].[Mobile Telephone] NOT IN ('', '0')
				OR
					[MHDATA].[Other Telephone] NOT IN ('', '0')
				)
			AND
				[MHDATA].[Mobile TPS Flag] <> 1
			AND
				[MHDATA].[Other TPS Flag] <> 1
		) AS [Load];

INSERT INTO @CampaignData ([Campaign Type], [Last_Name], [First_Name], [Title], [Client Name], [Other Telephone], [Mobile Telephone], [Customer ID], [Customer Postcode], [Customer Email], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [TierGroup], [CRMEntityStatus], [Client Reference], [Company Name], [Client name/contact], [UpdateDateTime], [Data Source], [Other TPS Flag], [OGI Live Client Flag], [TradeList], [Trade], [Agent], [ProspectProduct1 Type], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [Mobile TPS Flag], [Live Client Flag], [ProspectProduct4 Next Quote Due Date], [ProspectProduct1 Next Quote Due Date], [InsertDateTime])
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Title]
		,[Client Name]
		,[Other Telephone]
		,[Mobile Telephone]
		,[Customer ID]
		,[Customer Postcode]
		,[Customer Email]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[TierGroup]
		,[CRMEntityStatus]
		,[Client Reference]
		,[Company Name]
		,[Client name/contact]
		,[UpdateDateTime]
		,[Data Source]
		,[Other TPS Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[Trade]
		,[Agent]
		,[ProspectProduct1 Type]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[Mobile TPS Flag]
		,[Live Client Flag]
		,[ProspectProduct4 Next Quote Due Date]
		,[ProspectProduct1 Next Quote Due Date]
		,[InsertDateTime]
	FROM
		(
			SELECT
				'SMEPot E' AS [Campaign Type]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[UpdateDateTime]
				,NULL AS [Data Source]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[Trade]
				,[MHDATA].[Agent]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[InsertDateTime]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct1 Status] IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct2 Status] IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct3 Status] IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct4 Status] IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'N'
			AND
				(
					[MHDATA].[Mobile Telephone] NOT IN ('', '0')
				OR
					[MHDATA].[Other Telephone] NOT IN ('', '0')
				)
			AND
				[MHDATA].[Mobile TPS Flag] <> 1
			AND
				[MHDATA].[Other TPS Flag] <> 1
		) AS [Load];

/*	SME Auto CC Decline API	*/
INSERT INTO @CampaignData ([Campaign Type], [Last_Name], [First_Name], [Customer ID], [Mobile Telephone], [Other Telephone], [Title], [Customer Postcode], [Customer Email], [Client name/contact], [LiveProduct2 Expiry date], [LiveProduct2 Expiry Month], [LiveProduct3 Expiry date], [LiveProduct3 Type], [Agent], [LiveProduct3 Expiry Month], [LiveProduct4 Expiry date], [LiveProduct4 Expiry Month], [LiveProduct5 Type], [LiveProduct5 Expiry date], [LiveProduct5 Expiry Month], [LiveProduct6 Type], [LiveProduct6 Expiry date], [LiveProduct6 Expiry Month], [InsertDateTime], [Client Reference], [Mobile TPS Flag], [LiveProduct4 Type], [UpdateDateTime], [Live Client Flag], [OGI Live Client Flag], [AutoCCDecline], [LiveProduct1 Type], [LiveProduct1 Expiry date], [LiveProduct1 Expiry Month], [LiveProduct2 Type], [Other TPS Flag])
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Customer ID]
		,[Mobile Telephone]
		,[Other Telephone]
		,[Title]
		,[Customer Postcode]
		,[Customer Email]
		,[Client name/contact]
		,[LiveProduct2 Expiry date]
		,[LiveProduct2 Expiry Month]
		,[LiveProduct3 Expiry date]
		,[LiveProduct3 Type]
		,[Agent]
		,[LiveProduct3 Expiry Month]
		,[LiveProduct4 Expiry date]
		,[LiveProduct4 Expiry Month]
		,[LiveProduct5 Type]
		,[LiveProduct5 Expiry date]
		,[LiveProduct5 Expiry Month]
		,[LiveProduct6 Type]
		,[LiveProduct6 Expiry date]
		,[LiveProduct6 Expiry Month]
		,[InsertDateTime]
		,[Client Reference]
		,[Mobile TPS Flag]
		,[LiveProduct4 Type]
		,[UpdateDateTime]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[AutoCCDecline]
		,[LiveProduct1 Type]
		,[LiveProduct1 Expiry date]
		,[LiveProduct1 Expiry Month]
		,[LiveProduct2 Type]
		,[Other TPS Flag]
	FROM
		(
			SELECT
				'SME Auto CC Decline API' AS [Campaign Type]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Insured_Party_ID] AS [Customer ID]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,[MHDATA].[Client name/contact] AS [Client name/contact]
				,[MHDATA].[LiveProduct2 Expiry date] AS [LiveProduct2 Expiry date]
				,[MHDATA].[LiveProduct2 Expiry Month] AS [LiveProduct2 Expiry Month]
				,[MHDATA].[LiveProduct3 Expiry date] AS [LiveProduct3 Expiry date]
				,[MHDATA].[LiveProduct3 Type] AS [LiveProduct3 Type]
				,[MHDATA].[Agent]
				,[MHDATA].[LiveProduct3 Expiry Month] AS [LiveProduct3 Expiry Month]
				,[MHDATA].[LiveProduct4 Expiry date] AS [LiveProduct4 Expiry date]
				,[MHDATA].[LiveProduct4 Expiry Month] AS [LiveProduct4 Expiry Month]
				,[MHDATA].[LiveProduct5 Type]
				,[MHDATA].[LiveProduct5 Expiry date]
				,[MHDATA].[LiveProduct5 Expiry Month]
				,[MHDATA].[LiveProduct6 Type]
				,[MHDATA].[LiveProduct6 Expiry date]
				,[MHDATA].[LiveProduct6 Expiry Month]
				,[MHDATA].[InsertDateTime]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[LiveProduct4 Type]
				,[MHDATA].[UpdateDateTime]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[AutoCCDecline]
				,[MHDATA].[LiveProduct1 Type]
				,[MHDATA].[LiveProduct1 Expiry date]
				,[MHDATA].[LiveProduct1 Expiry Month]
				,[MHDATA].[LiveProduct2 Type]
				,[MHDATA].[Other TPS Flag] AS [Other TPS Flag]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[AutoCCDecline] = 'Y'
		) AS [Load];

/*	SME DATA API Specialist Risks	*/
INSERT INTO @CampaignData ([Campaign Type], [Customer Postcode], [Customer ID], [Mobile Telephone], [Other Telephone], [Client Name], [Title], [First_Name], [Last_Name], [CRMEntityStatus], [ProspectProduct1 Next Quote Due Date], [Data Source], [UpdateDateTime], [InsertDateTime], [ProspectProduct4 Next Quote Due Date], [ProspectProduct4 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct3 Type], [ProspectProduct2 Next Quote Due Date], [ProspectProduct2 Type], [ProspectProduct1 Type], [TradeList], [OGI Live Client Flag], [Live Client Flag], [Mobile TPS Flag], [Other TPS Flag], [Client name/contact], [Company Name], [Client Reference], [Agent], [Trade], [TierGroup], [Customer Email])
	SELECT
		[Campaign Type]
		,[Customer Postcode]
		,[Customer ID]
		,[Mobile Telephone]
		,[Other Telephone]
		,[Client Name]
		,[Title]
		,[First_Name]
		,[Last_Name]
		,[CRMEntityStatus]
		,[ProspectProduct1 Next Quote Due Date]
		,[Data Source]
		,[UpdateDateTime]
		,[InsertDateTime]
		,[ProspectProduct4 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct3 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[ProspectProduct2 Type]
		,[ProspectProduct1 Type]
		,[TradeList]
		,[OGI Live Client Flag]
		,[Live Client Flag]
		,[Mobile TPS Flag]
		,[Other TPS Flag]
		,[Client name/contact]
		,[Company Name]
		,[Client Reference]
		,[Agent]
		,[Trade]
		,[TierGroup]
		,[Customer Email]
	FROM
		(
			SELECT
				'SME DATA API Specialist Risks' AS [Campaign Type]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,NULL AS [Data Source]
				,[MHDATA].[UpdateDateTime]
				,[MHDATA].[InsertDateTime]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[TradeList]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Agent]
				,[MHDATA].[Trade]
				,[MHDATA].[TierGroup]
				,[MHDATA].[Customer Email] AS [Customer Email]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] IN ('Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] IN ('Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] IN ('Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] IN ('Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 27, @RunDate) AND DATEADD(DAY, 28, @RunDate)
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				(
					[MHDATA].[Agent] LIKE '%constructaquote%'
				OR
					[MHDATA].[Agent] LIKE '%Moorhouse Group Limited%'
				)
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'N'
			AND
				(
					[MHDATA].[Mobile Telephone] NOT IN ('', '0')
				OR
					[MHDATA].[Other Telephone] NOT IN ('', '0')
				)
			AND
				[MHDATA].[Mobile TPS Flag] <> 1
			AND
				[MHDATA].[Other TPS Flag] <> 1
		) AS [Load];

/*	8788852741 Same pots as above, but rather than being 28 days in advance it is 35 days. */
INSERT INTO @CampaignData ([Campaign Type], [Last_Name], [First_Name], [Title], [Client Name], [Other Telephone], [Mobile Telephone], [Customer ID], [Customer Postcode], [Customer Email], [Agent], [Client Reference], [Company Name], [Client name/contact], [Other TPS Flag], [Mobile TPS Flag], [Live Client Flag], [OGI Live Client Flag], [TradeList], [ProspectProduct1 Type], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [ProspectProduct4 Next Quote Due Date], [InsertDateTime], [UpdateDateTime], [Data Source], [ProspectProduct1 Next Quote Due Date], [TierGroup], [Trade], [CRMEntityStatus])
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Title]
		,[Client Name]
		,[Other Telephone]
		,[Mobile Telephone]
		,[Customer ID]
		,[Customer Postcode]
		,[Customer Email]
		,[Agent]
		,[Client Reference]
		,[Company Name]
		,[Client name/contact]
		,[Other TPS Flag]
		,[Mobile TPS Flag]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[ProspectProduct1 Type]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[ProspectProduct4 Next Quote Due Date]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Data Source]
		,[ProspectProduct1 Next Quote Due Date]
		,[TierGroup]
		,[Trade]
		,[CRMEntityStatus]
	FROM
		(
			SELECT
				'35 Day SMEPot A' AS [Campaign Type]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,[MHDATA].[Agent]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
				,[MHDATA].[InsertDateTime]
				,[MHDATA].[UpdateDateTime]
				,NULL AS [Data Source]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[Trade]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
			FROM 
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[TradeList] = 'A'
			AND
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] > DATEADD(DAY, -365, @RunDate)
					AND
						[MHDATA].[ProspectProduct1 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					AND
						[MHDATA].[ProspectProduct1 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] > DATEADD(DAY, -365, @RunDate)
					AND
						[MHDATA].[ProspectProduct2 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					AND
						[MHDATA].[ProspectProduct2 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] > DATEADD(DAY, -365, @RunDate)
					AND
						[MHDATA].[ProspectProduct3 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					AND
						[MHDATA].[ProspectProduct3 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] > DATEADD(DAY, -365, @RunDate)
					AND
						[MHDATA].[ProspectProduct4 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					AND
						[MHDATA].[ProspectProduct4 Status] <> ''
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'N'
			AND
				(
					[MHDATA].[Mobile Telephone] IN ('', '0')
				OR
					[MHDATA].[Other Telephone] IN ('', '0')
				)
		) AS [Load];

INSERT INTO @CampaignData ([Campaign Type], [Last_Name], [First_Name], [Title], [Client Name], [Other Telephone], [Mobile Telephone], [Customer ID], [Customer Postcode], [Customer Email], [Data Source], [ProspectProduct1 Next Quote Due Date], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [TierGroup], [CRMEntityStatus], [Client Reference], [Company Name], [Client name/contact], [Other TPS Flag], [Mobile TPS Flag], [Live Client Flag], [OGI Live Client Flag], [TradeList], [Trade], [Agent], [ProspectProduct1 Type], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [ProspectProduct4 Next Quote Due Date], [UpdateDateTime], [InsertDateTime])
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Title]
		,[Client Name]
		,[Other Telephone]
		,[Mobile Telephone]
		,[Customer ID]
		,[Customer Postcode]
		,[Customer Email]
		,[Data Source]
		,[ProspectProduct1 Next Quote Due Date]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[TierGroup]
		,[CRMEntityStatus]
		,[Client Reference]
		,[Company Name]
		,[Client name/contact]
		,[Other TPS Flag]
		,[Mobile TPS Flag]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[Trade]
		,[Agent]
		,[ProspectProduct1 Type]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[ProspectProduct4 Next Quote Due Date]
		,[UpdateDateTime]
		,[InsertDateTime]
	FROM
		(
			SELECT
				'35 Day SMEPot B' AS [Campaign Type]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,NULL AS [Data Source]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[Trade]
				,[MHDATA].[Agent]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
				,[MHDATA].[UpdateDateTime]
				,[MHDATA].[InsertDateTime]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[TradeList] = 'A'
			AND
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND DATEADD(DAY, -366, @RunDate)
					AND
						[MHDATA].[ProspectProduct1 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					AND
						[MHDATA].[ProspectProduct1 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND DATEADD(DAY, -366, @RunDate)
					AND
						[MHDATA].[ProspectProduct2 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					AND
						[MHDATA].[ProspectProduct2 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND DATEADD(DAY, -366, @RunDate)
					AND
						[MHDATA].[ProspectProduct3 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					AND
						[MHDATA].[ProspectProduct3 Status] <> ''
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND DATEADD(DAY, -366, @RunDate)
					AND
						[MHDATA].[ProspectProduct4 Status] <> 'Incomplete'
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					AND
						[MHDATA].[ProspectProduct4 Status] <> ''
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'N'

			AND
				(
					[MHDATA].[Mobile Telephone] NOT IN ('', '0')
				OR
					[MHDATA].[Other Telephone] NOT IN ('', '0')
				)
			AND
				[MHDATA].[Mobile TPS Flag] <> 1
			AND
				[MHDATA].[Other TPS Flag] <> 1
		) AS [Load];

INSERT INTO @CampaignData ([Campaign Type], [Last_Name], [First_Name], [Title], [Client Name], [Other Telephone], [Mobile Telephone], [Customer ID], [Customer Postcode], [Customer Email], [Company Name], [Client name/contact], [Other TPS Flag], [Mobile TPS Flag], [Live Client Flag], [OGI Live Client Flag], [TradeList], [Trade], [Agent], [ProspectProduct1 Type], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [ProspectProduct4 Next Quote Due Date], [InsertDateTime], [UpdateDateTime], [Data Source], [ProspectProduct1 Next Quote Due Date], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [TierGroup], [Client Reference], [CRMEntityStatus])
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Title]
		,[Client Name]
		,[Other Telephone]
		,[Mobile Telephone]
		,[Customer ID]
		,[Customer Postcode]
		,[Customer Email]
		,[Company Name]
		,[Client name/contact]
		,[Other TPS Flag]
		,[Mobile TPS Flag]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[Trade]
		,[Agent]
		,[ProspectProduct1 Type]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[ProspectProduct4 Next Quote Due Date]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Data Source]
		,[ProspectProduct1 Next Quote Due Date]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[TierGroup]
		,[Client Reference]
		,[CRMEntityStatus]
	FROM
		(
			SELECT
				'35 Day SMEPot C' AS [Campaign Type]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[Trade]
				,[MHDATA].[Agent]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
				,[MHDATA].[InsertDateTime]
				,[MHDATA].[UpdateDateTime]
				,NULL AS [Data Source]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[Client Reference]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[TradeList] = 'B'
			AND
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND @RunDate
					AND
						[MHDATA].[ProspectProduct1 Status] NOT IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND @RunDate
					AND
						[MHDATA].[ProspectProduct2 Status] NOT IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND @RunDate
					AND
						[MHDATA].[ProspectProduct3 Status] NOT IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND @RunDate
					AND
						[MHDATA].[ProspectProduct4 Status] NOT IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'N'
			AND
				(
					[MHDATA].[Mobile Telephone] NOT IN ('', '0')
				OR
					[MHDATA].[Other Telephone] NOT IN ('', '0')
				)
			AND
				[MHDATA].[Mobile TPS Flag] <> 1
			AND
				[MHDATA].[Other TPS Flag] <> 1
		) AS [Load];

INSERT INTO @CampaignData ([Campaign Type], [Customer Postcode], [Customer ID], [Mobile Telephone], [Other Telephone], [Client Name], [Title], [First_Name], [Last_Name], [Customer Email], [ProspectProduct1 Next Quote Due Date], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [TierGroup], [CRMEntityStatus], [Client Reference], [Company Name], [Client name/contact], [UpdateDateTime], [Other TPS Flag], [Live Client Flag], [OGI Live Client Flag], [TradeList], [Trade], [Agent], [ProspectProduct1 Type], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [Mobile TPS Flag], [InsertDateTime], [Data Source], [ProspectProduct4 Next Quote Due Date])
	SELECT
		[Campaign Type]
		,[Customer Postcode]
		,[Customer ID]
		,[Mobile Telephone]
		,[Other Telephone]
		,[Client Name]
		,[Title]
		,[First_Name]
		,[Last_Name]
		,[Customer Email]
		,[ProspectProduct1 Next Quote Due Date]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[TierGroup]
		,[CRMEntityStatus]
		,[Client Reference]
		,[Company Name]
		,[Client name/contact]
		,[UpdateDateTime]
		,[Other TPS Flag]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[Trade]
		,[Agent]
		,[ProspectProduct1 Type]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[Mobile TPS Flag]
		,[InsertDateTime]
		,[Data Source]
		,[ProspectProduct4 Next Quote Due Date]
	FROM
		(
			SELECT
				'35 Day SMEPot D' AS [Campaign Type]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[UpdateDateTime]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[Trade]
				,[MHDATA].[Agent]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[InsertDateTime]
				,NULL AS [Data Source]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'Y'
			AND
				(
					[MHDATA].[Mobile Telephone] NOT IN ('', '0')
				OR
					[MHDATA].[Other Telephone] NOT IN ('', '0')
				)
			AND
				[MHDATA].[Mobile TPS Flag] <> 1
			AND
				[MHDATA].[Other TPS Flag] <> 1
		) AS [Load];

INSERT INTO @CampaignData ([Campaign Type], [Last_Name], [First_Name], [Title], [Client Name], [Other Telephone], [Mobile Telephone], [Customer ID], [Customer Postcode], [Customer Email], [ProspectProduct2 Type], [ProspectProduct2 Next Quote Due Date], [TierGroup], [CRMEntityStatus], [Client Reference], [Company Name], [Client name/contact], [UpdateDateTime], [Data Source], [Other TPS Flag], [OGI Live Client Flag], [TradeList], [Trade], [Agent], [ProspectProduct1 Type], [ProspectProduct3 Type], [ProspectProduct3 Next Quote Due Date], [ProspectProduct4 Type], [Mobile TPS Flag], [Live Client Flag], [ProspectProduct4 Next Quote Due Date], [ProspectProduct1 Next Quote Due Date], [InsertDateTime])
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Title]
		,[Client Name]
		,[Other Telephone]
		,[Mobile Telephone]
		,[Customer ID]
		,[Customer Postcode]
		,[Customer Email]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[TierGroup]
		,[CRMEntityStatus]
		,[Client Reference]
		,[Company Name]
		,[Client name/contact]
		,[UpdateDateTime]
		,[Data Source]
		,[Other TPS Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[Trade]
		,[Agent]
		,[ProspectProduct1 Type]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[Mobile TPS Flag]
		,[Live Client Flag]
		,[ProspectProduct4 Next Quote Due Date]
		,[ProspectProduct1 Next Quote Due Date]
		,[InsertDateTime]
	FROM
		(
			SELECT
				'35 Day SMEPot E' AS [Campaign Type]
				,[MHDATA].[Last_Name] AS [Last_Name]
				,[MHDATA].[First_Name] AS [First_Name]
				,[MHDATA].[Title] AS [Title]
				,[MHDATA].[Client name/contact] AS [Client Name]
				,[MHDATA].[Other Telephone] AS [Other Telephone]
				,[MHDATA].[Mobile Telephone] AS [Mobile Telephone]
				,[MHDATA].[Client Reference] AS [Customer ID]
				,[MHDATA].[Customer Postcode] AS [Customer Postcode]
				,[MHDATA].[Customer Email] AS [Customer Email]
				,[MHDATA].[ProspectProduct2 Type]
				,[MHDATA].[ProspectProduct2 Next Quote Due Date]
				,[MHDATA].[TierGroup]
				,[MHDATA].[CRMEntityStatus] AS [CRMEntityStatus]
				,[MHDATA].[Client Reference]
				,[MHDATA].[Company Name]
				,[MHDATA].[Client name/contact]
				,[MHDATA].[UpdateDateTime]
				,NULL AS [Data Source]
				,[MHDATA].[Other TPS Flag]
				,[MHDATA].[OGI Live Client Flag]
				,[MHDATA].[TradeList]
				,[MHDATA].[Trade]
				,[MHDATA].[Agent]
				,[MHDATA].[ProspectProduct1 Type]
				,[MHDATA].[ProspectProduct3 Type]
				,[MHDATA].[ProspectProduct3 Next Quote Due Date]
				,[MHDATA].[ProspectProduct4 Type]
				,[MHDATA].[Mobile TPS Flag]
				,[MHDATA].[Live Client Flag]
				,[MHDATA].[ProspectProduct4 Next Quote Due Date]
				,[MHDATA].[ProspectProduct1 Next Quote Due Date]
				,[MHDATA].[InsertDateTime]
			FROM
				[CRM].[dbo].[CRMEntityMH1] AS [MHDATA]
			WHERE
				[MHDATA].[Live Client Flag] = 'N'
			AND
				(
					(
						[MHDATA].[ProspectProduct1 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct1 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct1 Status] IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct1 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct2 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct2 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct2 Status] IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct2 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct3 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct3 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct3 Status] IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct3 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				OR
					(
						[MHDATA].[ProspectProduct4 Type] NOT IN ('Open GI Van', 'Open Market Commercial Vehicle', 'Property Owners', 'Fleet')
					AND
						[MHDATA].[ProspectProduct4 Last Quoted Date] BETWEEN DATEADD(DAY, -1100, @RunDate) AND GETDATE()
					AND
						[MHDATA].[ProspectProduct4 Status] IN ('Incomplete', '')
					AND
						[MHDATA].[ProspectProduct4 Next Quote Due Date] BETWEEN DATEADD(DAY, 34, @RunDate) AND DATEADD(DAY, 35, @RunDate)
					)
				)
			AND
				[MHDATA].[CRMEntityStatus] = 'Active'
			AND
				[MHDATA].[AllowMarketingMessagesViaTelephone] = 'Yes'
			AND
				[MHDATA].[Agent] LIKE '%constructaquote%'
			AND
				[MHDATA].[TGSL Sum of Client Debt Outstanding] = '0'
			AND
				[MHDATA].[OGI Live Client Flag] = 'N'
			AND
				(
					[MHDATA].[Mobile Telephone] NOT IN ('', '0')
				OR
					[MHDATA].[Other Telephone] NOT IN ('', '0')
				)
			AND
				[MHDATA].[Mobile TPS Flag] <> 1
			AND
				[MHDATA].[Other TPS Flag] <> 1
		) AS [Load];

/*	End result table, PS script then filters through	*/
	SELECT
		[Campaign Type]
		,[Last_Name]
		,[First_Name]
		,[Title]
		,[Client Name]
		,[Other Telephone]
		,[Mobile Telephone]
		,[Customer ID]
		,[Customer Postcode]
		,[Customer Email]
		,[Agent]
		,[Client Reference]
		,[Company Name]
		,[Client name/contact]
		,[Other TPS Flag]
		,[Mobile TPS Flag]
		,[Live Client Flag]
		,[OGI Live Client Flag]
		,[TradeList]
		,[ProspectProduct1 Type]
		,[ProspectProduct2 Type]
		,[ProspectProduct2 Next Quote Due Date]
		,[ProspectProduct3 Type]
		,[ProspectProduct3 Next Quote Due Date]
		,[ProspectProduct4 Type]
		,[ProspectProduct4 Next Quote Due Date]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Data Source]
		,[ProspectProduct1 Next Quote Due Date]
		,[TierGroup]
		,[Trade]
		,[CRMEntityStatus]
		,[LiveProduct1 Type]
		,[LiveProduct1 Expiry date]
		,[LiveProduct1 Expiry Month]
		,[LiveProduct2 Type]
		,[LiveProduct2 Expiry date]
		,[LiveProduct2 Expiry Month]
		,[LiveProduct3 Type]
		,[LiveProduct3 Expiry date]
		,[LiveProduct3 Expiry Month]
		,[LiveProduct4 Type]
		,[LiveProduct4 Expiry date]
		,[LiveProduct4 Expiry Month]
		,[LiveProduct5 Type]
		,[LiveProduct5 Expiry date]
		,[LiveProduct5 Expiry Month]
		,[LiveProduct6 Type]
		,[LiveProduct6 Expiry date]
		,[LiveProduct6 Expiry Month]
		,[AutoCCDecline]
	FROM
		@CampaignData
	ORDER BY
		[Campaign Type];