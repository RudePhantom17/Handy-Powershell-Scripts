<# 
.INFORMATION 
   Description:	Ad Inactive account download and to set up Temp area to download to
   Author:	Kane Walsh
   Version:	1.0
   Date:	01/08/2021 
   Requires:	Windows PowerShell Module for AD and RSAT tools installed 
.VERSION
  01/08/2021	1.0		First Version

  How to use:
            change the <OU>  in  line 26 to reflect the OU's you want to use
            Change the "Howold" Variable to relfect how old the last login date will be

            then run


#> 

#Variables to the root folder
$Path = "C:\temp\ADExport"
$DeleteLogpath = "C:\temp\ADExport\"
$HowOld = -0
Import-Module ActiveDirectory
$Retrevbedomain = (Get-ADDomain -Current LocalComputer).dnsroot 
#$RetrevDCs = (Get-ADDomainController -Filter * -Server $Retrevbedomain)
$accutaldomain = (Get-ADDomain $Retrevbedomain | Select-Object dnsroot,pdcemulator,netbiosname)
$finalDomainname = $accutaldomain.netbiosname

# Menu
do {
    [int]$userMenuChoice = 0
    while ($userMenuchoice -eq 0 -or $userMenuChoice -eq $null) {
    #Task Menu
    Write-Host "1) Create File Location - Please Run Fist if First time using this" -ForegroundColor Yellow
    Write-Host "2) Staff Last Login Export" -ForegroundColor Yellow
    Write-Host "3) Quit and Exit" -ForegroundColor Yellow
    
    [int]$userMenuChoice = Read-Host "Choose a Number to continue!"
    
    switch ($userMenuChoice) {
    
    # Create File Location
    1 {
        if (-not(Test-Path -Path $DeleteLogpath -PathType Leaf)) {
            try {
                New-Item -Path "C:\temp" -Name "ADExport" -ItemType "directory"
                Write-Host "The file [$DeleteLogpath] has been created."
            }
            catch {
                throw $_.Exception.Message
            }
        }
        # If the file already exists, show the message and do nothing.
        else {
            Write-Host "Cannot create [$file] because a file with that name already exists. But will Continue"
        }
    }

    #Staff Last Login
    2 {
        #Get the CSV to delete
        $csvToDelete = Get-ChildItem -Path "$Path\Staff_Last_Login.csv" -Recurse | Where-Object {$_.CreationTime -lt (Get-Date).AddDays($HowOld)} 

        # Delete CSV File 
        $csvToDelete | Remove-Item -Recurse -Force 


        #Export to CSV file
        Get-ADUser -server $finalDomainname -Filter * -SearchBase "<OU>" -ResultPageSize 0 -Prop CN,samaccountname,Useraccountcontrol,lastLogonTimestamp,whenchanged,pwdLastSet,CanonicalName | Select-Object CN,UserPrincipalName, samaccountname,Useraccountcontrol,@{n="lastLogonDate";e={[datetime]::FromFileTime($_.lastLogonTimestamp)}},whenchanged, pwdLastSet, CanonicalName | Export-CSV -NoType -path "$path\Staff_Last_Login.csv"

        #Complete Confomation
        Write-Host "CSV Created in $path" -BackgroundColor Green -ForegroundColor black

    }
    }
}
}while ($userMenuChoice -ne 3)