clear
cls
use "_OUT\DATA.dta", clear

// borrar años no significativos
//replace year=. if year<2016 | year>2020
//dropmiss year, obs force

//tab born_year year

destring id_pd, replace
xtset id_pd year

//////////////////////////Pruebas para determinación del modelo/////////////////

*0.- Logaritmo yhogpc

cap drop lnyhogpc
gen lnyhogpc = ln(ine_yhogpc)

cap drop lnsd_edu
gen lnsd_edu = ln(sd_edu)

*1.- Regresiónes con Media educativa
cap drop dic
gen dic=0
replace dic=1 if born_year>1995

cap drop dict
gen dict=.
replace dict=dic*(born_year-1995)

//replace dict=. if dic==0

gen b_y=born_year-1990

pwcorr yedc dic lnyhogpc idep 

tab dic
quietly xtreg sd_edu dic dict, re
xttest0
//housman test

*Regresión tentativa

xtreg sd_edu i.year dic 1.dic#ib(1).dict rural ethnic0 b_y,  re 

// Test de heterosedasticidad

cap drop resid
cap drop resid_sq
predict resid, e
gen resid_sq = resid^2

reg resid_sq i.year dic 1.dic#ib(1).dict rural ethnic0 b_y

xtpcse sd_edu i.year dic 1.dic#ib(1).dict rural ethnic0 b_y, het
// Test de Autocorrelación
xtserial sd_edu year dic dict rural ethnic0 b_y, output 


//matrix define A = r(table)

//matrix define B = A'

//putexcel set "C:\Users\Andres\Desktop\Tablas regresiónales.xlsx", sheet(SD) modify 

//putexcel d6=matrix(B), rownames

xttest0
xtcsd, pesaran abs
estat vce, corr
* Regresión para desviación estandar en años de educación

reg yedc dic ib(1).dict ethnic0 female lnyhogpc rural if year>2015 & year<2021

vif
estat imtest, white
estat hettest, normal

cap drop error
predict error, resid
swilk error
sktest error


reg yedc dic if year>2015 & year<2021 & born_year==1995 | born_year==1996

//matrix define A = r(table)

//matrix define B = A'

//putexcel set "C:\Users\Andres\Desktop\Tablas regresiónales.xlsx", sheet(yedu) modify 

//putexcel d6=matrix(B), rownames

*Regresión para promedio en años de educación

xtreg yedc dic lnyhogpc i.born_year year, re 
estimates store re1

xtreg yedc dic lnyhogpc, be
estimates store fe1

hausman fe1 re1

*2.- Regresiónes con SD educativa
//cap drop dic
//gen dic=0
//replace dic=1 if born_year>1995

//pwcorr sd_edu dic lnyhogpc idep 

//tab dic
//quietly xtreg sd_edu dic lnyhogpc idep, re
//xttest0
//housman test
//xtreg sd_edu dic lnyhogpc idep, re
//estimates store re1
//xtreg sd_edu dic lnyhogpc idep, fe
//estimates store fe1
//hausman fe1 re1