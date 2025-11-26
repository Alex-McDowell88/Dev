<#
    .SYNOPSIS
        This script is utilised during Autopilot Device Preparation to customize the device name.

    .DESCRIPTION
        This script completes the following tasks
        
        1. Queries the devices public IP to obtain the state the device is being enrolled in.

        2. Queries the devices serial number and truncates it to 6 characters.

        3. The device is named using the following convention:

            INT-<STATE>-<SERIAL>
        
    .NOTES
        TBC.
        
#>

$ipaddress = (Invoke-WebRequest -uri "https://api.ipify.org/").Content
$geoinfo = Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$IPAddress"
$serial = Get-WmiObject win32_bios | Select-Object -ExpandProperty "Serialnumber"
$suffix = $serial.SubString(0,6)
$prefix = 'INT-'
$hostname = ($prefix) + ($geoinfo.region) + "-" + ($suffix)


try {
    Rename-Computer -NewName $hostname
}
catch {
    Write-Host $_
}