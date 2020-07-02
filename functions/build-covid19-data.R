build_covid19_data <- function(.src, .live_src){
  
  .state_data <- readr::read_csv(.src) %>% select(-fips)
  
  state_covid_data <- 
    .state_data %>% 
    bind_rows(
      readr::read_csv(.live_src) %>% select(colnames(.state_data))
    ) %>%
    filter(
      date >= as.Date("2020-03-01"),
      !(state %in% c("Northern Mariana Islands",
                     "Virgin Islands",
                     "Puerto Rico",
                     "Guam")
      )
    ) %>% 
    arrange(state, date) %>% 
    group_by(state) %>% 
    mutate(
      n_cases = cases - lag(cases),
      n_deaths = deaths - lag(deaths)
    ) %>% 
    mutate(
      n_cases = case_when(
        date == min(date) ~ cases,
        TRUE ~ n_cases
      ),
      n_deaths = case_when(
        date == min(date) ~ deaths,
        TRUE ~ n_deaths
      )
    ) %>% 
    ungroup() %>% 
    left_join(readr::read_csv("data/state_pop.csv"))
  
  
  country_covid_data <- 
    state_covid_data %>% 
    group_by(
      date
    ) %>% 
    summarise(
      n_cases = sum(n_cases),
      n_deaths = sum(n_deaths),
      pop = sum(pop)
    ) %>% 
    ungroup() %>% 
    mutate(
      state = "United States"
    )
  
  
  ans <- 
    bind_rows(
      state_covid_data,
      country_covid_data
    ) %>% 
    arrange(state, date) %>% 
    group_by(state) %>% 
    mutate(
      `7 Day Avg. Cases Per Capita` = zoo::rollmeanr(n_cases, 7, na.pad = TRUE) / pop,
      `7 Day Avg. Deaths Per Capita` = zoo::rollmeanr(n_deaths, 7, na.pad = TRUE) / pop,
      `Total Cases Per Capita` = cumsum(n_cases) / pop,
      `Total Deaths Per Capita` = cumsum(n_deaths) / pop
    ) %>% 
    ungroup() %>% 
    select(-n_cases, -n_deaths, -cases, -deaths) %>% 
    gather(key,
           value,
           -date,
           -state,
           -pop) %>% 
    group_by(state, key) %>% 
    ungroup() %>% 
    left_join(
      states_df %>% 
        bind_rows(
          tibble(
            state = c("United States", "District of Columbia"),
            abbr = c("US", "DC")
          )
        )
    ) %>% 
    mutate(
      type = case_when(
        state == "United States" ~ "US",
        TRUE ~ "States"
      )
    ) %>% 
    filter(
      value > 0
    )
  
  ans 
}
