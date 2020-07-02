
library(tidyverse)
library(shinydashboard)

states_df <- readr::read_csv("data/states.csv")

data_src <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"
live_data_src <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/live/us-states.csv"

states <- states_df$state

states <- states[states!="United States"]

lapply(
  list.files("functions", full.names = TRUE),
  source
)
