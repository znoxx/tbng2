#!/bin/bash
set -e
./stop_bridge.sh
docker-compose -f compose/bridge/docker-compose.yaml up -d

