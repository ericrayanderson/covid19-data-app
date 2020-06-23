function(input, output, session) {
    
    covid19_data <- eventReactive(session, {
        build_covid19_data(.src = data_src)
    })
    
    output$dateSource <- renderUI({
        tagList(
            paste0("Data updated: ", max(covid19_data()$date)),
            tags$br(),
            tags$a(
                href = data_src,
                target = "_blank",
                HTML("Data Source", '<i class="fa fa-external-link" aria-hidden="true"></i>')
            ),
            tags$br(),
            tags$a(
                href = data_src,
                target = "_blank",
                HTML("Source Code", '<i class="fa fa-external-link" aria-hidden="true"></i>')
            )
        )
    })
    
    
    covid19_last_data <- reactive({
        covid19_data() %>% 
            group_by(state, abbr, key) %>% 
            slice(n()) %>% 
            ungroup() %>% 
            select(date, state, abbr, key, value)
    })
    
    
    output$covid19_plotAvg <- renderPlot({
        
        main_plot(
            .covid19_data = covid19_data(), 
            .covid19_last_data = covid19_last_data(),
            .type = "Avg",
            input = input
        )
    }, bg="transparent")
    
    output$covid19_plotCumul <- renderPlot({
        
        main_plot(
            .covid19_data = covid19_data(), 
            .covid19_last_data = covid19_last_data(),
            .type = "Total",
            input = input
        )
    }, bg="transparent")
    
    
}

