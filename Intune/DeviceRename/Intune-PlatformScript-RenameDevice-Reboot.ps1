# Create the temp directory
$tempdir = "c:\Temp"
New-Item $tempdir -ItemType Directory -Force
Set-Location -Path $tempdir

# Pull files & register the scheduled task
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Alex-McDowell88/Dev/refs/heads/main/Intune/DeviceRename/Intune-RenameDevice-Reboot.ps1" -OutFile .\Intune-RenameDevice-Reboot.ps1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Alex-McDowell88/Dev/refs/heads/main/Intune/DeviceRename/Intune-RenameDevice-Reboot.xml" -OutFile .\Intune-RenameDevice-Reboot.xml
Register-ScheduledTask -xml (Get-Content '.\Intune-RenameDevice-Reboot.xml' | Out-String) -TaskName "Intune-RenameDevice-Reboot" -Force
