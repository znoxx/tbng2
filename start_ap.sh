#!/bin/bash
set -e
./stop_ap.sh
./prepare_volumes.sh
source $(pwd)/env_load.sh
docker compose $ENVFILE -f compose/tbng2/docker-compose.yaml up -d --remove-orphans

