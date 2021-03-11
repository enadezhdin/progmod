FROM rocker/shiny:latest

LABEL maintainer="Dr Eugene Nadezhdin <en5@sanger.ac.uk>"

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update && apt upgrade -y && apt install -y \
	libssl-dev \
	libxml2-dev

# Install R libs
RUN R -e "options(warn = 2); install.packages(c('devtools', 'xtable', 'RColorBrewer', 'Rcpp', 'ggplot2', 'png'), repos='https://cran.rstudio.com/'); library(devtools); install_github(c('mg14/mg14', 'mg14/CoxHD/CoxHD'))"

# Hack in the latest master from github of httpuv to fix proxy issues
RUN R -e "options(warn = 2); library(devtools); install_github(c('rstudio/httpuv'))"

# Add app data
WORKDIR /srv/shiny-server/


ADD app/ progmod/

