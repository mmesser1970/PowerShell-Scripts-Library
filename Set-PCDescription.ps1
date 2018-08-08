<#

.SYNOPSIS
	Powershell script to fill the Description section in Active Directory

.DESCRIPTION
	This PowerShell script will fill in the Description section in for a(ll) computers in Active Directory

.NOTES
	Version:		1.0
	Creation Date:  29-MAR-2018
 
.EXAMPLE
	Contoso : JSmith : CNSO-DLI43NR35 : Dell Inc. : Latitude E7250 : DLI43NR35

#>

#============================================================================================================================================
# $COMPUTERS = (GET-CONTENT C:\<FILENAME>.TXT)
$COMPUTERS = GET-WMIOBJECT WIN32_BIOS -COMPUTERNAME $ENV:COMPUTERNAME
#============================================================================================================================================
FOREACH ($COMPUTER IN $COMPUTERS)
{
	$USERDOM            = $ENV:USERDOMAIN
	$COMPUTERNAME		= $ENV:COMPUTERNAME
	$MANUFACTURER		= (GET-WMIOBJECT WIN32_COMPUTERSYSTEM).MANUFACTURER
	$MODEL				= (GET-WMIOBJECT WIN32_COMPUTERSYSTEMPRODUCT).MODEL
	$NAME			    = (GET-WMIOBJECT WIN32_COMPUTERSYSTEMPRODUCT).NAME
	$SERIALNUMBER		= (GET-WMIOBJECT WIN32_BIOS).SERIALNUMBER
	
	$MACADDRESS 		= (GET-WMIOBJECT -CLASS WIN32_NETWORKADAPTERCONFIGURATION -COMPUTERNAME $COMPUTERNAME |`
	WHERE { $_.IPADDRESS -EQ $IPADDRESS}).MACADDRESS

	IF ($MODEL){$COMPUTERMODEL = $MODEL}
	ELSE {$COMPUTERMODEL = $NAME}
	
	# SEND THE INFORMATION OUT TO ACTIVE DIRECTORY
	SET-ADCOMPUTER $COMPUTER –DESCRIPTION “$USERDOM : $COMPUTERNAME : $MANUFACTURER : $COMPUTERMODEL : $SERIALNUMBER : $MACADDRESS”
}
