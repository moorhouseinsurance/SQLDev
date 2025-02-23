USE [CRM]
GO
/****** Object:  StoredProcedure [dbo].[uspConfigureDatabase]    Script Date: 29/01/2025 10:16:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--================================
--Author	D. Hostler
--Date		07 Apr 2020
--Desc		Set default database config (Generally after a restore)
--======================================
ALTER PROCEDURE [dbo].[uspConfigureDatabase]
AS

/*
	EXEC [dbo].[uspConfigureDatabase]
*/
BEGIN
	SET NOCOUNT ON
	ALTER USER [LinkedServerUser] WITH LOGIN = [LinkedServerUser];
	ALTER USER [ReportServerUser]  WITH LOGIN = [ReportServerUser];
	ALTER USER [TGSLUser]  WITH LOGIN = [TGSLUser];
	
	
	IF @@ServerName !=  'MHGSQL01\TGSL' -- Skip this when running in live
	BEGIN
		DROP SYNONYM [dbo].[CRMEntityMH1_Dialler];
		DROP SYNONYM [dbo].[CS_MHGDEF_Customer_Dialler];
		DROP SYNONYM [dbo].[CS_MHGLG_Customer];
		DROP SYNONYM [dbo].[SMEWebEntityReport_Dialler];
		DROP SYNONYM [dbo].[uspCRMEntityMH1Sync];

		CREATE SYNONYM [dbo].[CRMEntityMH1_Dialler] FOR [MHGMICCSQL01].[Phoenix].[dbo].[CRMEntityMH1_Test];
		CREATE SYNONYM [dbo].[CS_MHGDEF_Customer_Dialler] FOR [MHGMICCSQL01].[Phoenix].[dbo].[CS_MHGDEF_Customer_Test];
		CREATE SYNONYM [dbo].[CS_MHGLG_Customer] FOR [MHGMICCSQL01].[Phoenix].[dbo].[CS_MHGLG_Customer_Test];
		CREATE SYNONYM [dbo].[SMEWebEntityReport_Dialler] FOR [MHGMICCSQL01].[Phoenix].[dbo].[SMEWebEntityReport_TMP];
		CREATE SYNONYM [dbo].[uspCRMEntityMH1Sync] FOR [MHGMICCSQL01].[Phoenix].[dbo].[uspCRMEntityMH1Sync_test];
	END

END
