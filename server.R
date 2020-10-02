library(DT)
library(gdata)
library(data.table)
library(leaflet)
library(ggplot2)
library(dplyr)
library(magrittr)
library(lubridate)
library(readr)
#okkkk Comit

##Commit 2 Branch

##SECOND BRANCH

options(shiny.maxRequestSize=10000000000*1024^2) #pour les data du grande taille


server <- shinyServer(function(input, output, session) {

  ##################### Importer la base ################
 
    dat <- read_csv("AviationDataEnd2016UP.csv")
 
  output$cont <- renderDataTable({
    
    head(dat, n = input$obs)
  })
  
  ########### fonction Time #################
  
  
  output$currentTime <- renderText({
    invalidateLater(1000, session)
    paste("The current time is", Sys.time())
  })
  
  
  ##############INPUTS###############
 
  output$mapVars = renderUI(
    awesomeCheckboxGroup(inputId = "mapVars", 
                         label = "Choose type of investigation", choices =  c("Accident", "Incident"), selected = "Accident", 
                         inline = TRUE, status = "warning")
  )
  
  output$Country = renderUI(
    selectInput('Country',
                'Choose a Country',
                c(levels(as.factor(dat$Country)),"All"),
                "All")
  )
  
  ############### modifier notre base selon "type of investigation" ###############
  miniBase<-reactive({
   
   # d<- subset(dat,dat[,Investigation.Type] %in% c(input$mapVars))
    d <- dat %>% filter(Investigation.Type == input$mapVars)
   
    return(d)
    
  })
  
  
  ##############Map function##################
  
  output$mymap <- renderLeaflet({
  base<- miniBase()
  leaflet(data = base) %>% addTiles() %>%
    addMarkers(~Longitude, ~Latitude, popup = ~as.character(Country), label = ~as.character(Country))
  leaflet(data = base) %>% addTiles() %>% addMarkers(
    clusterOptions = markerClusterOptions())
  
  })
  
  
  #############################data explorer#################

   accident<-dat
   accident$Year <- year(accident$Event.Date) %>% as.integer()
   accident <- select(accident, Total.Fatal.Injuries, Year, Purpose.of.Flight,
                     Aircraft.Damage, Report.Status, Country, Aircraft.Category, Amateur.Built) 
   
   accident$Amateur.Built  %<>%  as.factor()
  
     
     # Filter the accident, returning a data frame
     getaccident <- reactive({
       f <- accident %>% filter(
         Total.Fatal.Injuries > input$fatalInjuries, 
         Year > input$year[1],
         Year < input$year[2]
       )
       
       if (input$purposeFlight != "All") {
         f <- f %>% filter(Purpose.of.Flight == input$purposeFlight)
       }
       if (input$aircraftDamage != "All") {
         f <- f %>% filter(Aircraft.Damage == input$aircraftDamage)
       }
       if (input$reportStatus != "All") {
         f <- f %>% filter(Report.Status == input$reportStatus)
       }
       if (input$Country!= "All" ) {
         f <- f %>% filter(Country == input$Country)
       }
       if (input$aircraftCategory != "All") {
         f <- f %>% filter(Aircraft.Category == input$aircraftCategory)
       }
       
       return(f)
     })
     
     output$plot1 <- renderPlot({
       myaccident <- getaccident()
       ggplot(myaccident, aes(x = Year)) +
         geom_bar(aes(fill = Amateur.Built), position = "stack") + 
         xlab("Year") + 
         ylab("Accidents")
       
     })
     output$n_accident <- renderText({
       myaccident <- getaccident()
       nrow(myaccident) 
     })
     
   
 
})