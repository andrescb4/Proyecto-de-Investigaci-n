
clear
cls
use "_OUT\DATA.dta", clear

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

cap drop dict
gen dict=0
replace dict=dic*(born_year-1995)

gen b_y=born_year-1990

gen year_n=year-2014

tab year_n, gen(year_)

gen dico=dic

xtreg sd_edu year_2 year_3 year_4 year_5 year_6 year_7 year_8 dico 1.dic#dict female rural b_y,  re 

margins, nose  at(b_y=(1(1)11) year_2=(0(1)1) year_3=(0(1)1) year_4=(0(1)1) year_5=(0(1)1) year_6=(0(1)1) year_7=(0(1)1) year_8=(0(1)1)) ///
saving(_OUT\3dg2.dta, replace)
use _OUT\3dg2.dta,  clear


rename _at1 y_2016

rename _at2 y_2017

rename _at3 y_2018

rename _at4 y_2019

rename _at5 y_2020

rename _at6 y_2021

rename _at7 y_2022

rename _at13 born_year

rename _margin yedc

gen dic=0
replace dic=1 if born_year>5

gen dict=dic*(born_year-5)

cap drop filt

gen filt=1
replace filt=. if dic==1 & born_year<6
replace filt=. if dic==0 & born_year>6
replace filt=. if dict==0 & dic==1 & born_year!=6

replace filt=. if dict==1 & born_year!=6 
replace filt=. if dict==2 & born_year!=7
replace filt=. if dict==3 & born_year!=8
replace filt=. if dict==4 & born_year!=9
replace filt=. if dict==5 & born_year!=10
replace filt=. if dict==6 & born_year!=11

dropmiss filt, obs force

cap drop filt

cap drop xy

gen xy=y_2016+y_2017+y_2018+y_2019+y_2020+y_2021+y_2022

replace xy=. if xy>1
dropmiss xy ,obs force

cap drop yearf
gen yearf=2015+ y_2016 + y_2017*2 + y_2018*3 + y_2019*4 + y_2020*5 + y_2021*6 + y_2022*7
rename yearf year

replace born_year=born_year+1990

cap drop dob
expand 2 if born_year==1996, gen(dob)
replace dic=0 if dob==1
cap drop dob

replace yedc=yedc-0.5045719 if dic==1

replace yedc=yedc+0.4595234 if dict==1 & dic==1

replace yedc=yedc+0.4317902 if dict==2

replace yedc=yedc+0.3353724 if dict==3

replace yedc=yedc+0.2320085 if dict==4

replace yedc=yedc+0.0816574 if dict==5


save _OUT\3dg2.dta, replace

python:
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


from mpl_toolkits.mplot3d import Axes3D

# Read the data
data = pd.read_stata(r'F:\Trabajo\_PROYECTOS\_STATA\Proyecto_de_Investigacion\_OUT/3dg2.dta')

# Separate data based on the value of dic
dic_0_data = data[(data['dic'] == 0)]
dic_1_data = data[(data['dic'] == 1)]




images = []
for i in range(31):
	# Plot the graph
	fig = plt.figure()
	ax = fig.add_subplot(111, projection='3d')

	# Plot the first plane for dic = 0
	ax.plot_trisurf(dic_0_data['born_year'], dic_0_data['year'], dic_0_data['yedc'], cmap='plasma', alpha=0.9)

	# Plot the second plane for dic = 1
	ax.plot_trisurf(dic_1_data['born_year'], dic_1_data['year'], dic_1_data['yedc'], cmap='plasma', alpha=0.9)

	ax.set_xticks(np.arange(1991, 2001, step=2))
	ax.set_yticks(np.arange(2015, 2022, step=2))
	ax.set_zticks(np.arange( 1, 5, step=0.5))

	# Set labels and ticks
	ax.set_xlabel('Año de nacimiento')
	ax.set_ylabel('Año de la encuesta')
	ax.set_zlabel('SD (Años de educación)')
	
	ax.view_init(15,12*i)
	
	plt.savefig(f"frame_{i}.png")
	plt.close()
	images.append(f"frame_{i}.png")
	





end