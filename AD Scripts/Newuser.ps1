<# 
.INFORMATION 
   Description:	To automate AD Account Creation
   Author:	Kane Walsh
   Version:	1.0
   Date:	25/07/2022 
   Requires:	Windows PowerShell Module for AD and RSAT tools installed 
.VERSION
  25/07/2022 	1.0		First Version
  01/08/2022    1.1     Fixed issue with user set up (Did not like being split between diffrent lines) and added if statement for AD group section


#> 

#Remove error message that says can't add to group, even though it does add it successfully.
#$ErrorActionPreference = 'SilentlyContinue'
Write-Host -BackgroundColor DarkGreen "Creating Active Directory user account..."

# Active Directory
Import-Module ActiveDirectory

# Arrays for the script
$FirstName = Read-Host "Enter First Name"
$Surname = Read-Host "Enter Last Name"
$Username = Read-Host "Enter Username (i.e - FirstinitialLastName)"
$ADgroups = Read-Host "Copy AD group membership from which user?"
$Password = Read-Host "Enter a Password" | ConvertTo-SecureString -AsPlainText -Force
$Domain = $env:USERDNSDomain
#$Path = 

# Creating Displayname, First name, surname, samaccountname, UPN, etc and entering and a password for the user.
New-ADUser -Name "$FirstName" -GivenName $FirstName -Surname $Surname -SamAccountName $Username -UserPrincipalName $Username@$Domain -Displayname "$FirstName $Surname" -AccountPassword $Password

# Set required details
Set-ADUser $Username -Enabled $True
Set-ADUser $Username -ChangePasswordAtLogon $False 
Set-ADUser $Username -EmailAddress "$Username@$Domain"

# Finds all the AD-groups that the "$ADGroups" user you entered is a part of and adds it to the new user automatically.
if ( -not [string]::IsNullOrEmpty( $ADgroups))
  {Get-ADPrincipalGroupMembership -Identity $ADgroups | Select-Object SamAccountName | ForEach-Object {Add-ADGroupMember -Identity $_.SamAccountName -Members  $Username }}

Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete!"
