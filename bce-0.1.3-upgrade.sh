#!/bin/bash

echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee /etc/apt/sources.list.d/cran-rstudio-trusty.list
sudo mv /etc/apt/sources.list.d/google-chrome.list /etc/apt/sources.list.d/.google-chrome.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update || echo "Error updating apt indices. Check your network connection."
sudo apt-get install -y r-recommended libgsl0-dev git-cola r-cran-rcpp oracle-java8-installer
sudo rm -rf /usr/local/lib/R/site-library/tm /usr/local/lib/R/site-library/topicmodels
sudo R --vanilla <<EOF
repos <- 'http://cran.cnr.berkeley.edu'
pkgs <- c("devtools", "packrat", "SnowballC", "slam", "modeltools", "gsubfn", "stringr", "lazyeval")
install.packages(pkgs, repos = repos)
EOF
(cd /tmp;
 wget -N --continue http://nlp.stanford.edu/software/stanford-parser-full-2014-10-31.zip
 wget -N --continue http://cran.r-project.org/src/contrib/Archive/tm/tm_0.5-10.tar.gz
 wget -N --continue http://cran.r-project.org/src/contrib/Archive/topicmodels/topicmodels_0.2-0.tar.gz
 sudo R CMD INSTALL tm_0.5-10.tar.gz
 sudo R CMD INSTALL topicmodels_0.2-0.tar.gz
)
unzip /tmp/stanford-parser-full-2014-10-31.zip
