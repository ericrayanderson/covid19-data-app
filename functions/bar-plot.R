bar_plot <- function(.covid19_last_data, .type, input){
  gg_color_hue <- function(n) {
    hues = seq(15, 375, length = n + 1)
    hcl(h = hues, l = 65, c = 100)[1:n]
  }
  
  
  .colors <- 
    .covid19_last_data %>%
    distinct(abbr) %>%
    mutate(col = gg_color_hue(n()))
  
  last_data <- .covid19_last_data %>% filter(grepl(.type, key))
  
  if(!is.null(input$statesShow)){
    last_data <-
      last_data %>% 
      filter(
        state %in% c("United States", input$statesShow)
      )
  } else {
    last_data <-
      last_data %>% 
      filter(
        state %in% c("United States")
      ) 
  }
  
  .colors <- .colors %>% filter(abbr %in% last_data$abbr)
  .colors_c <- .colors$col
  names(.colors_c) <- .colors$abbr
  
  
  last_data <-
    last_data %>% arrange(-value) %>% mutate(abbr = forcats::fct_inorder(abbr))
  
  ans <- 
  ggplot(
    last_data,
    aes(
      x = abbr,
      y = value,
      label = abbr,
      fill = abbr
    )
  ) +
    scale_fill_manual(values = .colors_c) + 
    geom_bar(stat = "identity", alpha = .5) + 
    geom_bar(
      data = last_data %>% filter(abbr == "US"),
      stat = "identity",
      fill = "black",
      show.legend = FALSE) +
    geom_label(size=5, alpha = 1, color = "white") +
    geom_label(size=5, 
               data = last_data %>% filter(abbr == "US"),
               color = "white",
               fill = "black",
               alpha = 1) +
    theme_classic(base_size = 16) +
    theme(axis.text.y = element_blank(),
          axis.text.x = element_text(angle = 90,size = 8),
          axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          panel.grid = element_blank(),
          panel.grid.minor = element_blank(), 
          panel.grid.major = element_blank(),
          panel.background = element_blank(),
          plot.background = element_blank(),
          legend.position = "none") +
    facet_wrap(~key, nrow = 2, scales="free_y")
  
  if(input$logScale){
    ans <- ans + scale_y_log10()
  }
  
  ans
  
}
