### Tidy tuesday - 2022 week 45
## Author: Tero Jalkanen


## Libraries ----

library(here)
library(tidyverse)
library(patchwork)
library(rvest)


#library(ggmap)
library(statebins)
#library(sf)


# define project paths
here::i_am(path = "2022/2022-11-08/week45.R")

## Read in data

state_stations <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-08/state_stations.csv')


# Population of US states from Wikipedia
state_population <- read_html("https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population")

# Extract table info part 1
pop_table_states <- state_population %>% 
  html_nodes("tr th") %>% 
  html_text()

## Extract states and territories starting from line 23 (56 states + territories)
pop_table_states <- pop_table_states[23:(23+55)]

# Extract table info part 2
pop_table_pop <- state_population %>% 
  html_nodes("tr td") %>% 
  html_text()

# data in 15 columns per row / 56 lines for states and areas
pop_table_pop <- pop_table_pop %>% head(56*15) %>% matrix(ncol = 15, byrow = T)


## Combine state names and 2021 Census data

states_pop <- tibble("state" = pop_table_states, "population" = pop_table_pop[,3]) %>% 
  # Remove rows with "N/A"
  filter(!grepl("N/A", x = population)) %>% 
  # Remove "\n" from state and population columns
  mutate(state = gsub(pattern = "\\n", replacement = "", x = state),
         population = gsub(pattern = "\\n", replacement = "", x = population)) %>% 
  # remove commas from population and make numeric
  mutate(population = gsub(pattern = ",", replacement = "", x = population) %>% as.numeric()) %>% 
  # remove whitespace from the beginning of state name
  mutate(state = stringr::str_trim(string = states_pop$state, side = "left"))


## Modify data -----

states_radio_density <- state_stations %>% 
  mutate(state = gsub(pattern = "_", replacement = " ", x = state)) %>% 
  group_by(state) %>% 
  count() %>% 
  ## add state populations
  left_join(states_pop, by = "state") %>%
  # radio station density per 1000 inhabitants
  mutate(radio_station_density = 1000* n / population)
  


#############
## Creating the visualization -----
#######

## Get fonts
font_add_google("Frijole")
font_add_google("Kolker Brush")
# add font automatically
showtext_auto()
family_title <- "Frijole"
family_other <- "Kolker Brush"

## Texts ----

### Picture attribution
# star

main_title <- "Place holder"
sub_title <- "nnn"
info_text <- "#TidyTuesday week 45, 2022 | Data: DATACREDIT | @JalkanenTero"


### Colors ---

font_color <- "#ff0000"
bg_color <- "#000000"


## Theme -----

plot_theme <- theme(axis.text = element_text(color = font_color, size = 50, family = family_other),
                    axis.title = element_text(color = font_color, size = 45, family = family_other),
                    plot.caption = element_text(color = font_color, face = "bold", size = 45, family = family_other),
                    plot.title = element_text(color = font_color, face = "bold", size = 40, hjust = 0.5, family = family_title, lineheight = 0.5),
                    plot.background = element_rect(fill = bg_color),
                    panel.background = element_rect(fill = bg_color),
                    strip.background = element_rect(fill = bg_color),
                    strip.text = element_text(family = family_other, color = font_color, size = 50)
)



## The plots --------

states_radio_density %>% 
  statebins(value_col="radio_station_density") +
  theme_statebins(legend_position="bottom") +
  viridis::scale_fill_viridis(option = "A") +
  labs(fill = "Density of stations per 1000 inhabitants")


## Save output -----

ggsave(filename = "TidyTuesday-2022-Week45.png", 
       path = here("2022", "2022-11-08"), 
       device = "png", 
       units = "cm", 
       height = 15,
       width = 15, 
       dpi = 300)
