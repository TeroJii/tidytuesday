### Tidy tuesday - 2022 week 47
## Author: Tero Jalkanen


## Libraries ----

library(here)
library(tidyverse)
library(patchwork)
library(showtext)
library(maps)

# define project paths
here::i_am(path = "2022/2022-11-15/week46.R")

## Read in data

museums <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-22/museums.csv')


#############
## Creating the visualization -----
#######

## Get fonts
font_add_google("Julee")
font_add_google("Barlow")
# add font automatically
showtext_auto()
family_title <- "Julee"
family_other <- "Barlow"

## Texts ----

### Picture attribution

main_title <- "Museums"
sub_title <- "Something"
info_text <- "#TidyTuesday week 47, 2022 | Data: Data downloaded from the Mapping Museums website at www.mappingmuseums.org, Accessed on 2022-11-22 | Viz: @TeroJii"


### Colors ---

title_color <- "#E14D2A"
font_color <- "#FD841F"
bg_color <- "#001253"
  

## Theme -----

plot_theme <- theme(axis.text = element_blank(),
                    axis.title = element_blank(),
                    plot.caption = element_text(color = font_color, face = "bold", size = 20, family = family_other),
                    plot.title = element_text(color = title_color, face = "bold", size = 60, hjust = 0.5, family = family_title, lineheight = 0.5),
                    plot.subtitle = element_text(color = font_color, face = "bold", size = 50, hjust = 0.5, family = family_other, lineheight = 0.5),
                    plot.background = element_rect(fill = bg_color),
                    panel.background = element_rect(fill = bg_color),
                    strip.background = element_rect(fill = bg_color),
                    strip.text = element_text(family = family_other, color = font_color, size = 50),
                    panel.grid = element_blank()
)



## The plots --------

worldmap <-  map_data('world')

ggplot() + 
  geom_polygon(data = worldmap, aes(x = long, 
                                    y = lat, 
                                    group = group), 
               fill = 'gray90', 
               color = 'black') + 
  coord_fixed(ratio = 1.3, 
              xlim = c(-10,3), 
              ylim = c(50, 59)) + 
  geom_point(data = museums, aes(x = Longitude, y = Latitude), shape = 15, fill = "black", alpha = 0.6) +
  theme_void() +
  ggtitle(main_title) +
  theme(plot.title = element_text(color = title_color, face = "bold", size = 60, hjust = 0.5, family = family_title, lineheight = 0.5)) +
  labs(caption = info_text)

## Save output -----

ggsave(filename = "TidyTuesday-2022-Week47.png", 
       path = here("2022", "2022-11-22"), 
       device = "png", 
       units = "cm", 
       height = 12,
       width = 20, 
       dpi = 300)
