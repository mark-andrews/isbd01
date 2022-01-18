data {
  int<lower=1> N;
  int<lower=0, upper=1> y[N];
  real<lower=0> a;
  real<lower=0> b;
}

parameters {
  real<lower=0, upper=1> theta;
}

model {
  
  theta ~ beta(a, b); // uniform beta prior
  
  for (i in 1:N){
    y[i] ~ bernoulli(theta); // bernoulli data model
  }
  
}
