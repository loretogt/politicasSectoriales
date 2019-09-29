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




```{r}
#Insercion de librerias necesarias
library(pxR)
library(shiny)

nEmpresas <- read.px("http://www.ine.es/jaxi/files/_px/es/px/t14/p197/e01/evoluc/a2017/l0/01001.px?nocab=1")
nEmpresas <- as.data.frame(nEmpresas)
#nos quedamos solo con un años 2013
nEmpresas<- subset(nEmpresas, periodo!="2013 (ámbito 2012)")
nEmpresas$periodo<-as.character(nEmpresas$periodo)
nEmpresas$periodo[nEmpresas$periodo=="2013 (ámbito ampliado)"]<-"2013"

cifraNeg <- read.px("http://www.ine.es/jaxi/files/_px/es/px/t14/p197/e01/evoluc/a2017/l0/01002.px?nocab=1")
cifraNeg <- as.data.frame(cifraNeg)
#nos quedamos solo con un años 2013
cifraNeg<- subset(cifraNeg, periodo!="2013 (ámbito 2012)")
cifraNeg$periodo<-as.character(cifraNeg$periodo)
cifraNeg$periodo[cifraNeg$periodo=="2013 (ámbito ampliado)"]<-"2013"

vAñadido <- read.px("http://www.ine.es/jaxi/files/_px/es/px/t14/p197/e01/evoluc/a2017/l0/01003.px?nocab=1")
vAñadido <- as.data.frame(vAñadido)
#nos quedamos solo con un años 2013
vAñadido<- subset(vAñadido, periodo!="2013 (ámbito 2012)")
vAñadido$periodo<-as.character(vAñadido$periodo)
vAñadido$periodo[vAñadido$periodo=="2013 (ámbito ampliado)"]<-"2013"

nOcupados <- read.px("http://www.ine.es/jaxi/files/_px/es/px/t14/p197/e01/evoluc/a2017/l0/01004.px?nocab=1")
nOcupados <- as.data.frame(nOcupados)
#nos quedamos solo con un años 2013
nOcupados<- subset(nOcupados, periodo!="2013 (ámbito 2012)")
nOcupados$periodo<-as.character(nOcupados$periodo)
nOcupados$periodo[nOcupados$periodo=="2013 (ámbito ampliado)"]<-"2013"

periodo<- nEmpresas [nEmpresas$Ramas.de.actividad.del.sector.TIC=="2. SERVICIOS",];
periodo<-periodo[1];
sectores<-nEmpresas [nEmpresas$periodo=="2017",];

graf<-nEmpresas[ nEmpresas$Ramas.de.actividad.del.sector.TIC=="2. SERVICIOS" ,];



```
----------------SHINY APP-----------------
```{r}
# Define UI for application that draws a histogram

library(shiny)
library(plotly)
library(shinyWidgets)
library(ggplot2)
library(shinythemes)

ui <-navbarPage(    
  theme = shinytheme("flatly"),
  title= "Proyecto Loreto",
  
  tabPanel("Variables",
           sidebarLayout(
             sidebarPanel(
               selectInput("var","Variables:",
                           c("Número de empresas en el sector TIC por ramas de actividad del sector TIC y periodo" ="nEmpresas", 
                             "Cifra de negocios en el sector TIC por ramas de actividad del sector TIC y periodo" ="cifraNeg", 
                             "Valor añadido en el sector TIC por ramas de actividad del sector TIC y periodo"= "vAñadido",
                             "Número de ocupados en el sector TIC por ramas de actividad del sector TIC y periodo"="nOcupados")),
               selectInput("per","Periodo:",choices = c(periodo)),
               selectInput("sect","Sectores:",choices = c(sectores[2]))
             ),
             
             
             
             # Show a plot of the generated distribution
             mainPanel(
               tabsetPanel(
                 tabPanel(title = "En funcion del sector",
                          h4("Grafico"), 
                          plotlyOutput("grafico"),
                          h4("Valores del gráfio"), 
                          tableOutput("dat")
                 ), 
                 tabPanel(title ="En función del año", 
                          h4("Comparación entre industrias manufacteras TIC y Servicos"),
                          plotlyOutput("difindyserv"),
                          h4("Comparación entre industrias comerciales TIC e Industrias de servicios TIC"),
                          plotlyOutput("compcomserv"),
                          h4("Industrias de servicios TIC"),
                          plotlyOutput("servTIC"),
                          h4("Valores del los gráficos"),
                          tableOutput("tab")
                 )
                 
               )
             )
           )
  )#variables 
)#UI

#Seleccion de la variable 
server <- function(input, output) {
  
  #selección de la variable
  variable <- reactive ({
    input$var
  })
  
  output$dat <- renderTable({
    vari<-toString(variable())
    tabla<-nEmpresas[nEmpresas$Ramas.de.actividad.del.sector.TIC==input$sect  ,];
    tabla<-subset(tabla, select= c("periodo", "value"))
    
  })
  
  output$grafico <- renderPlotly({
    graf<-nEmpresas[nEmpresas$Ramas.de.actividad.del.sector.TIC==input$sect  ,];
    graf<-as.data.frame(graf);
    graf1<-t(t(graf[3]));
    años1<-t(t(periodo))
    
    df1 <- data.frame(años1,
                      graf1)
    ggplot(data=df1, aes(x=años1, y=graf1, group=1))+
      geom_line(color="#4f94cd")+
      geom_point(color="#00688b")+
      xlab("Años")+
      ylab("Valores")+
      theme_classic()
    
  })
  
  output$tab <- renderTable({
    tabla<-nEmpresas[nEmpresas$periodo==input$per ,];
    tabla<-subset(tabla, select=c("Ramas.de.actividad.del.sector.TIC", "value"))
    
  })
  
    output$difindyserv <- renderPlotly({
    tabla1<-nEmpresas[nEmpresas$periodo==input$per ,];
    tabla1<-tabla1[1:2,];
    tabla1<-as.data.frame(tabla1);
    dat1<-t(t(tabla1[3]));
    com1<-c("1. INDUSTRIAS MANUFACTURERAS TIC","2 SERVICIOS");
    media1<-mean(dat1)+
    theme(axis.text.x = element_text(angle=55, vjust=0.6))
    
    
    df11 <- data.frame(com1,
                       dat1)
    ggplot(data=df11, aes(x=com1, y=dat1, group=1))+
      geom_bar(stat="identity",fill="#4f94cd")+
      xlab("Sectores")+
      ylab("Valores ")+
      theme_classic()
    
    
  })
    output$compcomserv <- renderPlotly({
    tabla<-nEmpresas[nEmpresas$periodo==input$per ,];
    tabla1<-tabla[3:4,];
    tabla1[3]=tabla[2]-tabla[3];
    tabla1<-as.data.frame(tabla1);
    dat1<-t(t(tabla1[3]));
    com1<-c("2.a INDUSTRIAS COMERCIALES TIC","2.b INDUSTRIAS DE SERVICIOS TIC");
    media1<-mean(dat1)+
    theme(axis.text.x = element_text(angle=55, vjust=0.6))
    
    
    df11 <- data.frame(com1,
                       dat1)
    ggplot(data=df11, aes(x=com1, y=dat1, group=1))+
      geom_bar(stat="identity",fill="#4f94cd")+
      xlab("Sectores")+
      ylab("Valores ")+
      theme_classic()
    
    
  })
    
  
    output$servTIC <- renderPlotly({
    tabla1<-nEmpresas[nEmpresas$periodo==input$per ,];
    tabla1<-tabla1[4:8,];
    tabla1<-as.data.frame(tabla1);
    dat1<-t(t(tabla1[3]));
    com1<-c("EDICIÓN DE PROGRAMAS INFORMÁTICOS          2.b.1 ", 
            "TELECOMUNICACIONES         2.b.2", 
            "PROGRAMACIÓN, CONSULTORÍA Y OTRAS ACTIVIDADES RELACIONADAS CON LA INFORMÁTICA            2.b.3 ",
            "PORTALES WEB, PROCESAMIENTO DE DATOS, HOSTING Y ACTIVIDADES RELACIONADAS         2.b.4",
            "REPARACION DE ORDENADORES Y EQUIPOS DE COMUNICACIÓN         2.b.5 ");
    media1<-mean(dat1)
    
    
    df11 <- data.frame(com1,
                       dat1)
    ggplot(data=df11, aes(x=com1, y=dat1, group=1))+
      geom_bar(stat="identity",fill="#4f94cd")+
      xlab("Sectores")+
      ylab("Valores")+
      geom_hline(yintercept=media1, linetype="dashed", color = "coral")+
      theme_classic()+
      theme(axis.text.x = element_text(angle=25, vjust=0.6))
    
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
```