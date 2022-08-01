<# 
.INFORMATION 
   Description:	to Help manage office 365 shared mailbox reports and set up Temp area to download to
   Author:	Kane Walsh
   Version:	1.0
   Date:	09/12/2021 
   Requires:	ExchangeOnlineManagement Module tools installed 
.VERSION
  05/01/2021	1.0		First Version
  06/01/2021    1.1     Tweeked to use V2 Exchange Cmdlets and added Wildcard seach to delete temp files and added date to exported file name
  01/08/2022    1.2     First upload to GitHub

#> 

#Variables to the root folder
$Path = "C:\temp\ExchangeExport"
$DeleteLogpath = "C:\temp\ExchangeExport\"
$HowOld = -0
Import-Module -Name ExchangeOnlineManagement 

#Menu

do {
    [int]$userMenuChoice = 0
    while ($userMenuchoice -eq 0 -or $userMenuChoice -eq $null) {
    #Task Menu
    Write-Host "1) Create File Location - Please Run Fist if First time using this" -ForegroundColor Yellow
    Write-Host "2) Shared Mailbox Permissions Export" -ForegroundColor Yellow
    Write-Host "3) Shared Mailbox Forwarding Export" -ForegroundColor Yellow
    Write-Host "4) Shared Mailbox Send As Permissions Export" -ForegroundColor Yellow
    Write-Host "5) Shared Mailbox Send on behalf of Export" -ForegroundColor Yellow
    Write-Host "6) Quit and Exit" -ForegroundColor Yellow
    
    [int]$userMenuChoice = Read-Host "Choose a Number to continue!"
    
    switch ($userMenuChoice) {
    
    # Create File Location
    1 {
        if (-not(Test-Path -Path $DeleteLogpath -PathType Leaf)) {
            try {
                New-Item -Path "C:\temp" -Name "ExchangeExport" -ItemType "directory"
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

    #Shared Mailbox Permissions
    2 {
        #Get the CSV to delete
        $csvToDelete = Get-ChildItem -Path "$Path\Shared_Mailbox_Permissions*.csv" -Recurse | Where-Object {$_.CreationTime -lt (Get-Date).AddDays($HowOld)} 

        # Delete CSV File 
        $csvToDelete | Remove-Item -Recurse -Force 

        # Connect to Exchange
        Connect-ExchangeOnline


        #Export to CSV file
        Get-EXOMailbox  -ResultSize Unlimited -RecipientTypeDetails SharedMailbox | Get-EXOMailboxPermission | Where-Object {$_.User -ne "NT AUTHORITY\SELF" -and $_.IsInherited -ne $true -and $_.user -notlike "S-1-5-*"} | Export-CSV  "$path\Shared_Mailbox_Permissions_$(get-date -f dd_MM-yyyy).csv"

        #Complete Confomation
        Write-Host "CSV Created in $path" -BackgroundColor Green -ForegroundColor black

        #Disconnect from Exchange
        Disconnect-ExchangeOnline -Confirm:$false -InformationAction Ignore -ErrorAction SilentlyContinue

    }
     #Mailbox Forwarding
     3 {
        #Get the CSV to delete
        $csvToDelete = Get-ChildItem -Path "$path\Shared_Mailbox_Forwarding*.csv" -Recurse | Where-Object {$_.CreationTime -lt (Get-Date).AddDays($HowOld)} 

        # Delete CSV File 
        $csvToDelete | Remove-Item -Recurse -Force 

        # Connect to Exchange
        Connect-ExchangeOnline        

        #Export to CSV file
        Get-EXOMailbox -ResultSize unlimited | Select-Object UserPrincipalName,DisplayName,ForwardingSmtpAddress,ForwardingAddress,DeliverToMailboxAndForward | Where-Object {$_.ForwardingAddress -ne $Null}  | Export-CSV "$path\Shared_Mailbox_Forwarding_$(get-date -f dd_MM-yyyy).csv"

        #Complete Confomation
        Write-Host "CSV Created in $path" -BackgroundColor Green -ForegroundColor black

        #Disconnect from Exchange
        Disconnect-ExchangeOnline -Confirm:$false -InformationAction Ignore -ErrorAction SilentlyContinue
    }

    #Mailbox Send As Permissions
     4 {
        #Get the CSV to delete
        $csvToDelete = Get-ChildItem -Path "$path\Shared_Mailbox_Send_As_Permissions*.csv" -Recurse | Where-Object {$_.CreationTime -lt (Get-Date).AddDays($HowOld)} 

        # Delete CSV File 
        $csvToDelete | Remove-Item -Recurse -Force 

        # Connect to Exchange
        Connect-ExchangeOnline        

        #Export to CSV file
        Get-EXOMailbox  -ResultSize unlimited | Select-Object UserPrincipalName,DisplayName,ForwardingSmtpAddress,ForwardingAddress,DeliverToMailboxAndForward | Where-Object {$_.ForwardingAddress -ne $Null}  | Export-CSV "$path\Shared_Mailbox_Send_As Permissions_$(get-date -f dd_MM-yyyy).csv"

        #Complete Confomation
        Write-Host "CSV Created in $path" -BackgroundColor Green -ForegroundColor black

        #Disconnect from Exchange
        Disconnect-ExchangeOnline -Confirm:$false -InformationAction Ignore -ErrorAction SilentlyContinue
        }

    #Shared Mailbox Send on behalf of
    5 {
        #Get the CSV to delete
        $csvToDelete = Get-ChildItem -Path "$path\Shared_Mailbox_Send_on behalf_of_*.csv" -Recurse | Where-Object {$_.CreationTime -lt (Get-Date).AddDays($HowOld)} 

        # Delete CSV File 
        $csvToDelete | Remove-Item -Recurse -Force 

        # Connect to Exchange
        Connect-ExchangeOnline        

        #Export to CSV file
        Get-EXOMailbox  -ResultSize unlimited | Select-Object UserPrincipalName,DisplayName,ForwardingSmtpAddress,ForwardingAddress,DeliverToMailboxAndForward | Where-Object {$_.ForwardingAddress -ne $Null}  |  Export-CSV "$path\Shared_Mailbox_Send_on behalf_of_$(get-date -f dd_MM-yyyy).csv"

        #Complete Confomation
        Write-Host "CSV Created in $path" -BackgroundColor Green -ForegroundColor black

        #Disconnect from Exchange
        Disconnect-ExchangeOnline -Confirm:$false -InformationAction Ignore -ErrorAction SilentlyContinue
        }
}
}
} while ($userMenuChoice -ne 6)