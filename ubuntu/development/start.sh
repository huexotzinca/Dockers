#!/bin/bash

# Enable ssh, apache, mysql and postgresql on container start
service ssh start
service mysql start
service postgresql start

service apache2 stop
a2enmod rewrite
a2enmod expires
service apache2 start

curl https://gist.githubusercontent.com/huexotzinca/a88f3afb0feca1b3e5b55736779d1ec7/raw > /home/docker/after_init.sh && \
chown docker:docker /home/docker/after_init.sh && \
chmod +X /home/docker/after_init.sh

echo "NOTE: To set all system values to your location and to load all extra tools, you need exec '/home/docker/after_init.sh' as 'docker' user."

/bin/bash
