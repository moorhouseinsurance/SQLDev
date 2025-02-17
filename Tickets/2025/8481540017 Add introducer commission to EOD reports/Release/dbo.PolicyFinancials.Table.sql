USE [MI]
GO

--DROP TABLE [dbo].[PolicyFinancials]

CREATE TABLE [dbo].[PolicyFinancials](
	 [POLICY_DETAILS_ID] [char](32) NOT NULL
	,[POLICY_DETAILS_HISTORY_ID] [int] NOT NULL
	,[HistoryOrGroupingID] [bigint] NOT NULL
	,[EarliestTranCodePerHistGroup] varchar(255)
	,[EarliestPayMethodIDPerHistGroup] varchar(8)
	,[EarliestPayMethodPerHistGroup] varchar(255)
	,[GWP] [money]
	,[Fee] [money]
	,[BrokerCommissionFlatRate] [money]
	,[BrokerCommission] [money]
	,[BrokerTotalCommission] [money]
	,[BrokerDiscount] [money]
	,[BrokerTotalCommissionAndDiscount] [money]
	,[Income] [money]
	,[GrossIncomeIncSubagentCommission] [money]
	,[AgentCommissionFlatRate] [money]
	,[AgentCommission] [money]
	,[AgentTotalCommission] [money]
	,[AgentDiscount] [money]
	,[AgentTotalCommissionAndDiscount] [money]
	,[SubAgentCommissionFlatRate] [money]
	,[SubAgentCommission] [money]
	,[SubAgentTotalCommission] [money]
	,[SubAgentDiscount] [money]
	,[SubAgentTotalCommissionAndDiscount] [money]
	,[TotalDiscount] [money] -- There is no Introducer discount type in LIST_TRAN_BREAKDOWN_TYPE
	,[IntroducerCommissionFlatRate] [money]
	,[IntroducerCommission] [money]
	,[IntroducerTotalCommission] [money]
	,[IPT] [money]
	,[Deposit] [money]
	,[CP_GWP] [money]
	,[CP_Fee] [money]
	,[CP_BrokerCommissionFlatRate] [money]
	,[CP_BrokerCommission] [money]
	,[CP_BrokerTotalCommission] [money]
	,[CP_BrokerDiscount] [money]
	,[CP_BrokerTotalCommissionAndDiscount] [money]
	,[CP_Income] [money]
	,[CP_GrossIncomeIncSubagentCommission] [money]
	,[CP_AgentCommissionFlatRate] [money]
	,[CP_AgentCommission] [money]
	,[CP_AgentTotalCommission] [money]
	,[CP_AgentDiscount] [money]
	,[CP_AgentTotalCommissionAndDiscount] [money]
	,[CP_SubAgentCommissionFlatRate] [money]
	,[CP_SubAgentCommission] [money]
	,[CP_SubAgentTotalCommission] [money]
	,[CP_SubAgentDiscount] [money]
	,[CP_SubAgentTotalCommissionAndDiscount] [money]
	,[CP_TotalDiscount] [money] -- There is no Introducer discount type in LIST_PREMIUM_TYPE
	,[CP_IntroducerCommissionFlatRate] [money]
	,[CP_IntroducerCommission] [money]
	,[CP_IntroducerTotalCommission] [money]
	,[CP_IPT] [money]
);

GO


CREATE CLUSTERED INDEX [IX_PolicyFinancials_POLICY_DETAILS_ID] ON [dbo].[PolicyFinancials]
(
	[POLICY_DETAILS_ID] ASC,
	[POLICY_DETAILS_HISTORY_ID] ASC,
	[HistoryOrGroupingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
;
GO