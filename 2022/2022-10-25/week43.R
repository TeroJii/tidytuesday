## Read in data

bakers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-25/bakers.csv')
challenges <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-25/challenges.csv')
ratings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-25/ratings.csv')
episodes<- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-25/episodes.csv')


## Libraries ----

library(here)
library(tidyverse)
library(showtext)
library(ggimage)

# define project paths
here::i_am(path = "2022/2022-10-25/week43.R")


## Visualizations -----

## Get fonts
font_add_google("Lora")
# add font automatically
showtext_auto()


### Picture attribution
# star
attribution_star <- "I, Ssolbergj, CC BY 3.0 <https://creativecommons.org/licenses/by/3.0>, via Wikimedia Commons"


# get season winners
series_winners <- bakers %>% 
  select(series, baker, series_winner) %>% 
  filter(series_winner == 1)

## label series
series.label <- paste("Series", 1:10)
names(series.label) <- 1:10


# How did season winners fare in challenges?
season_winner_progression <- challenges %>% 
  filter(baker %in% series_winners$baker) %>%
  # remove David from series 1 (namesake of series 10 winner)
  filter(!(series == 1 & baker == "David")) %>% 
  mutate(technical = if_else(is.na(technical), true = 1, false = technical))


season_winner_progression %>% 
  ggplot(aes(x = episode, y = technical/2)) +
  geom_tile(width = 0.8, 
            aes(height = technical),
            # White filling on bars
            fill = "#FFFFFF") +
  geom_image(data = season_winner_progression %>% filter(result == "STAR BAKER") %>%  mutate(image = here("2022", "2022-10-25", "star.png")), 
             aes(image = image, y = technical + 1, x = episode), size = 0.05) +
  geom_text(data = season_winner_progression %>% filter(result == "WINNER"), 
             aes(label = result, y = technical + 3, x = episode), 
            angle = 90,
            color = "#FFFFFF") +
  facet_wrap(facets = "series", nrow = 2,
             # Add labels on facets
             labeller = labeller(series = series.label)) +
  scale_y_continuous(breaks = 1:12) +
  scale_x_continuous(breaks = 1:10) +
  theme(plot.background = element_rect(fill = "#006666"), 
        axis.line = element_blank(), 
        panel.background = element_rect(fill = "#006666"), 
        panel.grid = element_blank(), 
        strip.background = element_blank(), 
        axis.text.x = element_text(colour = "#FFFFFF"),
        axis.ticks.x = element_line(colour = "#FFFFFF"),
        strip.text = element_text(colour = "#FFFFFF"),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()
        )
