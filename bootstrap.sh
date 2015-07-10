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
# libcurl4-openssl-dev is for RCurl
# libxslt-dev and libxml2-dev for python lxml
apt-get update
apt-get install -y r-base r-base-dev libxml2-dev libcurl4-openssl-dev \
    build-essential python-dev libxslt-dev python-matplotlib graphviz

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

## create R packages provisioning script -----------------------------------#
cat > /tmp/Rpackages.R <<EOF
## Create user package library location
vagrantLib <- .Library.site[1]
## select http://cran.stat.auckland.ac.nz for CRAN mirror
chooseCRANmirror(
    ind=which(getCRANmirrors()[,"URL"] == "http://cran.stat.auckland.ac.nz/"))
## selecte CRAN, BioConductor, R-Forge for repos
setRepositories(ind=c(1,2,8))

## install packages from repos
packages <- c("XML", "RCurl", "graph", "RBGL", "Rgraphviz", "gridGraphviz", 
              "devtools")
installIfRequired <- function(pkg) {
    if (!require(package=pkg, character.only=TRUE)) {
        install.packages(pkgs=pkg, lib=vagrantLib)
    }
}
for (i in packages) {
    installIfRequired(i)
}
while (!require("gridGraphviz")) {
  install.packages("gridGraphviz", lib=vagrantLib)
}

## Install conduit
if (!require(conduit)) {
  devtools::install_github("anhinton/conduit", ref="develop", lib=vagrantLib)
}

EOF

## install R packages from /vagrant/Rpackages.R
Rscript /tmp/Rpackages.R
