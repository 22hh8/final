library(shiny)
library(shinydashboard)
library(ggplot2)

dashboardPage(title="Artworks at the Tate",
              # Header
              dashboardHeader(title = "Artworks at the Tate"),
              
              dashboardSidebar(
                sidebarMenu(id ="sidebarid",
                    menuItem("About",tabName="about"),
                    menuItem("Plots", tabName = "plots",icon = icon("bar-chart-o")),
                    menuItem("Data", tabName = "data",icon = icon("dashboard")),
                    conditionalPanel('input.sidebarid == "plots"', 
                                     sliderInput("date", label = h3("Select Year Range:"), min = 1823, 
                                                 max = 2013, value = c(1823,1923), sep="",
                                                 animate = animationOptions(interval = 1000))
                    ),
                    conditionalPanel('input.sidebarid == "data"', 
                                     sliderInput("date1", label = h3("Select Year Range:"), min = 1823, 
                                                 max = 2013, value =c(1823,1923), sep="",
                                                 animate = animationOptions(interval = 1000))
                    )
                  )
                ),
              
              dashboardBody(
                  
                tabItems(
                  tabItem(tabName = "plots",
                          h2("Plots"),
                          fluidRow(
                            box("Distribution of Artists' Gender",plotOutput("gender")),
                            box("Distribution of Artworks by Time Period", plotOutput("year")),
                            valueBoxOutput("artist"),
                            valueBoxOutput("count"),
                            valueBoxOutput("total")
                          ),
                          fluidRow(
                            box("Top 5 Art Mediums",plotOutput("medium")),
                            box("Inscriptions on Art",plotOutput("inscription"))
                          )
                  ),
                  tabItem(tabName = "data",
                          h2("Data"),
                          DT::dataTableOutput("tate")
                  ),
                  tabItem(tabName = "about",
                          h2("About"),
                          h4("For my final project, I decided to visualize how the artwork collection changed over time
                              at the Tate Gallery in the UK. I obtained my data from the Tate Gallery's GitHub. Please note 
                              that the dataset is no longer being updated and the most recent update occurred in 2014."),
                          h4("I created a dataset using the two datasets on the Tate Gallery's Github. I noticed that there were
                             many duplicate artworks. If the artworks had the same artist ID, year produced, medium, dimension, 
                             and acquistion Year I considered them the same artwork that was registered twice possibly as it was
                             being moved from the collection to the archives.")
                    
                  )
                )
              )
)

