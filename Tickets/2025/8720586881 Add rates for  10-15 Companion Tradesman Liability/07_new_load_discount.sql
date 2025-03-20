USE [Calculators]
GO

INSERT INTO [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_LoadDiscount]
           ([LoadDiscountType]
           ,[StartRange]
           ,[EndRange]
           ,[LoadDiscountValue]
           ,[StartDateTime]
           ,[InsertDateTime]
           ,[UserID])
     VALUES
           ('EmployeesELManual'
           ,11
           ,15
           ,0.75
           ,GETDATE()-1
           ,GETDATE()
           ,'Simon')
GO


