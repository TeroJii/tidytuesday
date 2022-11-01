### Tidy tuesday - 2022 week 44
## Author: Tero Jalkanen

## Read in data

horror_movies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv')


## Libraries ----

library(here)
library(tidyverse)
library(showtext)
library(tidytext)
library(lubridate)
library(ggrepel)

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



## Modify data -----
finnish_movies <- horror_movies %>% 
  filter(original_language == "fi") %>% 
  mutate(release_year = lubridate::year(release_date))

tidy_overviews <- finnish_movies %>% 
  select(original_title, release_year, overview) %>% 
  filter(!is.na(overview)) %>% 
  unnest_tokens(word, input = overview)


common_words_matrix <- tidy_overviews %>% 
  count(release_year, word, sort = TRUE) %>% 
  anti_join(stop_words) %>% 
  pivot_wider(names_from = "word", values_from = "n") %>% 
  arrange(release_year) %>% 
  column_to_rownames("release_year") %>% 
  mutate(across(.cols = everything(), ~ replace(., is.na(.), 0)))


pca.out <- prcomp(common_words_matrix, scale. = TRUE)


pca.result <- pca.out$x %>% 
  as.data.frame.matrix() %>% 
  rownames_to_column(var = "release_year")

## Theme -----

plot_theme <- theme(axis.text = element_text(color = font_color, size = 40, family = family_other),
                    axis.title = element_text(color = font_color, size = 40, family = family_other),
                    plot.caption = element_text(color = font_color, face = "bold", size = 15, family = family_other),
                    plot.title = element_text(color = font_color, face = "bold", size = 105, hjust = 0.5, family = family_title),
                    plot.subtitle = element_text(color = font_color, face = "italic", size = 95, hjust = 0.5, family = family_other),
                    plot.background = element_rect(fill = bg_color),
                    panel.background = element_rect(fill = bg_color)
)

## The plots --------


pca.result %>% 
  ggplot(aes(x = PC1 + 50, y = PC2 + 20)) +
  geom_point(color = font_color) +
  ggrepel::geom_label_repel(aes(label = release_year)) +
  ggtitle("Test", subtitle = "test test") +
  scale_y_log10() +
  scale_x_log10() +
  plot_theme
