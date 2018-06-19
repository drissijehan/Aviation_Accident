library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(DT)
library(gdata)
library(data.table)
library(leaflet)
library(ggplot2)
library(dplyr)
library(magrittr)
library(lubridate)
library(readr)

shinyUI(tagList(
  dashboardPage(skin = "blue",
                
                dashboardHeader(title = "Aviation Accident"),
                dashboardSidebar(width = 240, sidebarMenu(
                  
                  menuItem("Instructions", tabName = "genIns", icon = icon("info-circle")),
                  menuItem("Data", tabName = "uploadData", icon = icon("table")),
                  menuItem("Data Explorer", tabName = "explore", icon = icon("bar-chart-o")),
                  menuItem("Map", tabName = "carte", icon = icon("fa fa-eercast"))
                  
                  
                )
              
                ),
                dashboardBody(
                  tabItems(
                    tabItem(tabName = "genIns",
                            fluidPage(
                              
                              titlePanel("General Instruction will go here"),
                              textOutput("currentTime"), 
                              br(),
                              box(width = 15, status = "primary",background = "navy",
                              h4("Content"),
                              h5("The NTSB aviation accident database contains information from 1962 and later about civil aviation accidents and selected incidents within the United States, 
                                 its territories and possessions, and in international waters."),
                              br(),
                              h4("Acknowledgements"),
                              h5("Generally, a preliminary report is available online within a few days of an accident. Factual information is added when available,
                                 and when the investigation is completed, the preliminary report is replaced with a final description of the accident and its probable cause.
                                 Full narrative descriptions may not be available for dates before 1993, cases under revision, or where NTSB did not have primary investigative
                                 responsibility."),
                              br(),
                              h4("Source:", a("Kaggle", href="https://www.kaggle.com/khsamaha/aviation-accident-database-synopses/data"))),
                              br(),
                              box(width = 15, status = "primary",background = "navy",
                                  h5("This Application is powered by Jehan DRISSI", a("LinkedIn", href="https://www.linkedin.com/in/jehan-drissi-360409124/"))
                              )
                              
                              
                              
                              
                              
                            )
                    ),
                    # First tab content
                    tabItem(tabName = "uploadData",
                            
                         
                            
                            
                            box(width = 15, status = "primary",background = "navy",
                                numericInput("obs", "Number of observations to view:", 50)),
                            br(),
                            fluidRow(
                              
                              
                              box( width = 30, status = "primary",
                                   div(style = 'overflow-x: scroll',dataTableOutput('cont'))))
                            
                            
                    ),
                    tabItem(tabName = "explore",
                            fluidPage(
                              titlePanel("Aviation data explorer"),
                              fluidRow(
                                column(3,
                                       wellPanel(
                                         h4("Select options"),
                                         h5("This apps allows us to analyze easily the aviation data set. Select the parameters
                                            to filter the data."),
                                         sliderInput("year", "Year of the accident", 1982, 2017, value = c(1982, 2017)),
                                         sliderInput("fatalInjuries", "At least X deaths",
                                                     0, 350, 0, step = 1),
                                         #textInput("country", "Country name"),
                                         uiOutput("Country"),
                                         selectInput("aircraftDamage", "Damage of the aircraft",
                                                     c("All", "Destroyed", "Substantial", "Minor")),
                                         selectInput("aircraftCategory", "Category of the aircraft",
                                                     c("All", "Airplane", "Balloon", "Blimp", "Glider", "Gyrocraft",
                                                       "Gyroplane", "Helicopter", "Powered-Lift", "Powered Parachute",
                                                       "Rocket", "Ultralight", "Unknown", "Weight-Shift")),
                                         selectInput("reportStatus", "Status of the report",
                                                     c("All", "Factual", "Foreign", "Preliminary", "Probable Cause")),
                                         selectInput("purposeFlight", "Purpose of the flight",
                                                     c("All", "Aerial Application", "Aerial Observation", "Air Drop", "Air Race/Show",
                                                       "Banner Tow", "Business", "Executive/Corporate", "External Load", "Ferry",
                                                       "Firefighting", "Flight Test", "Glider Tow", "Instructional",
                                                       "Other Work Use", "Personal", "Positioning", "Public Aircraft",
                                                       "Public Aircraft - Federal", "Public Aircraft - Local",
                                                       "Public Aircraft - State", "Skydiving", "Unknown"))
                                         )
                                ),
                                column(9,
                                       plotOutput("plot1"),
                                       wellPanel(
                                         span("Number of flights selected:",
                                              textOutput("n_accident")
                                         )
                                       )
                                )
                            )
                              )
                            
                            
                    ),
                    tabItem(tabName = "carte",
                      
                            
                            uiOutput("mapVars"),
                            h5("Use the Zoom for more details"),
                            leafletOutput("mymap")
                    )
                )
                  )
)))