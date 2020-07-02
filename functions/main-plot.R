main_plot <- function(.covid19_data, .covid19_last_data, .type, input){
  
  
  gg_color_hue <- function(n) {
    hues = seq(15, 375, length = n + 1)
    hcl(h = hues, l = 65, c = 100)[1:n]
  }
  
  
  .colors <- 
    .covid19_data %>%
    distinct(abbr) %>%
    mutate(col = gg_color_hue(n()))
  
  plot_data <- .covid19_data %>% filter(grepl(.type, key))
  last_data <- .covid19_last_data %>% filter(grepl(.type, key))
  
  
  if(!is.null(input$statesShow)){
    plot_data <-
      plot_data %>% 
      filter(
        state %in% c("United States", input$statesShow)
      )
  } else {
    plot_data <-
      plot_data %>% 
      filter(
        state %in% c("United States")
      ) 
  }
  
  .colors <- .colors %>% filter(abbr %in% plot_data$abbr)
  .colors_c <- .colors$col
  names(.colors_c) <- .colors$abbr
  
  ans <- 
    ggplot(
      data = plot_data,
      aes(x = date, y = value)
    ) + 
    geom_line(aes(color = abbr, size = type)) +
    geom_line(
      data = plot_data %>% filter(state == "United States"),
      aes(size = type), color = "black", show.legend = FALSE) +
    scale_color_manual(values = .colors_c) + 
    scale_alpha_manual(values = c(1, .5)) +
    scale_size_manual(values = c("US" = 2, "States" = 1), guide = FALSE) + 
    theme_classic(base_size = 18) +
    guides(color = FALSE) + 
    theme(axis.text.y = element_blank(),
          axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          legend.title = element_blank(),
          panel.grid = element_blank(),
          panel.grid.minor = element_blank(), 
          panel.grid.major = element_blank(),
          panel.background = element_blank(),
          plot.background = element_blank(),
          legend.position = "top",
          legend.background = element_blank())
  
  
  if(!is.null(input$statesShow)){
    ans <- ans + 
      geom_point(
        data = last_data %>% 
          filter(
            state %in% c("United States", input$statesShow)
          ),
        aes(x = date, y = value, label = abbr, color = abbr),
        size = 8,
        show.legend = FALSE
      ) +
      geom_text(
        data = last_data %>% 
          filter(
            state %in% c("United States", input$statesShow)
          ),
        aes(x = date, y = value, label = abbr),
        color = "white",
        size = 4,
        show.legend = FALSE,
        alpha = 1
      )
    
  }
  ans <- ans + 
    geom_point(
      data = last_data %>% 
        filter(
          state %in% c("United States")
        ),
      aes(x = date, y = value, color = abbr),
      color = "black",
      size = 8,
      show.legend = FALSE,
      alpha = 1
    ) +
    geom_text(
      data = last_data %>% 
        filter(
          state %in% c("United States")
        ),
      aes(x = date, y = value, label = abbr),
      color = "white",
      size = 4,
      show.legend = FALSE,
      alpha = 1
    ) +
    facet_wrap(~key, nrow = 2, scales="free_y")
  
  if(input$logScale){
    ans <- ans + scale_y_log10()
  }
  return(ans)
}
