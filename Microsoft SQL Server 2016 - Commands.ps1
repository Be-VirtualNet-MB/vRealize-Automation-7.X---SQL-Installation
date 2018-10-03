##### Files required
# - Microsoft SQL Server 2016 Installation File
# - Microsoft SQL Management Studio 2016 Installation File

##### Volume 1 - DB 64k
$Disk = Get-Disk -Number 1
Set-Disk -InputObject $Disk -IsOffline $false
Initialize-Disk -InputObject $Disk
New-Partition $Disk.Number -UseMaximumSize -DriveLetter D
Format-Volume -DriveLetter D -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "DB" -Confirm:$false

##### Volume 2 - TEMP DB 64k
$Disk = Get-Disk -Number 2
Set-Disk -InputObject $Disk -IsOffline $false
Initialize-Disk -InputObject $Disk
New-Partition $Disk.Number -UseMaximumSize -DriveLetter E
Format-Volume -DriveLetter E -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "TEMP DB" -Confirm:$false

##### Volume 3 - Logs 4k
$Disk = Get-Disk -Number 3
Set-Disk -InputObject $Disk -IsOffline $false
Initialize-Disk -InputObject $Disk
New-Partition $Disk.Number -UseMaximumSize -DriveLetter F
Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel "Logs" -Confirm:$false

##### Make the service account member of the local administrators group
Add-LocalGroupMember -Group "Administrators" -Member "svc-vra-iaas"
Add-LocalGroupMember -Group "Administrators" -Member "svc-vra-sql"

##### Windows Firewall - Allow Microsoft SQL
New-NetFirewallRule -DisplayName "Microsoft SQL Server 2016 - SQL - TCP" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow

##### Microsoft SQL Management Studio
C:\Temp\SSMS-Setup-ENU.exe /install /passive /norestart

##### Microsoft SQL Server 2016
B:\Setup.exe /ConfigurationFile="C:\Temp\Microsoft SQL Server 2016 - Configuration.ini"