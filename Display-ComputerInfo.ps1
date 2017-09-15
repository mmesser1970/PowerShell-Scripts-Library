<#
.Synopsis
	Display local coputer information

.DESCRIPTION
	Extracts local computer information and outputs the information into an easy-to-read window.

.INSTRUCTIONS
	-Create a batch file to run the PowerShell file using the following script:
		@ECHO OFF
		PowerShell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "& '%~Dpn0.ps1'"
	-Save the batch file in the same location as this PowerShell file using the EXACT same name as this file.
	-Create a shortcut to the batch file in a central location (i.e. network drive).
	-Copy the shortcut to end-user desktops.
#>

#@========================================================================================
#@ Script Name: Display-ComputerInfo
#@ Created: 02/21/2017
#@ Updated: 09/12/2017
#@ Originator: Matthew Messer
#@ Email: mmesserlmt@gmail.com
#@========================================================================================

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

$UserDom            = $env:userdomain
$UserName           = $env:username
$User               = (([ADSI]"WinNT://$UserDom/$UserName").FullName.ToString())
$ComputerName		= $env:computername
$OSRegister         = (Get-WmiObject Win32_OperatingSystem).RegisteredUser
$IPAddress			= ((IPConfig | FindStr [0-9].\.)[0]).Split()[-1]
$Manufacturer		= (Get-WmiObject Win32_ComputerSystem).Manufacturer
$Model				= (Get-WmiObject Win32_ComputerSystemProduct).Model
$Version			= (Get-WmiObject Win32_ComputerSystemProduct).Version
$SerialNumber		= (Get-WmiObject Win32_Bios).SerialNumber

If ($Model){$ComputerModel = $Model}
Else {$Computermodel = $Version}

[System.Windows.Forms.MessageBox]::Show((" User: `t`t $($User)`r`n","Computer Name:`t $($ComputerName)`r`n","Registered To:`t $($OSRegister)`r`n",`
"IP Address:`t $($IPAddress)`r`n",`
"Manufacturer: `t $($Manufacturer)`r`n","Model: `t`t $($ComputerModel)`r`n",`
"Serial Number: `t $($SerialNumber)`r`n") , "Computer Information" ,`
[System.Windows.Forms.MessageBoxButtons]::OK,`
[System.Windows.Forms.MessageBoxIcon]::Information)
