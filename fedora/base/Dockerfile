FROM fedora:25
MAINTAINER Neftali Bautista<dev@neftalibautista.com>

LABEL version="0.0.1"

ARG USER_NAME="docker"
ARG USER_PATH="/home/${USER_NAME}"
ARG TMP_PATH="${USER_PATH}/tmp"
ARG REDIS_RELEASE="redis-4.0.2"
ARG REDIS_TAR_NAME="${REDIS_RELEASE}.tar.gz"
ARG MONGODB_USER_NAME="mongod"
ARG MONGODB_GROUP_NAME="${MONGODB_USER_NAME}"
ARG MONGODB_RELEASE="3.4"
ARG MONGODB_VER_NAME="mongodb-${MONGODB_RELEASE}"
ARG PHANTOMJS_RELEASE="phantomjs-2.1.1"
ARG PHANTOMJS_VER_NAME="${PHANTOMJS_RELEASE}-linux-x86_64"
ARG PHANTOMJS_TAR_NAME="${PHANTOMJS_VER_NAME}.tar.bz2"
ARG ROOT_USER_PASSWORD="docker"
ARG DOCKER_USER_PASSWORD="${ROOT_USER_PASSWORD}"
ARG BASH_RC_FILE="bashrc"
ARG WATCHMAN_RELEASE_VERSION="4.9.0"

RUN dnf -y update && \
    dnf -y install autoconf automake bison procps && \
    dnf -y install sudo && \
    dnf -y install curl && \
    dnf -y install wget && \
    dnf -y install git subversion bzr bash-completion && \
    dnf -y install vim && \
    dnf -y install sqlite libsqlite3x-devel && \
    dnf -y install openssl libtool tcl tcl-devel  && \
    dnf -y install libxml2-devel libffi-devel && \
    dnf -y install libxslt-devel ncurses-devel && \
    dnf -y install python-devel python3 python3-devel

# PhantomJS dependencies
RUN dnf -y install gcc gcc-c++ make flex bison gperf ruby && \
    dnf -y install openssl-devel freetype-devel fontconfig-devel && \
    dnf -y install libicu-devel sqlite-devel libpng-devel libjpeg-devel

# Watchman dependencies
RUN dnf -y install redhat-rpm-config

# Install open ssh
RUN dnf -y install openssh-server openssh-clients openssh gnupg

# Adding mongo dependencies
RUN echo -e "[${MONGODB_VER_NAME}]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/${MONGODB_RELEASE}/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-${MONGODB_RELEASE}.asc" > "/etc/yum.repos.d/${MONGODB_VER_NAME}.repo" && \
    dnf -y update

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
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN /bin/bash -l -c "curl -L https://get.rvm.io | bash -s stable"

#Install NVM
RUN /bin/bash -l -c "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash"

RUN /bin/bash -l -c  "rvm install 2.4 && \
    rvm install 2.2 && \
    rvm use 2.2 && \
    gem install haml && \
    gem install sass && \
    gem install compass && \
    gem install rails && \
    rvm --default use 2.4 && \
    gem install haml && \
    gem install sass && \
    gem install compass && \
    gem install rails"

RUN /bin/bash -l -c "source \"${USER_PATH}/.nvm/nvm.sh\" && \
    nvm install 6.11.3 && \
    nvm install 8.6.0 && \
    nvm alias default 8.6.0 && \
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
    git checkout v${WATCHMAN_RELEASE_VERSION} && \
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
RUN dnf install -y mongodb-org mongodb-org-server && \
    mkdir -p /data/db && \
    chown "${USER_NAME}:${USER_NAME}" "/data" && \
    chown "${USER_NAME}:${USER_NAME}" "/data/db"

# Make symlink to phantomJS
RUN ln -s /opt/phantomjs/${PHANTOMJS_VER_NAME}/bin/phantomjs /usr/bin/phantomjs

WORKDIR $USER_PATH

RUN rm -rf "${TMP_PATH}"

EXPOSE 22 27017 3000 3200 30820 4200 49153 5000 6379 7357

ENTRYPOINT ["/root/start.sh"]