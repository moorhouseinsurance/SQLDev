USE [Transactor_Live];

EXEC SP_DM_INSERT_FORMULA 'GetPOAddressDetails','GetPOAddressDetails',' EXECUTESP
( "uspGetPOAddressDetails" , "$cpdPolicyDetailsID_0_001001|$cpdHistoryID_0_001001")'