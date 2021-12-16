#!/bin/sh
cd 
/usr/bin/expect -c '
set timeout 20

spawn /usr/bin/java -jar i2pinstall_$::env(I2P_VERSION).jar -console


expect "Input selection:" { send "0\r" }
expect "Press 1 to continue, 2 to quit, 3 to redisplay" { send "1\r" } 
expect "Press 1 to continue, 2 to quit, 3 to redisplay" { send "1\r" }
expect -ex {Select the installation path:  [/home/i2p-tbng/i2p]} { send -- "\r" }
expect "Enter O for OK, C to Cancel:" { send "O\r" }
expect "Press 1 to continue, 2 to quit, 3 to redisplay" { send "1\r" }
expect "Press 1 to continue, 2 to quit, 3 to redisplay" { send "1\r" } 
'
/home/i2p-tbng/i2p/i2prouter start
sleep 30
/home/i2p-tbng/i2p/i2prouter stop
sed -i 's/clientApp.0.args=7657\s*::1,127.0.0.1\s*.\/webapps\//clientApp.0.args=7657 0.0.0.0 .\/webapps\//' ~/.i2p/clients.config.d/00-net.i2p.router.web.RouterConsoleRunner-clients.config
sed -i 's/clientApp.0.startOnLoad=true/clientApp.0.startOnLoad=false/'  ~/.i2p/clients.config.d/04-net.i2p.apps.systray.UrlLauncher-clients.config
sed -i 's/i2psnark.dir=i2psnark/i2psnark.dir=\/home\/i2p-tbng\/i2psnarkdata\//' ~/.i2p/i2psnark.config.d/i2psnark.config
