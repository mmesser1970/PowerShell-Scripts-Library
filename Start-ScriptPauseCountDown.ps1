<#
	.SYNOPSIS
	Display a graphical countdown in PowerShell when pausing a script
	
	.PARAMETER Seconds
	Time, in seconds, to count down
	
	.PARAMETER Message
	Message displayed while waiting
	
	.EXAMPLE
	Start-CountDown -Seconds 30 -Message "Please wait while..."
#>

Function Start-CountDown {
	Param(
		[Int32]$Seconds = 10,
		[string]$Message = "Pausing for 10 seconds..."
	)
	ForEach ($Count in (1..$Seconds))
	{
		Write-Progress -Id 1 -Activity $Message -Status "Waiting for $Seconds seconds, $($Seconds - $Count) left" -PercentComplete (($Count / $Seconds) * 100)
		Start-Sleep -Seconds 1
	}
	Write-Progress -Id 1 -Activity $Message -Status "Completed" -PercentComplete 100 -Completed
}

Start-CountDown -Seconds 10 -Message "This is a test"
