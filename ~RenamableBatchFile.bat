:: Save this Batch file as the same name and location of the PowerShell script you want to run!

@ECHO OFF
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy BYPASS -NoLogo -Noninteractive -NoProfile -WindowStyle HIDDEN -Command "& '%~dpn0.ps1'"
