#!/bin/bash
set -e
source $(pwd)/env_load.sh
./prepare_volumes.sh
./stop_bridge.sh
docker compose $ENVFILE -f compose/bridge/docker-compose.yaml up -d 

