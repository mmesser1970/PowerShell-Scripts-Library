Import-Module ActiveDirectory

$SCRIPT_PARENT = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Users = ForEach ($User in $(Get-Content "C:\PathToFile\AllADUsers.txt"))

{
	Get-ADUser -Filter {displayName -eq $User} -Properties Department,Mail,telephoneNumber,Displayname
}

$Users | Select-Object SamAccountName, Displayname, telephoneNumber, Mail |`

Export-CSV -Path "C:\PathToFile\\AllADUsers.csv" -NoTypeInformation
