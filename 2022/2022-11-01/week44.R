## Read in data

horror_movies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv')


## Libraries ----

library(here)
library(tidyverse)
library(showtext)
library(ggimage)
library(patchwork)
library(tidytext)


# define project paths
here::i_am(path = "2022/2022-11-01/week44.R")

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

main_title <- "Placeholder"
sub_title <- "Placeholder"
info_text <- "#TidyTuesday week 44, 2022 | Data: https://github.com/tashapiro/horror-movies | @JalkanenTero"


### Colors ---

font_color <- "#ff0000"
bg_color <- "#000000"

## Theme -----

plot_theme <- theme(axis.text = element_text(color = font_color, size = 40, family = family_other),
                    plot.caption = element_text(color = font_color, face = "bold", size = 15, family = family_other),
                    plot.title = element_text(color = font_color, face = "bold", size = 105, hjust = 0.5, family = family_title),
                    plot.subtitle = element_text(color = font_color, face = "italic", size = 95, hjust = 0.5, family = family_other),
                    plot.background = element_rect(fill = bg_color),
                    panel.background = element_rect(fill = bg_color)
)


## Modify data -----
finnish_movies <- horror_movies %>% 
  filter(original_language == "fi")

tidy_overviews <- finnish_movies %>% 
  select(original_title, overview) %>% 
  filter(!is.na(overview)) %>% 
  unnest_tokens(word, input = overview)

## The plots --------

data.frame(x = 1:10, y =1:10) %>% 
  ggplot(aes(x,y)) +
  geom_point(color = font_color) +
  ggtitle("Test", subtitle = "test test") +
  plot_theme
