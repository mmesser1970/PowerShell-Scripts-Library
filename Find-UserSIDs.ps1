##*=====================================================================================
## REQUIRES ADMIN PRIVELAGES
##*=====================================================================================

#$COMPUTERS = Get-Content C:\Temp\Computers.txt
$COMPUTERS = $env:ComputerName 

ForEach ($COMPUTER in $COMPUTERS)
{
	# SID PATTERN TO LOOK FOR
	$PATTERNSID = 'S-1-5-21-\d+-\d+-\d+-\d+$'

	# GET USERNAME, SID, AND LOCATION OF NTUSER.DAT FOR ALL USERS
	$PROFILELIST = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*' |`
	Where-Object {$_.PSChildName -match $PATTERNSID} |`
	Select	@{name="SID";expression={$_.PSChildName}},
			@{name="UserHive";expression={"$($_.ProfileImagePath)\ntuser.dat"}},
			@{name="Username";expression={$_.ProfileImagePath -replace '^(.*[\\\/])', ''}}
	
	Get-ChildItem Registry::HKEY_USERS | Where-Object {$_.PSChildName -match $PATTERNSID} | Select PSChildName

	# GET ALL USER SIDS FOUND IN HKEY_USERS
	$LOADEDHIVES = Get-ItemProperty Registry::HKEY_USERS | Where-Object {$_.PSChildname -match $PATTERNSID} | Select @{name="SID";expression={$_.PSChildName}}

	# GET ALL USERS THAT ARE NOT CURRENTLY LOGGED ON
	$UNLOADEDHIVES = Compare-Object $PROFILELIST.SID $LOADEDHIVES.SID | Select @{name="SID";expression={$_.InputObject}}, UserHive, Username

	# LOOP THROUGH EACH PROFILE ON THE MACHINE
	Foreach ($ITEM in $PROFILELIST)

		# LOAD USER NTUSER.DAT IF IT'S NOT ALREADY LOADED
		{
			IF ($ITEM.SID -in $UNLOADEDHIVES.SID)
			{
			REG LOAD HKU\$($ITEM.SID) $($ITEM.UserHive) | Out-Null
			}
				# UNLOAD NTUSER.DAT
				IF ($ITEM.SID -in $UNLOADEDHIVES.SID)
				{
				# GARBAGE COLLECTION AND CLOSING OF NTUSER.DAT
				[gc]::Collect()
				REG UNLOAD HKU\$($ITEM.SID) | Out-Null
				}
		}
}
