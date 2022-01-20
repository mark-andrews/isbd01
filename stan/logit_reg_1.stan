data {
  int<lower=1> N;
  int<lower=1> K;
  matrix[N, K+1] X;
  int<lower=0, upper=1> y[N];
  
  // hyper parameters
  real<lower=0> tau;
}

parameters {
  vector[K+1] beta;
}

transformed parameters {
  vector[N] mu;
  mu = X * beta;
}

model {
  beta ~ normal(0, tau);
  y ~ bernoulli_logit(mu); // likelihood model 
}

generated quantities {
  vector[N] theta;
  theta = inv_logit(mu);
}
