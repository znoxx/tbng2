#!/bin/bash
set -e
source $(pwd)/env_load.sh
./stop_bridge.sh
docker-compose $ENVFILE -f compose/bridge/docker-compose.yaml up -d 

