library(shiny)
library(plotly)
shinyUI(
    dashboardPage(
        dashboardHeader(
            title = "Alternative Fuel Stations in the United States"
        ),
        dashboardSidebar(

            sidebarUserPanel("Fuel Statistics"),
            sidebarMenu(
                menuItem("Map", tabName = "map", icon = icon("map")),
                menuItem("EV Graphs", tabName = "EVgraphs", icon = icon("battery bolt")),
                menuItem("Fleet Graphs", tabName = "fleetgraphs", icon = icon("car")),
                menuItem("Conclusion", tabName = "conclusion", icon = icon("lightbulb")),
                menuItem("Data", tabName = "data", icon = icon("database"))
            )
        ),
        dashboardBody(
            tabItems(
                tabItem(tabName = "map",
                        fluidRow(
                            column(2,
                                checkboxGroupInput("checkGroup", label = h3("Fuel Types"), 
                                                   choices = (unique(fuels$fuel_type_code)),
                                                   selected = NULL),
                                verbatimTextOutput("value")
                                ),
                            
                            column(10,
                                box(
                                    background = 'blue',
                                    plotlyOutput("map"),
                                    height = 'auto',
                                    width = 'auto'
                                    )
                                )
                            )
                        ),
                tabItem(tabName = "EVgraphs",
                        fluidRow(
                            box(
                                background = 'blue',
                                plotOutput("hist")
                            ),
                            box(
                                background = 'blue',
                                plotOutput("hist1")
                            ),
                            hr(),
                            
                            box(
                                background = 'blue',
                                plotOutput("hist2")
                            ),
                            box(
                                background = 'blue',
                                plotOutput("hist3")
                            )
                        )),
                tabItem(tabName = "fleetgraphs",
                        fluidRow(
                            selectizeInput('cartype',
                                label = 'Fuel Type',
                                choices = unique(vehicles$fuel_type_code)),
                            box(
                                background = 'blue',
                                plotOutput("fleet"),
                                width = 12
                            )
                        )),
                tabItem(tabName = "conclusion",
                        fluidRow(
                            h1('Conclusion'),
                            h2('Landscape of Fuel Stations'),
                            h4('E85, LPG, and ELEC stations are well dispersed across the US with the necessary infrastructure to support a fleet.'),
                            h4('The fuel stations that aren\'t well established are more concentrated in more energy-productive areas.'),
                            h4('The unestablished fuel stations are those whose required fuels are those that provide only marginal carbon emission improvements\
                            or who\'s infrastructure is premature'),
                            h2('Landscape of EV charging stations'),
                            h4('Level 2 chargers are the most common. DC chargers require costly infrastructure, and level 1 chargers are highly myopic'),
                            h4('Proliferation of public chargers needed to addrss range anxiety.'),
                            h2('Landscape of Fleet'),
                            h4('EV vehicles ar becoming more common as fueling infrastructure proliferates.'),
                            h4('Struggling fuel type still face the Chicken and Egg problem, so long as policy remains the same.')
                        
                        )),
                tabItem(tabName = "data",
                        fluidRow(box(DT::dataTableOutput("table"), width = 12)),
                        fluidRow(box(DT::dataTableOutput("table1"), width = 12))
                        )
                )
        ))
)
    
    

        
        
