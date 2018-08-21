$COMPUTER = $env:computername
$CURRENTUSER = GWMI Win32_ComputerSystem -CN $COMPUTER | Select -Property Username
$USER = $CURRENTUSER.username.split("\")[1]

$FOLDERPATH = "C:\Users\$USER\AppData\<FolderPath>"

If (Test-Path "$FOLDERPATH\filename.ext")
{
    Return 1
}
Else
{
    Return 0
}
