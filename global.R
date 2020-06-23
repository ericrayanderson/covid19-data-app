
library(tidyverse)
library(shinydashboard)

states_df <- readr::read_csv("states.csv")

data_src <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"

states <- states_df$state

states <- states[states!="United States"]

lapply(
  list.files("functions", full.names = TRUE),
  source
)
