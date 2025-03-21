USE [Transactor_Live]
GO
/****** Object:  Trigger [dbo].[TRIG_BOUGHT_POLICY]    Script Date: 04/12/2024 09:47:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Simon Mackness-Pettit
-- Create date: 31 Jan 2024
-- Description:	A trigger on both CAQ.com and XB.com that sends an email when a new business is purchased or a policy is renewed.
-- =============================================

ALTER TRIGGER
	[dbo].[TRIG_BOUGHT_POLICY]
ON
	[dbo].[CUSTOMER_POLICY_DETAILS]
AFTER UPDATE
NOT FOR REPLICATION
AS

BEGIN

SET NOCOUNT ON;

DECLARE @Client AS TABLE
(
	[CLIENT_REF_NO] CHAR(25)
);

IF NOT EXISTS	(
					SELECT
						0
					FROM
						Inserted AS [Inserted]
					INNER JOIN
						[Transactor_Support].[dbo].[TGSL_Web_Policies] AS [TGSLWP] ON [TGSLWP].[policy_details_id] = [Inserted].[policy_details_id]
				)
BEGIN
	--First look for a client record when the case does not exist in our [TGSL_Web_Policies] table
	INSERT INTO @Client
		SELECT
			[CIP].[CLIENT_REF_NO]
		FROM
			[dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD]
		INNER JOIN
			Inserted AS [INSERTED] ON [INSERTED].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID]	
		AND
			--CAQ, XBroker
			[INSERTED].[AGENT_ID] IN ('5208F39A498E4706A91BEEC84ED25686', '0F849A389DD4477CAF66BBCBECA49AA4')
		INNER JOIN
			[dbo].[SYSTEM_SECURITY_PROFILE] AS [SSP] ON [SSP].[PROFILE_ID] = [INSERTED].[CREATEDBY]
		AND
			(
				[SSP].[ROLE_ID] = 2
			OR
				[SSP].[PROFILE_ID] = '3IMU7EF8'
			)
		INNER JOIN
			[dbo].[CUSTOMER_POLICY_LINK] AS [CPL] ON [CPD].[POLICY_DETAILS_ID] = [CPL].[POLICY_DETAILS_ID]
		INNER JOIN
			[dbo].[CUSTOMER_INSURED_PARTY] AS [CIP] ON [CPL].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID]
		AND
			[CPL].[INSURED_PARTY_HISTORY_ID] = [CIP].[HISTORY_ID];

	IF EXISTS	(
					SELECT
						0
					FROM
						[dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD]
					INNER JOIN
						Inserted AS [Inserted] ON [CPD].[POLICY_DETAILS_ID] = [Inserted].[POLICY_DETAILS_ID]
					INNER JOIN
						[dbo].[SYSTEM_SECURITY_PROFILE] AS [SSP] ON [SSP].[PROFILE_ID] = [INSERTED].[CREATEDBY]
					AND
						(
							[SSP].[ROLE_ID] = 2
						OR
							[SSP].[PROFILE_ID] = '3IMU7EF8'
						)
					WHERE
						[Inserted].[AGENT_ID] IN ('5208F39A498E4706A91BEEC84ED25686', '0F849A389DD4477CAF66BBCBECA49AA4')
					AND
						--Policy, Renewal Invited
						[Inserted].[POLICY_STATUS_ID] IN ('3AJPUL66', '3AJPUL79')
					AND
						[CPD].[CREATEDDATE] > GETDATE()-1
				) 
	BEGIN 
	
		DECLARE @PolicyNumber VARCHAR(30);
		SET @PolicyNumber = (SELECT [CPD].[POLICYNUMBER] FROM Inserted AS [Inserted] INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [Inserted].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID])

		DECLARE @ClientReferance VARCHAR(25);
		SET @ClientReferance = (SELECT [CLIENT_REF_NO] FROM @Client)

		DECLARE @Agent VARCHAR(7);
		SET @Agent =	(
							SELECT
								CASE [Inserted].[AGENT_ID]
								WHEN '0F849A389DD4477CAF66BBCBECA49AA4' THEN 'XB.com'
								WHEN '5208F39A498E4706A91BEEC84ED25686' THEN 'CAQ.com'
								ELSE 'Unknown'
								END
							FROM
								Inserted AS [Inserted]
						)

		DECLARE @tableHTML NVARCHAR(MAX);

		SET @tableHTML = N'<p>Policy bought on ' + CAST((SELECT @Agent) AS NVARCHAR(MAX)) + ' for policy number ' + CAST((SELECT @PolicyNumber) AS NVARCHAR(MAX)) + ' with a client referance of ' + CAST((SELECT @ClientReferance) AS NVARCHAR(MAX)) + ' please issue docs</p>';

		DECLARE @recipients_list VARCHAR(100);

		SET @recipients_list =	(
									SELECT
										CASE @Agent
										WHEN '0F849A389DD4477CAF66BBCBECA49AA4' THEN 'sevans@constructaquote.com; CustomerAdmin@constructaquote.com; agauci@moorhousegroup.co.uk'
										ELSE 'sevans@constructaquote.com; CustomerAdmin@constructaquote.com'
										END
								)

		EXEC msdb.dbo.sp_send_dbmail
			@recipients = @recipients_list,
			@subject = 'Sold Policy',
			@body = @tableHTML,
			@body_format = 'HTML';

		INSERT INTO [Transactor_Support].[dbo].[TGSL_Web_Policies] ([policy_details_id], [policy_number], [agent_id], [dss_update_date], [dss_update_time])
			SELECT
				[CPD].[POLICY_DETAILS_ID]
				,[CPD].[POLICYNUMBER]
				,[CPD].[AGENT_ID]
				,CAST([CPD].[CREATEDDATE] AS DATE)
				,CAST([CPD].[CREATEDDATE] AS TIME)
			FROM
				Inserted AS [Inserted]
			INNER JOIN
				[dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [Inserted].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID]

	END;

END;

END;