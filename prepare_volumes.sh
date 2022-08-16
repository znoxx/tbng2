#!/bin/sh
folders="data/i2psnark data/tbng-tor data/tbng-bridge data/tbng-i2p conf/tbng-i2p"
for folder in $folders
do
   if [ -e "$folder" ]; then
     echo "Folder $folder already exists, skpping..."
   else
     echo "Creating folder $folder"
     mkdir -p $folder
     chmod 777 $folder
    fi
done
