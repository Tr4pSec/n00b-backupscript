<# Backup script by @Tr4pSec
Copies one folder with subfolders to a destination drive. Creates a \backups\ folder, and a new folder named after the date when 
the backup runs. It deletes backups older than 10 days. 
#>
function DiskSpaceAlert {
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::OK
$MessageIcon = [System.Windows.MessageBoxImage]::Error
$MessageBody = "Please check diskpace on target!"
$MessageTitle = "Cannot perform backup"
[System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
}

$SourcePath = "C:\folder\keep" <#Enter the path to the folder you want to back up#>
$DesinationDrive = "E:" <#Change this with the drive letter you want to use as the destination drive#>


$DestinationPath = "$DesinationDrive\backups\$((Get-Date).ToString('yyyy-MM-dd'))" 
$FreeSpace = Get-PSDrive | Where-Object {$_.Root -eq "$DesinationDrive\"} | Select-Object -ExpandProperty Free
$FreeSpacetoGB = ($FreeSpace/1GB -as [int])

if ($FreeSpacetoGB -ge 100) {
    New-Item -Type Directory -Path $DestinationPath
    Copy-Item $SourcePath -Destination $DestinationPath -Recurse -Verbose
} else {    
DiskSpaceAlert
}


$HowOld = -10 <# This number is how old (days) the folder needs to be before the script deletes it #>
$Path = "$DesinationDrive\backups"
get-childitem $Path -recurse | Where-Object {$_.lastwritetime -lt (get-date).adddays($HowOld)} | remove-item -Recurse -force -confirm:$false

