#!/bin/sh
sed -i 's/clientApp.0.args=7657\s*::1,127.0.0.1\s*.\/webapps\//clientApp.0.args=7657 0.0.0.0 .\/webapps\//' clients.config.d/00-net.i2p.router.web.RouterConsoleRunner-clients.config
sed -i 's/clientApp.0.startOnLoad=true/clientApp.0.startOnLoad=false/'  clients.config.d/04-net.i2p.apps.systray.UrlLauncher-clients.config
sed -i 's/i2psnark.dir=i2psnark/i2psnark.dir=\/home\/i2p-tbng\/i2psnarkdata\//' i2psnark.config.d/i2psnark.config
