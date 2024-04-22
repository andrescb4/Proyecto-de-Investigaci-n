
////////////////////////////////////
//                                //
//  Análisis de años de encuesta  //
//                                //
////////////////////////////////////

* 1.- Graficar variables de entrada y salida por años
use "_OUT\DATA.dta", clear
// Quadratic prediction plot for all years

twoway (qfit yedc born_year if year == 2014, mlabel(year) legend(label(1 "2014"))) (qfit yedc born_year if year == 2015, mlabel(year) legend(label(2 "2015"))) (qfit yedc born_year if year == 2016, mlabel(year) legend(label(3 "2016"))) (qfit yedc born_year if year == 2017, mlabel(year) legend(label(4 "2017"))) (qfit yedc born_year if year == 2018, mlabel(year) legend(label(5 "2018"))) (qfit yedc born_year if year == 2019, mlabel(year) legend(label(6 "2019"))) (qfit yedc born_year if year == 2020, mlabel(year) legend(label(7 "2020"))) (qfit yedc born_year if year == 2021, mlabel(year) legend(label(8 "2021"))) (qfit yedc born_year if year == 2022, mlabel(year) legend(label(9 "2022")))

graph save "_GRAPHS\_GPH\Qfit_All.gph", replace

graph export "_GRAPHS\_PNG\Qfit_All.png", as(png) name("Graph") replace


// Fractional polynomial plot for all years

twoway (fpfit yedc born_year if year == 2014, mlabel(year) legend(label(1 "2014"))) (fpfit yedc born_year if year == 2015, mlabel(year) legend(label(2 "2015"))) (fpfit yedc born_year if year == 2016, mlabel(year) legend(label(3 "2016"))) (fpfit yedc born_year if year == 2017, mlabel(year) legend(label(4 "2017"))) (fpfit yedc born_year if year == 2018, mlabel(year) legend(label(5 "2018"))) (fpfit yedc born_year if year == 2019, mlabel(year) legend(label(6 "2019"))) (fpfit yedc born_year if year == 2020, mlabel(year) legend(label(7 "2020"))) (fpfit yedc born_year if year == 2021, mlabel(year) legend(label(8 "2021"))) (fpfit yedc born_year if year == 2022, mlabel(year) legend(label(9 "2022"))) 

graph save "_GRAPHS\_GPH\FPfit_All.gph", replace

graph export "_GRAPHS\_PNG\FPfit_All.png", as(png) name("Graph") replace


* 2.- Definir años a ser utilizados

// Quadratic prediction plot for selected years

twoway (qfit yedc born_year if year == 2022, mlabel(year) legend(label(1 "2022"))) (qfit yedc born_year if year == 2021, mlabel(year) legend(label(2 "2021"))) (qfit yedc born_year if year == 2020, mlabel(year) legend(label(3 "2020"))) (qfit yedc born_year if year == 2019, mlabel(year) legend(label(4 "2019"))) 

graph save "_GRAPHS\_GPH\Qfit_2015-2018.gph", replace

graph export "_GRAPHS\_PNG\Qfit_2015-2018.png", as(png) name("Graph") replace

twoway (qfit yedc born_year if year == 2022, mlabel(year) legend(label(1 "2022"))) (qfit yedc born_year if year == 2021, mlabel(year) legend(label(2 "2021"))) (qfit yedc born_year if year == 2020, mlabel(year) legend(label(3 "2020")))

graph save "_GRAPHS\_GPH\Qfit_2015-2017.gph", replace

graph export "_GRAPHS\_PNG\Qfit_2015-2017.png", as(png) name("Graph") replace

//Testing for CV in the new dataset

local cv

sum yedc if year>=2015 & year<2018
 
local cv = (r(sd)/r(mean))*100

display `cv'
* 3.- Histogramas por año

hist yedc, by(year)

graph save "_GRAPHS\_GPH\Histogramas por año.gph", replace

graph export "_GRAPHS\_PNG\Histogramas por año.png", as(png) name("Graph") replace

* 4.- Eliminar años no utilizados de la base de datos agrupada

replace year=. if year<=2014 | year>2018 
dropmiss year, obs force

* 5.- Generar variable de identificación para pseudopanel

egen id_pd = concat(female born_month born_year)

*6.- Guardar Cambios en Data.dta

save "_OUT\DATA.dta", replace