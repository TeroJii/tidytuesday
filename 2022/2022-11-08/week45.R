### Tidy tuesday - 2022 week 45
## Author: Tero Jalkanen


## Libraries ----

library(here)
library(tidyverse)
library(showtext)
library(tidytext)
library(lubridate)
library(ggrepel)
library(textdata)
library(rvest)
library(tidylo)

# define project paths
here::i_am(path = "2022/2022-11-08/week45.R")

## Read in data

state_stations <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-08/state_stations.csv')




## Modify data -----



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




## Save output -----

ggsave(filename = "TidyTuesday-2022-Week45.png", 
       path = here("2022", "2022-11-08"), 
       device = "png", 
       units = "cm", 
       height = 15,
       width = 15, 
       dpi = 300)
