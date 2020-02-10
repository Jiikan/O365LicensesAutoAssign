<#
.SYNOPSIS
Add-O365Licenses will assign the default licenses to a user.

.DESCRIPTION
Add-O365Licenses connects to the Microsoft Online Services and only accepts a user email address as an input.
The 3 default license groups - Office 365 E3, Multi-Geo Capabilities in Office 365, Azure Active Directory Premium P1 are assigned to an $SKU variable.
Any sub-licenses not specified in the -DisabledPlans parameter will be enabled.
Once an email is entered, it sets the location of the user to "US" which is required before a license can be assigned.

#>

Connect-AzureAd
Connect-MsolService

$Office365E3SKU = Get-MsolAccountSku | Where {$_.SkuPartNumber -eq "ENTERPRISEPACK"} 
$MultiGeoSKU = Get-MsolAccountSku | Where {$_.SkuPartNumber -eq "OFFICE365_MULTIGEO"}
$AzureADSKU = Get-MsolAccountSku | Where {$_.SkuPartNumber -eq "AAD_PREMIUM"}

$Office365E3 = New-msollicenseoptions -AccountSKUID fieracapitalcorp:ENTERPRISEPACK -DisabledPlans MIP_S_CLP1, MYANALYTICS_P2, BPOS_S_TODO_2, FORMS_PLAN_E3, STREAM_O365_E3, Deskless, FLOW_O365_P2, POWERAPPS_O365_P2, TEAMS1, PROJECTWORKMANAGEMENT, SWAY, YAMMER_ENTERPRISE, RMS_S_ENTERPRISE, MCOSTANDARD, SHAREPOINTWAC, SHAREPOINTENTERPRISE  
$MultiGeo = New-msollicenseoptions -AccountSKUID fieracapitalcorp:OFFICE365_MULTIGEO -DisabledPlans SHAREPOINTONLINE_MULTIGEO
$AzureAD = New-msollicenseoptions -AccountSKUID fieracapitalcorp:AAD_PREMIUM -DisabledPlans ADALLOM_S_DISCOVERY, EXCHANGE_S_FOUNDATION, MFA_PREMIUM


$O365UPN = Read-Host "E-mail address of the user where licenses will be assigned"
Get-MsolUser -UserPrincipalName $O365UPN
Set-MsolUser -UserPrincipalName $O365UPN -UsageLocation "US"
Set-MsolUserLicense -UserPrincipalName $O365UPN -AddLicenses $Office365E3SKU.AccountSkuId -LicenseOptions $Office365E3
Set-MsolUserLicense -UserPrincipalName $O365UPN -AddLicenses $MultiGeoSKU.AccountSkuId -LicenseOptions $MultiGeo
Set-MsolUserLicense -UserPrincipalName $O365UPN -AddLicenses $AzureADSKU.AccountSkuId -LicenseOptions $AzureAD
Add-AzureADGroupMember -ObjectId ed36f809-1f9c-493f-b9cc-1a534c494859 -RefObjectId (Get-AzureADUser -ObjectId $O365UPN).objectID
Add-AzureADGroupMember -ObjectId 404f643b-3e6d-4b36-9029-616c1d5d4054 -RefObjectId (Get-AzureADUser -ObjectId $O365UPN).objectID
Add-AzureADGroupMember -ObjectId 69efcf95-43a6-4043-b99a-6ba970d4d027 -RefObjectId (Get-AzureADUser -ObjectId $O365UPN).objectID
Write-Host "Default licenses have been assigned for $O365UPN" -BackgroundColor Green
