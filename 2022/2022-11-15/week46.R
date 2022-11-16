### Tidy tuesday - 2022 week 46
## Author: Tero Jalkanen


## Libraries ----

library(here)
library(tidyverse)
library(patchwork)
library(showtext)
library(lubridate)
library(ggrepel)

# define project paths
here::i_am(path = "2022/2022-11-15/week46.R")

## Read in data


# Or read in the data manually

image_alt <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-15/image_alt.csv')
color_contrast <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-15/color_contrast.csv')
ally_scores <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-15/ally_scores.csv')
bytes_total <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-15/bytes_total.csv')
speed_index <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-15/speed_index.csv')


## Fix dates on all data.frames
fix_dates <- function(df){
  
  df <- df %>% 
    mutate(date = str_replace_all(string = date, pattern = "_", replacement = "-")) %>% 
    mutate(date = lubridate::as_date(date))
    
  
  return(df)
}

data_frames_list = list(image_alt, color_contrast, ally_scores, bytes_total, speed_index) %>% 
  stats::setNames(nm = c("image_alt", "color_contrast", "ally_scores", "bytes_total", "speed_index"))


data_frames_list <- map(.x = data_frames_list, ~fix_dates(df = .x))

# remove "old" dfs with character strings as dates
rm("image_alt", "color_contrast", "ally_scores", "bytes_total", "speed_index")

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

main_title <- "Page Metrics"
info_text <- "#TidyTuesday week 46, 2022 | Data: httparchive.org | Viz: @TeroJii"


### Colors ---

font_color <- "#000000"


## The plots --------

title_plot <- ggplot() +
  geom_text(data = data.frame(x = 0, y = 0, label = main_title), 
            aes(x = x, y= y, label = label), color = font_color, size = 25, family = family_title) +
  theme_void() +
  theme(axis.text.x = element_blank(), 
        axis.ticks.x = element_blank(), text = element_text(face = "bold"))

#speed
data_frames_list$speed_index %>% 
  pivot_longer(cols = paste0("p", c(10,25,50,75,90)), names_to = "percentile", values_to = "speed_index") %>%
  ggplot(aes(x = date, y = speed_index, color = percentile)) +
  geom_line() +
  facet_grid(. ~ client)

#size
data_frames_list$bytes_total %>% 
  pivot_longer(cols = paste0("p", c(10,25,50,75,90)), names_to = "percentile", values_to = "bytes_total") %>%
  ggplot(aes(x = date, y = bytes_total, color = percentile)) +
  geom_line() +
  facet_grid(. ~ client)

# accessibility
data_frames_list$ally_scores %>% 
  pivot_longer(cols = paste0("p", c(10,25,50,75,90)), names_to = "percentile", values_to = "ally_score") %>%
  ggplot(aes(x = date, y = ally_score, color = percentile)) +
  geom_line() +
  facet_grid(. ~ client)

## Friendliness for visually impaired

# alt text and color contrast

vis_friend <- data_frames_list$image_alt %>% 
  bind_rows(data_frames_list$color_contrast) %>% 
  # mobile phones only
  filter(client == "mobile") %>% 
  mutate(measure = if_else(measure == "a11yImageAlt", 
                           true = "Contains Alt text", 
                           false = "Color Contrast for Optimized Viewablity")) %>% 
  ggplot(aes(x = date, y = percent, group = measure)) +
  geom_line(size = 2) +
  ggrepel::geom_label_repel(data = . %>% filter(date == "2017-11-01"), 
                            aes(x = date, 
                                y = percent+2.5, 
                                label = measure)) +
  ggtitle("Mobile optimized webpage ")


title_plot + title_plot + plot_layout(nrow = 2, heights = c(1,1))

## Save output -----

ggsave(filename = "TidyTuesday-2022-Week46.png", 
       path = here("2022", "2022-11-15"), 
       device = "png", 
       units = "cm", 
       height = 15,
       width = 20, 
       dpi = 300)
