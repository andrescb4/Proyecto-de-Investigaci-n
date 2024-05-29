clear
cls
use "_OUT\DATA.dta", clear

cap drop dic
gen dic=0
replace dic=1 if born_year>1995

*grafico de tendencias paralelas
bysort dic year : egen ave_yedu=mean(yedc)

twoway (connected ave_yedu year if dic==0 & year>2015 & year<2021, mlabel(year) legend(label(1 "Control"))) (connected ave_yedu year if dic==1 & year>2015 & year<2021, mlabel(year) legend(label(2 "Treatment")))

*testear tendencias paralelas para años promedio de educación
cap drop dy
gen dy=dic*year
regress yedc dic year dy ethnic0 female lnyhogpc rural if year>2015 & year<2021


bysort dic year: egen ave_sdedu=mean(sd_edu)

twoway (connected ave_sdedu year if dic==0 , mlabel(year) legend(label(1 "Control"))) (connected ave_sdedu year if dic==1 , mlabel(year) legend(label(2 "Treatment")))

*testear tendencias paralelas para sd educativo
cap drop dy
gen dy=dic*year
regress sd_edu dic year dy ethnic0 female lnyhogpc rural 
