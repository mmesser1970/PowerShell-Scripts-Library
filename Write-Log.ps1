Function Write-Log
{
	<#
		.Synopsis
		This is a function to create/edit a log file

		.Description
		The purpose of this function is to be able to createand edit a log file
		using focused message data created/identified by a script(owner).
		
		.Example
		Write-Log -LogFile <filepath> -Level INFO -Message "Message to be added to the log."
	#>

	[CmdletBinding()]
	Param
	(
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
	$Stamp = "$((Get-Date).GetDateTimeFormats()[73])"
	$Line = "$Stamp $Level $Message"

	If ($LogFile)
	{
		Add-Content $LogFile -Value $Line
	}
	Else
	{
		Write-Output $Line
	}
}
