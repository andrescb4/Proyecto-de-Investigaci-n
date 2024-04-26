tab born_year year

destring id_pd, replace
xtset id_pd year

//////////////////////////Pruebas para determinación del modelo/////////////////

*0.- Logaritmo yhogpc

cap drop lnyhogpc
gen lnyhogpc = ln(ine_yhogpc)

*1.- Regresiónes con Media educativa
cap drop dic
gen dic=0
replace dic=1 if born_year>1995

pwcorr yedc dic lnyhogpc idep 

tab dic
quietly xtreg yedc dic lnyhogpc idep, re
xttest0
//housman test
xtreg yedc dic lnyhogpc idep, re
//estimates store re1
//xtreg yedc dic lnyhogpc, fe
//estimates store fe1
//hausman fe1 re1

*2.- Regresiónes con SD educativa
cap drop dic
gen dic=0
replace dic=1 if born_year>1995

pwcorr sd_edu dic lnyhogpc idep 

tab dic
quietly xtreg sd_edu dic lnyhogpc idep, re
xttest0
//housman test
xtreg sd_edu dic lnyhogpc idep, re
//estimates store re1
//xtreg sd_edu dic lnyhogpc idep, fe
//estimates store fe1
//hausman fe1 re1