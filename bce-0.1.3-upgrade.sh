#!/bin/bash

echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee /etc/apt/sources.list.d/cran-rstudio-trusty.list
sudo mv /etc/apt/sources.list.d/google-chrome.list /etc/apt/sources.list.d/.google-chrome.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update || echo "Error updating apt indices. Check your network connection."
sudo apt-get install -y r-recommended libgsl0-dev git-cola
sudo rm -rf /usr/local/lib/R/site-library/tm /usr/local/lib/R/site-library/topicmodels 2>/dev/null
sudo R --vanilla <<EOF
repos <- 'http://cran.cnr.berkeley.edu'
pkgs <- c("SnowballC", "slam", "modeltools")
install.packages(pkgs, repos = repos)
EOF
(cd /tmp;
 wget -N --continue http://cran.r-project.org/src/contrib/Archive/tm/tm_0.5-10.tar.gz
 wget -N --continue http://cran.r-project.org/src/contrib/Archive/topicmodels/topicmodels_0.2-0.tar.gz
 sudo R CMD INSTALL tm_0.5-10.tar.gz
 sudo R CMD INSTALL topicmodels_0.2-0.tar.gz
)
