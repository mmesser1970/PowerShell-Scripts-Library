Function Get-AllUsers ($ComputerName){
$DRIVE = (Get-Location).drive.root
$ALLUSERS = @(Get-ChildItem "$($DRIVE)Users")
$ALLUSERS.name
}

$COMPUTER = $env:computername

Get-AllUsers -ComputerName $COMPUTER
