#!/bin/bash

sudo R --vanilla <<EOF
repos <- 'http://cran.cnr.berkeley.edu'
pkgs <- c("stm", "igraph")
install.packages(pkgs, repos = repos)
EOF
