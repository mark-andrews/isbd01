library(tidyverse)

dice_df <- read_csv("https://raw.githubusercontent.com/mark-andrews/isbd01/main/data/loaded_dice.csv")

y <- dice_df %>% 
  mutate(is_six = 1 * (outcome == 6)) %>% 
  pull(is_six)
