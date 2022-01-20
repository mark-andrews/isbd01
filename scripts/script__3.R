library(tidyverse)
library(rstan)
library(modelr)


# Get some data -----------------------------------------------------------

biochem_df <- read_csv("https://raw.githubusercontent.com/mark-andrews/isbd01/main/data/biochemist.csv")

biochem_df <- mutate(biochem_df,
                     is_published = publications > 0)

X <- model_matrix(biochem_df, ~ prestige + children + married) %>% 
  as.matrix()

y <- 1 * biochem_df$is_published

length(y) == nrow(X)

logit_reg_1_data <- list(y = y,
                         X = X,
                         K = ncol(X) - 1,
                         N = nrow(X),
                         tau = 100)

logit_reg_1_model <- stan(file = 'stan/logit_reg_1.stan',
                          data = logit_reg_1_data)

glm(is_published ~ prestige + children + married, 
    family = binomial(link = 'logit'),
    data = biochem_df) %>% 
  summary() %>% 
  magrittr::extract2('coefficients')


# Poisson regression ------------------------------------------------------

y <- biochem_df$publications
pois_reg_1_data <- list(y = y,
                        X = X,
                        K = ncol(X) - 1,
                        N = nrow(X),
                        tau = 100)

pois_reg_1_model <- stan(file = 'stan/pois_reg_1.stan',
                         data = pois_reg_1_data)

glm(publications ~ prestige + children + married, 
    family = poisson(link = 'log'),
    data = biochem_df) %>% 
  summary() %>% 
  magrittr::extract2('coefficients')


# Neg binom reg -----------------------------------------------------------

nb_reg_1_model <- stan(file = 'stan/nb_reg_1.stan', data = pois_reg_1_data)

summary(nb_reg_1_model,
        pars = c('beta','phi'), 
        probs = c(0.025, 0.975))$summary %>%
  as_tibble(rownames = 'var')

MASS::glm.nb(publications ~ prestige + children + married, 
    data = biochem_df) %>% 
  summary() %>% 
  magrittr::extract2('coefficients')


# Linear mixed effects ----------------------------------------------------

library(lme4)
ggplot(sleepstudy,
       aes(x = Days, y = Reaction, colour = Subject)
) + geom_point() +
  stat_smooth(method= 'lm', se = F) +
  facet_wrap(~Subject)


y <- sleepstudy$Reaction
x <- sleepstudy$Days
s <- as.numeric(sleepstudy$Subject)
N <- length(y)
J <- max(s)

lmm_1_data <- list(y = y,
                   x = x,
                   s = s,
                   N = N,
                   J = J,
                   nu = 5,
                   omega = 50)

lmm_1_model <- stan(file = 'stan/lmm_1.stan', data = lmm_1_data)

summary(lmm_1_model,
        pars = c('b', 'rho', 'tau', 'sigma'),
        probs = c(0.025, 0.975)
)$summary %>% as_tibble(rownames = 'vars')

lmer(Reaction ~ Days + (Days|Subject), data = sleepstudy) %>% 
  summary()



# Stan with target += statements ------------------------------------------

dice_df <- read_csv("https://raw.githubusercontent.com/mark-andrews/isbd01/main/data/loaded_dice.csv")

y <- dice_df %>% 
  mutate(is_six = 1 * (outcome == 6)) %>% 
  pull(is_six)

dice_1_data <- list(y = y, N = length(y))

# this model uses sampling statements
dice_1_model <- stan(file = 'stan/dice_1.stan', 
                     data = dice_1_data)

# this uses target += statements
dice_1_target_model <- stan(file = 'stan/dice_1_target.stan', 
                            data = dice_1_data)



# Zero inflated Negative Binomial -----------------------------------------

# We'll use publications from the bio-chem data set.

biochem_df <- read_csv("https://raw.githubusercontent.com/mark-andrews/isbd01/main/data/biochemist.csv")

X <- model_matrix(biochem_df, ~ prestige + children + married) %>% 
  as.matrix()

y <- biochem_df$publications

zinb_1_data <- list(y = y,
                    X = X,
                    K = ncol(X) - 1,
                    N = nrow(X))

zinb_1_model <- stan(file = 'stan/zinb_1.stan', data = zinb_1_data)
summary(zinb_1_model, pars = c('beta', "theta", "phi"),
        probs = c(0.025, 0.975))$summary %>% 
  as_tibble(rownames = 'var')

# for comparison
zinb_1_model_brms <- brms::brm(publications ~ prestige + children + married, 
                               family = zero_inflated_negbinomial(),
                               data = biochem_df)
