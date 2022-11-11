### Tidy tuesday - 2022 week 45
## Author: Tero Jalkanen


## Libraries ----

library(showtext)
library(here)
library(tidyverse)
library(patchwork)
library(rvest)
library(statebins)
library(gt)
library(gtExtras)

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
  mutate(state = stringr::str_trim(string = state, side = "left"))


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
font_add_google("Black Ops One")
font_add_google("Gruppo")
# add font automatically
showtext_auto()
family_title <- "Black Ops One"
family_other <- "Gruppo"

## Texts ----

### Picture attribution
# star

main_title <- "Radio Stations in Different States"
info_text <- "#TidyTuesday week 45, 2022 | Data: from Wikipedia by @frankiethull and @erindataviz | Viz: @JalkanenTero"


### Colors ---

font_color <- "#000000"


## The plots --------

title_plot <- ggplot() +
  geom_text(data = data.frame(x = 0, y = 0, label = main_title), 
            aes(x = x, y= y, label = label), color = font_color, size = 25, family = family_title) +
  theme_void() +
  theme(axis.text.x = element_blank(), 
        axis.ticks.x = element_blank(), text = element_text(face = "bold"))

map_plot <- states_radio_density %>% 
  statebins(value_col="radio_station_density", font_size = 12) +
  theme_statebins(legend_position="bottom") +
  viridis::scale_fill_viridis(option = "A") +
  labs(fill = "Density of stations per 1000 inhabitants") +
  theme(text = element_text(size = 20, family = family_other))

sub_plot <- ggplot() +
  geom_text(data = data.frame(x = 0, y = 0, label = info_text), 
            aes(x = x, y= y, label = label), color = font_color, size = 10, family = family_other) +
  theme_void() +
  theme(axis.text.x = element_blank(), 
        axis.ticks.x = element_blank())

title_plot + map_plot + sub_plot + plot_layout(nrow = 3, heights = c(2.5,17,0.5))

## Save output -----

ggsave(filename = "TidyTuesday-2022-Week45.png", 
       path = here("2022", "2022-11-08"), 
       device = "png", 
       units = "cm", 
       height = 15,
       width = 20, 
       dpi = 300)
