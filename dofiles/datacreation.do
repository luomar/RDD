/********************************************************************************
***   This Do file is for assignment 4										  ***
*********************************************************************************

	Creator: Luis Omar Herrera Prada - IMF
	First Version: 			JUN 8 / 2020
	Date of last version:  	JUN 8 / 2020
			
		Important changes made to do:
		
		Notes:
*********************************************************************************/

**Globals
		global path 		"/Volumes/Shura/Dropbox/phd/ResearchD/RDD"
		

use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear
save "$path/data/hansen_dwi.dta" , replace

gen select=bac1>= 0.08

gen DU=bac1>= 0.08

histogram bac1, addplot(pci 0 0.08 2000 0.08)freq width(0.0001) lcolor(black)  ///
bfcolor(gs12) blcolor(gs10) graphregion(fcolor(white)) ///
xtitle("BAC", margin(medium)) ytitle("Frequency") title("BAC histogram") legend(off)
graph export "$path/figures/BACHist.png", replace 

gen bac1XDU=bac1*DU
local poly bac1*

foreach var in male white aged acc {
	reg `var' select##c.bac1 if bac1<0.131 , cluster(bac1)
}


reg  select##c.bac1 if  male
bac1<0.131

reg male select##c.bac1  if bac2<=0.13 


reg male select##c.bac1  if abs(bac1)<=0.5

