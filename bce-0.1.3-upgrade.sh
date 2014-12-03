#!/bin/bash

echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee /etc/apt/sources.list.d/cran-rstudio-trusty.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update && sudo apt-get install -y r-recommended
