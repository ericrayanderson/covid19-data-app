dashboardPage(
    skin = "purple", 
    dashboardHeader(title = "COVID-19 Data"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        fluidRow(
            column(
                width = 6,
                shinyWidgets::pickerInput(
                    inputId = "statesShow", 
                    label = "View States", 
                    choices = states, 
                    selected = c("Connecticut", "Florida"),
                    options = list(
                        `actions-box` = TRUE, 
                        size = 10,
                        `selected-text-format` = "count > 8"
                    ), 
                    multiple = TRUE, width = "100%"
                )
            ),
            column(
                width = 2,
                shinyWidgets::switchInput(inputId = "logScale",
                                          label = "Log Scale",
                                          value = TRUE)
                
            ),
            column(
                width = 2,
                uiOutput("dateSource")
            ),
            column(
                width = 2,
                tags$a(
                    href = data_src,
                    target = "_blank",
                    HTML("Data Source", '<i class="fa fa-external-link" aria-hidden="true"></i>')
                ),
                tags$br(),
                tags$a(
                    href = "https://github.com/ericrayanderson/covid19-data-app",
                    target = "_blank",
                    HTML("Source Code", '<i class="fa fa-external-link" aria-hidden="true"></i>')
                )
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


