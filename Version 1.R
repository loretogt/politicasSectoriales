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
               selectInput("sect","Sectores:",choices = c(sectores[2])),
               selectInput("per","Periodo:",choices = c(periodo))
               
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
                          h4("Industrias de servicios TIC"),
                          plotlyOutput("servTIC"),
                          h4("Valores del los gráficos"),
                          tableOutput("tab")
                 )
                 
               )
               
             )
             
           )
  ),
  tabPanel("Descargas",
           selectInput("dataset", "Escoge una Variable:",width ='1000px',
                       choices = c("Número de empresas en el sector TIC por ramas de actividad del sector TIC y periodo" ="nEmpresas", 
                             "Cifra de negocios en el sector TIC por ramas de actividad del sector TIC y periodo" ="cifraNeg", 
                             "Valor añadido en el sector TIC por ramas de actividad del sector TIC y periodo"= "vAñadido",
                             "Número de ocupados en el sector TIC por ramas de actividad del sector TIC y periodo"="nOcupados")),
           fluidRow(
             
             column(5, 
                    wellPanel(
                      h4("Descargar Variable seleccionada en Rdata"),
                      downloadButton("descargarRdat", label = "Descargar")
                    )
             ),
             column(5,
                    wellPanel(
                      h4("Descargar la variable seleccionada en csv"),
                      downloadButton("descargarVariables", label = "Descargar")
                    )
             ),
             column(5,
                    wellPanel(
                      h4("Descargar el código"),
                      downloadButton("descargarCodigo", label = "Descargar")
                    )
             ),
             
             column(5,
                    wellPanel(
                      h4("Descargar el protocolo"),
                      downloadButton("descargarProtocolo", label = "Descargar")
                    )
             ),
             column(5,
                    wellPanel(
                      h4("Descargar el informe"),
                      downloadButton("descargarInforme", label = "Descargar")
                    )
             )
             
           )
           
  )
)#UI

#Seleccion de la variable 
server <- function(input, output) {
  
  #selección de la variable
  variable <- reactive ({
    # if (input$var== "nEmpresas"){
    #   filtrado= filter(nEmpresas, input$sect %in% nEmpresas$Ramas.de.actividad.del.sector.TIC )
    # }
    if (input$var== "nEmpresas") {
      filtrado = nEmpresas
    }
    if (input$var == "cifraNeg") {
      filtrado = cifraNeg
    }
    if (input$var == "vAñadido") {
      filtrado = vAñadido
    }
    if (input$var == "nOcupados") {
      filtrado = nOcupados
    }
    
    return(filtrado
    )
  })
  
  output$dat <- renderTable({
    var=variable()
    tabla<-var[var$Ramas.de.actividad.del.sector.TIC==input$sect,];
    tabla<-subset(tabla, select= c("periodo", "value"))
    
  })
  
  output$grafico <- renderPlotly({
    var=variable()
    graf<-var[var$Ramas.de.actividad.del.sector.TIC==input$sect  ,];
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
    var=variable()
    tabla<-var[var$periodo==input$per ,];
    tabla<-subset(tabla, select=c("Ramas.de.actividad.del.sector.TIC", "value"))
    
  })
  
  output$difindyserv <- renderPlotly({
    var=variable()
    tabla1<-var[var$periodo==input$per ,];
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

  
  
  output$servTIC <- renderPlotly({
    var=variable()
    tabla1<-var[var$periodo==input$per ,];
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
    ######### DESCARGAS ########
  

  output$descargarRdat <- downloadHandler(
    filename = "variable.Rdata",
    content = function(file) {
      if (input$dataset == "nEmpresas"){
        write.table(nEmpresas[], file, row.names = FALSE)
      }
      if (input$dataset == "cifraNeg"){
        write.table(cifraNeg[], file, row.names = FALSE)
      }
      if (input$dataset == "vAñadido"){
        write.table(vAñadido[], file, row.names = FALSE)
      }
      if (input$dataset == "nOcupados"){
        write.table(nOcupados[], file, row.names = FALSE)
      }
      
    }
  )
  
  #Aqui hay que poner la direccion donde se encuentra el codigo en el ordenador 
  output$descargarCodigo <- downloadHandler(
    filename = "codigo.R",
    content = function(file) {
      file.copy("", file)
    }
  )
  #Aqui hay que poner la direccion donde se encuentra el codigo en el ordenador 
  output$ descargarProtocolo <- downloadHandler(
    filename = "protocolo.html",
    content = function(file) {
      file.copy("", file)
    }
  )
  #Aqui hay que poner la direccion donde se encuentra el codigo en el ordenador 
  output$ descargarInforme <- downloadHandler(
    filename = "informe.pdf",
    content = function(file) {
      file.copy("", file)
    }
  )
  
  
  output$descargarVariables <- downloadHandler(
    filename = "variable.csv",
    content = function(file) {
      if (input$dataset == "nEmpresas"){
        write.csv(nEmpresas[], file, row.names = FALSE)
      }
      if (input$dataset == "cifraNeg"){
        write.csv(cifraNeg[], file, row.names = FALSE)
      }
      if (input$dataset == "vAñadido"){
        write.csv(vAñadido[], file, row.names = FALSE)
      }
      if (input$dataset == "nOcupados"){
        write.csv(nOcupados[], file, row.names = FALSE)
      }
      
    }
  )
  
}

# Run the application
shinyApp(ui = ui, server = server)
```