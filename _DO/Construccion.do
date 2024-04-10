clear
////////////////////////////////////
//                                //
//  Construcción de Pseudo-Panel  //
//                                //
////////////////////////////////////

use $IN\echBOLVIA.dta

* 1.- Limpiar Datos

// Eliminar datos no utilizados

replace year=. if year<=2011 
dropmiss year, obs force

replace born_year=. if born_year<=1979
dropmiss born_year, obs force

replace born_year=. if born_year<=1979 & born_year>2022
dropmiss born_year, obs force

replace edad=. if edad<=17
dropmiss edad, obs force

// Generar variable de años de educación por nivel educativo

cap drop ynived

gen ynived=. 
replace ynived=0 if nivedu==0
replace ynived=3 if nivedu==1
replace ynived=6 if nivedu==2
replace ynived=9 if nivedu==3
replace ynived=12 if nivedu==4
replace ynived=17 if nivedu==7
dropmiss ynived, obs force

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


//di "$id_var"
//di "$cv_var"

*3.- Generar Id para Pseudo-Panel

dropmiss, force
cap drop id_rd 
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

ds
local ds_list `r(varlist)'
egen id_rd = concat(year idep female born_month born_year)

// (Las variables ,year ,idep ,female ,edad y born_month presentan un CV relativamente pequeño para poder realizar el analisis)

// obtener el CV conjunto de las variables selecionadas para el id
preserve 

collapse yedc, by(id_rd)

local cv

sum yedc 
 
local cv = (r(sd)/r(mean))*100

display `cv'

restore

*3.- Comprimir la base de datos

//di "`ds_list'"

collapse `ds_list', by(id_rd)

// Guardar en DATA.dta

save "_OUT\DATA.dta", replace