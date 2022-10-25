## Read in data

bakers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-25/bakers.csv')
challenges <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-25/challenges.csv')
ratings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-25/ratings.csv')
episodes<- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-25/episodes.csv')


## Libraries ----

library(tidyverse)
library(showtext)



## Visualizations -----

## Get fonts
font_add_google("Lora")
# add font automatically
showtext_auto()

# get season winners
series_winners <- bakers %>% 
  select(series, baker, series_winner) %>% 
  filter(series_winner == 1)

## label series
series.label <- paste("Series", 1:10)
names(series.label) <- 1:10


# How did season winners fare in challenges?
challenges %>% 
  filter(baker %in% series_winners$baker) %>%
  # remove David from series 1 (namesake of series 10 winner)
  filter(!(series == 1 & baker == "David")) %>% 
  ggplot(aes(x = episode, y = technical/2)) +
  geom_tile(width = 0.8, 
            aes(height = technical),
            # White filling on bars
            fill = "#FFFFFF") +
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
