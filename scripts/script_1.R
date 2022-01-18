library(tidyverse)
library(rstan)


# Get the data ------------------------------------------------------------

dice_df <- read_csv("https://raw.githubusercontent.com/mark-andrews/isbd01/main/data/loaded_dice.csv")

y <- dice_df %>% 
  mutate(is_six = 1 * (outcome == 6)) %>% 
  pull(is_six)


# Dice 1 model ------------------------------------------------------------


dice_1_data <- list(y = y, N = length(y))

dice_1_model <- stan(file = 'stan/dice_1.stan', 
                     data = dice_1_data)

# Dice 2 model -------------------------------------------------------------


dice_2_data <- list(y = y, 
                    N = length(y),
                    a = 2,
                    b = 3)

dice_2_model <- stan(file = 'stan/dice_2.stan', 
                     data = dice_2_data)



# Dice 3 model ------------------------------------------------------------

dice_3_data <- list(y = y, 
                    N = length(y),
                    a = 2,
                    b = 3)

dice_3_model <- stan(file = 'stan/dice_3.stan', 
                     data = dice_3_data)



# Dice 4 model ------------------------------------------------------------

dice_4_data <- list(m = sum(y), 
                    N = length(y),
                    a = 2,
                    b = 3)

dice_4_model <- stan(file = 'stan/dice_4.stan', 
                     data = dice_4_data)


# Dice 5 model ------------------------------------------------------------

dice_5_data <- list(y = y,  
                    N = length(y),
                    sigma = 1)

dice_5_model <- stan(file = 'stan/dice_5.stan', 
                     data = dice_5_data)
