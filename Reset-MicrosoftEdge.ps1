Function Get-AllUsers ($ComputerName){
$DRIVE = (Get-Location).drive.root
$ALLUSERS = @(Get-ChildItem "$($DRIVE)Users")
$ALLUSERS.name
}

$EDGEPATH = "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe"
$EDGEPROPERTY = Get-ItemProperty -Path $EDGEPATH
$EDGEVERSION = $EDGEPROPERTY | Where {($_).VersionInfo.ProductVersion -eq "11.00.17134.1"} #*Change the file version to suit your needs
$USERACCOUNT = "System"
$PERMISSION = ":(OI)(CI)F"
$USERS = Get-AllUsers -ComputerName $env:computername

ForEach ($USER in $USERS)
{
    Invoke-Expression -Command ('TAKEOWN /f "C:\Users\$USER\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /a /r')
    Invoke-Expression -Command ('ICACLS "C:\Users\$USER\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /GRANT *S-1-1-0:F /T "${$USERACCOUNT}${$PERMISSION}"')
}

If (!(Test-Path $EDGEVERSION))
{
	ForEach ($USER in $USERS)
	{
		Remove-Item -Path "C:\Users\$USER\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -Force -Recurse -ErrorAction SilentlyContinue
		Start-Sleep -S 10
		Get-AppXPackage -AllUsers -Name Microsoft.MicrosoftEdge | `
		ForEach {Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)\AppXManifest.xml” -Verbose}
	}
}

ForEach ($USER in $USERS)
{
    Invoke-Expression -Command ('ICACLS "C:\Users\$USER\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /setowner "NT SERVICE\TrustedInstaller"')
    Invoke-Expression -Command ('ICACLS "C:\Users\$USER\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /remove Everyone /T /C')
}
