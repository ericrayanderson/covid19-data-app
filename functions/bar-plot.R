bar_plot <- function(.covid19_last_data, .type){
  gg_color_hue <- function(n) {
    hues = seq(15, 375, length = n + 1)
    hcl(h = hues, l = 65, c = 100)[1:n]
  }
  
  
  .colors <- 
    .covid19_last_data %>%
    distinct(abbr) %>%
    mutate(col = gg_color_hue(n()))
  
  last_data <- .covid19_last_data %>% filter(grepl(.type, key))
  
  .colors <- .colors %>% filter(abbr %in% last_data$abbr)
  .colors_c <- .colors$col
  names(.colors_c) <- .colors$abbr
  
  ggplot(
    last_data %>% arrange(-value) %>% mutate(abbr1 = forcats::fct_inorder(abbr)),
    aes(
      x = abbr1,
      y = value,
      label = abbr,
      fill = abbr
    )
  ) +
    scale_fill_manual(values = .colors_c) + 
    geom_bar(stat = "identity", alpha = .5) + 
    geom_label(size=3, alpha = .5) +
    theme_classic(base_size = 14) +
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
  
}
