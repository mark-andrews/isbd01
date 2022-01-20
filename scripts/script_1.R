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




# Dice 6 model ------------------------------------------------------------

dice_6_data <- list(y = y,  
                    N = length(y),
                    sigma = 1)

dice_6_model <- stan(file = 'stan/dice_6.stan', 
                     data = dice_6_data)


# Summarizing -------------------------------------------------------------

summary(dice_6_model)

# look at chain 4 only
summary(dice_6_model)$c_summary[,,4]

# just look at `mu` and `theta`
summary(dice_6_model, par = c('theta', 'mu'))$summary


# just look at `theta`
summary(dice_6_model, par = c('theta', 'mu'), probs = c(0.025, 0.975))$summary



# Get the samples ---------------------------------------------------------

rstan::extract(dice_6_model, pars = 'theta', permuted = FALSE, inc_warmup = TRUE) %>%
  magrittr::extract(,,1) %>% 
  as_tibble()


tidybayes::spread_draws(dice_6_model, theta)



# Plotting ----------------------------------------------------------------

plot(dice_6_model)


library(bayesplot)
mcmc_areas(dice_6_model, pars = c('mu', 'theta'))
mcmc_areas_ridges(dice_6_model, pars = c('mu', 'theta'))
mcmc_combo(dice_6_model, pars = c('mu', 'theta'))
mcmc_hist(dice_6_model, pars = c('mu', 'theta'))



# Out of sample predictive performance ------------------------------------

library(loo)
loo(dice_6_model) # this does not work....


# run a model, but collect the pointwise log likelihood 
dice_7_model <- stan(file = 'stan/dice_7.stan', data = dice_5_data)

# extract log_lik and calculate relative effective sample size
log_lik_7 <- extract_log_lik(dice_7_model, merge_chains = F)
r_eff_7 <- relative_eff(exp(log_lik_7))

loo(dice_7_model, r_eff = r_eff_7)



