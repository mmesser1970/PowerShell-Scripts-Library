##*=============================================================================================================================================
##* DEFINITIONS
##*=============================================================================================================================================

# Interface Definition
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$CONSOLEPTR = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($CONSOLEPTR, 0)

##*=============================================================================================================================================
##* MAIN FORM
##*=============================================================================================================================================

# Main Form Definition
$MAINFORM = New-Object System.Windows.Forms.Form
$MAINFORM.ClientSize = New-Object System.Drawing.Size(325, 200)
$MAINFORM.MaximumSize = New-Object System.Drawing.Size(325, 200)
$MAINFORM.MinimumSize = New-Object System.Drawing.Size(325, 200)
$MAINFORM.MaximizeBox = $false
$MAINFORM.MinimizeBox = $false
$MAINFORM.StartPosition = "CenterScreen"
$MAINFORM.Text = "ATTENTION!"
$MAINFORM.BackColor = "#FFFFFFFF"

# Font Definition
$FONT = NEW-OBJECT SYSTEM.DRAWING.FONT("CALIBRI",14,[SYSTEM.DRAWING.FONTSTYLE]::REGULAR)
$FONT2 = NEW-OBJECT SYSTEM.DRAWING.FONT("CALIBRI",20,[SYSTEM.DRAWING.FONTSTYLE]::BOLD)
$FONT3 = NEW-OBJECT SYSTEM.DRAWING.FONT("SEGOE",38,[SYSTEM.DRAWING.FONTSTYLE]::BOLD)
$MAINFORM.FONT = $FONT

# Image Definition - (Add an Icon image to display in the top corner of the message box)
# $IMAGE = [SYSTEM.DRAWING.IMAGE]::FROMFILE("C:\FilePath\File.ico")
# $MAINFORM.BACKGROUNDIMAGE = $IMAGE
# $MAINFORM.BACKGROUNDIMAGELAYOUT = "NONE"

##*=============================================================================================================================================
##* DISPLAY COUNTDOWN
##*=============================================================================================================================================

# WarningLabel Label
$WarningLabel = New-Object System.Windows.Forms.Label
$WarningLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$WarningLabel.Location = New-Object System.Drawing.Point(65, 21)
$WarningLabel.Size = New-Object System.Drawing.Size(275, 30)
$WarningLabel.ForeColor = "#000000"
$WarningLabel.Text = "You are about to be logged off!"

# WarningLabel Label
$WarningLabel2 = New-Object System.Windows.Forms.Label
$WarningLabel2.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$WarningLabel2.Location = New-Object System.Drawing.Point(50, 60)
$WarningLabel2.Size = New-Object System.Drawing.Size(275, 30)
$WarningLabel2.Font = $FONT2
$WarningLabel2.ForeColor = "#000000"
$WarningLabel2.Text = "Save all your work!"

# Countdown
$Countdown_Label = New-Object System.Windows.Forms.Label
$Countdown_Label.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$Countdown_Label.Location = New-Object System.Drawing.Point(120, 95)
$Countdown_Label.Size = New-Object System.Drawing.Size(250, 100)
$Countdown_Label.Font = $FONT3
$Countdown_Label.ForeColor = "#FF0000"

# Countdown starts at 90 seconds
$Countdown_Label.Text = "90"

# Countdown is decremented every second using a timer
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.add_Tick({CountDown})
$timer.Start()

# Assign Button and Countdown to Page
$MAINFORM.Controls.Add($WarningLabel)
$MAINFORM.Controls.Add($WarningLabel2)
$MAINFORM.Controls.Add($Countdown_Label)

##*=============================================================================================================================================
##* FUNCTIONS
##*=============================================================================================================================================
Function Get-LoggedOnUser ($ComputerName){
	$REGEXA = '.+Domain="(.+)",Name="(.+)"$' 
	$REGEXD = '.+LogonId="(\d+)"$'
	$LOGONTYPE = @{
		"0"="Local System"			#(Local System)
		"2"="Interactive"			#(Local Logon)
		"3"="Network"				#(Remote Logon)
		"4"="Batch"					#(Scheduled Task)
		"5"="Service"				#(Service Account Logon)
		"7"="Unlock"				#(Screen Saver)
		"8"="NetworkCleartext"		#(Cleartext Network Logon)
		"9"="NewCredentials"		#(RunAs Using Alternate Credentials)
		"10"="RemoteInteractive"	#(RDP\TS\RemoteAssistance)
		"11"="CachedInteractive"	#(Local W\Cached Credentials)
	}
	$LOGON_SESSIONS = @(gwmi win32_logonsession -ComputerName $ComputerName)
	$LOGON_USERS = @(gwmi win32_loggedonuser -ComputerName $ComputerName)
	$SESSION_USER = @{}
	$LOGON_USERS | %{
		$_.antecedent -match $REGEXA > $nul
		$USERNAME = $matches[1] + "\" + $matches[2]
		$_.dependent -match $REGEXD > $nul
		$session = $matches[1]
		$SESSION_USER[$session] += $USERNAME
	}	 
	$LOGON_SESSIONS |%{
		$STARTTIME = [management.managementdatetimeconverter]::todatetime($_.starttime)
		$LOGGEDONUSER = New-Object -TypeName psobject
		$LOGGEDONUSER | Add-Member -MemberType NoteProperty -Name "Session" -Value $_.logonid
		$LOGGEDONUSER | Add-Member -MemberType NoteProperty -Name "User" -Value $SESSION_USER[$_.logonid]
		$LOGGEDONUSER | Add-Member -MemberType NoteProperty -Name "Type" -Value $LOGONTYPE[$_.logontype.tostring()]
		$LOGGEDONUSER | Add-Member -MemberType NoteProperty -Name "Auth" -Value $_.authenticationpackage
		$LOGGEDONUSER | Add-Member -MemberType NoteProperty -Name "StartTime" -Value $STARTTIME
		$LOGGEDONUSER
	}
}

Function Logoff-User {
	$COMPUTERNAME = $env:computername
	$USERID = Get-LoggedOnUser -ComputerName $COMPUTERNAME
	$USER = $USERID.user.split("\")[1]
	$SESSIONID = ((quser /server:$COMPUTERNAME | Where-Object { $_ -match $USER }) -split ' +')[2]
	LOGOFF $SESSIONID /server:$COMPUTERNAME
}

Function Start-LogOffCountDown {
	[System.Windows.Forms.Application]::EnableVisualStyles()
	[System.Windows.Forms.Application]::Run($MAINFORM)
}

Function CountDown {
    $Countdown_Label.Text -= 1
	If ($Countdown_Label.Text -eq 0) {
        $timer.Stop()
        Action_After_End
	}
}

Function Action_After_End {
	Add-Type -AssemblyName System.Windows.Forms
	$RESULT = [System.Windows.Forms.MessageBox]::Show('Press OK to log off', 'Warning', 'OK', 'Warning')

	If ($RESULT -eq 'OK')
	{
	  Logoff-User
	}
    $MAINFORM.close()
}

##*=============================================================================================================================================
##* CALL START-COUNTDOWN FUNCTION
##*=============================================================================================================================================

Start-LogOffCountDown
