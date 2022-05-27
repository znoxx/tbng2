#!/bin/sh
if [ -e $(pwd)/.env ]
then
    echo "Using environment file from $(pwd)/.env"
    ENVFILE="--env-file $(pwd)/.env"
else
    echo "Not using environment file"
    ENVFILE=""
fi
