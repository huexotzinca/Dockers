FROM huexotzinca/base
MAINTAINER Neftali Bautista<dev@neftalibautista.com>

LABEL version="0.0.2"

ARG USER_NAME="docker"
ARG USER_PATH="/home/${USER_NAME}"
ARG TMP_PATH="${USER_PATH}/tmp"
ARG ROOT_USER_PASSWORD="docker"
ARG DOCKER_USER_PASSWORD="${ROOT_USER_PASSWORD}"
ARG ROOT_DB_PASSWORD="${ROOT_USER_PASSWORD}"
ARG PHPUNIT_VERSION="5.5"
ARG BASH_RC_FILE="bashrc"

RUN apt-get update 

# Apache, PHP and MySQL-PostgreSQL
RUN apt-get -y install apache2 apache2-dev && \
    apt-get -y install php php-cli && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server && \
    apt-get -y install mysql-client && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql && \
    apt-get -y install postgresql-client postgresql-contrib && \
    apt-get -y install libapache2-mod-php php-gd php-ldap php-odbc php-mysql php-pgsql libapache2-mod-auth-pgsql php-curl php-xmlrpc php-intl php-mcrypt && \
    apt-get -y install php-pear pear-channels

RUN pear channel-update pear.php.net && \
    pear upgrade-all

USER "${USER_NAME}"
RUN mkdir -p "${TMP_PATH}"
WORKDIR $TMP_PATH

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
        php composer-setup.php && \
        php -r "unlink('composer-setup.php');" && \
        sudo mv composer.phar /usr/local/bin/composer && \
        sudo composer self-update && \
        composer global require "phpunit/phpunit=${PHPUNIT_VERSION}.*" && \
        composer global require "laravel/installer"

# Config apache
COPY apache "${USER_PATH}/apache"
COPY media "${USER_PATH}/media"
COPY start.sh "${USER_PATH}/start.sh"

RUN cp "${USER_PATH}/.bashrc" "${USER_PATH}/.bashrc.old"
COPY "${BASH_RC_FILE}" "${USER_PATH}/.bashrc"

USER root

RUN mkdir "${USER_PATH}/apache/enabled"
RUN mkdir "${USER_PATH}/apache/sites"

RUN chown -R "${USER_NAME}:${USER_NAME}" "${USER_PATH}/apache" && \
        chown -R "${USER_NAME}:${USER_NAME}" "${USER_PATH}/media" && \
        chown -R "${USER_NAME}:${USER_NAME}" "${USER_PATH}/.bashrc"

# Make apache conf backup copy
RUN cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.backup
COPY apache2.conf /etc/apache2/apache2.conf

RUN chmod +X "${USER_PATH}/start.sh" && \
        chown -R "${USER_NAME}:${USER_NAME}" "${USER_PATH}/start.sh"

RUN apt-get -y install libmysqlclient20 libmysqlclient-dev python-dev

# Install open ssh
RUN apt-get -y install openssh-server openssh-client

# Expose the ssh port
EXPOSE 22

# Expose the Apache ports
EXPOSE 80 8080

# Expose the MySQL port
EXPOSE 3306

# Expose the PostgreSQL port
EXPOSE 5432

WORKDIR $USER_PATH
RUN rm -rf "${TMP_PATH}"

CMD ["/home/docker/start.sh"]