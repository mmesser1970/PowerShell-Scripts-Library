#=========================================================================================
# INSTRUCTIONS
# -This script is invoked by executing the PC_Refresh_Asset_Inventory.ps1 script.
# -This was originally created to identify Lenovo computers but can be configured for any
#  model that is being replaced by another model. Simply change "Lenovo" to the correct
#  model.
#=========================================================================================
# FileName: PC_Refresh_Asset_Inventory_Lenovo.ps1
# Created: 02/21/2017
# Updated: 09/17/2017
# Tech: Matthew Messer
# Email: mmesserlmt@gmail.com
#=========================================================================================
# Purpose: Export computer asset information to the "Lenovo" sheet in the "PC_Refresh_Asset_Inventory" Excel Workbook
# Execution: Runs when called to from the PS Script "PC_Refresh_Asset_Inventory.ps1"
#=========================================================================================

#@======================Code Start========================================================
# Change <excel-file-location> to the proper folder location.
$Path = ("C:\<excel-file-location>\PC_Refresh_Asset_Inventory.xlsx")
$ComputerName = $env:computername
$User = Read-Host -Prompt "Enter Full Name of the USER or the DEPARTMENT that will own this computer"
$AssetTag = Read-Host -Prompt "Enter the Asset Tag# for this computer"
$ImageDate = (Get-Date)
#=========================================================================================
# Color Index //msdn.microsoft.com/en-us/library/cc296089(v=office.12).aspx
#=========================================================================================
$ColorIndexBlack = 1
$ColorIndexWhite = 2
#=========================================================================================
# Opens an existing Excel Workbook.
#=========================================================================================
Add-Type -AssemblyName Microsoft.Office.Interop.Excel
$xlFixedFormat = [Microsoft.Office.Interop.Excel.XlFileFormat]::xlWorkbookDefault
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $True
$WorkBook = $Excel.Workbooks.Open($Path)
$Sheet = $Excel.WorkSheets.Item(1)
$Sheet.Range("A3:I3").Insert(-4121)
#=========================================================================================
# Retrieve the Computer Asset Information.
#=========================================================================================
$UserDom = $env:userdomain
$TechName = $env:username
$Manufacturer = (Get-WmiObject Win32_ComputerSystem).Manufacturer
$Model = (Get-WmiObject Win32_ComputerSystemProduct).Version
$SerialNumber = (Get-WmiObject Win32_Bios).SerialNumber
$IntRow = 3
#=========================================================================================
# Format the cells and insert the retrieved corresponding data.
#=========================================================================================
ForEach ($Computer in $ComputerName)
{
	$Sheet.Cells.Item($IntRow, 1) = $User
	$Sheet.Cells.Item($IntRow, 1).Font.ColorIndex = $ColorIndexBlack
	$Sheet.Cells.Item($IntRow, 1).Font.Size = 12
	$Sheet.Cells.Item($IntRow, 1).Font.Name = "Calibri"
	$Sheet.Cells.Item($IntRow, 1).Interior.ColorIndex = $ColorIndexWhite
	$Sheet.Cells.Item($IntRow, 1).VerticalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 1).HorizontalAlignment = -4131
	$Sheet.Cells.Item($IntRow, 1).Borders.Weight = -4138
	$Sheet.Cells.Item($IntRow, 1).Borders.LineStyle = 1
	$Sheet.Cells.Item($IntRow, 1).EntireColumn.AutoFit() | Out-Null
	
	$Sheet.Cells.Item($IntRow, 2) = $ComputerName
	$Sheet.Cells.Item($IntRow, 2).Font.ColorIndex = $ColorIndexBlack
	$Sheet.Cells.Item($IntRow, 2).Font.Size = 12
	$Sheet.Cells.Item($IntRow, 2).Font.Name = "Calibri"
	$Sheet.Cells.Item($IntRow, 2).Interior.ColorIndex = $ColorIndexWhite
	$Sheet.Cells.Item($IntRow, 2).VerticalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 2).HorizontalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 2).Borders.Weight = -4138
	$Sheet.Cells.Item($IntRow, 2).Borders.LineStyle = 1
	$Sheet.Cells.Item($IntRow, 2).EntireColumn.AutoFit() | Out-Null
	
	$Sheet.Cells.Item($IntRow, 3) = $Manufacturer
	$Sheet.Cells.Item($IntRow, 3).Font.ColorIndex = $ColorIndexBlack
	$Sheet.Cells.Item($IntRow, 3).Font.Size = 12
	$Sheet.Cells.Item($IntRow, 3).Font.Name = "Calibri"
	$Sheet.Cells.Item($IntRow, 3).Interior.ColorIndex = $ColorIndexWhite
	$Sheet.Cells.Item($IntRow, 3).VerticalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 3).HorizontalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 3).Borders.Weight = -4138
	$Sheet.Cells.Item($IntRow, 3).Borders.LineStyle = 1
	$Sheet.Cells.Item($IntRow, 3).EntireColumn.AutoFit() | Out-Null
	
	$Sheet.Cells.Item($IntRow, 4) = $Model
	$Sheet.Cells.Item($IntRow, 4).Font.ColorIndex = $ColorIndexBlack
	$Sheet.Cells.Item($IntRow, 4).Font.Size = 12
	$Sheet.Cells.Item($IntRow, 4).Font.Name = "Calibri"
	$Sheet.Cells.Item($IntRow, 4).Interior.ColorIndex = $ColorIndexWhite
	$Sheet.Cells.Item($IntRow, 4).VerticalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 4).HorizontalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 4).Borders.Weight = -4138
	$Sheet.Cells.Item($IntRow, 4).Borders.LineStyle = 1
	$Sheet.Cells.Item($IntRow, 4).EntireColumn.AutoFit() | Out-Null
	
	$Sheet.Cells.Item($IntRow, 5) = $SerialNumber
	$Sheet.Cells.Item($IntRow, 5).Font.ColorIndex = $ColorIndexBlack
	$Sheet.Cells.Item($IntRow, 5).Font.Size = 12
	$Sheet.Cells.Item($IntRow, 5).Font.Name = "Calibri"
	$Sheet.Cells.Item($IntRow, 5).Interior.ColorIndex = $ColorIndexWhite
	$Sheet.Cells.Item($IntRow, 5).VerticalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 5).HorizontalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 5).Borders.Weight = -4138
	$Sheet.Cells.Item($IntRow, 5).Borders.LineStyle = 1
	$Sheet.Cells.Item($IntRow, 5).EntireColumn.AutoFit() | Out-Null
	
	$Sheet.Cells.Item($IntRow, 6) = $AssetTag
	$Sheet.Cells.Item($IntRow, 6).Font.ColorIndex = $ColorIndexBlack
	$Sheet.Cells.Item($IntRow, 6).Font.Size = 12
	$Sheet.Cells.Item($IntRow, 6).Font.Name = "Calibri"
	$Sheet.Cells.Item($IntRow, 6).Interior.ColorIndex = $ColorIndexWhite
	$Sheet.Cells.Item($IntRow, 6).VerticalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 6).HorizontalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 6).Borders.Weight = -4138
	$Sheet.Cells.Item($IntRow, 6).Borders.LineStyle = 1
	$Sheet.Cells.Item($IntRow, 6).EntireColumn.AutoFit() | Out-Null
	
	$Sheet.Cells.Item($IntRow, 7) = (([ADSI]"WinNT://$UserDom/$TechName,User").FullName.ToString())
	$Sheet.Cells.Item($IntRow, 7).Font.ColorIndex = $ColorIndexBlack
	$Sheet.Cells.Item($IntRow, 7).Font.Size = 12
	$Sheet.Cells.Item($IntRow, 7).Font.Name = "Calibri"
	$Sheet.Cells.Item($IntRow, 7).Interior.ColorIndex = $ColorIndexWhite
	$Sheet.Cells.Item($IntRow, 7).VerticalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 7).HorizontalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 7).Borders.Weight = -4138
	$Sheet.Cells.Item($IntRow, 7).Borders.LineStyle = 1
	$Sheet.Cells.Item($IntRow, 7).EntireColumn.AutoFit() | Out-Null
		
	$Sheet.Cells.Item($IntRow, 8) = $ImageDate
	$Sheet.Cells.Item($IntRow, 8).Font.ColorIndex = $ColorIndexBlack
	$Sheet.Cells.Item($IntRow, 8).Font.Size = 12
	$Sheet.Cells.Item($IntRow, 8).Font.Name = "Calibri"
	$Sheet.Cells.Item($IntRow, 8).Interior.ColorIndex = $ColorIndexWhite
	$Sheet.Cells.Item($IntRow, 8).VerticalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 8).HorizontalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 8).Borders.Weight = -4138
	$Sheet.Cells.Item($IntRow, 8).Borders.LineStyle = 1
	$Sheet.Cells.Item($IntRow, 8).EntireColumn.AutoFit() | Out-Null
	
	$Sheet.Cells.Item($IntRow, 9) = $Status
	$Sheet.Cells.Item($IntRow, 9).Font.ColorIndex = $ColorIndexBlack
	$Sheet.Cells.Item($IntRow, 9).Font.Size = 12
	$Sheet.Cells.Item($IntRow, 9).Font.Name = "Calibri"
	$Sheet.Cells.Item($IntRow, 9).Interior.ColorIndex = $ColorIndexWhite
	$Sheet.Cells.Item($IntRow, 9).VerticalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 9).HorizontalAlignment = -4108
	$Sheet.Cells.Item($IntRow, 9).Borders.Weight = -4138
	$Sheet.Cells.Item($IntRow, 9).Borders.LineStyle = 1
	$Sheet.Cells.Item($IntRow, 9).EntireColumn.AutoFit() | Out-Null
}
#=========================================================================================
# Save the spreadsheet, close the Workbook and end all Excel processes.
#=========================================================================================
$Excel.DisplayAlerts = $False
$Excel.ActiveWorkbook.SaveAs($Path)
$Excel.Workbooks.Close()
$Excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel)
Stop-Process -Name EXCEL -Force
#@======================Code End==========================================================