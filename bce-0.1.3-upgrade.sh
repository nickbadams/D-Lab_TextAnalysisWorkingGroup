#!/bin/bash

echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee /etc/apt/sources.list.d/cran-rstudio-trusty.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update && sudo apt-get install -y r-recommended libgsl0-dev
wget http://cran.r-project.org/src/contrib/Archive/tm/tm_0.5-10.tar.gz
wget http://cran.r-project.org/src/contrib/Archive/topicmodels/topicmodels_0.2-0.tar.gz
R CMD INSTALL tm_0.5-10.tar.gz
R CMD INSTALL topicmodels_0.2-0.tar.gz
sudo R --vanilla <<EOF
repos <- 'http://cran.cnr.berkeley.edu'
pkgs <- c("SnowballC", "slam")
install.packages(pkgs, repos = repos)
EOF
