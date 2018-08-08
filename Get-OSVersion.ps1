$COMPUTER = $env:computername # Or Remote ComputerName
$OS = Get-WmiObject -Computer $COMPUTER -Class Win32_OperatingSystem
	
IF($OS.caption -like '*Windows 7*')
{

}

IF($OS.caption -like '*Windows 10*')
{

}
