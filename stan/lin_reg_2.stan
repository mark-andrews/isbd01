data {
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
  
  // hyper parameters
  real<lower=0> tau;
  real<lower=0> nu;
  real<lower=0> omega;
}

parameters {
  real beta_0;
  real beta_1;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu;
  mu = beta_0 + beta_1 * x;
}

model {
  beta_0 ~ normal(0, tau);
  beta_1 ~ normal(0, tau);
  
  sigma ~ student_t(nu, 0, omega);
  y ~ normal(mu, sigma); // likelihood model 
}
