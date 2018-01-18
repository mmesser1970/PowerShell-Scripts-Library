#==============================================================================================================================
# Save this script in the "\\path-to-network-file\" location
#==============================================================================================================================

Import-Module ActiveDirectory

$SCRIPT_PARENT = Split-Path -Parent $MyInvocation.MyCommand.Definition

$Users = ForEach ($User in $(Get-Content "\\path-to-network-file\AllADUsers.txt"))

{
	Get-ADUser -Filter {displayName -eq $User} -Properties Department,Mail,telephoneNumber,Displayname
}

$Users | Select-Object SamAccountName, Displayname, telephoneNumber, Mail |`
Export-CSV -Path "\\path-to-network-file\AllADUsers.csv" -NoTypeInformation
