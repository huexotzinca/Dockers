# Huexotzinca Dockers

[![N|Solid](https://www.docker.com/sites/default/files/legal/small_h.png)](https://www.docker.com/)

This repo contains all Dockerfiles for automaticbuild used in [Huexotzinca's containers](https://hub.docker.com/u/huexotzinca/)


## [Development Version](https://hub.docker.com/r/huexotzinca/development/)

This Dockerfile builds an container for development purposes, [based on Ubuntu-Base](https://github.com/huexotzinca/Dockers/tree/ubuntu-base) container plus the next tools:

- [Command-line fuzzy finder](https://github.com/junegunn/fzf)
- Apache
-	PHP (7.0.*)
  - [PhalconPHP](https://phalconphp.com/de/)
	-	Composer
		-	Laravel
		-	PHPUnit
- MySQL
- PostgreSQL
- [NVM](https://github.com/creationix/nvm)**
- [RVM](https://rvm.io/)**

** For NVM and RVM check this [list](https://github.com/huexotzinca/Dockers/tree/ubuntu-base/ubuntu/base), that will show you info from the packages and tools installed into the base image.

> Remember the main user info are the next (User/Password):
> 
>	`docker/docker`
>
>	`root/docker`
>
> And if you have problems with RVM. For example when you try run this command 
> ``` gem update ``` you get ``` command not found ``` maybe you need try run 
> ``` /bin/bash --login ``` command.


## Build and Run

1. First clone the repo and change to ***ubuntu-development*** *branch*
	```bash
	> git clone https://github.com/huexotzinca/Dockers
	> cd Dockers
	> git checkout ubuntu-development
	```

2. And run the build command
	```bash
	> docker build -t my_image_name:my_tag .
	# Example:
	> docker build -t huexotzinca/development:v0.1.4 .
	```

3. Now you can run your container
	```bash
	> docker run -itP my_image_name:my_tag
	# Example, I would like have access to my code in the container, so you need -v (volume parameter):
	> docker run -itP -v /my/machine/path/for/projects:/home/docker/projects huexotzinca/development:v0.1.4
	> 
	# List your container ports with:
	> docker ps -la
	```

4. Finally you can set yours locales and time (as root or sudo):
	```bash
	# Configure yours $LC_* and $LANG
	> sudo dpkg-reconfigure locales
	# And your time zone
	> sudo dpkg-reconfigure tzdata
	```


### Apache Notes

> NOTE: If you want mount a volume or volumes with your projects in PHP, then need you mount that volume(s) with default parameters, because www-data user is into admin group and the default values in run command set ` chown docker:admin ` values to these.

To enable sites on Apache like my-site.conf :

1. Create your my-site.conf on ~/apache/sites/ into Docker user session
	```bash
	> touch /home/docker/apache/sites/my-site.conf
	# Edit your conf file
	> vim !$
	```

2. Create the Symlink on ~/apache/enabled
	```bash
	> ln -s /home/docker/apache/sites/my-site.conf /home/docker/apache/enabled/my-site.conf
	```

3. Finally restart apache and enjoy:
	```bash
	> sudo apache2ctl -k restart
	# OR
	> sudo service apache2 restart
	```

Remember when you add ServerName apache parameter you need a DNS or add to your HOSTS file, example:

1. Repeat the previous 3 steps but in the step 1 do the next:
	```bash
	> vim /home/docker/your-site.conf
	```
	```config
	# Into VIM like docker user on your container
	Define MY_SITE_PATH /my/path/to/my/site
	ServerName my-site.dev
	<VirtualHost *:80>
	  DocumentRoot "${MY_SITE_PATH}"
	  ServerName subdomain.my-site.dev
	  DirectoryIndex  index.php index.html

	  ServerAdmin dev@airview.info

	  ErrorLog  ${ERRORS_PATH}/airview.error.log
	  CustomLog ${LOGS_PATH}/airview.log common
	  <Directory "${MY_SITE_PATH}/">
	    Options Indexes FollowSymLinks  Includes  ExecCGI
	    AllowOverride All
	    Order Allow,Deny
	    Allow from all
	    Require all granted
	  </Directory>
	</VirtualHost>
	```

2. Edit in ***your machine*** (**NOT DOCKER CONTAINER**) edit your HOSTFILE
```bash
	#linux
	> vim /etc/hosts
	#mac
	> vim /private/etc/hosts
	#windows maybe in windows you need move the file and then edit (is allowed) next you can overwrite the file.
	> /system32/drivers/etc/hosts
```
and add the line:
```bash
ip.of.your.docker_container	my-site.dev subdomain.my-site.dev
#eg. 
# 192.168.1.15	my-site.dev	subdomain.my-site.dev
```


### SQL (MySQL, PostgreSQL) Notes

If you want connect to MySql, then try:

```bash
# User: root
# Password: docker
mysql -U root -H localhost -P
```

Or connect to postgresql
```bash
# check the service is online
sudo service postgresql status

# otherwise start
sudo service postgresql restart

# connect to user that can use psql command
sudo -i -u postgres

postgres=# psql
```


### NoSQL (Mongo Notes)
See the [ubuntu-base](https://github.com/huexotzinca/Dockers/tree/ubuntu-base/ubuntu/base) branch documentation.


### Vim Notes

If you have issues with vim, try to reinstall all plugins, with [Plug](https://github.com/junegunn/vim-plug) is so easy:
```bash
# Into vim run
:PlugClean
# then confirm
# and after that run
:PlugInstall

# to reinstall all plugins, finally restart vim
```

The themes and air-line plugin work better on ssh connection.


And enjoy make code :sunglasses: !!
