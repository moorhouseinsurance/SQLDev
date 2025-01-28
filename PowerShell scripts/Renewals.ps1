# Load Functions as required
Import-Module "S:\PowerShell\Functions\email_ops.ps1";

#Parameters
$ErrorCount = 0;

#Provide SQL Server connection via external variable PowerShell File
. "S:\PowerShell\Connections\SQL\MHGSQL01_TGSL.ps1"

#Set the Database
$DatabaseName = "Transactor_Live";

$SqlQuery = "
                SELECT   
                    [rl].[CREATEDDATE] AS [Created Date],  
                    (SELECT MIN(ActionDate) ActionDate FROM REPORT_ACTION_LOG RAL with (nolock) WHERE ACTIONTYPE IN (2, 23) AND RAL.POLICY_DETAILS_ID = cpd.POLICY_DETAILS_ID AND RAL.HISTORY_ID = cpd.HISTORY_ID) AS [Conversion Time], 
                    [cpd].[POLICYNUMBER] AS [Policy Number],
					[rl].[INSURED_PARTY_ID] AS [Insured Party ID],
					[cpd].[POLICY_DETAILS_ID] AS [Policy Details ID]
                FROM   
                    REALEX_LOG rl with (nolock)  
                INNER JOIN
                    REALEX_LOG_PAYMENT rlp with (nolock) on rl.ID = rlp.ID  
                INNER JOIN
                    CUSTOMER_POLICY_DETAILS cpd with (nolock) on rl.POLICY_DETAILS_ID = cpd.POLICY_DETAILS_ID  
                AND
                    rl.POLICY_DETAILS_HISTORY_ID = cpd.HISTORY_ID  
                INNER JOIN
                    LIST_POLICY_STATUS lps on lps.POLICY_STATUS_ID = cpd.POLICY_STATUS_ID  
                WHERE   
                    rl.CREATEDDATE > DATEADD(HOUR, -24, GETDATE())  
                AND
                    WEB = 1   
                AND
                    SUCCESS = 1  
                AND
                    cpd.POLICY_STATUS_ID IN ('3AJPUL67', '3AJPUL79', '3AJPUL87') 
                ORDER BY   
                    rl.CREATEDDATE DESC;
            ";

$resultobject = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $DatabaseName -Username $DBUsername -Password $DBPassword -Querytimeout 0 -Query $SqlQuery -ErrorAction stop;

$resultobjects = $resultobject | Select * -ExcludeProperty RowError, RowState, Table, ItemArray, HasErrors | convertto-html | out-string

if ($resultobject.Count -gt 1)
{
            #Send E-Mail in the event of an issue

            $Subject = "Renewals Count - The following cases have been identified"

            $Body = $resultobjects

        Send-Email $Subject $Body
}

#Close scripting window
exit;