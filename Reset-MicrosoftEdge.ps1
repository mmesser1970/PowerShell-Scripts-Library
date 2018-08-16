##*==================================================================================================================
##*  Run "Delete-MicrosoftEdge.ps1" before running this script
##*==================================================================================================================

Function Get-AllUsers ($ComputerName){
$DRIVE = (Get-Location).drive.root
$ALLUSERS = @(Get-ChildItem "$($DRIVE)Users")
$ALLUSERS.name
}

$USERACCOUNT = "System"
$PERMISSION = ":(OI)(CI)F"
$USERS = Get-AllUsers -ComputerName $env:computername

ForEach ($USER in $USERS)
{
	ForEach ($USER in $USERS)
	{
		Get-AppXPackage -AllUsers -Name Microsoft.MicrosoftEdge | ForEach `
		{
			Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)\AppXManifest.xml” -Verbose
		}
	}
}
