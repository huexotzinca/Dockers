#!/bin/bash

# Enable ssh, apache, mysql and postgresql on container start
service ssh start
apache2ctl -k start
service mysql start
sudo service postgresql stop
service postgresql start

## Uncomment the next code if you like autoupdate from gem and node on Start
# su docker
# gem update && npm -g update

/bin/bash