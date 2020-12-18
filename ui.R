library(shiny)
library(shinydashboard)
library(ggplot2)

dashboardPage(title="Artworks at the Tate",
              # Header
              dashboardHeader(title = "Artworks at the Tate"),
              
              dashboardSidebar(
                sidebarMenu(
                  menuItem("About",tabName="about"),
                  menuItem("Plots", tabName = "plots"),
                  menuItem("Data", tabName = "data")
                ),
                # Hide Slider during About/make slider a range
                sliderInput("date", label = h3("Select Year:"), min = 1823, 
                            max = 2013, value = 1823, sep="",
                            animate = animationOptions(interval = 1000))
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
                              that the dataset is no longer being updated and the most recent update occurred in 2014.")
                    
                  )
                )
              )
)

