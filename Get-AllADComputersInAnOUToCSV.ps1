$OU = "OU=COMPUTERS,DC=CONTOSO,DC=COM"
$CSVFILE = "C:\Temp\AllComputers_In_AD - " + (GET-DATE -FORMAT "yyyy-MM-dd") + ".csv"
$COMPUTERS = Get-ADComputer -Filter * -Properties * -SearchBase $OU | EXPORT-CSV "$CSVFILE" -NOTYPEINFORMATION
