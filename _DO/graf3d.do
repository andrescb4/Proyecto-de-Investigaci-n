clear
cls
use "_OUT\DATA.dta", clear

//tab born_year year

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

cap drop dict
gen dict=0
replace dict=dic*(born_year-1996)

xtreg sd_edu year dic rural lnyhogpc born_year,  re
//xtreg sd_edu i.dic born_year year,  re 

margins, at(born_year=(1980(1)2001) year=(2020(1)2022) dic=(0(1)1)) ///
vce(delta) saving(_OUT\3dg.dta, replace)
use _OUT\3dg.dta,  clear

rename _at1 year

rename _at2 dic

rename _at3 rural

rename _at4 lnyhogpc

rename _at5 born_year

rename _margin sd_edu

//dropmiss yedc, obs force 

save "C:\Users\Andres\Desktop\3dg.dta", replace

python:
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Read the data
data = pd.read_stata(r'C:\Users\Andres\Desktop/3dg.dta')

# Separate data based on the value of dic
dic_0_data = data[(data['dic'] == 0) & (data['born_year'] <= 1996)]
dic_1_data = data[(data['dic'] == 1) & (data['born_year'] > 1995)]

# Plot the graph
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot the first plane for dic = 0
ax.plot_trisurf(dic_0_data['born_year'], dic_0_data['year'], dic_0_data['sd_edu'], cmap='plasma', alpha=0.9)

# Plot the second plane for dic = 1
ax.plot_trisurf(dic_1_data['born_year'], dic_1_data['year'], dic_1_data['sd_edu'], cmap='plasma', alpha=0.9)

ax.set_xticks(np.arange(1980, 2001, step=5))
ax.set_yticks(np.arange(2020, 2022, step=1))
ax.set_zticks(np.arange( 0, 6, step=0.5))

# Set labels and ticks
ax.set_xlabel('Año de nacimiento')
ax.set_ylabel('Año de la encuesta')
ax.set_zlabel('Años de educación')

# Show the plot
plt.show()
plt.show()

end