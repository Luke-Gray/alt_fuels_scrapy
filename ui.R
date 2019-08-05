library(shiny)
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
                                plotOutput("hist")
                            ),
                            box(
                                plotOutput("hist1")
                            ),
                            hr(),
                            
                            box(
                                plotOutput("hist2")
                            ),
                            box(
                                plotOutput("hist3")
                            )
                        )),
                tabItem(tabName = "fleetgraphs",
                        fluidRow(
                            selectizeInput('cartype',
                                label = 'Fuel Type',
                                choices = unique(vehicles$fuel_type_code)),
                            box(
                                plotOutput("fleet"),
                                width = 12
                            )
                        )),
                tabItem(tabName = "data",
                        fluidRow(box(DT::dataTableOutput("table"), width = 12)),
                        fluidRow(box(DT::dataTableOutput("table1"), width = 12))
                        )
                )
        ))
)
    
    

        
        
