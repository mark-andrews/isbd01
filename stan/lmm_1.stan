data {
  int<lower=1> N;
  int<lower=1> J;
  
  vector[N] x;
  vector[N] y;
  int<lower=1, upper=J> s[N];
  
  // hyper parameters for prior over sigma
  real<lower=0> nu;
  real<lower=0> omega;
}

parameters {
  vector[2] b;
  vector[2] beta[J];
  real<lower=-1, upper=1> rho;
  vector<lower=0>[2] tau;
  real<lower=0> sigma;
}

transformed parameters {
  cov_matrix[2] Sigma;
  corr_matrix[2] Omega;
  Omega[1, 1] = 1;
  Omega[1, 2] = rho;
  Omega[2, 1] = rho;
  Omega[2, 2] = 1;
  Sigma = quad_form_diag(Omega, tau);
}

model {

  // priors
  rho ~ uniform(-1, 1);
  tau ~ cauchy(0, 10);
  b ~ normal(0, 100);
  sigma ~ student_t(nu, 0, omega);
  
  // population model
  beta ~ multi_normal(b, Sigma);
  
  for (i in 1:N){
     y[i] ~ normal(beta[s[i], 1] + beta[s[i], 2] * x[i], sigma);
  }
 
}
