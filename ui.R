dashboardPage(title = "COVID-19 Data",
    skin = "purple", 
    dashboardHeader(
        title = tagList(
            "COVID-19 Data ",
            tags$a(
                class = "text-right",
                style = "color:white",
                href = "https://github.com/ericrayanderson/covid19-data-app",
                target = "_blank",
                icon("github")
            )
        ),
        titleWidth = 275),
    dashboardSidebar(
        width = 275,
        tags$br(),
        fluidRow(
            column(
                width = 11,
                offset = 1,
                uiOutput("dateSource")
            )
        ),
        
        shinyWidgets::pickerInput(
            inputId = "statesShow", 
            label = "", 
            choices = states, 
            selected = c("Connecticut", "Florida"),
            options = list(
                `actions-box` = TRUE, 
                size = 10,
                `selected-text-format` = "count > 3"
            ), 
            multiple = TRUE, 
            width = "100%"
        ),
        shinyWidgets::switchInput(inputId = "logScale",
                                  label = "Log Scale",
                                  value = FALSE)
        
    ),
    dashboardBody(
        fluidRow(
            column(
                width = 6,
                plotOutput("covid19_plotAvg", height = 525)
            ),
            column(
                width = 6,
                plotOutput("covid19_plotCumul", height = 525)
            )
        ),
        fluidRow(
            column(
                width = 6,
                plotOutput("covid19_barPlotAvgCases", height = 525)
            ),
            column(
                width = 6,
                plotOutput("covid19_barPlotAvgDeaths", height = 525)
            )
        ),
        tags$hr(),
        fluidRow(
            column(
                width = 6,
                plotOutput("covid19_barPlotTotalCases", height = 525)
            ),
            column(
                width = 6,
                plotOutput("covid19_barPlotTotalDeaths", height = 525)
            )
        ),
        tags$br(),
        tags$a(
            target = "_blank",
            href = "https://github.com/nytimes/covid-19-data",
            "Data source: https://github.com/nytimes/covid-19-data"
        )
    )
)

