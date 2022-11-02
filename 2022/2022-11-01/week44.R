### Tidy tuesday - 2022 week 44
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
here::i_am(path = "2022/2022-11-01/week44.R")

## Read in data

horror_movies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv')

# Iron Maiden - Fear of the Dark lyrics
fear_of_the_dark <- read_html("https://genius.com/Iron-maiden-fear-of-the-dark-lyrics")

# Extract lyrics
fear_of_the_dark <- fear_of_the_dark %>% 
  html_nodes("a span") %>% 
  html_text()

# Make a data.frame with the fear of the dark lyrics
fear_df <- data.frame(verse = 1:12, lyrics = fear_of_the_dark[8:19]) %>% 
  # remove instrumental part
  filter(verse != 6) %>% 
  mutate(verse = rownames(.)) %>% 
  mutate(original_title = "Fear of the Dark",
         release_year = 1992) %>% 
  # add white spaces where line breaks have been
  mutate(lyrics = gsub(pattern = "([a-z])([A-Z])", replacement = "\\1 \\2", x = lyrics))



## Modify data -----
finnish_movies <- horror_movies %>% 
  filter(original_language == "fi") %>% 
  mutate(release_year = lubridate::year(release_date)) %>% 
  filter(original_title %in% c("Sauna", "Dark Floors", "Vihanpidot"))

tidy_overviews <- finnish_movies %>% 
  select(original_title, release_year, overview) %>% 
  filter(!is.na(overview)) %>% 
  unnest_tokens(word, input = overview)

tidy_fear_of_the_dark <- fear_df %>% 
  select(original_title, release_year, lyrics) %>% 
  unnest_tokens(word, input = lyrics)


word_counts <- bind_rows(tidy_overviews, tidy_fear_of_the_dark) %>%  
  count(original_title, word, sort = TRUE)


word_log_odds <- word_counts %>% 
  bind_log_odds(original_title, word, n) 



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

main_title <- "Finnish Horror Movies"
sub_title <- "Vs. Fear of the Dark"
info_text <- "#TidyTuesday week 44, 2022 | Data: https://github.com/tashapiro/horror-movies | @JalkanenTero"


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


pl <- word_log_odds %>%
  group_by(original_title) %>%
  slice_max(log_odds_weighted, n = 5) %>% 
  ungroup() %>%
  mutate(word = reorder(word, log_odds_weighted)) %>%
  ggplot(aes(log_odds_weighted, word, fill = font_color)) +
  geom_col(show.legend = FALSE) +
  ggtitle(paste(main_title, sub_title)) +
  facet_wrap(vars(original_title), scales = "free") +
  labs(y = NULL,
       x = "Weighted log odds",
       caption = info_text) +
  plot_theme 


## Save output -----

ggsave(filename = "TidyTuesday-2022-Week44.png", 
       path = here("2022", "2022-11-01"), 
       device = "png", 
       units = "cm", 
       height = 15,
       width = 15, 
       dpi = 300)
