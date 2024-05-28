cls
clear all 
///////////////////////////////////PROCESAMIENTO DE LA ENCUESTA DE HOGARES///////////////////////////////////
//                                                                                                         //
//                                                                                                         //
//                                           Autor: Andrés Crespo                                          //
//                                         Co-Autor: Carlos Pantoja                                        //
//                         Proyecto: Ley Avelino Siñani y desigualdad en educación                         //
//       Descripción: Análisis del impacto de la ley Avelino Siñani sobre la desigualdad en educación      //
//                     para la construcción de un Pseudo-Panel y regresión discontinua                     //
//                                                                                                         //
//                                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////// DO Files /////////////////////////////////////////////////



//////////////////////////Construcción de Pseudo-Panel//////////////////////////

* Comparación entre los CV de las diferentes variables

do _DO\Construccion.do

*Comportamiento de Años de la encuesta

do _DO\Años_Encuesta.do

//////////////////////////////////Regresión Discontinua en Data Panel////////////////////////////////////

//do _DO\Data_Panel.do

/////////////////////////////DID//////////////////////////////

//do _DO\graf3d