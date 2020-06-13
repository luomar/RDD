/********************************************************************************
***   This Do file is for assignment 4										  ***
*********************************************************************************

	Creator: Luis Omar Herrera Prada - IMF
	First Version: 			JUN 11 / 2020
	Date of last version:  	JUN 12 / 2020
			
		Important changes made to do:
		
		Notes:
*********************************************************************************/

**Globals
		global path 		"/Volumes/Shura/Dropbox/phd/ResearchD/RDD"
		global oro 			"tex(frag) label dec(3)  "
		global oro2			"tex(frag) label dec(3) nor2 e(N) "
		

use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear
save "$path/data/hansen_dwi.dta" , replace

gen select=bac1>= 0.08 // generate the dummy for the cut-off

// Histogram 1
histogram bac1, addplot(pci 0 0.08 2000 0.08)freq disc width(0.0001) lcolor(black)  ///
lwidth(vthin) fcolor(gray) bfcolor(gs12) blcolor(gs10) graphregion(fcolor(white)) ///
xtitle("BAC", margin(medium)) ytitle("Frequency") title("BAC histogram") legend(off)
graph export "$path/figures/BACHist.png", replace 

// Histogram 2
DCdensity bac1, breakpoint(0.08) generate(Xj Yj r0 fhat se_fhat)
graph export "$path/figures/BACHist2.png", replace 
drop Yj Xj r0 fhat se_fhat

**Test
{
/* open output file */
	cap file close fh
	file open fh using "$path/tables/assignment4_part21.tex", write replace
	
/* write table header to file */
	file write fh "\begin{tabular}{l cc }\hline\hline   \multicolumn{3}{c}{RD Manipulation Test using local polynomial density estimation.}   \\  & (1) &  (2)   \\ " _n	   	
	  
file write fh "&Left of c&Right of c\\" _n
file write fh "Obs&23010&191548\\" _n
file write fh "Eff. Obs&8895&13730\\" _n
file write fh "Order est.&2&2\\" _n
file write fh "Order bias&3&3\\" _n
file write fh "BW est&0.011&0.012\\" _n
file write fh "\hline" _n
file write fh "T&2.2&\\" _n
file write fh "Prob>T=&0.028&\\" _n
	file write fh "\hline" _n
	file write fh "\end{tabular}" _n
	/* close file handle */
	  file close fh
}

label var male		"Panel B. Male"
label var white		"Panel D. White"
label var aged		"Panel C. Age"
label var acc		"Panel A. Accident"	  
local replace replace

//Regressions and Charts for Table 2 and Figure 2
foreach var in male white aged acc {
qui	reg `var' select##c.bac1 if bac1<0.131 , cluster(bac1)
	outreg2  using "$path/tables/assignment4_part22.tex", $oro `replace'
	local replace 
	cmogram `var' bac1 if bac1<0.22 , cut(0.08) sc lfit lineat(0.08) graphopts(ti( "`:var l `var'' " ,size(med)) xti("BAC", size(small)) yti("Mean", size(med))) 
graph save "_graph0" "${path}/figures/`var'.gph" , replace
}

graph combine "$path/figures/acc.gph" "$path/figures/male.gph" "$path/figures/aged.gph" "$path/figures/white.gph"   , xcom graphregion(fcolor(white)) 
graph export "$path/figures/comb.png", replace 

gen bacsq=bac1^2
local replace replace

global L1 "bac1>0.03 & bac1<0.13"
global L2 "bac1>0.055 & bac1<0.105"

//Regressions and Charts for Table 3
forvalues r=1/2 {
	sum recidivism if ${L`r'}
	local m=r(mean)
	reg recidivism bac1 if  ${L`r'} , r
	outreg2  using "$path/tables/assignment4_part4`r'.tex", addstat(mean , `m') addtext(Type, Linear) $oro2 replace
	reg recidivism select##c.bac1 if  ${L`r'} , r
	outreg2  using "$path/tables/assignment4_part4`r'.tex", addstat(mean , `m') addtext(Type, Interaction) $oro2 
	reg recidivism c.bac1##select select##c.bacsq if  ${L`r'}, r
	outreg2  using "$path/tables/assignment4_part4`r'.tex", addstat(mean , `m') addtext(Type, Quadratic) $oro2 
}

global tlfit	"Linear"
global tqfit	"Quadratic"


foreach var in lfit qfit {
	cmogram recidivism bac1 if bac1<0.15 , cut(0.08) sc `var' lineat(0.08) graphopts(ti( "${t`var'}" ,size(med)) xti("BAC", size(small)) yti("Mean", size(med))) 
graph save "_graph0" "${path}/figures/`var'.gph" , replace
}

graph combine "$path/figures/lfit.gph" "$path/figures/qfit.gph"  , xcom graphregion(fcolor(white)) 
graph export "$path/figures/comb2.png", replace 
