dashboardPage(
    skin = "purple", 
    dashboardHeader(title = "COVID-19 Data"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        fluidRow(
            column(
                width = 10,
                selectInput(
                    "statesShow", 
                    label = "States",
                    choices = states, 
                    selected = c("New York", "Florida"),
                    multiple = TRUE,
                    width = "100%"
                ) 
            ),
            column(
                width = 2,
                uiOutput("dateSource")
            )
        ),
        fluidRow(
            column(
                width = 6,
                plotOutput("covid19_plotAvg", height = 525)
            ),
            column(
                width = 6,
                plotOutput("covid19_plotCumul", height = 525)
            )
        )
    )
)


