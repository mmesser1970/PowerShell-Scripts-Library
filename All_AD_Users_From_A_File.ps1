#====================================================================================================================================
# EXTRACT ACTIVE DIRECTORY USER INFORMATION FROM A LIST OF USERS IN A TEXT FILE
#====================================================================================================================================

# IDENTIFY THE FILEPATH TO SAVE IN
$PATH = SPLIT-PATH -PARENT "C:\TEMP\*.*"
$PATHEXIST = TEST-PATH -PATH $PATH

# TEST THE PATH AND CREATE IT IF IT DOES NOT ALREADY EXIST
IF ($PATHEXIST -EQ $FALSE)
{NEW-ITEM -TYPE DIRECTORY -PATH $PATH}

# IDENTIFY THE FILENAME TO SAVE AS
$REPORTDATE = GET-DATE -FORMAT yyyyMMdd
$CSVREPORTFILE = $PATH + "\ALLADUSERS_$REPORTDATE.CSV"

# IDENTIFY PATH TO THE LIST OF USERS IN A TEXT FILE
$USERS = FOREACH ($USER IN $(GET-CONTENT C:\TEMP\WIN10USERSLIST.TXT))

# SELECT WHICH PROPERTIES ARE TO BE AVAILABLE TO EXTRACT DATA FROM IN AD
{
	GET-ADUSER $USER -PROPERTIES *
}

# SELECT THE AD INFORMATION TO BE LISTED IN EACH COLUMN AND EXPORT TO A CSV FILE
$USERS | SELECT-OBJECT SAMACCOUNTNAME,DISPLAYNAME,MAIL | EXPORT-CSV -PATH $CSVREPORTFILE -NOTYPEINFORMATION

#====================================================================================================================================
# LIST OF AVAILABLE PROPERTIES TO SELECT FROM
#====================================================================================================================================

# OUTPUT TO CSV		  OBJECT PROPERTY IN AD
#____________________________________
# "FIRST NAME" 		= GIVENNAME
# "LAST NAME" 		= SURNAME
# "DISPLAY NAME" 	= DISPLAYNAME
# "LOGON NAME" 		= SAMACCOUNTNAME
# "FULL ADDRESS" 	= STREETADDRESS
# "CITY" 			= CITY
# "STATE" 			= ST
# "POST CODE" 		= POSTALCODE
# "JOB TITLE" 		= TITLE
# "COMPANY"	 		= COMPANY
# "DEPARTMENT" 		= DEPARTMENT
# "OFFICE" 			= OFFICENAME
# "PHONE" 			= TELEPHONENUMBER
# "EMAIL" 			= MAIL
