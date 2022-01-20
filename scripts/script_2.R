library(tidyverse)
library(rstan)

# Normal inference --------------------------------------------------------

math_df <- read_csv("https://raw.githubusercontent.com/mark-andrews/isbd01/main/data/MathPlacement.csv")


ggplot(math_df, aes(x = ACTM)) + geom_boxplot()

y <- math_df %>% select(ACTM) %>% na.omit() %>% pull(ACTM)

normal_1_data <- list(y = y, 
                      N = length(y))

normal_1_model <- stan(file = 'stan/normal_1.stan', data = normal_1_data)

mcmc_combo(normal_1_model, pars = c("mu", "sigma"))
mcmc_hist(normal_1_model, pars = c("mu", "sigma"),
          binwidth = 0.01)

# passing in the hyper-par values
normal_2_data <- list(y = y, 
                      N = length(y),
                      nu = 5,
                      tau = 50,
                      omega = 5)

normal_2_model <- stan(file = 'stan/normal_2.stan', data = normal_2_data)

summary(normal_2_model, pars = c("mu", "sigma"), probs = c(0.025, 0.975))$summary



# Simple linear regression ------------------------------------------------

ggplot(math_df,
       aes(x = ACTM, y = PlcmtScore)
) + geom_point()

math_df_2 <- select(math_df, x = ACTM, y = PlcmtScore) %>% 
  na.omit()

lin_reg_1_data <- list(y = math_df_2$y,
                       x = math_df_2$x,
                       N = nrow(math_df_2),
                       tau = 100,
                       nu = 5,
                       omega = 10)

lin_reg_1_model <- stan(file = 'stan/lin_reg_1.stan',
                        cores = 4,
                        data = lin_reg_1_data)

lin_reg_2_model <- stan(file = 'stan/lin_reg_2.stan',
                        cores = 4,
                        data = lin_reg_1_data)



# Multiple linear regression ----------------------------------------------


weight_df <- read_csv("https://raw.githubusercontent.com/mark-andrews/isbd01/main/data/weight.csv")

library(modelr)

X <- select(weight_df,
            weight, height, age, gender, handedness) %>% 
  na.omit() %>% 
  model_matrix(~ height + age + gender + handedness) %>%
  as.matrix()

lin_reg_3_data <- list(y = weight_df$weight,
                       X = X,
                       N = nrow(X),
                       K = ncol(X) - 1,
                       tau = 100,
                       nu = 3,
                       omega = 50)

lin_reg_3_model <- stan(file = 'stan/lin_reg_3.stan',
                        data = lin_reg_3_data,
                        cores = 4)
