data {
  int<lower=1> N;
  int<lower=0, upper=1> y[N];
  real<lower=0> sigma;
}

parameters {
  real mu;
}

model {
  
  mu ~ normal(0, sigma);
  y ~ bernoulli_logit(mu); // bernoulli data model
  
}

generated quantities {
  real log_lik[N];
  real<lower=0, upper=1> theta;
  theta = inv_logit(mu);
  
  for (i in 1:N){
    log_lik[i] = bernoulli_logit_lpmf(y[i] | mu);
  }
  
}


