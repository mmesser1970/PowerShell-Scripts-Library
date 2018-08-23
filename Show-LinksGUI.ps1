#Configure the font style
$FONT = New-Object System.Drawing.Font("Tahoma",12,[System.Drawing.FontStyle]::Regular)

#Create Form Object
$FORM = New-Object System.Windows.Forms.Form
$FORM.Size = New-Object System.Drawing.Size(500,800)
$FORM.Text = "Link Label Demo"
$FORM.StartPosition = "CenterScreen"
$FORM.Font = $FONT
 
#Link Label 1
$LINKLABEL1 = New-Object System.Windows.Forms.LINKLABEL
$LINKLABEL1.Location = New-Object System.Drawing.Size(10,10)
$LINKLABEL1.Size = New-Object System.Drawing.Size(450,20)
$LINKLABEL1.Font = $FONT
$LINKLABEL1.LinkColor = "BLUE"
$LINKLABEL1.ActiveLinkColor = "PURPLE"
$LINKLABEL1.Text = "My GitHub"
$LINKLABEL1.add_Click({[system.Diagnostics.Process]::start("https://github.com/mmesser1970/PowerShell-Scripts-Library")})
$FORM.Controls.Add($LINKLABEL1)
 
#Link Label 2
$LINKLABEL2 = New-Object System.Windows.Forms.LINKLABEL
$LINKLABEL2.Location = New-Object System.Drawing.Size(10,40)
$LINKLABEL2.Size = New-Object System.Drawing.Size(450,20)
$LINKLABEL2.Font = $FONT
$LINKLABEL2.LinkColor = "BLUE"
$LINKLABEL2.ActiveLinkColor = "PURPLE"
$LINKLABEL2.Text = "My TechNet Profile"
$LINKLABEL2.add_Click({[system.Diagnostics.Process]::start("https://social.technet.microsoft.com/profile/twysted_scripter")})
$FORM.Controls.Add($LINKLABEL2) 
 
#Link Label 3
$LINKLABEL3 = New-Object System.Windows.Forms.LINKLABEL
$LINKLABEL3.Location = New-Object System.Drawing.Size(10,70)
$LINKLABEL3.Size = New-Object System.Drawing.Size(450,20)
$LINKLABEL3.Font = $FONT
$LINKLABEL3.LinkColor = "BLUE"
$LINKLABEL3.ActiveLinkColor = "PURPLE"
$LINKLABEL3.Text = "Simplify PowerShell By Creating ISE Snippets"
$LINKLABEL3.add_Click({[system.Diagnostics.Process]::start("https://www.pdq.com/blog/creating-powershell-ise-snippets")})
$FORM.Controls.Add($LINKLABEL3) 

#Link Label 4
$LINKLABEL4 = New-Object System.Windows.Forms.LINKLABEL
$LINKLABEL4.Location = New-Object System.Drawing.Size(10,100)
$LINKLABEL4.Size = New-Object System.Drawing.Size(450,20)
$LINKLABEL4.Font = $FONT
$LINKLABEL4.LinkColor = "BLUE"
$LINKLABEL4.ActiveLinkColor = "PURPLE"
$LINKLABEL4.Text = "MS Office Configuration XML Editor"
$LINKLABEL4.add_Click({[system.Diagnostics.Process]::start("https://officedev.github.io/Office-IT-Pro-Deployment-Scripts/XmlEditor.html")})
$FORM.Controls.Add($LINKLABEL4)

#Link Label 5
$LINKLABEL5 = New-Object System.Windows.Forms.LINKLABEL
$LINKLABEL5.Location = New-Object System.Drawing.Size(10,130)
$LINKLABEL5.Size = New-Object System.Drawing.Size(450,20)
$LINKLABEL5.Font = $FONT
$LINKLABEL5.LinkColor = "BLUE"
$LINKLABEL5.ActiveLinkColor = "PURPLE"
$LINKLABEL5.Text = "Windows PowerShell Tutorial"
$LINKLABEL5.add_Click({[system.Diagnostics.Process]::start("https://www.computerperformance.co.uk/powershell/")})
$FORM.Controls.Add($LINKLABEL5)

#Show Form
$FORM.ShowDialog()
