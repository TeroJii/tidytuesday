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
font_add_google("Kanit")
font_add_google("Quicksand")
# add font automatically
showtext_auto()
family_title <- "Kanit"
family_other <- "Quicksand"

## Texts ----

### Picture attribution

main_title <- "Page Metrics"
sub_title <- "Accessibility of Mobile Optimized Webpages"
info_text <- "#TidyTuesday week 46, 2022 | Data: httparchive.org | Viz: @TeroJii"


### Colors ---

title_color <- "#E14D2A"
font_color <- "#FD841F"
bg_color <- "#001253"
  

## Theme -----

plot_theme <- theme(axis.text = element_text(color = font_color, size = 45, family = family_other),
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

## Friendliness for visually impaired

# alt text and color contrast

vis_data <- data_frames_list$image_alt %>% 
  bind_rows(data_frames_list$color_contrast) %>% 
  # mobile phones only
  filter(client == "mobile") %>% 
  mutate(measure = if_else(measure == "a11yImageAlt", 
                           true = "Contains Alt text", 
                           false = "Color Contrast for Optimized Viewablity"))

vis_friend <- vis_data %>% 
  ggplot(aes(x = date, y = percent, group = measure)) +
  geom_line(color = font_color, linewidth = 1.5) +
  ggrepel::geom_text_repel(data = . %>% filter(date == "2017-11-01"), 
                            aes(x = date, 
                                y = percent+2.5, 
                                label = measure),
                           size = 15,
                           color = font_color) +
  ggtitle(label = main_title, subtitle = sub_title) +
  scale_y_continuous(labels = function(percent) paste0(percent, "%")
                     ) +
  labs(caption = info_text) +
  plot_theme


vis_friend

## Save output -----

ggsave(filename = "TidyTuesday-2022-Week46.png", 
       path = here("2022", "2022-11-15"), 
       device = "png", 
       units = "cm", 
       height = 12,
       width = 20, 
       dpi = 300)
