#===========================================================================================================================================================
# Initiate The Write-Log Function Code
#===========================================================================================================================================================
Function Write-Log {
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$False)]
    [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
    [String]
    $Level = "INFO",

    [Parameter(Mandatory=$True)]
    [string]
    $Message,

    [Parameter(Mandatory=$False)]
    [string]
    $LogFile
    )

    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $Line = "$Stamp $Level $Message"
    If($LogFile) {
        Add-Content $LogFile -Value $Line
    }
    Else {
        Write-Output $Line
    }
}

#===========================================================================================================================================================
# Configure The Working Script Directory
#===========================================================================================================================================================
If ($PSScriptRoot -NotIn '',' ',$Null)
{
	$PathToDirectory = $PSScriptRoot
}
Else
{
	$PathToDirectory = $(Get-Location | Select -ExpandProperty Path)
}

#===========================================================================================================================================================
# Define CSV And LOG File Paths
#===========================================================================================================================================================
$LogPath = "$($PathToDirectory)\Logs"
$Log = "$($LogPath)\LogFileName.log"

#===========================================================================================================================================================
# Create a Log file if one doesn't exist
#===========================================================================================================================================================
If (!(Test-Path $Log))
{
	New-Item -ItemType File -Path $Log -Force
}

#===========================================================================================================================================================
# Initiate The Display-MessageBox Function Code
#===========================================================================================================================================================
Function Display-MessageBox
{
	<#
		.Synopsis
		Display a Message Box GUI

		.Description
		This command uses the Wscript.Shell method to display a graphical message box.
		You can customize the Message, Title, Time (how long to display the message), Button, and Icon.
		By default the user must click a button to dismiss the Message Box.
		A timeout value in seconds can be set, however, to automatically dismiss the Message Box.
		
		.Example
		Display-MessageBox -Message "Message body." -Title "Window title" -Time 10 -Button YesNoCancel -Icon Exclamation
	#>
	[CmdletBinding()]
	Param
	(	# Set parameter requirements
		[Parameter(Position = 0, Mandatory = $True, HelpMessage = "Message body.")]
			[ValidateNotNullorEmpty()]
			[string]$Message,
		[Parameter(Position = 1, Mandatory = $True, HelpMessage = "Window title.")]
			[ValidateNotNullorEmpty()]
			[string]$Title,
		[Parameter(Position = 2, HelpMessage = "Length of time to keep the window open. Use 0 to enforce clicking a button.")]
			[ValidateScript({$_ -ge 0})]
			[int]$Time = 0,
		[Parameter(Position = 3, HelpMessage = "Choose the button group to display")]
			[ValidateNotNullorEmpty()]
			[ValidateSet("OK","OKCancel","AbortRetryIgnore","YesNo","YesNoCancel","RetryCancel")]
			[string]$Button = "OKCancel",
		[Parameter(Position = 4, HelpMessage = "Choose an Icon to display")]
			[ValidateNotNullorEmpty()]
			[ValidateSet("Stop","Question","Exclamation","Information")]
			[string]$Icon = "Information"
	)
	Switch ($Button)
	{	# Convert Button to their equivalent integer values
		"OK"               {$ButtonValue = 0}
		"OKCancel"         {$ButtonValue = 1}
		"AbortRetryIgnore" {$ButtonValue = 2}
		"YesNoCancel"      {$ButtonValue = 3}
		"YesNo"            {$ButtonValue = 4}
		"RetryCancel"      {$ButtonValue = 5}
	}
	Switch ($Icon)
	{	# Convert icons to their equivalent integer values
		"Stop"        {$IconValue = 16}
		"Question"    {$IconValue = 32}
		"Exclamation" {$IconValue = 48}
		"Information" {$IconValue = 64}
	}
	Try
	{	# Create the COM Object
		$WShell = New-Object -ComObject WScript.Shell -ErrorAction Stop
		$WShell.Popup($Message,$Time,$Title,$ButtonValue+$IconValue) # The button and icon values are combined to create a singular integer value
	}
	Catch
	{	# This exception failure is rare
		Write-Warning "Failed to create WScript.Shell COM object"
		Write-Warning $_.exception.message
	}
} # End Function Code

$MessageBox = Display-MessageBox -Message " Warning!!! `n`r`r Continuing this operation will <DO SOMETHING>! `n`r`r Do you wish to continue?" -Title "Administrative Warning" -Time 0 -Button YesNoCancel -Icon Exclamation

If ($MessageBox -eq '7')
{	# Clicking 'No' will stop the operation
	Write-Log -LogFile $Log -Level INFO -Message "The operation was CANCELLED."
}
ElseIf ($MessageBox -eq '2')
{	# Clicking 'X' or 'Cancel' will stop the operation
	Write-Log -LogFile $Log -Level INFO -Message "The operation was CANCELLED."
}
Else
{
	Write-Log -LogFile $Log -Level WARN -Message "The operation was selected to CONTINUE!"
}
