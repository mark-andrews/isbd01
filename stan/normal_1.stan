data {
  int<lower=1> N;
  vector[N] y;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  mu ~ normal(0, 100);
  sigma ~ student_t(3, 0, 10);
  y ~ normal(mu, sigma); // likelihood model 
}