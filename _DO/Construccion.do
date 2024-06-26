clear
////////////////////////////////////
//                                //
//  Construcción de Pseudo-Panel  //
//                                //
////////////////////////////////////

// generar gini educativo por id
local gy 1


////////////////////////////////////////////////////////////////////////////////
use _IN\echBOLVIA.dta

* 1.- Limpiar Datos

// Eliminar datos no utilizados
gen gini=1
gen sd_edu=1
//replace year=. if year<2014 | year>2022
//dropmiss year, obs force

replace born_year=. if born_year<=1990
dropmiss born_year, obs force
//dropmiss born_month, obs force

replace born_year=. if born_year>2001
dropmiss born_year, obs force


cap drop cont_edad

gen cont_edad=year-born_year

replace cont_edad=. if cont_edad<=17
dropmiss cont_edad, obs force

// Generar variable de años de educación por nivel educativo

tabulate idep, gen(dep)

cap drop ynived

gen ynived=. 
replace ynived=0 if nivedu==0
replace ynived=3 if nivedu==1
replace ynived=6 if nivedu==2
replace ynived=9 if nivedu==3
replace ynived=12 if nivedu==4
replace ynived=17 if nivedu==7
dropmiss ynived, obs force


dropmiss, force
cap drop country
cap drop id_hh
cap drop id_person
cap drop iupm
cap drop cob_cod
cap drop folio1
cap drop folio
cap drop _idcheck
cap drop hc_d2
cap drop hc_d2_a
cap drop hc_d2_b
cap drop hc_d2_c
cap drop hc_d2_d
cap drop hc_d2_e
cap drop hc_d2_f
cap drop hc_d2_g
cap drop ipro
cap drop isec
cap drop ican
cap drop iloc
cap drop izon
cap drop isect
cap drop iseg
cap drop imanz
cap drop iviv
cap drop ibol 

*2.- Realizar las pruebas de Coeficiente de variación probando clusters de observaciónes

// Obtener una lista de posibles variables que presentan un cv<=20 al usarlas para colapsar la base

ds

local allvar `r(varlist)'

global cv_var ""
global id_var "" 

//di "`allvar'"
foreach x of local allvar{

//di "`x'"

if "`x'"!="yedc"{
preserve 

collapse yedc, by(`x')

local cv

quietly sum yedc 

local cv = (r(sd)/r(mean))*100

if `cv'<=20{

global id_var "$id_var `x'"
global cv_var "$cv_var `cv'"
}
//display `cv'

restore

}
}


di "$id_var"
di "$cv_var"

*3.- Generar Id para Pseudo-Panel
// propensity score matching puede ser una solución 

cap drop id_rd 

ds
local ds_list `r(varlist)'
egen id_rd = concat(year born_month born_year female)

// (Las variables ,year ,idep ,female ,edad y born_month presentan un CV relativamente pequeño para poder realizar el analisis)

// obtener el CV conjunto de las variables selecionadas para el id
preserve 

collapse yedc, by(id_rd)

local cv

sum yedc 
 
local cv = (r(sd)/r(mean))*100

display `cv'

restore

cap drop x
gen x=1

cap drop tam_clust

egen tam_clust = total(x), by(id_rd)
drop x

*3.- Generar el Gini para educación


if `gy'==1{
do _DO\Gini_by_year.do
}

if `gy'==0{

destring id_rd, gen(id_rd_num) 

quietly levelsof id_rd_num , local(id_count)

qui global id_C "`id_count'" 

}

*4.- Generar SD para cada grupo
cap drop id_rd_num

destring id_rd, gen(id_rd_num) 

cap drop sd_edu
gen sd_edu=.

quietly levelsof id_rd, local(id_co)


foreach r of local id_co{
	
quietly sum yedc if id_rd_num==`r'

quietly replace sd_edu=r(sd) if id_rd_num==`r'
	
}


*5.- Comprimir la base de datos

//save labels
foreach v of var * {
 local l`v' : variable label `v'
 if `"`l`v''"' == "" {
 local l`v' "`v'"
}

di  `"`l`v''"'

}




//di "`ds_list'"
//Collapse

local ds_list "`ds_list' tam_clust"

collapse `ds_list', by(id_rd)

if `gy'==0{
cap drop gini
}

//Paste labels

foreach v of var * {
quietly label var `v' `"`l`v''"'
}

// Guardar en DATA.dta

save "_OUT\DATA.dta", replace