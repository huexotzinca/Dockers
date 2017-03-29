# Huexotzinca Dockers

[![N|Solid](https://www.docker.com/sites/default/files/legal/small_h.png)](https://www.docker.com/)

This repo contains all Dockerfiles for automaticbuild used in [Huexotzinca's containers](https://hub.docker.com/u/huexotzinca/)


## [Base Version](https://hub.docker.com/r/huexotzinca/base/)

This Dockerfile builds an container for development purposes, [based on Ubuntu](https://hub.docker.com/_/ubuntu/) plus the next tools:

- Open SSH
- NVM
	- Node 0.12.18
	- Node 6.10
	- Node 4.5
	- Less
	- Uglify-js
	- Socket.io
	- Coffee-Script
	- Handlebars
	- Grunt
	- Brunch
	- Bower
	- Browserify 
	- Forever
	- [Express](http://expressjs.com/)
		- [Express-Generator](http://expressjs.com/es/starter/generator.html)
	- [Sails](http://sailsjs.com/)
	- [Geddy](http://geddyjs.org/)
	- [Angular-cli](https://github.com/angular/angular-cli)
	- [Ember-Cli](https://ember-cli.com/)
	- [Yeoman](http://yeoman.io/)
		- generator-webapp
		- generator-jquery
		- generator-jasmine
		- generator-mocha
		- generator-chrome-extension
		- generator-chromeapp
		- generator-bootstrap
		- generator-polymer
		- generator-backbone
		- generator-angular
		- generator-karma
	- [WeinRe](http://people.apache.org/~pmuellr/weinre/)
	- [Vows](http://vowsjs.org/)
	- [Jasmine](https://jasmine.github.io/)
		- [Jasmine-node](https://github.com/mhevery/jasmine-node)
	- [Mocha](https://mochajs.org/)
	- [QUnitJS](https://qunitjs.com/)
	- [Blanket](http://blanketjs.org/)
	- [Karma](http://karma-runner.github.io/)
- RVM
	- haml
	- sass
	- compass
	- rails
- NoSQL
	- MongoDB
	- Redis

> The users for this container are the next (User/Password):
> 
>	`docker/docker`
>
>	`root/docker`
>
> And if you have problems with RVM. For example when you try run this command 
> ``` gem update ``` you get ``` command not found ``` maybe you need try run 
> ``` /bin/bash --login ``` command.

### Build and Run

1. First clone the repo and change to ***ubuntu-base*** *branch*
	```bash
	> git clone https://github.com/huexotzinca/Dockers
	> cd Dockers
	> git checkout ubuntu-base
	```

2. And run the build command
	```bash
	> docker build -t my_image_name:my_tag .
	# Example:
	> docker build -t huexotzinca/base:v0.1.0 .
	```

3. Now you can run your container
	```bash
	> docker run -itP my_image_name:my_tag
	# Example, I would like have access to my code in the container, so you need -v (volume parameter):
	> docker run -itP -v /my/machine/path/for/projects:/home/docker/projects huexotzinca/base:v0.1.0
	> 
	# List your container ports with:
	> docker port YOUR_CONTAINER_ID
	# For list yours containers try:
	> docker ps -la
	```

Finally if you need connect through SSH you can see ```docker port YOUR_CONTAINER_ID | grep -E 22/tcp | grep -oE "[0-9]{4,6}"``` for show the bridge port.

### RVM Notes

The only thing you need know is that RVM needs enter with login shell, and in docker interactive (docker run -it) and in exec (docker exec -it) this doesn't work; so in case of you can't run ```ruby --version```, maybe you need exec ``` /bin/bash --login ``` into your container with `docker` user session. Otherwise you can try connect through SSH if your terminal supports user login RVM works fine.