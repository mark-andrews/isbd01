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

