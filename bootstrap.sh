#!/bin/bash

# create and activate swapfile
if [ ! -e /mnt/swapfile ]
then fallocate -l 1024m /mnt/swapfile
     chmod 600 /mnt/swapfile
fi
if [ `swapon -s | grep -c '/mnt/swapfile'` -eq 0 ]
   then mkswap /mnt/swapfile
	swapon /mnt/swapfile
fi
if [ `grep -c '/mnt/swapfile' /etc/fstab` -eq 0 ]
then
    echo /mnt/swapfile  none  swap  sw  0 0 >> /etc/fstab
fi

# Add CRAN to repos
echo deb https://cran.stat.auckland.ac.nz/bin/linux/ubuntu trusty/ > \
     /etc/apt/sources.list.d/CRAN.list
# Add signing authority for CRAN repo
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
# install packages
# libxml2-dev is required by R package XML
# libcurl4-openssl-dev is required by R package RCurl
# libssl-dev is required by a dependency of R package devtools
apt-get update
apt-get install -y r-base r-base-dev libxml2-dev libssl-dev

## install R packages from /vagrant/Rpackages.R
Rscript /vagrant/Rpackages.R
