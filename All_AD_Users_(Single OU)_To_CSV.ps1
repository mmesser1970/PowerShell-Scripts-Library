# Change the OU "*Administrators*" to suit your needs (Keep the asterisk wild card)

Get-ADUser -Filter {(Enabled -eq $true)} -SearchBase "OU=Computers,dc=Contoso,dc=com" |`
? { ($_.distinguishedname -like "*Administrators*") } |`
Export-Csv -Path C:\Temp\All-Admin-Users.csv
