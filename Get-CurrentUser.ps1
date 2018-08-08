Function Get-CurrentUser ($ComputerName){
$PCUSER = @(GWMI Win32_ComputerSystem -ComputerName $ComputerName | Select -Property username)
$PCUSER.username.split("\")[1]
}

$COMPUTER = $env:computername

Get-CurrentUser -ComputerName $COMPUTER
