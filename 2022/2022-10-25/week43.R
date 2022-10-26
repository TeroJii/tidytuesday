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
library(patchwork)

# define project paths
here::i_am(path = "2022/2022-10-25/week43.R")

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
attribution_star <- "Star figure: I, Ssolbergj, CC BY 3.0 <https://creativecommons.org/licenses/by/3.0>, via Wikimedia Commons"
main_title <- "Great British Bakeoff:"
sub_title <- "Do the winners grow during the competition?"
info_text <- "#TidyTuesday week 43, 2022 | Data: {bakeoff} package | @JalkanenTero"


# get season winners
series_winners <- bakers %>% 
  select(series, baker, series_winner) %>% 
  filter(series_winner == 1)

## label series
series.label <- series_winners$baker
names(series.label) <-series_winners$series


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

# How did season winners fare in challenges?
season_winner_progression <- challenges %>% 
  filter(baker %in% series_winners$baker) %>%
  # remove David from series 1 (namesake of series 10 winner)
  filter(!(series == 1 & baker == "David")) %>% 
  mutate(technical = if_else(is.na(technical), true = 1, false = technical))


## The plots --------

main_chart <- season_winner_progression %>% 
  ggplot(aes(x = episode, y = technical/2)) +
  geom_tile(width = 0.8, 
            aes(height = technical),
            # White filling on bars
            fill = font_color) +
  geom_image(data = season_winner_progression %>% 
               filter(result == "STAR BAKER") %>%  
               mutate(image = here("2022", "2022-10-25", "star.png")), 
             aes(image = image, y = technical + 1, x = episode), size = 0.05) +
  geom_text(data = season_winner_progression %>% filter(result == "WINNER"), 
             aes(label = strsplit(result, split = "NER"), y = technical + 2, x = episode), 
            angle = 90,
            color = font_color,
            size = 20, 
            family = family) +
  facet_wrap(facets = "series", nrow = 2,
             # Add labels on facets
             labeller = labeller(series = series.label)) +
  scale_y_continuous(breaks = 1:12) +
  scale_x_continuous(breaks = 1:10) +
  plot_theme +
  labs(caption = attribution_star) +
  ggtitle(main_title, subtitle = paste0(sub_title, "\n")) +
  theme(axis.title.y = element_text(color = font_color, size = 50, family = family)) +
  labs(y = "Technical scoring per episode")


sub_plot <- ggplot() +
  geom_text(data = data.frame(x = 0, y = 0, label = info_text), 
            aes(x = x, y= y, label = label), color = font_color, size = 10, family = family) +
  plot_theme +
  theme(axis.text.x = element_blank(), 
        axis.ticks.x = element_blank())


main_chart / sub_plot + plot_layout(nrow = 2, heights = c(15,1))


## Save output -----

ggsave(filename = "TidyTuesday-2022-Week43_v2.png", 
       path = here("2022", "2022-10-25"), 
       device = "png", 
       units = "cm", 
       height = 25,
       width = 30, 
       dpi = 300)
