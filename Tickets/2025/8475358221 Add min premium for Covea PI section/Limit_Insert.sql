USE [Calculators]
GO

INSERT INTO [dbo].[Limit]
           ([Insurer]
           ,[LineOfBusiness]
           ,[LimitType]
           ,[Minimum]
           ,[StartDateTime]
           ,[InsertDateTime]
           ,[InsertUserID])
     VALUES
           ('Covea Insurance'
           ,'MCLIAB'
           ,'Professional Indemnity Premium'
           ,48.00
           ,GETDATE()-1
           ,GETDATE()
           ,'SMP');

INSERT INTO [dbo].[Limit]
           ([Insurer]
           ,[LineOfBusiness]
           ,[LimitType]
           ,[Minimum]
           ,[StartDateTime]
           ,[InsertDateTime]
           ,[InsertUserID])
     VALUES
           ('Covea Insurance'
           ,'MLIAB'
           ,'Professional Indemnity Premium'
           ,48.00
           ,GETDATE()-1
           ,GETDATE()
           ,'SMP');
GO


