data {
  int<lower=1> N;
  int<lower=1> K;
  matrix[N, K+1] X;
  int<lower=0> y[N];
  
  // hyper parameters
  real<lower=0> tau;
}

parameters {
  vector[K+1] beta;
  real<lower=0> phi;
}

transformed parameters {
  vector[N] mu;
  mu = X * beta;
}

model {
  beta ~ normal(0, tau);
  phi ~ cauchy(0, 10);
  y ~ neg_binomial_2_log(mu, phi); // likelihood model 
}

generated quantities {
  vector[N] lambda;
  lambda = exp(mu);
}
