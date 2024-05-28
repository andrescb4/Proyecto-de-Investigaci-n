
clear
cls
use "_OUT\DATA.dta", clear

//replace year=. if year<=2013 | year>2016
//dropmiss year, obs force


//tab born_year year

destring id_pd, replace
xtset id_pd year

//////////////////////////Pruebas para determinación del modelo/////////////////

*0.- Logaritmo yhogpc

cap drop lnyhogpc
gen lnyhogpc = ln(ine_yhogpc)

*1.- Definición de variables de tratamiento variable temporal
cap drop dic
gen dic=0
replace dic=1 if born_year>1995

cap drop did_b
gen did_b=0
replace did_b=1 if year>2014

cap drop did_n
gen did_n=did_b*dic

*2.- Regresiónes con Media educativa
xtdidregress (yedc lnyhogpc idep) (did_n), group(dic) time(did_b)

*3.- Regresiónes con SD educativa
xtdidregress (sd_edu lnyhogpc idep) (did_n), group(dic) time(did_b)

//estat trendplots