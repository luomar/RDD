/********************************************************************************
***   This Do file creates folders											  ***
*********************************************************************************

	Creator: Luis Omar Herrera Prada - World Bank
	First Version: 			SEP 14 / 2017
	Date of last version:  	SEP 14 / 2017
			
		Important changes made to do:
*********************************************************************************/
{
clear all
set more off, perm

// Starting Globals.
	if "`c(username)'"!="Luisin" {
		global path "~/Dropbox/WB/"
	}
	else{
		global path "/Volumes/Shura/Dropbox/phd/ResearchD/"
		global lugar "RDD"
	}
}	
  
foreach f in articles data dofiles figures inference tables writing {
	!mkdir "${path}/${lugar}/`f'"
}
