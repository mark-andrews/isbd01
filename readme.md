# Introduction to Stan for Bayesian Data Analysis

[Stan](https://mc-stan.org) is "a state-of-the-art platform for statistical modeling and high-performance statistical computation. Thousands of users rely on Stan for statistical modeling, data analysis, and prediction in the social, biological, and physical sciences, engineering, and business."
Stan is a powerful programming language for developing and fitting custom Bayesian statistical models.
In this course, we provide a general introduction to the Stan language, and describe how to use it to develop and run Bayesian models.
We begin by first covering the theory behind Stan, which covers Bayesian inference, Markov Chain Monte Carlo (MCMC) for sampling from probability distributions, and the efficient Hamiltonian Monte Carlo (HMC) method that Stan implements.
Next, we learn how to write Stan models by creating simple Bayesian such as binomial models and models using normal distributions.
In so doing, the basics of the Stan language will be apparent.
Although Stan can be used with multiple different type of statistical programs (Python, Julia, Matlab, Stata), we will use Stan with R exclusively, specifically using the rstan or cmdstanr packages.
Using these packages, we will can compile and sample from a HMC sampler for the Bayesian models we defined, plot and summarize the results, evaluate the models, etc.
We then cover some widely used and practically useful models including linear regression, logistic regression, multilevel and mixed effects models.
We will end by covering some more complex models, including probabilistic mixture models.

## Intended Audience

This course is aimed at anyone who is in interested in doing advanced Bayesian data analysis using Stan. Stan is a state of the art tool for advanced analysis across all academic scientific disciplines, engineering, and business, and other sectors.


## Teaching Format

This course will be largely practical, hands-on, and workshop based. For many topics, there will first be some lecture style presentation, i.e., using slides or blackboard, to introduce and explain key concepts and theories. Then, we will work with examples and perform the analyses using R. Any code that the instructor produces during these sessions will be uploaded to a publicly available GitHub site after each session.

The course will take place online using Zoom. On each day, the live video broadcasts will occur between (EST; UTC/GMT-5) at:

* 12pm-2pm
* 3pm-5pm

All the sessions will be video recorded, and made available as soon as possible after each 2hr session on a private video hosting website.

# Assumed quantitative knowledge

We assume familiarity with inferential statistics concepts like hypothesis testing and statistical significance, and practical experience with linear regression, logistic regression, mixed effects models using R.

## Assumed computer background

Some experience and familiarity with R is required. No prior experience with Stan itself is required.

## Equipment and software requirements

A computer with a working version of R or RStudio is required. R and RStudio are both available as free and open source software for PCs, Macs, and Linux computers. In addition to R and RStudio, some R packages, particularly `rstan`, are required. Installing these packages will install Stan, which is a standalone program to R. Instructions on how to install R/RStudio and all required R packages and Stan are available [here](software.md).


# Course programme

## Day 1

* Topic 1: Hamiltonian Monte Carlo for Bayesian inference. We begin by describing Bayesian inference, whose objective is the calculation of a probability distribution over a high dimensional space, namely the posterior distribution. In general, this posterior distribution can not be described analytically, and so to summarize or make predictions from the posterior distribution, we must draw samples from it. For this, we can use Markov Chain Monte Carlo (MCMC) methods including the Metropolis sampler, sometimes known as random-walk Metropolis. Hamiltonian Monte Carlo (HMC), which Stan implements, is ultimately an efficient version of the Metropolis sampler that does not involve random walk behaviour. In this introductory section of the course, we will go through these major theoretical topics in sufficient detail to be able to understand how Stan works.

* Topic 2: Univariate models. To learn the Stan language and how to use it to develop Bayesian models, we will start with simple models. In particular, we will look at binomial models and models involving univariate normal distributions. The models will allow us to explore many of the major features of the Stan language, including how to specify priors, in conceptually easy examples. Here, we will also learn how to use `rstan` and `cmdstanr` to compile the HMC sampler from the defined Stan model, and draw samples from it.

## Day 2

* Topic 3: Regression models. Having learned the basics of Stan using simple models, we now turn to more practically useful examples including linear regression, general linear models with categorical predictor variables, logistic regression, Poisson regression, etc. All of these examples involve the use of similar programming features and specifications, and so they are easily extensible to other regression models.

## Day 3

* Topic 4: Multilevel and mixed effects models. As an extension of the regression models that we consider in the previous topic, here we consider multilevel and mixed effects models. We primarily concentrate on linear mixed effects models, and consider the different ways to specify these models in Stan.

* Topic 5: Because Stan is a programming language, it essentially gives us the means to create any bespoke or custom statistical model, and not just those that are widely used. In this final topic, we will cover some more complex cases to illustrate it power. In particular, we will cover probabilistic mixture models, which are a type of latent variable model.
