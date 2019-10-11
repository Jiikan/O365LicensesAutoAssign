##Connect to Microsoft Online Services
Connect-MsolService

##Get the main O365 license plan name and put them into a variable; Office 365 E3, Multi-Geo Capabilities in Office 365, Azure Active Directory Premium P1  
$Office365E3SKU = Get-MsolAccountSku | Where {$_.SkuPartNumber -eq "ENTERPRISEPACK"}
$MultiGeoSKU = Get-MsolAccountSku | Where {$_.SkuPartNumber -eq "OFFICE365_MULTIGEO"}
$AzureADSKU = Get-MsolAccountSku | Where {$_.SkuPartNumber -eq "AAD_PREMIUM"}


##Get the services within each main license that you want to disable. Services that are not specified in -DisabledPlans parameter will be enabled 
$Office365E3 = New-msollicenseoptions -AccountSKUID fieracapitalcorp:ENTERPRISEPACK -DisabledPlans MIP_S_CLP1, MYANALYTICS_P2, BPOS_S_TODO_2, FORMS_PLAN_E3, STREAM_O365_E3, Deskless, FLOW_O365_P2, POWERAPPS_O365_P2, TEAMS1, PROJECTWORKMANAGEMENT, SWAY, YAMMER_ENTERPRISE, RMS_S_ENTERPRISE, MCOSTANDARD, SHAREPOINTWAC, SHAREPOINTENTERPRISE  
$MultiGeo = New-msollicenseoptions -AccountSKUID fieracapitalcorp:OFFICE365_MULTIGEO -DisabledPlans SHAREPOINTONLINE_MULTIGEO
$AzureAD = New-msollicenseoptions -AccountSKUID fieracapitalcorp:AAD_PREMIUM -DisabledPlans ADALLOM_S_DISCOVERY, EXCHANGE_S_FOUNDATION, MFA_PREMIUM



#Set users location to US and and assign the licenses
Get-Content "C:\UsersToLicense.csv" | ForEach {
Set-MsolUser -UserPrincipalName $_ -UsageLocation "US"
Set-MsolUserLicense -UserPrincipalName $_ -AddLicenses $Office365E3SKU.AccountSkuId -LicenseOptions $Office365E3
Set-MsolUserLicense -UserPrincipalName $_ -AddLicenses $MultiGeoSKU.AccountSkuId -LicenseOptions $MultiGeo
Set-MsolUserLicense -UserPrincipalName $_ -AddLicenses $AzureADSKU.AccountSkuId -LicenseOptions $AzureAD
} 
