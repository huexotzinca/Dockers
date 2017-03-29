# Huexotzinca Dockers

[![N|Solid](https://www.docker.com/sites/default/files/legal/small_h.png)](https://www.docker.com/)

This repo contains all Dockerfiles for automaticbuild used in [Huexotzinca's containers](https://hub.docker.com/u/huexotzinca/)


## [Development Version](https://hub.docker.com/r/huexotzinca/development/)

This Dockerfile builds an container for development purposes, [based on Ubuntu-Base](https://github.com/huexotzinca/Dockers/tree/ubuntu-base) container plus the next tools:

- Apache
-	PHP (7.0.*)
	-	Composer
		-	Laravel
		-	PHPUnit
- MySQL
- PostgreSQL
- [NVM](https://github.com/creationix/nvm)**
- [RVM](https://rvm.io/)**

** For NVM and RVM check this [list](https://github.com/huexotzinca/Dockers/tree/ubuntu-base/ubuntu/base) that show you info from the packages and tools installed into the base image.

> Remember the main user info is the next (User/Password):
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
	> docker build -t huexotzinca/development:v0.1.0 .
	```

3. Now you can run your container
	```bash
	> docker run -itP my_image_name:my_tag
	# Example, I would like have access to my code in the container, so you need -v (volume parameter):
	> docker run -itP -v /my/machine/path/for/projects:/home/docker/projects huexotzinca/development:v0.1.0
	> 
	# List your container ports with:
	> docker ps -la
	```


### SQL (MySQL, PostgreSQL) Notes

If you need connect to MySql:

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

And have fun :sunglasses: !!