
*** Add county_ssa var to each file ***
forval i = 1/7 {
	use "C:\Users\marku\Desktop\ssa_fip\ssa_fips_state_county201`i'.dta" , clear
	drop if ssacounty=="" & fipscounty=="" //drops empty row
	gen county_ssa = substr(ssacounty,3,3)
	save , replace
}
