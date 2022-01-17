# This is rocker/verse from Jan 13, 2022
FROM rocker/verse@sha256:166dc9ea1c6fe3f479b507279899dc7f8bbac817921a4eb8bc9f8daef1c933b8

# Some packages we definitely, or may, need that not included in rocker/tidyverse
RUN install2.r --error rstan\
	brms \
	lme4 \
        tidybayes \
        bayesplot


# Clean up packages
RUN rm -rf /tmp/downloaded_packages /tmp/*.rds

# Some Linux things to make life more pleasant
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		vim \
		zsh \
		&& apt-get clean
