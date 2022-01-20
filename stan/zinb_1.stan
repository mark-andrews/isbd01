functions {
  
  // Return the log probability of an observed count
  // assuming that that is drawn from a zero inflated Negative Binomial
  real zero_infl_nb_log_lpmf(int y, real mu, real phi, real theta) { 
  
    if (y == 0) { 
      /*
      This is the log of the probability of choosing a zero value of `y`.
      This can happen for two reasons.
      Either the zero component is sampled.
      Or else the Neg Bin count model component is sampled, and then a
      zero value is sampled from that count model.
      Therefore, the probability is
      theta + (1-theta) * NegBin(0 | mu, phi)
      where theta is the same as Bernoulli(1 | theta)
      and 1-theta is the same as Bernoulli(0 | theta).
      And we want the log of this probability.
      And because we already have the log of Bernoulli(1 |theta) from
      `bernoulli_lpmf(1|theta)`, etc., we have to use logsumexp.
      */
      return log_sum_exp(bernoulli_lpmf(1 | theta), 
                         bernoulli_lpmf(0 | theta) + 
                         neg_binomial_2_log_lpmf(0 | mu, phi)); 
    } else { 
      /* This is LOG of the probability of observing a non-zero `y` value.
      This is the probability of choosing the Neg Bin count model component,
      (which is 1 - theta, i.e. the probability of
      observing 0 from a bernoulli distribution with probability theta)
      multiplied by the probability of observing some value non-zero `y`
      from a Negative Binomial with mean and scale `eta` and `phi`, respectively.
      */ 
      return bernoulli_lpmf(0 | theta) + neg_binomial_2_log_lpmf(y | mu, phi); 
    } 
  }
  
}

data {
  int<lower=1> N;
  int<lower=1> K;
  int<lower=0> y[N];
  matrix[N, K + 1] X;
}

parameters {
  real<lower=0, upper=1> theta;
  real<lower=0> phi;
  vector[K + 1] beta;
}

transformed parameters {
  vector[N] mu;
  mu = X * beta;
}

model {

  for (i in 1:N){
    target += zero_infl_nb_log_lpmf(y[i] | mu[i], phi, theta);
  }
  
  target += cauchy_lpdf(phi | 0, 10);
  target += beta_lpdf(theta | 1, 1);

}
