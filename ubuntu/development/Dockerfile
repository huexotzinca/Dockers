FROM huexotzinca/base
MAINTAINER Neftali Bautista<dev@neftalibautista.com>

LABEL version="0.0.1"

ARG USER_NAME="docker"
ARG USER_PATH="/home/${USER_NAME}"
ARG TMP_PATH="${USER_PATH}/tmp"
ARG ROOT_USER_PASSWORD="docker"
ARG DOCKER_USER_PASSWORD="${ROOT_USER_PASSWORD}"
ARG ROOT_DB_PASSWORD="${ROOT_USER_PASSWORD}"
ARG PHPUNIT_VERSION="5.5"
ARG APACHE_SEARCH="IncludeOptional sites-enabled/*.conf"
ARG APACHE_REPLACEMENT="# ${APACHE_SEARCH}\nIncludeOptional /home/docker/apache/main.conf"

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
    php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    sudo mv composer.phar /usr/local/bin/composer && \
    composer global require "phpunit/phpunit=${PHPUNIT_VERSION}.*" && \
    composer global require "laravel/installer"

# Config apache
COPY apache "${USER_PATH}/apache"
COPY media "${USER_PATH}/media"

USER root

RUN chown "${USER_NAME}:${USER_NAME}" "${USER_PATH}/apache" && \
        chown "${USER_NAME}:${USER_NAME}" "${USER_PATH}/media"

# Make apache conf backup copy
RUN cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.backup

RUN APACHE_SEARCH="$(echo $APACHE_SEARCH | sed 's=[/.*]=\\\0=gm')" && \
        APACHE_REPLACEMENT="$(echo $APACHE_REPLACEMENT | sed 's=[/.*]=\\\0=gm')"
        
RUN sed -i 's/'"${APACHE_SEARCH}"'/'"${APACHE_REPLACEMENT}"'/' /etc/apache2/apache2.conf

RUN apt-get -y install libmysqlclient20 libmysqlclient-dev python-dev

# Install open ssh
RUN apt-get -y install openssh-server openssh-client

#Enable ssh, apache and mysql on start
RUN service ssh start && systemctl enable ssh
RUN systemctl enable apache2
RUN systemctl enable mysql
RUN systemctl enable postgresql

CMD ["/usr/sbin/sshd", "-D"]
CMD ["/usr/sbin/apache2ctl", "-k", "start"]
CMD ["/usr/sbin/mysqld"]
CMD ["/usr/lib/postgresql/9.5/bin/postgres", "-D", "/var/lib/postgresql/9.5/main", "-c", "config_file=/etc/postgresql/9.5/main/postgresql.conf"]

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