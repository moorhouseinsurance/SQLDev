USE [Transactor_Live]
GO

-- Step1: Added new fields to capture existing records info
  ALTER TABLE [Transactor_Live].[dbo].[SchemeContractorsAllRiskTokioMarineKilnTrade]
  ADD [Decline] BIT, [EndDateTime] datetime, [InsertDateTime] datetime, [InsertUserID] varchar(50), [UpdateDateTime] datetime, [UpdateUserID] varchar(50);


-- Step2: Update existig records enddatetime with todays date

  -- 203 records
  -- Select * from [Transactor_Live].[dbo].[SchemeContractorsAllRiskTokioMarineKilnTrade] where enddatetime is null order by [SchemeContractorsAllRiskTokioMarineKilnTradeID]
  UPDATE [Transactor_Live].[dbo].[SchemeContractorsAllRiskTokioMarineKilnTrade]
  SET [EndDateTime] = '08 Jan 2025'
     ,[UpdateDateTime] = GETDATE()
     ,[UpdateUserID] = 'LINGA'


-- Step3 : Insert new Records with new endorsements
INSERT INTO [Transactor_Live].[dbo].[SchemeContractorsAllRiskTokioMarineKilnTrade]( 
       [StartDatetime]
      ,[TradeID]
      ,[Endorsements]
      ,[Load]
      ,[Refer]
      ,[MaxDepth]
      ,[MaxHeight]
	  ,[Decline]
	  ,[EndDateTime]
	  ,[InsertDateTime]
	  ,[InsertUserID]
	  ,[UpdateDateTime]
      ,[UpdateUserID]
)
SELECT 
       
       '08 Jan 2025'
      ,[TradeID]
      ,'TMKCAR03'  
      ,[Load]
      ,[Refer]
      ,[MaxDepth]
      ,[MaxHeight]
	  ,[Decline]
	  ,NULL
	  ,GETDATE()
	  ,'LINGA'
	  ,NULL
	  ,NULL 
FROM [Transactor_Live].[dbo].[SchemeContractorsAllRiskTokioMarineKilnTrade]
WHERE [StartDatetime] = '29 Apr 2022' AND [UpdateUserID] = 'LINGA'
ORDER BY SchemeContractorsAllRiskTokioMarineKilnTradeID ASC;

