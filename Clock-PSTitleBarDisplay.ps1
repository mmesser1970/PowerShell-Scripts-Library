$CODE = 
{
	param($RAWUI)
	DO
	{
		$TIME = Get-Date -Format 'HH:mm:ss dddd MMMM d'
		$TITLE = "Current Time: $TIME" 
		$RAWUI.WindowTitle = $TITLE
		Start-Sleep -Milliseconds 500
	} WHILE ($true)
}
$PS = [PowerShell]::Create()
$NULL = $PS.AddScript($CODE).AddArgument($HOST.UI.RawUI)
$HANDLE = $PS.BeginInvoke()
