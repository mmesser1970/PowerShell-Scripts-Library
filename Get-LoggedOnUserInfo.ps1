Function Get-LoggedOnUserInfo ($COMPUTERNAME){
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
	$LOGON_SESSIONS = @(gwmi win32_logonsession -ComputerName $COMPUTERNAME)
	$LOGON_USERS = @(gwmi win32_loggedonuser -ComputerName $COMPUTERNAME)
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
$User = Get-LoggedOnUserInfo -ComputerName $COMPUTERNAME

# Just the UserName
# $USERNAME = $User.user.split("\")[1]
# $USERNAME

# Just the Domain
# $USERNAME = $User.user.split("\")[0]
# $USERNAME
