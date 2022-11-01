## Read in data

horror_movies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv')


## Libraries ----

library(here)
library(tidyverse)
library(showtext)
library(ggimage)
library(patchwork)

# define project paths
here::i_am(path = "2022/2022-10-25/week44.R")

#############
## Creating the visualization -----
#######


## Get fonts
font_add_google("Cinzel")
# add font automatically
showtext_auto()
family <- "Cinzel"

## Texts ----

### Picture attribution
# star

main_title <- "Placeholder"
sub_title <- "Placeholder"
info_text <- "#TidyTuesday week 44, 2022 | Data: https://github.com/tashapiro/horror-movies | @JalkanenTero"


### Colors ---

font_color <- "#FFFFFF"
bg_color <- "#006666"

## Theme -----

plot_theme <- theme(plot.background = element_rect(fill = bg_color), 
                    axis.line = element_blank(), 
                    panel.background = element_rect(fill = bg_color), 
                    panel.grid = element_blank(), 
                    strip.background = element_blank(), 
                    axis.text.x = element_text(color = font_color, size = 40, family = family),
                    axis.ticks.x = element_line(color = font_color, size = 50),
                    strip.text = element_text(color = font_color, size = 50, family = family),
                    axis.text.y = element_blank(),
                    axis.ticks.y = element_blank(),
                    axis.title = element_blank(),
                    plot.caption = element_text(color = font_color, face = "bold", size = 15, family = family),
                    plot.title = element_text(color = font_color, face = "bold", size = 105, hjust = 0.5, family = family),
                    plot.subtitle = element_text(color = font_color, face = "italic", size = 95, hjust = 0.5, family = family)
                    
)


## Modify data -----



## The plots --------

