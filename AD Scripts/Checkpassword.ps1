<# 
.INFORMATION 
   Description:	Script to Help service Desk look up asswords
   Author:	Kane Walsh & Jordan Goodman
   Version:	1.2
   Date:	22/10/2021 
   Requires:	Windows PowerShell Module for AD and RSAT tools installed 
.VERSION
  22/10/2021	1.0		First Version
  29/10/2021    1.1     Added Random Quote
  05/11/2021    1.2     Added backup for Ad account lookup if Timeouts happen


#> 

#Menu
do {
    [int]$userMenuChoice = 0
    while ($userMenuchoice -eq 0 -or $userMenuChoice -eq $null) {
    #Task Menu
    Write-Host "1) Check Users Password Expiry Date?" -ForegroundColor Yellow
    Write-Host "2) Random Quote" -ForegroundColor Yellow
    Write-Host "3) (Backup) Check Users Password Expiry Date?" -ForegroundColor Yellow
    Write-Host "4) Quit and Exit" -ForegroundColor Yellow
    
    [int]$userMenuChoice = Read-Host "Choose a Number to continue!"
    
    switch ($userMenuChoice) {
    
    #AD Query
    1 {
    Write-Host "Who is the user?" -ForegroundColor Yellow
    $whois = Read-Host
    $output = $whois
    Get-ADUser $output -Properties msDS-UserPasswordExpiryTimeComputed,* | Select-Object SamAccountName, DisplayName , @{Name="ExpiryDate";Expression={([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")).ToShortDateString()}}, Lockedout | format-list
    Write-Host "Search Complete." -ForegroundColor Green
    }
    #Fun quotes
    2 {

        Invoke-RestMethod -Method Get -Uri 'https://ron-swanson-quotes.herokuapp.com/v2/quotes' -Headers $Header -UseBasicParsing | Write-Output

    }
    # Old AD Search
    3 {
        Write-Host "Who is the user?" -ForegroundColor Yellow
        $whois = Read-Host
        $output = $whois
        net user $output /domain
        Write-Host "Search Complete." -ForegroundColor Green
        }
}
    }
    } while ($userMenuChoice -ne 4)