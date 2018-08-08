# Set Variables
$SCRIPTDIRECTORY = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$COMPUTER = $env:computername
$CURRENTUSER = GWMI Win32_ComputerSystem -CN $COMPUTER | Select -Property Username
$USER = $CURRENTUSER.username.split("\")[1]
$THEME = "MyTheme"

# Identify "Trusted Installer" Ownership Variables
$REPLACEINHERIT = "/inheritance:r" #Remove ALL inherited Access Control
$GRANT = "/GRANT *S-1-1-0" #Grant access rights
$USERACCOUNT = "System" #Identify System account
$PERMISSION = ":(OI)(CI)F" #(OI)-Object Inherit; (CI)-Container Inherit; F-Full Access

# Run TAKEOWN using Invoke Expression
Invoke-Expression -Command ('TAKEOWN /f "C:\Windows\System32\oobe\info\backgrounds\backgroundDefault.jpg" /a')

# Run ICACLS using Invoke Expression
Invoke-Expression -Command ('ICACLS "C:\Windows\System32\oobe\info\backgrounds\backgroundDefault.jpg" /GRANT *S-1-1-0:F /T "${$USERACCOUNT}${$PERMISSION}"')

# Create the Images Folder
New-Item -ItemType "Directory" -Path "C:\Tools\Images" -Force -ErrorAction SilentlyContinue

# Copy Images to the Images Folder
Copy-Item -Path "$SCRIPTDIRECTORY\TranscodedWallpaper.jpg" -Destination "C:\Tools\Images" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$SCRIPTDIRECTORY\backgroundDefault.jpg" -Destination "C:\Tools\Images" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$SCRIPTDIRECTORY\$THEME.theme" -Destination "C:\Tools\Images" -Force -ErrorAction SilentlyContinue

# Delete Cached Images
Invoke-Expression -Command ('TAKEOWN /f "C:\Users\$USER\AppData\Local\Microsoft\Windows\Themes\*.*" /a /r')
Invoke-Expression -Command ('TAKEOWN /f "C:\Users\$USER\AppData\Roaming\Microsoft\Windows\Themes\*.*" /a /r')
Remove-Item -Path "C:\Users\$USER\AppData\Local\Microsoft\Windows\Themes\*.*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\$USER\AppData\Roaming\Microsoft\Windows\Themes\*.*" -Recurse -Force -ErrorAction SilentlyContinue

# Copy Images to User Locations
New-Item -ItemType File -Path "C:\Windows\System32\oobe\info\backgrounds\backgroundDefault.jpg" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\System32\oobe\info\backgrounds\backgroundDefault.jpg" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "C:\Tools\Images\backgroundDefault.jpg" -Destination "C:\Windows\System32\oobe\info\backgrounds\backgroundDefault.jpg" -Force -ErrorAction SilentlyContinue

New-Item -ItemType File -Path "C:\Users\$USER\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\$USER\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "C:\Tools\Images\TranscodedWallpaper.jpg" -Destination "C:\Users\$USER\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg" -Force -ErrorAction SilentlyContinue

# Copy Theme to User Locations
Copy-Item -Path "C:\Tools\Images\$THEME.theme" -Destination "C:\Users\$USER\AppData\Local\Microsoft\Windows\Themes\$THEME.theme" -Force -ErrorAction SilentlyContinue

# Set Wallpaper Variables
$WALLPAPERHASH = Get-FileHash "C:\Tools\Images\backgroundDefault.jpg"

# Make Necessary Changes to the Registry
New-Item -Path HKCU:\Software\Policies\Microsoft\Windows\Personalization -Name "ThemeFile" -Value "C:\Users\$USER\AppData\Local\Microsoft\Windows\Themes\$THEME.theme" -Force -ErrorAction SilentlyContinue
New-Item -Path 'HKCU:\Control Panel' -Name Desktop -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value "C:\Windows\System32\oobe\info\backgrounds\backgroundDefault.jpg" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperOriginX -Value "0" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperOriginY -Value "0" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value "0" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value "2" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Checksum -Value $WALLPAPERHASH.Hash -Force -ErrorAction SilentlyContinue

# Modify Attributes for the SBA\Images Folder
$FOLDER = Get-Item "C:\Tools\Images" -Force
$FOLDER.attributes = "ReadOnly"

# Returns Ownership to "Trusted Installer"
Invoke-Expression -Command ('ICACLS "C:\Windows\System32\oobe\info\backgrounds\backgroundDefault.jpg" /setowner "NT SERVICE\TrustedInstaller"')
