data {
  int<lower=1> N;
  int<lower=0, upper=N> m;
  real<lower=0> a;
  real<lower=0> b;
}

parameters {
  real<lower=0, upper=1> theta;
}

model {
  
  theta ~ beta(a, b); // uniform beta prior
  m ~ binomial(N, theta); // data model; binomial
  
}
