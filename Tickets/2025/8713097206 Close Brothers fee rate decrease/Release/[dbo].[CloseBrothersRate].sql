USE [MI]
GO

CREATE TABLE [dbo].[CloseBrothersRate] (
	 [ID] int IDENTITY(1,1)
	,[StartDate] datetime
	,[EndDate] datetime
	,[FeePC] decimal(6,4)
)

INSERT INTO [dbo].[CloseBrothersRate] (
	 [StartDate]
	,[EndDate]
	,[FeePC]
)
VALUES ('01 Aug 2022', '06 Sep 2022', 0.0344)
	  ,('06 Sep 2022', '25 Oct 2022', 0.0374)
	  ,('25 Oct 2022', '07 Mar 2023', 0.0404)								
	  ,('07 Mar 2023', '25 Apr 2023', 0.0434)								
	  ,('25 Apr 2023', '13 Jun 2023', 0.0449)
	  ,('13 Jun 2023', '25 Jul 2023', 0.0464)								
	  ,('25 Jul 2023', '16 Nov 2023', 0.0494)									
	  ,('16 Nov 2023', '10 Dec 2024', 0.0454)								
	  ,('10 Dec 2024', '19 Mar 2025', 0.0439)
	  ,('19 Mar 2025', NULL, 0.0424)
GO

--SELECT * FROM [dbo].[CloseBrothersRate]