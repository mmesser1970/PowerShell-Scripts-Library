function wait {
  param([int]$pause = 2)
  Start-Sleep -seconds $pause
}

[void] [System.Reflection.Assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
& "$env:WinDir\Notepad.exe"
$a = Get-Process | Where-Object {$_.Name -eq "Notepad"}
[void] [System.Reflection.Assembly]::LoadWithPartialName("'System.Windows.Forms")
wait

[System.Windows.Forms.SendKeys]::SendWait("What is today's time and date?")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
wait
[System.Windows.Forms.SendKeys]::SendWait("{F5}")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
wait
[System.Windows.Forms.SendKeys]::SendWait("What is my Username?")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
wait
[System.Windows.Forms.SendKeys]::SendWait("Name: $env:UserName")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
wait
[System.Windows.Forms.SendKeys]::SendWait("What is my computer name?")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
wait
[System.Windows.Forms.SendKeys]::SendWait("Computer: $env:ComputerName")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
wait
[System.Windows.Forms.SendKeys]::SendWait("How cool is this?")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
wait
[System.Windows.Forms.SendKeys]::SendWait("This window will close automatically!")
wait
[System.Windows.Forms.SendKeys]::SendWait("%F")
wait
[System.Windows.Forms.SendKeys]::SendWait("X")
wait
[System.Windows.Forms.SendKeys]::SendWait("%N")
