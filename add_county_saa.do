
*** County --> SSA codes are available at NBER: "https://www.nber.org/data/ssa-fips-state-county-crosswalk.html"
*** Check out "https://www.nber.org/data/medicare-advantage-ratebooks.html". Appears to have various state and county identifiers (and Medicare rates, of course) for 1990-2018!
cd "C:\Users\marku\Desktop\ssa_fip\"

erase ssa_fip.dta
*** Add county_ssa var and append to master file ***
forval i = 1/7 {
	use "C:\Users\marku\Desktop\ssa_fip\ssa_fips_state_county201`i'.dta" , clear
	ren county county_name
	drop if ssacounty=="" & fipscounty=="" //drops empty row
	gen year = 201`i'
	gen county_ssa = substr(ssacounty,3,3)
	cap append using ssa_fip
	save ssa_fip , replace
}

*** As a temporary measure, using a copy of 2017 file until 2018 file has been released ***
use "C:\Users\marku\Desktop\ssa_fip\ssa_fips_state_county2017 - Copy.dta" , clear
ren county county_name
drop if ssacounty=="" & fipscounty=="" //drops empty row
gen year = 2018
gen county_ssa = substr(ssacounty,3,3)
append using ssa_fip

keep county_name year fipscounty ssacounty fipsstate ssastate county_ssa state 
save ssa_fip , replace

*** Finally, add 2003 file after some minor cleaning 					 ***
*** Note that since CMS did not produce these crosswalks from 2003-2011, ***
*** I have duplicated the 2003 year for the years 2004-2010 			 ***


forval i = 3/10 {
	use "C:\Users\marku\Desktop\ssa_fip\msabea.dta" , clear
	ren (county abbr fips ssa ) (county_name state fipscounty ssacounty)
	gen county_ssa = substr(ssa,3,3)
	gen year = 200`i' if `i'<10 
	replace year = 20`i' if `i'>9
	gen fipsstate = substr(fipscounty,1,2)
	gen ssastate = substr(ssacounty,1,2)
	keep county_name year fipscounty ssacounty fipsstate ssastate county_ssa state 
	append using ssa_fip
	duplicates drop state county_ssa year , force // This drops 8 observations with duplicates values
	save ssa_fip , replace
}

