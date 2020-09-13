function(input, output, session) {
    
    covid19_data <- eventReactive(session, {
        shiny::withProgress(message = "Downloading data...", {
            build_covid19_data(.src = data_src, .live_src = live_data_src)
        })
    })
    
    output$dateSource <- renderUI({
        tags$h4(
            icon("calendar"),
            "Updated: ",
            max(covid19_data()$date)
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
    
    output$covid19_barPlotAvgCases <- renderPlot({
        
        bar_plot(
            .covid19_last_data = covid19_last_data(),
            .type = "Avg. Cases"
        )
    }, bg="transparent")
    
    output$covid19_barPlotAvgDeaths <- renderPlot({
        
        bar_plot(
            .covid19_last_data = covid19_last_data(),
            .type = "Avg. Deaths"
        )
    }, bg="transparent")
    
    output$covid19_barPlotTotalCases <- renderPlot({
        
        bar_plot(
            .covid19_last_data = covid19_last_data(),
            .type = "Total Cases"
        )
    }, bg="transparent")
    
    output$covid19_barPlotTotalDeaths <- renderPlot({
        
        bar_plot(
            .covid19_last_data = covid19_last_data(),
            .type = "Total Deaths"
        )
    }, bg="transparent")
    
    
    
}

