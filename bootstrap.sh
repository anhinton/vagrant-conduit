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
# libxslt-dev and libxml2-dev for python lxml
apt-get update
apt-get install -y r-base r-base-dev libxml2-dev build-essential python-dev \
    libxslt-dev python-matplotlib graphviz

## customise /etc/matplotlibrc 
## sets backend to 'Agg' to prevent needing X windows
sed -i -e 's/^backend[ ]*:[ ]*TkAgg/backend : Agg/' /etc/matplotlibrc

## install python modules
## download pip
wget -q -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
## install latest pip for user
python /tmp/get-pip.py
pip install -U numexpr
pip install -U numpy
pip install -U pandas

## install R packages from /vagrant/Rpackages.R
Rscript /vagrant/Rpackages.R
