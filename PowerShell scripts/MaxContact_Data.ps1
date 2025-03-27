#Load Functions as required
Import-Module "S:\PowerShell\Functions\email.ps1";

#Global Parameters
$Date = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss.fff");
$ErrorCount = 0;
$FileUNC = '\\MHGDW01\Extracts\MaxContact\';
$ArchiveUNC = '\\MHGDW01\Extracts\MaxContact\Archive\';

#Provide SQL Server connection via external variable PowerShell File
. "S:\PowerShell\Connections\SQL\MHGSQL01_TGSL.ps1"

#Set the Database
$DatabaseName ="CRM";

#Campaigns Query
$Campaigns_TableSQLQuery = 'EXEC [dbo].[uspMaxContact_DataExtract_Data] ''' + $Date + '''';

#Execute the SQL procedures, store the results in arrays
try
{
    #Detail
    $Campaigns_Table = invoke-sqlcmd –ServerInstance $SQLServer -Username $DBUsername -Password $DBPassword -Database $DatabaseName -Query $Campaigns_TableSQLQuery -ConnectionTimeout 0 -QueryTimeout 0 -ErrorAction 'Stop';
}
catch
{
    #Send E-Mail in the event of an issue
    $Subject = "MaxContact Data File Creation"

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
                        <td style=""width: 80.9659%;"">The SQL stored procedure part of the PowerShell script has failed.</td>
                        </tr>
						<tr>
						<td style=""width: 19.0341%;"">Scheduled Task:-</td>
						<td style=""width: 80.9659%;"">MaxContact Data</td>
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
    $ErrorCount = $ErrorCount+1;
	exit;
}
finally
{

}

#Export
if ($ErrorCount -gt 0)
{
    #Do nothing as error
    #$ErrorCount
	exit;
}
else
{

    # SME Data Pot A
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "SMEPot A" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No SMEPot A identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $FileUNC + 'SME Data Pot A.csv';
        Write-Output "SMEPot A identified";
        $CampaignCount | Select-Object "Last_Name", "First_Name", "Title", "Client Name", "Other Telephone", "Mobile Telephone", "Customer ID", "Customer Postcode", "Customer Email", "Agent", "Client Reference", "Company Name", "Client name/contact", "Other TPS Flag", "Mobile TPS Flag", "Live Client Flag", "OGI Live Client Flag", "TradeList", "ProspectProduct1 Type", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "ProspectProduct4 Next Quote Due Date", "InsertDateTime", "UpdateDateTime", "Data Source", "ProspectProduct1 Next Quote Due Date", "TierGroup", "Trade", "CRMEntityStatus" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

    # SME Data Pot B
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "SMEPot B" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No SMEPot B identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $FileUNC + 'SME Data Pot B.csv';
        Write-Output "SMEPot B identified";
        $CampaignCount | Select-Object "Last_Name", "First_Name", "Title", "Client Name", "Other Telephone", "Mobile Telephone", "Customer ID", "Customer Postcode", "Customer Email", "Data Source", "ProspectProduct1 Next Quote Due Date", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "TierGroup", "CRMEntityStatus", "Client Reference", "Company Name", "Client name/contact", "Other TPS Flag", "Mobile TPS Flag", "Live Client Flag", "OGI Live Client Flag", "TradeList", "Trade", "Agent", "ProspectProduct1 Type", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "ProspectProduct4 Next Quote Due Date", "UpdateDateTime", "InsertDateTime" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

    # SME Data Pot C
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "SMEPot C" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No SMEPot C identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $FileUNC + 'SME Data Pot C.csv';
        Write-Output "SMEPot C identified";
        $CampaignCount | Select-Object "Last_Name", "First_Name", "Title", "Client Name", "Other Telephone", "Mobile Telephone", "Customer ID", "Customer Postcode", "Customer Email", "Company Name", "Client name/contact", "Other TPS Flag", "Mobile TPS Flag", "Live Client Flag", "OGI Live Client Flag", "TradeList", "Trade", "Agent", "ProspectProduct1 Type", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "ProspectProduct4 Next Quote Due Date", "InsertDateTime", "UpdateDateTime", "Data Source", "ProspectProduct1 Next Quote Due Date", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "TierGroup", "Client Reference", "CRMEntityStatus" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

    # SME Data Pot D
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "SMEPot D" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No SMEPot D identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $FileUNC + 'SME Data Pot D.csv';
        Write-Output "SMEPot D identified";
        $CampaignCount | Select-Object "Customer Postcode", "Customer ID", "Mobile Telephone", "Other Telephone", "Client Name", "Title", "First_Name", "Last_Name", "Customer Email", "ProspectProduct1 Next Quote Due Date", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "TierGroup", "CRMEntityStatus", "Client Reference", "Company Name", "Client name/contact", "UpdateDateTime", "Other TPS Flag", "Live Client Flag", "OGI Live Client Flag", "TradeList", "Trade", "Agent", "ProspectProduct1 Type", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "Mobile TPS Flag", "InsertDateTime", "Data Source", "ProspectProduct4 Next Quote Due Date" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

    # SME Data Pot E
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "SMEPot E" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No SMEPot E identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $FileUNC + 'SME Data Pot E.csv';
        Write-Output "SMEPot E identified";
        $CampaignCount | Select-Object "Last_Name", "First_Name", "Title", "Client Name", "Other Telephone", "Mobile Telephone", "Customer ID", "Customer Postcode", "Customer Email", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "TierGroup", "CRMEntityStatus", "Client Reference", "Company Name", "Client name/contact", "UpdateDateTime", "Data Source", "Other TPS Flag", "OGI Live Client Flag", "TradeList", "Trade", "Agent", "ProspectProduct1 Type", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "Mobile TPS Flag", "Live Client Flag", "ProspectProduct4 Next Quote Due Date", "ProspectProduct1 Next Quote Due Date", "InsertDateTime" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }
	
    # SME DATA API Specialist Risks
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "SME DATA API Specialist Risks" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No SME DATA API Specialist Risks identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $FileUNC + 'SME DATA API Specialist Risks.csv';
        Write-Output "SME DATA API Specialist Risks identified";
        $CampaignCount | Select-Object "Customer Postcode", "Customer ID", "Mobile Telephone", "Other Telephone", "Client Name", "Title", "First_Name", "Last_Name", "CRMEntityStatus", "ProspectProduct1 Next Quote Due Date", "Data Source", "UpdateDateTime", "InsertDateTime", "ProspectProduct4 Next Quote Due Date", "ProspectProduct4 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct3 Type", "ProspectProduct2 Next Quote Due Date", "ProspectProduct2 Type", "ProspectProduct1 Type", "TradeList", "OGI Live Client Flag", "Live Client Flag", "Mobile TPS Flag", "Other TPS Flag", "Client name/contact", "Company Name", "Client Reference", "Agent", "Trade", "TierGroup", "Customer Email" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }	

    # SME Auto CC Decline
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "SME Auto CC Decline API" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No SME Auto CC Decline API Decline identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $FileUNC + 'SME Auto CC Decline API.csv';
        Write-Output "SME Auto CC Decline API Decline identified";
        $CampaignCount | Select-Object "Last_Name", "First_Name", "Customer ID", "Mobile Telephone", "Other Telephone", "Title", "Customer Postcode", "Customer Email", "Client name/contact", "LiveProduct2 Expiry date", "LiveProduct2 Expiry Month", "LiveProduct3 Expiry date", "LiveProduct3 Type", "Agent", "LiveProduct3 Expiry Month", "LiveProduct4 Expiry date", "LiveProduct4 Expiry Month", "LiveProduct5 Type", "LiveProduct5 Expiry date", "LiveProduct5 Expiry Month", "LiveProduct6 Type", "LiveProduct6 Expiry date", "LiveProduct6 Expiry Month", "InsertDateTime", "Client Reference", "Mobile TPS Flag", "LiveProduct4 Type", "UpdateDateTime", "Live Client Flag", "OGI Live Client Flag", "AutoCCDecline", "LiveProduct1 Type", "LiveProduct1 Expiry date", "LiveProduct1 Expiry Month", "LiveProduct2 Type", "Other TPS Flag" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

}

#Move csv files to Archive folder
Get-ChildItem -Path $FileUNC -File | Foreach-Object {
    
    $OriginalFileName = $FileUNC + $_.Name;
    $NewFileName = $FileUNC + $_.BaseName + '_' + (Get-Date).ToString("ddMMyyyy_HHmmss") + '.csv';
    $UploadLocation = '\\MHGDW01\Applications\LeadManagementImporter\ImportCSVFiles\'
    
    Copy-Item -Path $OriginalFileName -Destination $UploadLocation
    Rename-Item -Path $OriginalFileName -NewName $NewFileName;
    Move-Item -Path $NewFileName -Destination $ArchiveUNC;
}

#8788852741 Same as above but rather than being 28 days in advance it is 35 days.
$FileDate = (Get-Date).ToString("ddMMyyyyHHmmss");
$35DayFileUNC = '\\moorhouse.hosted\Moorhouse\Public\Operations\Process and User Guides\In Progress\Call Centre Optimisation\ReQuote Data\';
$35DayFileArchiveUNC = '\\moorhouse.hosted\Moorhouse\Public\Operations\Process and User Guides\In Progress\Call Centre Optimisation\ReQuote Data\Archive\';

#Move yesterdays items to folder
Get-ChildItem -Path $35DayFileUNC -File | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-1)} | Move-Item -destination $35DayFileArchiveUNC;

#Export
if ($ErrorCount -gt 0)
{
    #Do nothing as error
    #$ErrorCount
	exit;
}
else
{

    # 35 Day SME Data Pot A
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "35 Day SMEPot A" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No 35 Day SMEPot A identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $35DayFileUNC + $FileDate + '_SME_Data_Pot_A.csv';
        Write-Output "35 Day SMEPot A identified";
        $CampaignCount | Select-Object "Last_Name", "First_Name", "Title", "Client Name", "Other Telephone", "Mobile Telephone", "Customer ID", "Customer Postcode", "Customer Email", "Agent", "Client Reference", "Company Name", "Client name/contact", "Other TPS Flag", "Mobile TPS Flag", "Live Client Flag", "OGI Live Client Flag", "TradeList", "ProspectProduct1 Type", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "ProspectProduct4 Next Quote Due Date", "InsertDateTime", "UpdateDateTime", "Data Source", "ProspectProduct1 Next Quote Due Date", "TierGroup", "Trade", "CRMEntityStatus" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

    # 35 Day SME Data Pot B
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "35 Day SMEPot B" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No 35 Day SMEPot B identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $35DayFileUNC + $FileDate + '_SME_Data_Pot_B.csv';
        Write-Output "35 Day SMEPot B identified";
        $CampaignCount | Select-Object "Last_Name", "First_Name", "Title", "Client Name", "Other Telephone", "Mobile Telephone", "Customer ID", "Customer Postcode", "Customer Email", "Data Source", "ProspectProduct1 Next Quote Due Date", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "TierGroup", "CRMEntityStatus", "Client Reference", "Company Name", "Client name/contact", "Other TPS Flag", "Mobile TPS Flag", "Live Client Flag", "OGI Live Client Flag", "TradeList", "Trade", "Agent", "ProspectProduct1 Type", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "ProspectProduct4 Next Quote Due Date", "UpdateDateTime", "InsertDateTime" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

    # 35 Day SME Data Pot C
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "35 Day SMEPot C" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No 35 Day SMEPot C identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $35DayFileUNC + $FileDate + '_SME_Data_Pot_C.csv';
        Write-Output "35 Day SMEPot C identified";
        $CampaignCount | Select-Object "Last_Name", "First_Name", "Title", "Client Name", "Other Telephone", "Mobile Telephone", "Customer ID", "Customer Postcode", "Customer Email", "Company Name", "Client name/contact", "Other TPS Flag", "Mobile TPS Flag", "Live Client Flag", "OGI Live Client Flag", "TradeList", "Trade", "Agent", "ProspectProduct1 Type", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "ProspectProduct4 Next Quote Due Date", "InsertDateTime", "UpdateDateTime", "Data Source", "ProspectProduct1 Next Quote Due Date", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "TierGroup", "Client Reference", "CRMEntityStatus" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

    # 35 Day SME Data Pot D
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "35 Day SMEPot D" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No 35 Day SMEPot D identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $35DayFileUNC + $FileDate + '_SME_Data_Pot_D.csv';
        Write-Output "35 Day MEPot D identified";
        $CampaignCount | Select-Object "Customer Postcode", "Customer ID", "Mobile Telephone", "Other Telephone", "Client Name", "Title", "First_Name", "Last_Name", "Customer Email", "ProspectProduct1 Next Quote Due Date", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "TierGroup", "CRMEntityStatus", "Client Reference", "Company Name", "Client name/contact", "UpdateDateTime", "Other TPS Flag", "Live Client Flag", "OGI Live Client Flag", "TradeList", "Trade", "Agent", "ProspectProduct1 Type", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "Mobile TPS Flag", "InsertDateTime", "Data Source", "ProspectProduct4 Next Quote Due Date" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

    # 35 Day SME Data Pot E
    $CampaignCount = 0;

    $CampaignCount = $Campaigns_Table | Where-Object { $_.'Campaign Type' -eq "35 Day SMEPot E" };

    if ($CampaignCount.Count -eq 0)
    {
        #Do nothing, no campaigns
        Write-Output "No 35 Day SMEPot E identified";
    }
    else
    {
        #Export Files
        $CampaignFileUNC = $35DayFileUNC + $FileDate + '_SME_Data_Pot_E.csv';
        Write-Output "35 Day SMEPot E identified";
        $CampaignCount | Select-Object "Last_Name", "First_Name", "Title", "Client Name", "Other Telephone", "Mobile Telephone", "Customer ID", "Customer Postcode", "Customer Email", "ProspectProduct2 Type", "ProspectProduct2 Next Quote Due Date", "TierGroup", "CRMEntityStatus", "Client Reference", "Company Name", "Client name/contact", "UpdateDateTime", "Data Source", "Other TPS Flag", "OGI Live Client Flag", "TradeList", "Trade", "Agent", "ProspectProduct1 Type", "ProspectProduct3 Type", "ProspectProduct3 Next Quote Due Date", "ProspectProduct4 Type", "Mobile TPS Flag", "Live Client Flag", "ProspectProduct4 Next Quote Due Date", "ProspectProduct1 Next Quote Due Date", "InsertDateTime" | Export-Csv -Path $CampaignFileUNC -NoTypeInformation -UseQuotes AsNeeded;
    }

}

exit;