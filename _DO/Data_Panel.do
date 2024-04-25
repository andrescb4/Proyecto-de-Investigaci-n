tab born_year year

destring id_pd, replace
xtset id_pd year

//////////////////////////Pruebas para determinación del modelo/////////////////

cap drop dic
gen dic=0
replace dic=1 if born_year>1995

pwcorr yedc dic ine_yhogpc edad

tab dic
xtreg yedc dic ine_yhogpc edad, re
xttest0
//housman test
xtreg yedc dic ine_yhogpc edad, re
estimates store re1
xtreg yedc dic ine_yhogpc edad, fe
estimates store fe1
hausman fe1 re1