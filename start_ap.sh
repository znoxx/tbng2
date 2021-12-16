#!/bin/bash
set -e
./stop_ap.sh
docker-compose -f compose/tbng2/docker-compose.yaml up -d

