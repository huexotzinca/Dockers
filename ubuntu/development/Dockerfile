FROM huexotzinca/base
MAINTAINER Neftali Bautista<dev@neftalibautista.com>

LABEL version="0.1.3"

ARG ADMIN_GROUP_NAME="admin"
ARG USER_NAME="docker"
ARG USER_GROUP_NAME="docker"
ARG USER_PATH="/home/${USER_NAME}"
ARG APACHE_USER_NAME="www-data"
ARG APACHE_GROUP_NAME="apache"
ARG TMP_PATH="${USER_PATH}/tmp"
ARG ROOT_USER_PASSWORD="docker"
ARG DOCKER_USER_PASSWORD="${ROOT_USER_PASSWORD}"
ARG ROOT_DB_PASSWORD="${ROOT_USER_PASSWORD}"
ARG PHPUNIT_VERSION="6.3"
ARG BASH_RC_FILE="bashrc"

RUN apt-get update 

# Apache, PHP and MySQL-PostgreSQL
RUN apt-get -y install apache2 apache2-dev && \
    apt-get -y install php php-cli && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server && \
    apt-get -y install mysql-client && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql && \
    apt-get -y install postgresql-client postgresql-contrib && \
    apt-get -y install libapache2-mod-php php7.0-gd php7.0-ldap php7.0-odbc && \
    apt-get -y install php7.0-mysql php7.0-pgsql libapache2-mod-auth-pgsql && \
    apt-get -y install php7.0-curl php7.0-xmlrpc php7.0-intl php7.0-mcrypt && \
    apt-get -y install php7.0-mbstring php7.0-zip libapache2-mod-php7.0 && \
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
    composer self-update && \
    composer global require "phpunit/phpunit=${PHPUNIT_VERSION}.*" && \
    composer global require "laravel/installer"

# Config apache
COPY apache "${USER_PATH}/apache"
COPY media "${USER_PATH}/media"

RUN sudo groupadd ${APACHE_GROUP_NAME}
# WARNING: Adding apache user to admin group, because www-data need permissions
#          for access to media folder formount and read php projects in apache.
#          If you don't need that apache user modify your mounted volume, comment
#          this line. Or if you are in production server, for security reasons
#          you must comment the next line, and  use media or /var/www directory.
RUN sudo usermod -a -G ${ADMIN_GROUP_NAME} ${APACHE_USER_NAME}
# Adding docker user to apache group
RUN sudo usermod -a -G ${APACHE_GROUP_NAME} ${USER_NAME}

COPY "${BASH_RC_FILE}" "${USER_PATH}/.bashrc"

# vim and git global files
WORKDIR $TMP_PATH
RUN git clone https://github.com/huexotzinca/dotfiles && \
    cp -r dotfiles/vim "$USER_PATH/.vim" && \
    cp dotfiles/vimrc "$USER_PATH/.vimrc" && \
    cp dotfiles/gitconfig "$USER_PATH/.gitconfig" && \
    cp dotfiles/gitignore "$USER_PATH/.gitignore" && \
    git config --global --unset user.name && \
    git config --global --unset user.email

USER root

RUN mkdir "${USER_PATH}/apache/enabled"
RUN mkdir "${USER_PATH}/apache/sites"

RUN chown -R "${USER_NAME}:${USER_NAME}" "${USER_PATH}/apache" && \
    chown -R "${APACHE_USER_NAME}:${APACHE_GROUP_NAME}" "${USER_PATH}/media" && \
    chmod -R 775 "${USER_PATH}/media" && \
    chown "${USER_NAME}:${USER_NAME}" "${USER_PATH}/.bashrc"

COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

COPY after_init.sh /home/docker/after_init.sh
RUN chmod +x /home/docker/after_init.sh && chown ${USER_NAME}:${USER_NAME} /home/docker/after_init.sh

# Make apache conf backup copy
RUN cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.backup
COPY apache2.conf /etc/apache2/apache2.conf

# Install tools for mysql and set the root password
RUN apt-get -y install libmysqlclient20 libmysqlclient-dev python-dev && \
    service mysql start && \
    mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${ROOT_DB_PASSWORD}');"

# Expose the Apache ports
EXPOSE 80 8080

# Expose the MySQL port
EXPOSE 3306

# Expose the PostgreSQL port
EXPOSE 5432

#### Expose the Frameworks ports: ####
# PHP: laravel
EXPOSE 8000
### /Expose the Frameworks ports   ###

WORKDIR $USER_PATH
RUN rm -rf "${TMP_PATH}"
RUN [ -f "/home/docker/.sudo_as_admin_successful" ] && \
    rm -rf "/home/docker/.sudo_as_admin_successful" || echo "File not found"

ENTRYPOINT ["/root/start.sh"]
