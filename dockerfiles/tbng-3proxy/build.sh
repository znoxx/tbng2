#!/bin/sh
docker build . -t tbng-3proxy_ds --build-arg RELEASE=0.9.4 --build-arg ARCH=$(uname -m)
