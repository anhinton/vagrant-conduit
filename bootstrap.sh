#!/bin/bash

# use NZ repos
sed -i s/us.archive.ubuntu.com/nz.archive.ubuntu.com/g /etc/apt/sources.list
# Add CRAN to repos
echo deb http://cran.stat.auckland.ac.nz/bin/linux/ubuntu precise/ > \
    /etc/apt/sources.list.d/CRAN.list
# Add signing authority for CRAN repo
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
# install packages
# libxml2-dev is required by R package XML
# libcurl4-openssl-dev is required by R package RCurl
apt-get update
apt-get install -y r-base r-base-dev libxml2-dev libcurl4-openssl-dev 

## install R packages from /vagrant/Rpackages.R
Rscript /vagrant/Rpackages.R
