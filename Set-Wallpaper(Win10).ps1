# Set Variables
$SCRIPTDIRECTORY = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$PATHWEB = "C:\Windows\WEB\Wallpaper\Windows"
$PATH4K = "C:\Windows\Web\4K\Wallpaper\Windows"
$REPLACEINHERIT = "/inheritance:r" #Remove ALL inherited Access Control
$GRANT = "/GRANT *S-1-1-0" #Grant access rights. This Syntax grants FULL control to Everyone
$USERACCOUNT = "System"
$PERMISSION = ":(OI)(CI)F" #(OI) Object Inherit; (CI) Container Inherit; (F) Full Access

# Run TAKEOWN using Invoke Expression
Invoke-Expression -Command ('TAKEOWN /f $PATHWEB /a /r')
Invoke-Expression -Command ('TAKEOWN /f $PATH4K /a /r')

# Run ICACLS using Invoke Expression
Invoke-Expression -Command ('ICACLS $PATHWEB /GRANT *S-1-1-0:F /T "${$USERACCOUNT}${$PERMISSION}"')
Invoke-Expression -Command ('ICACLS $PATH4K /GRANT *S-1-1-0:F /T "${$USERACCOUNT}${$PERMISSION}"')

# Rename Default Web Wallpaper
Remove-Item -Path "$env:windir\Web\Wallpaper\Windows\img1.jpg" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "%AppData%\roaming\Microsoft\Windows\Themes\cachedfiles\*.*" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "%AppData%\roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg" -Force -ErrorAction SilentlyContinue

# Copy New Web Wallpaper
Copy-Item "$SCRIPTDIRECTORY\img0.jpg" "$env:windir\Web\Wallpaper\Windows" -Force

# Define image file list
$IMAGES = @(
    'img0_1024x768.jpg'
    'img0_1200x1920.jpg'
    'img0_1366x768.jpg'
    'img0_1600x2560.jpg'
    'img0_2160x3840.jpg'
    'img0_2560x1600.jpg'
    'img0_3840x2160.jpg'
    'img0_768x1024.jpg'
    'img0_768x1366.jpg'
)

# Copy each 4K Image
ForEach ($IMAGE in $IMAGES)
{
    Copy-Item "$SCRIPTDIRECTORY\$IMAGE" $env:windir\Web\4K\Wallpaper\Windows -Force
}

# Make Necessary Changes To The Registry
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value "$env:windir\Web\Wallpaper\Windows\img0.jpg" -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperOriginX -Value "0" -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperOriginY -Value "0" -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value "0" -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value "2" -Force | Out-Null


# Run ICACLS using Invoke Expression
Invoke-Expression -Command ('ICACLS $PATHWEB /setowner "NT SERVICE\TrustedInstaller"')
Invoke-Expression -Command ('ICACLS $PATH4K /setowner "NT SERVICE\TrustedInstaller"')

Invoke-Expression -Command ('ICACLS $PATHWEB /remove Everyone /T /C')
Invoke-Expression -Command ('ICACLS $PATH4K /remove Everyone /T /C')
