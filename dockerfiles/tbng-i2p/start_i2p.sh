#!/bin/bash -e
./i2p-installer.sh

rm -f /home/i2p-tbng/.i2p/i2p.pid

function stop_i2p() {
  /home/i2p-tbng/i2p/i2prouter stop
  rm -f /home/i2p-tbng/.i2p/i2p.pid
  echo "Exiting!"
}
sleep infinity & PID=$!
trap 'stop_i2p' INT 

echo "Starting i2p..."
/home/i2p-tbng/i2p/i2prouter start

wait

echo "Process $PID has finished" 



