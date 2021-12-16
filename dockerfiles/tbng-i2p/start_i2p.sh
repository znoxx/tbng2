#!/bin/bash -e


function stop_i2p() {
  /home/i2p-tbng/i2p/i2prouter stop
  echo "Exiting!"
}

trap 'stop_i2p' INT

echo "Starting i2p..."
PID=$(/home/i2p-tbng/i2p/i2prouter start | awk -F  ":" {'print $3'})

tail --pid=$(echo ${PID}) -f /dev/null

echo "i2p PID lost, exiting..."


