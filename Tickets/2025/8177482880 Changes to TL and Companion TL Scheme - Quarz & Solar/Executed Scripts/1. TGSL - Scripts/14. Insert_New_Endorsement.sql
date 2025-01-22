
--SELECT * FROM LIST_ENDORSEMENT WHERE endorsement_code_ID = 'TMTLCLAD'
--SELECT * FROM LIST_ENDORSEMENT WHERE INSURER_ID = '459' AND PRODUCTTYPE = 195 AND endorsement_code_debug like '%solar%'
INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] 
VALUES(
'TOMSOL'
,'TOMSOL'
,'Solar Panel Installation'
,'It is a Condition of this Policy that if the policyholder is responsible for ongoing maintenance of installed solar panels, they comply with BS 7671 Requirements for Electrical Installations and BS EN IEC 62446-2 Photovoltaic (PV) Systems – Requirements for testing, documentation, and maintenance – Part 2: Grid connected systems – Maintenance of PV systems. If the policyholder is not responsible for ongoing maintenance, we assume they provide the user with a PV Operation & Maintenance (O&M) manual'
,0
,'195'
,'154'
,'459'
,0
,'POLICYENDORS'
);


UPDATE [Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL]
SET [Endorsement] = 'TOMTLPR4,TOMTLHAW,TOMSOL'
WHERE [TradeID] = '3N0TVJ79' AND [EndDatetime] IS NULL;
