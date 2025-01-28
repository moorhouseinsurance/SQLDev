#Load Functions as required
Import-Module "S:\PowerShell\Functions\email_ops.ps1";

#Global Parameters
$Date = Get-Date -Format "dd/MM/yyyy";
$ErrorCount = 0;

#Provide SQL Server connection via external variable PowerShell File
. "S:\PowerShell\Connections\SQL\MHGSQL01_TGSL.ps1"

#Set the Database
$DatabaseName ="Transactor_Live";

#Select
$SQLQuery = "
                SELECT
	                [POLICYNUMBER] AS [Policy Number]
	                ,[PAYMENT_PLAN_ID] AS [Current Payment Plan]
	                ,CASE [PAYMENT_PLAN_ID]
		                WHEN '010DF016C4CA401BB108CD9FC79F960C' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '07307B9B592B40DF80895F8913337ECB' THEN '652320AF256942149924DAE952A6C1C4'
		                WHEN '0AF6FACD71AF4A8E8C074D1C9CBDC01A' THEN '652320AF256942149924DAE952A6C1C4'
		                WHEN '0C7A0CC891E8455982957CD595F523AA' THEN '652320AF256942149924DAE952A6C1C4'
		                WHEN '15490320D38A45D89A7F6685BAA057CC' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '2082FB178DE74BCF944DFD50A3F33427' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '25AD9B228FE34A8F9A26CD26AB60A2EB' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '26FBE5C329634E0B814479F50EE6F073' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '28AB8521EBB943BAB096C863B2E44757' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '2A4E9E88C7A54897A62C2B9C80E61216' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '2E80446FF50B4F7DB96EEC25D65FA873' THEN '652320AF256942149924DAE952A6C1C4'
		                WHEN '3E778FD04905416F959CEE7D5061262D' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '4563B2325B3A487B9954224ADE47B505' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '4BE5E10FD22F4A08ABA02EC0453D4D04' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '4ED05256AB5B484791C93E58F1F13CEF' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '504707FA7A8C42DBA5A8CB0FB56FE5DC' THEN '652320AF256942149924DAE952A6C1C4'
		                WHEN '5B84991504C84CB6B21027AEE98EA819' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '6714F2C987FA4A90A2573095DFEC169F' THEN '652320AF256942149924DAE952A6C1C4'
		                WHEN '6FD0BB8BF74343B5A83A7463305B9C55' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '82941527E709471DA3DFA1B2F0C6F630' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '88A1180205BA4E0082176EDB4F6CF66A' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '8FF2BBEC288549ABA4DE61C6FB7D227F' THEN '652320AF256942149924DAE952A6C1C4'
		                WHEN '9F1CDD6D0AC2486A9952539F72F2A4DF' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN '9F2F9E70E27B4B2E89D01C7B16871B37' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN 'AF1CA0D1E8B04E018F855ED4025D2943' THEN '652320AF256942149924DAE952A6C1C4'
		                WHEN 'B2DB9DEEB02C409983AA910175059FAC' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN 'B3CFD5F80A2D4D829519817E57DB0716' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN 'B8E4095D0F484CEFA14271FF993F302C' THEN '652320AF256942149924DAE952A6C1C4'
		                WHEN 'C91B121D16554F7AB3EEE997D9C449AF' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN 'D322E23721914CFD8F271DD16D59E82B' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN 'EA345581BF884425BBDDFE3D810558B5' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
		                WHEN 'F21A107BD0064958A1DA92492A8ACA3A' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
	                END AS [New Payment Plan]
                FROM
	                [Transactor_Live].[dbo].[CUSTOMER_POLICY_DETAILS]
                WHERE
	                CAST([POLICYENDDATE] AS DATE) BETWEEN CAST(DATEADD(DAY, 35, DATEADD(DAY, 1, EOMONTH(GETDATE(),-2))) AS DATE) AND CAST(DATEADD(DAY, 35, EOMONTH(DATEADD(MONTH, -1, GETDATE()))) AS DATE)
                AND
	                [AGENT_ID] IN
					                (
						                'E2F376B621E14C1FB532CED74C7EDCE1', --Constructaquote
						                '5208F39A498E4706A91BEEC84ED25686'  --Constructaquote.com
					                )
                AND
	                [POLICY_STATUS_ID] IN
							                (
								                '3AJPUL66',
								                '3AJPUL79',
								                '3AJPUL86',
								                '3AJPUL87',
								                '3F9246U1'
							                )
                AND
	                [PAYMENT_PLAN_ID] IN
							                (
								                '010DF016C4CA401BB108CD9FC79F960C',
								                '07307B9B592B40DF80895F8913337ECB',
								                '0AF6FACD71AF4A8E8C074D1C9CBDC01A',
								                '0C7A0CC891E8455982957CD595F523AA',
								                '15490320D38A45D89A7F6685BAA057CC',
								                '2082FB178DE74BCF944DFD50A3F33427',
								                '25AD9B228FE34A8F9A26CD26AB60A2EB',
								                '26FBE5C329634E0B814479F50EE6F073',
								                '28AB8521EBB943BAB096C863B2E44757',
								                '2A4E9E88C7A54897A62C2B9C80E61216',
								                '2E80446FF50B4F7DB96EEC25D65FA873',
								                '3E778FD04905416F959CEE7D5061262D',
								                '4563B2325B3A487B9954224ADE47B505',
								                '4BE5E10FD22F4A08ABA02EC0453D4D04',
								                '4ED05256AB5B484791C93E58F1F13CEF',
								                '504707FA7A8C42DBA5A8CB0FB56FE5DC',
								                '5B84991504C84CB6B21027AEE98EA819',
								                '6714F2C987FA4A90A2573095DFEC169F',
								                '6FD0BB8BF74343B5A83A7463305B9C55',
								                '82941527E709471DA3DFA1B2F0C6F630',
								                '88A1180205BA4E0082176EDB4F6CF66A',
								                '8FF2BBEC288549ABA4DE61C6FB7D227F',
								                '9F1CDD6D0AC2486A9952539F72F2A4DF',
								                '9F2F9E70E27B4B2E89D01C7B16871B37',
								                'AF1CA0D1E8B04E018F855ED4025D2943',
								                'B2DB9DEEB02C409983AA910175059FAC',
								                'B3CFD5F80A2D4D829519817E57DB0716',
								                'B8E4095D0F484CEFA14271FF993F302C',
								                'C91B121D16554F7AB3EEE997D9C449AF',
								                'D322E23721914CFD8F271DD16D59E82B',
								                'EA345581BF884425BBDDFE3D810558B5',
								                'F21A107BD0064958A1DA92492A8ACA3A'
							                );
            ";

try
{
    $Qualifying_Records = invoke-sqlcmd –ServerInstance $SQLServer -Username $DBUsername -Password $DBPassword -Database $DatabaseName -Query $SQLQuery -ConnectionTimeout 0 -QueryTimeout 0 -ErrorAction 'Stop';
}
catch
{
    $ErrorCount = 1;
}

if ($ErrorCount -eq 0)
{
    #Do nothing query ok
    Write-Host "SQL Select statment ok";
}
else
{
    #Send e-mail as issue with select statement
    Write-Host "Alert e-mail being sent"
    #Send E-Mail listing cases changed
    $Subject = "TGSL Renewals Update"

    $Body =
    "
        <html xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:w=""urn:schemas-microsoft-com:office:word"" xmlns:m=""http://schemas.microsoft.com/office/2004/12/omml"" xmlns=""http://www.w3.org/TR/REC-html40"">
            <head>
            <meta http-equiv=Content-Type content=""text/html; charset=us-ascii"">
            <meta name=Generator content=""Microsoft Word 15 (filtered medium)"">
            </head>
            <body lang=EN-GB link=""#0563C1"" vlink=""#954F72"">
                <table style=""width: 100%; border-collapse: collapse; border-style: none;"" border=""0"">
                    <tbody>
                        <tr>
                        <td style=""width: 19.0341%;"">Date:-</td>
                        <td style=""width: 80.9659%;"">$Date</td>
                        </tr>
                        <tr>
                        <td style=""width: 19.0341%;"">Detail:-</td>
                        <td style=""width: 80.9659%;"">There is an issue with the SQL Select statement, please investigate</td>
                        </tr>
						<tr>
                    </tbody>
                </table>
                </br>
                <table style=""border-collapse: collapse; width: 100%;"" border=""0"">
                    <tbody>
                        <tr>
                        <td style=""width: 100%;"">$_</td>
                        </tr>
                    </tbody>
                </table>
            </body>
        </html>
    "

    Send-Email $Subject $Body  
    Write-Host "Alert e-mail sent";
}

#Update
$SQLQuery = "
                UPDATE
	                [Transactor_Live].[dbo].[CUSTOMER_POLICY_DETAILS]
                SET
	                [PAYMENT_PLAN_ID] = CASE [PAYMENT_PLAN_ID]
							                WHEN '010DF016C4CA401BB108CD9FC79F960C' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '07307B9B592B40DF80895F8913337ECB' THEN '652320AF256942149924DAE952A6C1C4'
							                WHEN '0AF6FACD71AF4A8E8C074D1C9CBDC01A' THEN '652320AF256942149924DAE952A6C1C4'
							                WHEN '0C7A0CC891E8455982957CD595F523AA' THEN '652320AF256942149924DAE952A6C1C4'
							                WHEN '15490320D38A45D89A7F6685BAA057CC' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '2082FB178DE74BCF944DFD50A3F33427' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '25AD9B228FE34A8F9A26CD26AB60A2EB' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '26FBE5C329634E0B814479F50EE6F073' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '28AB8521EBB943BAB096C863B2E44757' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '2A4E9E88C7A54897A62C2B9C80E61216' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '2E80446FF50B4F7DB96EEC25D65FA873' THEN '652320AF256942149924DAE952A6C1C4'
							                WHEN '3E778FD04905416F959CEE7D5061262D' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '4563B2325B3A487B9954224ADE47B505' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '4BE5E10FD22F4A08ABA02EC0453D4D04' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '4ED05256AB5B484791C93E58F1F13CEF' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '504707FA7A8C42DBA5A8CB0FB56FE5DC' THEN '652320AF256942149924DAE952A6C1C4'
							                WHEN '5B84991504C84CB6B21027AEE98EA819' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '6714F2C987FA4A90A2573095DFEC169F' THEN '652320AF256942149924DAE952A6C1C4'
							                WHEN '6FD0BB8BF74343B5A83A7463305B9C55' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '82941527E709471DA3DFA1B2F0C6F630' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '88A1180205BA4E0082176EDB4F6CF66A' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '8FF2BBEC288549ABA4DE61C6FB7D227F' THEN '652320AF256942149924DAE952A6C1C4'
							                WHEN '9F1CDD6D0AC2486A9952539F72F2A4DF' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN '9F2F9E70E27B4B2E89D01C7B16871B37' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN 'AF1CA0D1E8B04E018F855ED4025D2943' THEN '652320AF256942149924DAE952A6C1C4'
							                WHEN 'B2DB9DEEB02C409983AA910175059FAC' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN 'B3CFD5F80A2D4D829519817E57DB0716' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN 'B8E4095D0F484CEFA14271FF993F302C' THEN '652320AF256942149924DAE952A6C1C4'
							                WHEN 'C91B121D16554F7AB3EEE997D9C449AF' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN 'D322E23721914CFD8F271DD16D59E82B' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN 'EA345581BF884425BBDDFE3D810558B5' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
							                WHEN 'F21A107BD0064958A1DA92492A8ACA3A' THEN '83D4DC909DA44C10B47FE2F4B0EEA89C'
						                END
                WHERE
	                CAST([POLICYENDDATE] AS DATE) BETWEEN CAST(DATEADD(DAY, 35, DATEADD(DAY, 1, EOMONTH(GETDATE(),-2))) AS DATE) AND CAST(DATEADD(DAY, 35, EOMONTH(DATEADD(MONTH, -1, GETDATE()))) AS DATE)
                AND
	                [AGENT_ID] IN
					                (
						                'E2F376B621E14C1FB532CED74C7EDCE1', --Constructaquote
						                '5208F39A498E4706A91BEEC84ED25686'  --Constructaquote.com
					                )
                AND
	                [POLICY_STATUS_ID] IN
							                (
								                '3AJPUL66',
								                '3AJPUL79',
								                '3AJPUL86',
								                '3AJPUL87',
								                '3F9246U1'
							                )
                AND
	                [PAYMENT_PLAN_ID] IN
							                (
								                '010DF016C4CA401BB108CD9FC79F960C',
								                '07307B9B592B40DF80895F8913337ECB',
								                '0AF6FACD71AF4A8E8C074D1C9CBDC01A',
								                '0C7A0CC891E8455982957CD595F523AA',
								                '15490320D38A45D89A7F6685BAA057CC',
								                '2082FB178DE74BCF944DFD50A3F33427',
								                '25AD9B228FE34A8F9A26CD26AB60A2EB',
								                '26FBE5C329634E0B814479F50EE6F073',
								                '28AB8521EBB943BAB096C863B2E44757',
								                '2A4E9E88C7A54897A62C2B9C80E61216',
								                '2E80446FF50B4F7DB96EEC25D65FA873',
								                '3E778FD04905416F959CEE7D5061262D',
								                '4563B2325B3A487B9954224ADE47B505',
								                '4BE5E10FD22F4A08ABA02EC0453D4D04',
								                '4ED05256AB5B484791C93E58F1F13CEF',
								                '504707FA7A8C42DBA5A8CB0FB56FE5DC',
								                '5B84991504C84CB6B21027AEE98EA819',
								                '6714F2C987FA4A90A2573095DFEC169F',
								                '6FD0BB8BF74343B5A83A7463305B9C55',
								                '82941527E709471DA3DFA1B2F0C6F630',
								                '88A1180205BA4E0082176EDB4F6CF66A',
								                '8FF2BBEC288549ABA4DE61C6FB7D227F',
								                '9F1CDD6D0AC2486A9952539F72F2A4DF',
								                '9F2F9E70E27B4B2E89D01C7B16871B37',
								                'AF1CA0D1E8B04E018F855ED4025D2943',
								                'B2DB9DEEB02C409983AA910175059FAC',
								                'B3CFD5F80A2D4D829519817E57DB0716',
								                'B8E4095D0F484CEFA14271FF993F302C',
								                'C91B121D16554F7AB3EEE997D9C449AF',
								                'D322E23721914CFD8F271DD16D59E82B',
								                'EA345581BF884425BBDDFE3D810558B5',
								                'F21A107BD0064958A1DA92492A8ACA3A'
							                );
            ";

try
{
    invoke-sqlcmd –ServerInstance $SQLServer -Username $DBUsername -Password $DBPassword -Database $DatabaseName -Query $SQLQuery -ConnectionTimeout 0 -QueryTimeout 0 -ErrorAction 'Stop';
}
catch
{
    $ErrorCount = 1;
}

if ($ErrorCount -eq 0)
{
    #Do nothing update ok
    Write-Host "SQL Update statment ok";
}
else
{
    #Send e-mail as issue with select statement
    Write-Host "Alert e-mail being sent"
    #Send E-Mail listing cases changed
    $Subject = "TGSL Renewals Update"

    $Body =
    "
        <html xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:w=""urn:schemas-microsoft-com:office:word"" xmlns:m=""http://schemas.microsoft.com/office/2004/12/omml"" xmlns=""http://www.w3.org/TR/REC-html40"">
            <head>
            <meta http-equiv=Content-Type content=""text/html; charset=us-ascii"">
            <meta name=Generator content=""Microsoft Word 15 (filtered medium)"">
            </head>
            <body lang=EN-GB link=""#0563C1"" vlink=""#954F72"">
                <table style=""width: 100%; border-collapse: collapse; border-style: none;"" border=""0"">
                    <tbody>
                        <tr>
                        <td style=""width: 19.0341%;"">Date:-</td>
                        <td style=""width: 80.9659%;"">$Date</td>
                        </tr>
                        <tr>
                        <td style=""width: 19.0341%;"">Detail:-</td>
                        <td style=""width: 80.9659%;"">There is an issue with the SQL Update, please investigate</td>
                        </tr>
						<tr>
                    </tbody>
                </table>
                </br>
                <table style=""border-collapse: collapse; width: 100%;"" border=""0"">
                    <tbody>
                        <tr>
                        <td style=""width: 100%;"">$_</td>
                        </tr>
                    </tbody>
                </table>
            </body>
        </html>
    "

    Send-Email $Subject $Body  
    Write-Host "Alert e-mail sent";
}

#Send E-Mail Verification
if ($Qualifying_Records.Count -eq 0 -Or $ErrorCount -eq 1)
{
    #Do nothing as no records to update
    Write-Host "No Records and/or error";

    #Send E-Mail listing cases changed
    $Subject = "TGSL Renewals Update - Monthly"

    $Body =
    "
        <html xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:w=""urn:schemas-microsoft-com:office:word"" xmlns:m=""http://schemas.microsoft.com/office/2004/12/omml"" xmlns=""http://www.w3.org/TR/REC-html40"">
            <head>
            <meta http-equiv=Content-Type content=""text/html; charset=us-ascii"">
            <meta name=Generator content=""Microsoft Word 15 (filtered medium)"">
            </head>
            <body lang=EN-GB link=""#0563C1"" vlink=""#954F72"">
                <table style=""width: 100%; border-collapse: collapse; border-style: none;"" border=""0"">
                    <tbody>
                        <tr>
                        <td>Date:- $Date</td>
                        </tr>
                        <tr>
                        <td>Detail:- The job ran but no records were identified</td>
                        </tr>
                    </tbody>
                </table>
                </br>
                <table style=""border-collapse: collapse; width: 100%;"" border=""0"">
                    <tbody>
                        <tr>
                        <td style=""width: 100%;"">$_</td>
                        </tr>
                    </tbody>
                </table>
            </body>
        </html>
    "

    Send-Email $Subject $Body  
    Write-Host "E-mail sent";
}
else
{
    #Records to update
    Write-Host "Records identified";
    $ErrorCount = 0;

    $EmailOutput = $Qualifying_Records | Select-Object 'Policy Number', 'Current Payment Plan', 'New Payment Plan' | ConvertTo-HTML

    #Send E-Mail listing cases changed
    $Subject = "TGSL Renewals Update"

    $Body =
    "
        <html xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:w=""urn:schemas-microsoft-com:office:word"" xmlns:m=""http://schemas.microsoft.com/office/2004/12/omml"" xmlns=""http://www.w3.org/TR/REC-html40"">
            <head>
            <meta http-equiv=Content-Type content=""text/html; charset=us-ascii"">
            <meta name=Generator content=""Microsoft Word 15 (filtered medium)"">
            </head>
            <body lang=EN-GB link=""#0563C1"" vlink=""#954F72"">
                <table style=""width: 100%; border-collapse: collapse; border-style: none;"" border=""0"">
                    <tbody>
                        <tr>
                        <td>Date:- $Date</td>
                        </tr>
                        <tr>
                        <td>Detail:- The following policies have been identified and changed as shown below</td>
                        </tr>
                        <tr></tr>
                        <tr></tr>
                        <tr>$EmailOutput</tr>
						<tr>
                    </tbody>
                </table>
                </br>
                <table style=""border-collapse: collapse; width: 100%;"" border=""0"">
                    <tbody>
                        <tr>
                        <td style=""width: 100%;"">$_</td>
                        </tr>
                    </tbody>
                </table>
            </body>
        </html>
    "

    Send-Email $Subject $Body  
    Write-Host "E-mail sent";

}

#Close scripting window
exit;