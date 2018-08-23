##*=========================================================================================
## Change the $SOURCEPATH and $DESTINATIONPATH
##*=========================================================================================

$SOURCEPATH = "C:\FolderPath\*"
$DESTINATIONPATH = "C:\FolderPath\Folder"

##*=========================================================================================
[Void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$FONT = New-Object System.Drawing.Font("Tahoma",13,[System.Drawing.FontStyle]::Regular)
$FORMLABEL = New-Object System.Windows.Forms.Label
$FORMLABEL.Size = New-Object System.Drawing.Size(480,25)
$FORMLABEL.Font = $FONT
$FORMLABEL.Text = "Process Starting, Please Wait..."
$FORMLABEL.Left = 5
$FORMLABEL.Top = 10

$FORM = New-Object System.Windows.Forms.Form
$FORMTITLE = "Working..."
$FORM.Text = $FORMTITLE
$FORM.Font = $FONT
$FORM.Height = 100
$FORM.Width = 500

##=====================================
$FORM.BackColor = "#FF0000FF"
$FORM.ForeColor = "#FF00FF7F"
##=====================================

$FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$FORM.Controls.Add($FORMLABEL)

$PROGRESSBAR = New-Object System.Windows.Forms.ProgressBar
$PROGRESSBAR.Size = New-Object System.Drawing.Size(480,20)
$PROGRESSBAR.Value = 0
$PROGRESSBAR.Left = 5
$PROGRESSBAR.Top = 40
$PROGRESSBAR.Style = 'Marquee'
$PROGRESSBAR.ForeColor = 'Red'
$PROGRESSBAR.BackColor='Black'
$PROGRESSBAR.Style = 'Continuous'

$FORM.Controls.Add($PROGRESSBAR)
$FORM.Show() | Out-Null
$FORM.Focus() | Out-Null
$FORM.Refresh()
Start-Sleep -Milliseconds 150

IF (!(Test-Path $DESTINATIONPATH))
{
	New-Item -Path $DESTINATIONPATH -ItemType Directory | Out-Null
}

Copy-Item $SOURCEPATH -Destination $DESTINATIONPATH -Recurse -Force

$FILES = Get-ChildItem -Path $DESTINATIONPATH -File -Recurse -Force | SELECT Name, @{NAME = "Path";Expression = {$_.FullName}}
$COUNTER = 0
FOREACH ($FILE IN $FILES)
{
	$COUNTER++
	[INT]$PERCENTAGE = ($COUNTER/$FILES.Count)*100
	$PROGRESSBAR.Value = $PERCENTAGE
	$FORMLABEL.Text = "Copying files from $SOURCEPATH to $DESTINATIONPATH"
	$FORM.Refresh()
	Start-Sleep -Milliseconds 200
	"`t" + $FILE.Path
}

$FORM.Close()
