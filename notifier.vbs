set WshShell = WScript.CreateObject("WScript.Shell")
DesktopPath = WshShell.SpecialFolders("Desktop")
Path = DesktopPath + "\notifier.ps1"
command = "powershell.exe -executionpolicy bypass -noninteractive -file " + Path
set shell = CreateObject("WScript.Shell")
shell.Run command,0
