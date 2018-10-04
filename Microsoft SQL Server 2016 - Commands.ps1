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

##### Windows Firewall

    ### Windows Firewall - Allow Microsoft SQL Port 1433 TCP
    New-NetFirewallRule -DisplayName "Microsoft SQL Server 2016 - SQL - TCP" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow

    ### Windows Firewall - Enable rule for RPC for DTC
    Enable-NetFirewallRule -DisplayName "Distributed Transaction Coordinator (RPC-EPMAP)"

    ### Windows Firewall - Enable rule for Incoming DTC
    Enable-NetFirewallRule -DisplayName "Distributed Transaction Coordinator (TCP-In)"

    ### Windows Firewall - Enable rule for Outgoing DTC
    Enable-NetFirewallRule -DisplayName "Distributed Transaction Coordinator (TCP-Out)"

##### Microsoft SQL Management Studio
C:\Temp\SSMS-Setup-ENU.exe /install /passive /norestart

##### Microsoft SQL Server 2016
B:\Setup.exe /ConfigurationFile="C:\Temp\Microsoft SQL Server 2016 - Configuration.ini"

##### Reboot the server
shutdown -r -t 0

##### Configure the Microsoft Distributed Transaction Coordinator (DTC)
Set-DtcNetworkSetting -DtcName "Local" -RemoteClientAccessEnabled:$true -RemoteAdministrationAccessEnabled:$false -AuthenticationLevel "Mutual" -InboundTransactionsEnabled:$true -OutboundTransactionsEnabled:$true -XATransactionsEnabled:$false -LUTransactionsEnabled:$true -Confirm:$false

##### Reboot the server
shutdown -r -t 0