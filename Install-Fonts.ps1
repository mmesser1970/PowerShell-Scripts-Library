# Identify the parent directory of this PS Script. NOTE: The script must be in the same folder location as the source of the fonts
$SCRIPTDIRECTORY = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Identify environmental variables
$SHELL = New-Object -ComObject Shell.Application
$SYSTEMFONTSFOLDER = $SHELL.Namespace(0x14)
$SYSTEMFONTSPATH = $SYSTEMFONTSFOLDER.Self.Path
$FONTREGISTRYPATH = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'

# Identify a folder to maintain an original copy of the fonts
$FONTWINFOLDER = "C:\Tools\Fonts"

# Create the folder to maintain an original copy of the fonts
New-Item -ItemType "Directory" -Path $FONTWINFOLDER -Force -ErrorAction SilentlyContinue

# Copies the fonts from the source folder to the destination folder
Copy-Item "$SCRIPTDIRECTORY\*.ttf" -Destination $FONTWINFOLDER -Force -ErrorAction SilentlyContinue

# Identify all fonts located in the destination folder
$FONTS = @(Get-ChildItem $FONTWINFOLDER)

# Copies the fonts to C:\Windows\Fonts and modifies the registry
FOREACH($FONT IN $FONTS)
{
	$TARGETPATH = Join-Path $SYSTEMFONTSPATH $FONT.Name

	IF(!(Test-Path $TARGETPATH))
	{
		Copy-Item $FONT.FullName -Destination $TARGETPATH -Force -ErrorAction SilentlyContinue
		Copy-Item $FONTWINFOLDER\*.ttf -Destination $SYSTEMFONTSPATH -Force -ErrorAction SilentlyContinue
		New-ItemProperty -Name $FONT.Name -Path $FONTREGISTRYPATH -Force -ErrorAction SilentlyContinue
		Set-ItemProperty -Path $FONTREGISTRYPATH -Name $FONT.Name -Value "$FONT" -Force -ErrorAction SilentlyContinue
		$SYSTEMFONTSFOLDER.CopyHere($FONT.Name,16)
	}
}
