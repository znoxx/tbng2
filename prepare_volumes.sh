#!/bin/sh
folders="data/tbng-tor data/tbng-bridge data/tbng-i2p"
for folder in $folders
do
   if [ -e "$folder" ]; then
     echo "Folder $folder already exist, skpping..."
   else
     echo "Creationg folder $folder"
     mkdir -p $folder
     chmod 777 $folder
    fi
done
