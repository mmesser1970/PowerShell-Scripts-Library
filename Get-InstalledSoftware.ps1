$COMPUTERS = Get-Content C:\Temp\PCAComputerList.txt
# OR
#$COMPUTERS = $env:ComputerName

$ARRAY = @()

FOREACH($PC IN $COMPUTERS)
{
    $COMPUTERNAME = $PC.Trim()
	#=========================================================================================
	# DEFINE THE VARIABLE TO HOLD THE LOCATION OF CURRENTLY INSTALLED PROGRAMS.
	#=========================================================================================

	$UNINSTALLKEY = ”SOFTWARE\\MICROSOFT\\WINDOWS\\CURRENTVERSION\\UNINSTALL”

	#=========================================================================================
	# CREATE AN INSTANCE OF THE REGISTRY OBJECT AND OPEN THE HKLM BASE KEY.
	#=========================================================================================

	$REG = [MICROSOFT.WIN32.REGISTRYKEY]::OPENREMOTEBASEKEY('LOCALMACHINE',$COMPUTERNAME)

	#=========================================================================================
	# DRILL DOWN INTO THE UNINSTALL KEY USING THE OPENSUBKEY METHOD.
	#=========================================================================================

	$REGKEY = $REG.OPENSUBKEY($UNINSTALLKEY)

	#=========================================================================================
	#RETRIEVE AN ARRAY OF STRING THAT CONTAIN ALL THE SUBKEY NAMES.
	#=========================================================================================

	$SUBKEYS = $REGKEY.GETSUBKEYNAMES()
	
	#=========================================================================================
	#OPEN EACH SUBKEY AND USE GETVALUE METHOD TO RETURN THE REQUIRED VALUES FOR EACH.
	#=========================================================================================

    FOREACH ($KEY IN $SUBKEYS)
	{
		$THISKEY = $UNINSTALLKEY + ”\\” + $KEY
		$THISSUBKEY = $REG.OPENSUBKEY($THISKEY)
		
		
		$ARROBJ = NEW-OBJECT PSOBJECT
		FOREACH ($OBJ IN $ARROBJ)
		{
			$OBJ | ADD-MEMBER -MEMBERTYPE NOTEPROPERTY -NAME "COMPUTERNAME" -VALUE $COMPUTERNAME
			$OBJ | ADD-MEMBER -MEMBERTYPE NOTEPROPERTY -NAME "DISPLAYNAME" -VALUE $($THISSUBKEY.GETVALUE(“DISPLAYNAME”))
			$OBJ | ADD-MEMBER -MEMBERTYPE NOTEPROPERTY -NAME "DISPLAYVERSION" -VALUE $($THISSUBKEY.GETVALUE(“DISPLAYVERSION”))
			$OBJ | ADD-MEMBER -MEMBERTYPE NOTEPROPERTY -NAME "INSTALLLOCATION" -VALUE $($THISSUBKEY.GETVALUE(“INSTALLLOCATION”))
			$OBJ | ADD-MEMBER -MEMBERTYPE NOTEPROPERTY -NAME "PUBLISHER" -VALUE $($THISSUBKEY.GETVALUE(“PUBLISHER”))
		}
		$ARRAY += $OBJ
	}
}

$ARRAY | WHERE-OBJECT { $_.DISPLAYNAME } | SELECT COMPUTERNAME, DISPLAYNAME, DISPLAYVERSION, PUBLISHER | EXPORT-CSV "C:\TEMP\INSTALLED_SOFTWARE.csv"
