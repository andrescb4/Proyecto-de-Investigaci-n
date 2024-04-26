

*3.- Generar el Gini para educación


cap drop gini
cap drop id_rd_num
gen gini=.

destring id_rd, gen(id_rd_num) 

quietly levelsof id_rd_num , local(id_count)

qui global id_C "`id_count'" 

cap drop x
gen x=1
egen tam_clust = total(x), by(id_rd)
drop x

//di "$id_C" 

foreach r of local id_count{
	
quietly ineqdec0 ynived [iw=factor_ine]  if id_rd_num==`r'

quietly replace gini=r(gini) if id_rd_num==`r'
	
} 
