##*==================================================================================================================
##*  Run "Reset-MicrosoftEdge.ps1" after running this script
##*==================================================================================================================

Function Get-AllUsers ($ComputerName){
$DRIVE = (Get-Location).drive.root
$ALLUSERS = @(Get-ChildItem "$($DRIVE)Users")
$ALLUSERS.name
}

$EDGEPATH = "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe"
$EDGEPROPERTY = Get-ItemProperty -Path $EDGEPATH
$EDGEVERSION = $EDGEPROPERTY | Where {($_).VersionInfo.ProductVersion -eq "11.00.17134.1"}
$USERACCOUNT = "System"
$PERMISSION = ":(OI)(CI)F"
$USERS = Get-AllUsers -ComputerName $env:computername

If (!(Test-Path $EDGEVERSION))
{
	ForEach ($USER in $USERS)
	{
		ForEach ($USER in $USERS)
		{
			Invoke-Expression -Command ('TAKEOWN /f "C:\Users\$USER\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /a /r')
			Invoke-Expression -Command ('ICACLS "C:\Users\$USER\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /GRANT *S-1-1-0:F /T "${$USERACCOUNT}${$PERMISSION}"')
		
			Remove-Item -Path "C:\Users\$USER\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -Force -Recurse -ErrorAction SilentlyContinue
		}
	}
}
