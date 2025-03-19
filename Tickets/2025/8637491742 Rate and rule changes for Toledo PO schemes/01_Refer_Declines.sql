USE [Calculators]
GO

UPDATE
	[dbo].[MLETPROP_Toledo_Construction]
SET
	[EndDateTime] = GETDATE()-1
WHERE
	[WALL_CONSTRUCTION_ID] = 'BUNG69DC';

INSERT INTO [dbo].[MLETPROP_Toledo_Construction]
           ([WALL_CONSTRUCTION_ID]
           ,[Construction]
           ,[Decline]
           ,[StartDateTime]
           ,[InsertDateTime]
           ,[UserID])
     VALUES
           ('BUNG69DC'
           ,'Bungaroosh'
           ,1
           ,GETDATE()-1
           ,GETDATE()
           ,'Simon');

GO