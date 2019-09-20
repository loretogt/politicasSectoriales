----------------INFORMACION-----------------
Autor: Loreto Garcia Tejada
Titulación: Doble grado en II + ADE - 2019/2020
Asignatura: Politicas sectoriales
Versión: 1.0

http://www.ine.es/dynt3/inebase/es/index.htm?padre=5842&capsel=5843

Variables:
 -Número de empresas en el sector TIC por ramas de actividad del sector TIC y periodo. ->
    http://www.ine.es/jaxi/Tabla.htm?path=/t14/p197/e01/evoluc/a2017/l0/&file=01001.px&L=0
    
 -Cifra de negocios en el sector TIC por ramas de actividad del sector TIC y periodo.->
    http://www.ine.es/jaxi/Tabla.htm?path=/t14/p197/e01/evoluc/a2017/l0/&file=01002.px&L=0
    
 -Valor añadido en el sector TIC por ramas de actividad del sector TIC y periodo.->
    http://www.ine.es/jaxi/Tabla.htm?path=/t14/p197/e01/evoluc/a2017/l0/&file=01003.px&L=0
    
 -Número de ocupados en el sector TIC por ramas de actividad del sector TIC y periodo.->
    http://www.ine.es/jaxi/Tabla.htm?path=/t14/p197/e01/evoluc/a2017/l0/&file=01004.px&L=0
    
 -Ganancia media por hora en el sector TIC por ramas de actividad del sector TIC y periodo.->
    http://www.ine.es/jaxi/Tabla.htm?path=/t14/p197/e01/evoluc/a2017/l0/&file=01005.px&L=0
    

```{r}
#Insercion de librerias necesarias
library(pxR)
library(shiny)

nEmpresas <- read.px("http://www.ine.es/jaxi/files/_px/es/px/t14/p197/e01/evoluc/a2017/l0/01001.px?nocab=1")
nEmpresas <- as.data.frame(nEmpresas)

cifraNeg <- read.px("http://www.ine.es/jaxi/files/_px/es/px/t14/p197/e01/evoluc/a2017/l0/01002.px?nocab=1")
cifraNeg <- as.data.frame(cifraNeg)

vAñadido <- read.px("http://www.ine.es/jaxi/files/_px/es/px/t14/p197/e01/evoluc/a2017/l0/01003.px?nocab=1")
vAñadido <- as.data.frame(vAñadido)

nOcupados <- read.px("http://www.ine.es/jaxi/files/_px/es/px/t14/p197/e01/evoluc/a2017/l0/01004.px?nocab=1")
nOcupados <- as.data.frame(nOcupados)

gananMed <- read.px("http://www.ine.es/jaxi/files/_px/es/px/t14/p197/e01/evoluc/a2017/l0/01005.px?nocab=1")
gananMed <- as.data.frame(gananMed)
```
----------------SHINY APP-----------------

```{r}
ui <- navbarPage(
  theme = shinytheme("flatly"),
  title= "Proyecto Loreto",
  navbarMenu("Variables",
  )
  )#navbarPage
) #Ui
```