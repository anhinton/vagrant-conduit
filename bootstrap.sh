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
# libcurl4-openssl-dev is required by R package RCurl
apt-get update
apt-get install -y r-base r-base-dev libxml2-dev build-essential python-dev \
    libxslt-dev python-matplotlib graphviz libcurl4-openssl-dev apache2

# set up conduit web server
if [ ! -d /var/www/conduit ]; then
    mkdir /var/www/conduit
fi
cp -r /vagrant/urlTesting /var/www/conduit/
chown -R conduit:conduit /var/www/conduit
a2dissite default
cp /etc/apache2/sites-available/default /etc/apache2/sites-available/conduit
sed -i -e 's#DocumentRoot[ ]/var/www#DocumentRoot /var/www/conduit#' /etc/apache2/sites-available/conduit
a2ensite conduit
service apache2 restart

## set timezone to NZ
echo "Pacific/Auckland" | tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

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

# set up 'conduit' user for module host testing
if [ ! -d /home/conduit ]; then
    useradd -m conduit
fi
if [ ! -d /home/conduit/.ssh ]; then
    mkdir -p /home/conduit/.ssh
    chmod 0700 /home/conduit/.ssh
fi
cat /vagrant/conduit.key.pub >> /home/conduit/.ssh/authorized_keys
chown conduit:conduit -R /home/conduit/.ssh
