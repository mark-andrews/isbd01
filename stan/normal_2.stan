data {
  int<lower=1> N;
  vector[N] y;
  
  // hyper parameters
  real<lower=0> tau;
  real<lower=0> nu;
  real<lower=0> omega;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  mu ~ normal(0, tau);
  sigma ~ student_t(nu, 0, omega);
  y ~ normal(mu, sigma); // likelihood model 
}
