[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

FUNCTION Read-InputBoxDialog([STRING]$MESSAGE, [STRING]$WINDOWTITLE, [STRING]$DEFAULTTEXT)
{
	Add-Type -AssemblyName Microsoft.VisualBasic
	RETURN [Microsoft.VisualBasic.Interaction]::InputBox($MESSAGE, $WINDOWTITLE, $DEFAULTTEXT)
}

$STARTTIME = Read-InputBoxDialog -MESSAGE "Enter Your Start Time" -WINDOWTITLE "Start Time" -DEFAULTTEXT "Example 07:55"
$ENDTIME = Get-Date -Format HH:mm
$TIMEDIFF = New-TimeSpan $STARTTIME $ENDTIME
IF ($TIMEDIFF.Minutes -lt 0)
{
	$HRS = ($TIMEDIFF.Hours) + 23
	$MINS = ($TIMEDIFF.Minutes) + 59
}
ELSE
{
	$HRS = $TIMEDIFF.Hours
	$MINS = $TIMEDIFF.Minutes
}

$MINSPERCNT = "{0:P0}" -f ($MINS/60)
$DIFFERENCE = '{0}.{1}' -f $HRS,$MINSPERCNT
$DIFFERENCE

[SYSTEM.WINDOWS.FORMS.MESSAGEBOX]::SHOW("$DIFFERENCE","Time Worked","OK")
