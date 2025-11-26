# Reboot device
Start-Transcript -Path "C:\Temp\Intune-RenameDevice-Reboot.txt" -Verbose
Disable-ScheduledTask -TaskName Intune-RenameDevice-Reboot -ErrorAction SilentlyContinue -Verbose
Restart-Computer -Force -Verbose