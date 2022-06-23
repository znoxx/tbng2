#!/bin/sh
set -e
if [ $(id -u) -ne 0 ] ; then echo "Please run as root" ; exit 1 ; fi
folders="data/tbng-tor data/tbng-bridge data/tbng-i2p conf/tbng-i2p"
for folder in $folders
do
   rm -rf $folder
done
