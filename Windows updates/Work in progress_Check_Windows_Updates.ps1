<# 
.INFORMATION 
   Description:	to Check for installed KB's
   Author:	Kane Walsh
   Version:	1.0
   Date:	14/12/2021 
   Requires:	Admin Account
.VERSION
  14/12/2021	1.0		First Version


#> 
#Module
Import-Module ActiveDirectory

# Arrays for the script
$server = Read-Host "Server Name?"
$KB = Read-Host "KB Number or Number's with ' separting them e.g 'KB5005076','KB5005106' "
$Admin = Read-Host "Enter Admin Username"


#Process
Get-HotFix -Id $KB -ComputerName $server -Credential (Get-Credential -Credential  "brent\$Admin")

#-ErrorAction SilentlyContinue -ErrorVariable Problem

#foreach ($p in $Problem) {
 #   if ($p.origininfo.pscomputername) {
  #      Write-Warning -Message "Patch not found on $($p.origininfo.pscomputername)"
   # }
    #elseif ($p.targetobject) {
     #   Write-Warning -Message "Unable to connect to $($p.targetobject)"
   # }
#}


