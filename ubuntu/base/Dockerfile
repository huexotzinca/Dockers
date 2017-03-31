FROM ubuntu:16.10
MAINTAINER Neftali Bautista<dev@neftalibautista.com>

LABEL version="0.1.1"

ARG USER_NAME="docker"
ARG USER_PATH="/home/${USER_NAME}"
ARG TMP_PATH="${USER_PATH}/tmp"
ARG REDIS_RELEASE="redis-3.2.8"
ARG REDIS_TAR_NAME="${REDIS_RELEASE}.tar.gz"
ARG PHANTOMJS_RELEASE="phantomjs-2.1.1"
ARG PHANTOMJS_VER_NAME="${PHANTOMJS_RELEASE}-linux-x86_64"
ARG PHANTOMJS_TAR_NAME="${PHANTOMJS_VER_NAME}.tar.bz2"
ARG ROOT_USER_PASSWORD="docker"
ARG DOCKER_USER_PASSWORD="${ROOT_USER_PASSWORD}"
ARG BASH_RC_FILE="bashrc"

RUN apt-get update && \
      apt-get -y install build-essential pkg-config autoconf automake bison && \
      apt-get -y install apt-utils && \
      apt-get -y install sudo && \
      apt-get -y install curl && \
      apt-get -y install wget && \
      apt-get -y install git subversion bzr && \
      apt-get -y install vim && \
      apt-get -y install sqlite3 libsqlite3-dev && \
      apt-get -y install openssl libcurl4-openssl-dev libtool zlib1g && \
      apt-get -y install zlib1g-dev python-software-properties tcl8.6  && \
      apt-get -y install tcl8.6-dev libssl-dev libreadline-dev libyaml-dev && \
      apt-get -y install libxml2-dev libxslt1-dev libffi-dev libreadline6 && \
      apt-get -y install libreadline6-dev libxslt-dev libc6-dev ncurses-dev && \
      apt-get -y install python-dev python3 python3-dev

# PhantomJS dependencies
RUN apt-get -y install build-essential g++ flex bison gperf ruby perl && \
    apt-get -y install libsqlite3-dev libfontconfig1-dev libicu-dev && \
    apt-get -y install libfreetype6 libssl-dev libpng-dev libjpeg-dev && \
    apt-get -y install python libx11-dev libxext-dev

# Install open ssh
RUN apt-get -y install openssh-server openssh-client

# Adding mongo dependencies
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update

# Adding docker user
RUN groupadd admin && \
    groupadd "${USER_NAME}" && \
    useradd -m -g "${USER_NAME}" -G admin -s /bin/bash "${USER_NAME}"

RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root:${ROOT_USER_PASSWORD}" | chpasswd && \
    echo "docker:${ROOT_USER_PASSWORD}" | chpasswd && \
    mkdir "${TMP_PATH}" && \
    chown $USER_NAME:$USER_NAME "${TMP_PATH}"

# BASHRC
RUN cp "${USER_PATH}/.bashrc" "${USER_PATH}/.bashrc.default"
COPY "${BASH_RC_FILE}" "${USER_PATH}/.bashrc"

RUN mkdir /opt/phantomjs
RUN cp "/root/.bashrc" "/root/.bashrc.default"
COPY "${BASH_RC_FILE}" "/root/.bashrc"

RUN chown "root:root" "/root/.bashrc" && \
    chown "root:root" "/root/.bashrc.default" && \
    chown "${USER_NAME}:${USER_NAME}" "${USER_PATH}/.bashrc" && \
    chown "${USER_NAME}:${USER_NAME}" "${USER_PATH}/.bashrc.default" && \
    chown "${USER_NAME}:${USER_NAME}" "/opt/phantomjs"

COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

USER $USER_NAME

WORKDIR $TMP_PATH

#Install RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN /bin/bash -l -c "curl -L https://get.rvm.io | bash -s stable"

#Install NVM
RUN /bin/bash -l -c "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash"

RUN /bin/bash -l -c  "rvm install 2.3 && \
      rvm install 2.2 && \
      rvm --default use 2.2 && \
      gem install haml && \
      gem install sass && \
      gem install compass && \
      gem install rails"

RUN /bin/bash -l -c "source \"${USER_PATH}/.nvm/nvm.sh\" && \
        nvm install 6.10 && \
        nvm install 4.5 && \
        nvm install 0.12.18 && \
        nvm alias default 6.10 && \
        npm install -g less  && \
        npm install -g uglify-js && \
        npm install -g socket.io && \
        npm install -g coffee-script && \
        npm install -g handlebars && \
        npm install -g grunt && \
        npm install -g brunch && \
        npm install -g bower && \
        npm install -g browserify  && \
        npm install -g forever"

## TESTING
RUN /bin/bash -l -c "source \"${USER_PATH}/.nvm/nvm.sh\" && \
        npm install -g vows && \
        npm install -g jasmine && \
        npm install -g jasmine-node && \
        npm install -g mocha && \
        npm install -g --save-dev qunitjs && \
        npm install -g blanket && \
        npm install -g karma"

## DEBUG
RUN /bin/bash -l -c "source \"${USER_PATH}/.nvm/nvm.sh\" && npm install -g weinre"

## FRAMEWORKS
RUN /bin/bash -l -c "source \"${USER_PATH}/.nvm/nvm.sh\" && \
      npm install -g express && \
      npm install -g express-generator  && \
      npm install -g sails && \
      npm install -g geddy && \
      npm install -g ember-cli && \
      npm install -g @angular/cli && \
      npm install -g yo && \
      npm install -g generator-webapp && \
      npm install -g generator-jquery && \
      npm install -g generator-jasmine && \
      npm install -g generator-mocha && \
      npm install -g generator-chrome-extension && \
      npm install -g generator-chromeapp && \
      npm install -g generator-bootstrap && \
      npm install -g generator-polymer && \
      npm install -g generator-backbone && \
      npm install -g generator-angular && \
      npm install -g generator-karma"

# install watchman for ember
WORKDIR $TMP_PATH
RUN git clone https://github.com/facebook/watchman.git && \
    cd watchman && \
    git checkout v4.7.0 && \
    ./autogen.sh && \
    ./configure && \
    make

WORKDIR $TMP_PATH

#PhantomJS
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/${PHANTOMJS_TAR_NAME} && \
    tar -xjf "${PHANTOMJS_TAR_NAME}" && \
    mv "${PHANTOMJS_VER_NAME}" /opt/phantomjs/


#install redis
RUN curl -O "http://download.redis.io/releases/${REDIS_TAR_NAME}" && \
    tar -xvzf "${REDIS_TAR_NAME}" && \
    cd "${REDIS_RELEASE}" && \
    make

USER root

# finish of installing Watchman for ember and Redis as root
WORKDIR $TMP_PATH
RUN cd watchman && \
    make install

WORKDIR $TMP_PATH
RUN cd "${REDIS_RELEASE}" && \
    make install

# install mongoDB opensource version
RUN apt-get install -y mongodb-org && \
    mkdir -p /data/db && \
    chown "${USER_NAME}:${USER_NAME}" "/data" && \
    chown "${USER_NAME}:${USER_NAME}" "/data/db"

RUN ln -s /opt/phantomjs/${PHANTOMJS_VER_NAME}/bin/phantomjs /usr/bin/phantomjs

WORKDIR $USER_PATH

RUN rm -rf "${TMP_PATH}"

EXPOSE 22 27017 3000 3200 30820 4200 49153 5000 6379 7357

ENTRYPOINT ["/root/start.sh"]