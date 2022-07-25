<# 
.INFORMATION 
   Description:	To automate AD Account Creation
   Author:	Kane Walsh
   Version:	1.0
   Date:	25/07/2022 
   Requires:	Windows PowerShell Module for AD and RSAT tools installed 
.VERSION
  25/07/2022 	1.0		First Version


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
#$Path = OU=Test,OU=BREComputerSpecialUsernames,DC=bre,DC=co,DC=uk

# Creating Displayname, First name, surname, samaccountname, UPN, etc and entering and a password for the user.
 New-ADUser `
-Name "$FirstName $Surname" `
-GivenName $FirstName `
-Surname $Surname `
-SamAccountName $Username `
-UserPrincipalName $Username@$Domain`
-Displayname "$FirstName $Surname" `
#-Path $Path `
-AccountPassword $Password `
#-Description

# Set required details
Set-ADUser $Username -Enabled $True
Set-ADUser $Username -ChangePasswordAtLogon $False 
Set-ADUser $Username -EmailAddress "$Username@$Domain"

# Finds all the AD-groups that the "$ADGroups" user you entered is a part of and adds it to the new user automatically.
Get-ADPrincipalGroupMembership -Identity $ADgroups | select SamAccountName | ForEach-Object {Add-ADGroupMember -Identity $_.SamAccountName -Members  $Username }

Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete!"