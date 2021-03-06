# UI file for shiny

library(dplyr)
library(plotly)
library(shiny)
library(leaflet)
library(shinythemes)


# Get the unique city names & unique incident types of King County Sheriff's Office
parent_incident_type.vector <- sort(unique(data$parent_incident_type))
parent_incident_type.list <- as.list(parent_incident_type.vector)
cities.vector <- sort(unique(police.call.data$city))

# Turn cities vector into a list so it can be used for the selectInput drop down choices
cities.list <- as.list(cities.vector)
names(cities.list) <- cities.vector # Set list elements names to city names

# Shiny app
shinyUI(fluidPage(

  # Browser tab name display
  title = "KC Sheriff Activity",

  navbarPage(title = p(strong(em("King County Sheriff Activity"))),
             theme = shinytheme("sandstone"),

             tabPanel("Home",
                      sidebarLayout(
                        sidebarPanel (
                          tags$img(src = "homepage-badge-sheriff.jpg", height = "100%", width = "100%"),
                          tags$img(src = "King.County.Sheriff.Logo.jpg", height = "100%", width = "100%")
                        ),

                        mainPanel(
                          includeMarkdown("HomePage.Rmd")
                          )
                        )
                      ),

             tabPanel("Incident Map",

                        div(class = "outer",
                            tags$head(
                              includeCSS("aaron_styles.css")),


                          leafletOutput("aaron_map", height = "100%"),

                          # Moveable user interaction that enables them to filter for desired map representation
                          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                        draggable = TRUE, top = 250, left = 50, right = "auto", bottom = "auto",
                                        width = 275, height = "auto", opacity = 0.6,

                                        h1("King County Sheriff Activity"),

                                        selectInput("aaron_select_crime", h3("Type of Crime"),
                                                    choices = c("All", data$parent_incident_type), width = "100%"),

                                        selectInput("aaron_select_city", h3("City"), choices = c("All", data$city), width = "100%"),

                                        sliderInput("range", h3("Range of Years"), min = 2000, max = 2017,
                                                   sep = "", value = c(2000, 2017)
                                                   )
                                        )
                          )
                      ),

             tabPanel("Incidents by Time of Day",
                      h1("Police Call Activity by Time"),

                      # Sidebar with a slider input desired city data
                      sidebarLayout(
                        sidebarPanel(
                          selectInput('city.choice', "What city do you want to see?",
                                      choices = cities.list)
                        ),

                        # Show a plot and data table of police calls
                        mainPanel(
                          plotlyOutput("city.graph"),
                          DT::dataTableOutput("city.table")
                        )
                      )
                       ),

             tabPanel("Incidents by Week Day",
                      h1("KC Sheriff Activity During the Week"),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput('parent_incident_type', 'Crime Type', choices = parent_incident_type.list)),

                      mainPanel(
                        plotlyOutput("keivon_pie")
                                )
                        )
                      ),

             tabPanel("Incidents by City",
                      h1("Crime by City Reported to King County"),

                      # Radio buttons
                      sidebarLayout(
                        sidebarPanel(

                          selectInput('omidcityname', 'City', choices = cities.list)
                        ),
                        mainPanel(
                                  plotlyOutput("omidscatter"),
                                  br(),
                                  p("This is an interactive graph that displays crime information for user-selected cities in reported King County.", align = "center"),
                                  br(),
                                  p("Working with this data helped us gain valuable insights into the spatial differences in the types of crimes perpetuated. For instance-
                                    Seattle had a more balanced crime profile to Burien which had far more proprty crimes than any other crime. In the data available- it's also
                                    interesting to see that Property Crimes are higher than other crimes from almost all cities selected. We decided to further explore this- and
                                    discovered this could be attributed to the county's growing poverty population.  ", align = "center")
                                  )
                        )
                      ),

             tabPanel("Our Team",
                      includeMarkdown("OurTeam.Rmd")
                    )

  )
))
