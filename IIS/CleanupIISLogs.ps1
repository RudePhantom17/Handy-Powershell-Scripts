<# 
.INFORMATION 
   Description:	To clean up IIS logs
   Author:	Kane Walsh
   Version:	1.0
   Date:	01/08/2022
   Requires:	IIS
.VERSION
  01/08/2022 	1.0		First Version
  


#> 

#Days older than
$HowOld = -0

#Path to the root folder
$Path = "C:\inetpub\logs\LogFiles\"
$DeleteLogpath = "C:\Logs\IISLogs\"

#Create Log Location if it does not exist
#New-Item -Path "C:\Logs" -Name "IISLogs" -ItemType "directory"

if (-not(Test-Path -Path $DeleteLogpath -PathType Leaf)) {
    try {
        New-Item -Path "C:\Logs" -Name "IISLogs" -ItemType "directory"
        Write-Host "The file [$DeleteLogpath] has been created."
    }
    catch {
        throw $_.Exception.Message
    }
}
# If the file already exists, show the message and do nothing.
else {
    Write-Host "Cannot create [$file] because a file with that name already exists."
}

#Get the files to delete
$LogfilesToDelete = Get-ChildItem -Path "$Path\*log" -Recurse | Where-Object {$_.CreationTime -lt (Get-Date).AddDays($HowOld)} 
$Pathtolog = "C:\Logs\IISLogs"

#Export to txt file

$LogfilesToDelete | Format-List  -Property Name,CreationTime,LastAccessTime,LastAccessTimeUtc | Out-File "C:\Logs\IISLogs\IISLogs_$((Get-Date).ToString('yyyyMMdd_HHmmss')).txt"

#Delete the files
$LogfilesToDelete | Remove-Item -Recurse -Force 


# Delete Log File after 90 days
Get-ChildItem -Path "$Pathtolog\*txt" -Recurse | Where-Object {$_.CreationTime -lt (Get-Date).AddDays($HowOld)} 