USE [Transactor_Support]
GO

INSERT INTO [dbo].[TGSL_Job_Log]
           ([job_name]
           ,[job_rundate]
           ,[job_runtime]
           ,[job_qualcases])
     VALUES
           ('Toledo PO BSI Change', CAST(GETDATE() AS DATE), CAST(GETDATE() AS TIME), 0)
GO


