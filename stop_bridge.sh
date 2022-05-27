#!/bin/bash
set -e
source $(pwd)/env_load.sh
docker-compose $ENVFILE -f compose/bridge/docker-compose.yaml down

