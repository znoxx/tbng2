#!/bin/bash
set -e
source $(pwd)/env_load.sh
docker-compose $ENVFILE -f compose/tbng2/docker-compose.yaml down

