#========================================================================================
# INSTRUCTIONS
# -Create a batch file to execute this PowerShell file using the following script:
#	@ECHO OFF
#	PowerShell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "& '%~Dpn0.ps1'"
# -Save the batch file in the same location as this PowerShell file using the EXACT same name as this file.
#  i.e. C:\Scripts\PC_Refresh_Asset_Inventory.bat
# -Create a shortcut to the batch file in a central location (i.e. network drive).
# -Copy the shortcut to the server desktop or technician computer desktops.
#========================================================================================
# FileName: PC_Refresh_Asset_Inventory.ps1
# Created: 02/21/2017
# Updated: 09/17/2017
# Tech: Matthew Messer
# Email: mmesserlmt@gmail.com
#========================================================================================
# Purpose: Export Computer Asset Information to an Excel Workbook.
# Execution: Run the script on a newly imaged computer.
#========================================================================================

#=============================Code Start==================================================
# Chenge <network location> to the proper network folder location.
$LenovoPath = ("& '\\<network location>\PC_Refresh_Asset_Inventory_Lenovo.ps1'")
#=========================================================================================
# Chenge <network location> to the proper network folder location.
$HPPath = ("& '\\<network location>\PC_Refresh_Asset_Inventory_HP.ps1'")
#=========================================================================================
# Chenge <network location> to the proper network folder location.
$MiscPath = ("& '\\<network location>\PC_Refresh_Asset_Inventory_Misc.ps1'")
#=========================================================================================
Function StatusDeployed {$Status = "Deployed"}
#@========================================================================================
Function StatusInInventory {$Status = "In Inventory"}
#@========================================================================================
Function ModelLV {$Manufacturer = Invoke-Expression "$LenovoPath"}
#@========================================================================================
Function ModelHP {$Manufacturer = Invoke-Expression "$HPPath"}
#@========================================================================================
Function ModelMisc {$Manufacturer = Invoke-Expression "$MiscPath"}
#@========================================================================================

#=========================================================================================
# Gather info from user input.
#=========================================================================================
Write-Host "********************************"	-ForegroundColor Green
Write-Host "PC Refresh Asset Inventory"			-ForegroundColor Green
Write-Host "`t By: Matthew Messer"				-ForegroundColor Green
Write-Host "********************************"	-ForegroundColor Green
Write-Host " "

$Status = Read-Host "
Press [1] if the computer will be deployed immediately
Press [2] if the computer is imaged but not yet scheduled to be deployed"

If ($Status -eq "1"){. StatusDeployed}
	ElseIf($Status -eq "2"){. StatusInInventory}
	Else{Write-Host "You did not supply a correct response, Please run script again." -ForegroundColor Yellow}
	
If ((Get-WmiObject Win32_ComputerSystem).Manufacturer -Like "LENOVO*"){. ModelLV}
	ElseIf((Get-WmiObject Win32_ComputerSystem).Manufacturer -Like "H*"){. ModelHP}
	Else{. ModelMisc}
#@======================Code End==========================================================
