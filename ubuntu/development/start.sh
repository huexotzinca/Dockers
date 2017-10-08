#!/bin/bash

# Enable ssh, apache, mysql and postgresql on container start
service ssh start
service mysql start
service postgresql start

service apache2 stop
a2enmod rewrite
a2enmod expires
service apache2 start

echo "NOTE: To set all system values to your location and to load all extra tools, you need exec '/home/docker/after_init.sh' as 'docker' user."

/bin/bash
