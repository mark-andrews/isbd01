data {
  int<lower=1> N;
  int<lower=1> K;
  matrix[N, K+1] X;
  vector[N] y;
  
  // hyper parameters
  real<lower=0> tau;
  real<lower=0> nu;
  real<lower=0> omega;
}

parameters {
  vector[K+1] beta;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu;
  mu = X * beta;
}

model {
  beta ~ normal(0, tau);
  
  sigma ~ student_t(nu, 0, omega);
  y ~ normal(mu, sigma); // likelihood model 
}
