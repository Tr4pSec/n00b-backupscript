<#
This script is supposed to copy a folder with subfolders and items to a "backup" folder on another drive. foldernames should include dates.
If the destination dosent have more than 100GB free space, you should get a error.
It also deletes any backups older than 15 days.

This is intended to run as a scheduled task on a endpoint daily.

Not fully tested, might produce unexpected results. Don't use this script if you can't afford to loose data.

Written by @tr4psec
#>


#Error alert box
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::OK
$MessageIcon = [System.Windows.MessageBoxImage]::Error
$MessageBody = "Please check diskpace on target!"
$MessageTitle = "Cannot perform backup"


#Enter your source folder here (the folder you want to back up)
$sourcefolder = "C:\backupthisfolder\documents\"

#Enter your destination Drive:
$destinationdrive = "E:\"

#Enter your destination path here (the folder you want the copy to end up in.)
$destinationpath = "$desinationdrive\backups\$((Get-Date).ToString('yyyy-MM-dd'))"

$date = get-date
$freespace = Get-PSDrive | Where-Object {$_.Root -eq "$destinationdrive"} | Select-Object -ExpandProperty Free
$freespacetoGB = ("{0:N0}" -f ($freespace/1GB))

#Only does action below if you have more than 100GB free space on destinationdrive
if ($freespacetoGB -ge 100) {
    New-Item -Type Directory -Path $destinationpath
    Copy-Item $sourcefolder -Destination $destinationpath -Recurse -Verbose
} else {

$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

}

#Deletes any folders older than $howold days
$HowOld = -15 
$Path = "$destinationdrive\backup"
get-childitem $Path -recurse | where {$_.lastwritetime -lt (get-date).adddays($HowOld) -and -not $_.psiscontainer} |% {remove-item $_.fullname -force}

