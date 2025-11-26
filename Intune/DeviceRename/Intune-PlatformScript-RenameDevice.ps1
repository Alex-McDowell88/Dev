<#
    .SYNOPSIS
        This script is utilised during Autopilot Device Preparation to customize the device name.

    .DESCRIPTION
        This script completes the following tasks
        
        1. Queries the devices' public IP to obtain the state the device is being enrolled in.

        2. Queries the devices' serial number and truncates it to 7 characters if necessary.

        3. The device name uses the following convention:

            INT-<STATE>-<SERIAL>
            INT-QLD-3F9VFX3

        4. The device is rebooted using a scheduled task after Windows Hello for Business is configured.        
        
    .NOTES
        N/A
        
#>

# Create the temp directory
$tempdir = "c:\Temp"
New-Item $tempdir -ItemType Directory -Force
Set-Location -Path $tempdir

# Pull files & register the scheduled task to reboot
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Alex-McDowell88/Dev/refs/heads/main/Intune/DeviceRename/Intune-RenameDevice-Reboot.ps1" -OutFile .\Intune-RenameDevice-Reboot.ps1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Alex-McDowell88/Dev/refs/heads/main/Intune/DeviceRename/Intune-RenameDevice-Reboot.xml" -OutFile .\Intune-RenameDevice-Reboot.xml
Register-ScheduledTask -xml (Get-Content '.\Intune-RenameDevice-Reboot.xml' | Out-String) -TaskName "Intune-RenameDevice-Reboot" -Force

# Query for variables
$ipaddress = (Invoke-WebRequest -uri "https://api.ipify.org/").Content
$geoinfo = Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$IPAddress"
$serial = Get-WmiObject win32_bios | Select-Object -ExpandProperty "Serialnumber"
$prefix = 'INT-'
$suffix = $serial.SubString(0,7)
$hostname = ($prefix) + ($geoinfo.region) + "-" + ($suffix)

# Rename device
try {
    Rename-Computer -NewName $hostname
}
catch {
    Write-Host $_
}
