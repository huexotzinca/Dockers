#!/bin/bash

#Enable ssh, apache and mysql on start
service ssh start
apache2ctl -k start
service mysql start
/bin/bash