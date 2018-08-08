# Identify environment variables
$COMPANYNAME = "Company"	# Change to your company name
$GROUP = "IT Admins"	# Change yo your group or department name

$LOGPATH = "C:\Logs"
$LOGFILE = "$LOGPATH\$COMPANYNAME-TSComplete.log"
$DATE = (Get-Date -UFormat "%Y-%m-%d").tostring()
$REGCOMPLETEPATH = "HKLM:\Software"
$REGCOMPLETEKEY = "$COMPANYNAME-$GROUP-Managed"
$REGCOMPLETEAPP = "$COMPANYNAME-TSDeploy"
$REGCOMPLETENAME = "Complete"
$REGPACKAGE = "SCCM"
$SYSTEMREG = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
$SYSTEMSTRING = "Model"
$SYSTEMMODEL = "$COMPANYNAME $DATE v1.0"
$REGKEYVALUESUCCESS = "Success"
$REGKEYTS = "TaskSequence"
$TSENV = New-Object -ComObject Microsoft.SMS.TSEnvironment

# Create the "C:\Logs" folder if it doesn't exist
If (Test-Path $LOGPATH) {Write-Host $LOGPATH Exists} else {New-Item $LOGPATH -Type Directory}

# Close the TS UI temporarily
$TSPROGRESSUI = New-Object -COMObject Microsoft.SMS.TSProgressUI
$TSPROGRESSUI.CloseProgressDialog()
$TSPACKAGE = $TSENV.Value("_SMSTSClientGUID")

# Start the log file
Write "------------------ Begin Script -----------------------" | Out-File $LOGFILE -Encoding ASCII -append
Write "------ Completed: $DATE $COMPANY OSD TS: $TSPACKAGE ------" | Out-File $LOGFILE -Encoding ASCII -append
Write "--------- Machine Name: $env:COMPUTERNAME ----------------" | Out-File $LOGFILE -Encoding ASCII -append
Write "------ Creating Registry entry for tracking -----------" | Out-File $LOGFILE -Encoding ASCII -append
Write "-------------------------------------------------------" | Out-File $LOGFILE -Encoding ASCII -append

# Make necessary changes to the Registry
New-Item -Path $REGCOMPLETEPATH -Name $REGCOMPLETEKEY -Force | Out-File $LOGFILE -Encoding ASCII -append
New-Item -Path $REGCOMPLETEPATH\$REGCOMPLETEKEY -Name $REGCOMPLETEAPP -Force | Out-File $LOGFILE -Encoding ASCII -append
New-ItemProperty -Path $REGCOMPLETEPATH\$REGCOMPLETEKEY\$REGCOMPLETEAPP -Name $REGCOMPLETENAME -Value $DATE -Force | Out-File $LOGFILE -Encoding ASCII -append
New-Item -Path $REGCOMPLETEPATH\$REGCOMPLETEKEY -Name $REGPACKAGE -Force | Out-File $LOGFILE -Encoding ASCII -append
New-ItemProperty -Path $REGCOMPLETEPATH\$REGCOMPLETEKEY\$REGPACKAGE -Name $REGKEYVALUESUCCESS -Value $DATE -Force | Out-File $LOGFILE -Encoding ASCII -append
New-ItemProperty -Path $REGCOMPLETEPATH\$REGCOMPLETEKEY\$REGPACKAGE -Name $REGKEYTS -Value $TSPACKAGE -Force | Out-File $LOGFILE -Encoding ASCII -append
New-ItemProperty -Path $SYSTEMREG -Name $SYSTEMSTRING -Value $SYSTEMMODEL -Force

Write "Local Logging complete!"
Write "Displaying the Notification Complete window on-screen for the build technician." | Out-File $LOGFILE -Encoding ASCII -append
Write "------------------- End Script ------------------------" | Out-File $LOGFILE -Encoding ASCII -append

#================= Window Notification for TS Completion ================
# http://msdn.microsoft.com/en-us/library/x83z1d9f(v=vs.84).aspx
#========================================================================

# Display the TS Complete Notification Window
$OBJ = New-Object -ComObject wscript.shell
$intAnswer = $OBJ.popup("        $COMPANY $GROUP`r`rDate Complete:`t$DATE`rWorkstation:`t$env:COMPUTERNAME",30,"Task Sequence Complete!", 0x0 + 0x40)
