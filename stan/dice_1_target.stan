data {
  int<lower=1> N;
  int<lower=0, upper=1> y[N];
}

parameters {
  real<lower=0, upper=1> theta;
}

model {
  // theta ~ beta(1, 1); // uniform beta prior
  target += beta_lpdf(theta | 1, 1);
  //y ~ bernoulli(theta); // bernoulli data model
  target += bernoulli_lpmf(y | theta);
}
