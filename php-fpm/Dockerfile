# --------------------------------------------------------------------------
# Image Setup
#
# Unified Dockerfile for PHP 8.1, 8.2, 8.3 and 8.4.
# Select the version with the build argument PHP_VERSION (default: 8.4).
# For PHP 7.4 legacy support see Dockerfile-7.4.
# --------------------------------------------------------------------------

ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm

LABEL maintainer="Cerberos <development@cerberos.dev>"

ARG PHP_VERSION

# --------------------------------------------------------------------------
# Mandatory Software Installation
# --------------------------------------------------------------------------

RUN apt-get update -yqq && \
    apt-get install -y --no-install-recommends \
        curl \
        libfreetype6-dev \
        libjpeg-dev \
        libmemcached-dev \
        libpng-dev \
        libpq-dev \
        libssl-dev \
        libxml2-dev \
        libzip-dev \
        libz-dev && \
    docker-php-ext-install pdo_mysql pdo_pgsql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# --------------------------------------------------------------------------
# Optional Software Installation
#
# Optional software is only installed when set to `true` in `docker-compose.yml`.
# --------------------------------------------------------------------------

# SSH
ARG INSTALL_SSH=false
RUN if [ "${INSTALL_SSH}" = true ]; then \
    apt-get update -yqq && \
    apt-get install -y --no-install-recommends ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
;fi

# SOAP
ARG INSTALL_SOAP=false
RUN if [ "${INSTALL_SOAP}" = true ]; then \
    apt-get update -yqq && \
    apt-get install -y --no-install-recommends libxml2-dev && \
    docker-php-ext-install soap && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
;fi

# PHP Redis Extension
ARG INSTALL_PHPREDIS=false
RUN if [ "${INSTALL_PHPREDIS}" = true ]; then \
    pecl install -o -f redis && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable redis \
;fi

# Swoole
ARG INSTALL_SWOOLE=false
RUN if [ "${INSTALL_SWOOLE}" = true ]; then \
    pecl install swoole && \
    docker-php-ext-enable swoole \
;fi

# ZipArchive
ARG INSTALL_ZIP_ARCHIVE=false
RUN if [ "${INSTALL_ZIP_ARCHIVE}" = true ]; then \
    docker-php-ext-install zip \
;fi

# bcmath
ARG INSTALL_BCMATH=false
RUN if [ "${INSTALL_BCMATH}" = true ]; then \
    docker-php-ext-install bcmath \
;fi

# Memcached
ARG INSTALL_MEMCACHED=false
RUN if [ "${INSTALL_MEMCACHED}" = true ]; then \
    pecl install -o -f memcached && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable memcached \
;fi

# Imagick (requires imagick 3.8+ for PHP 8.4)
ARG INSTALL_IMAGICK=false
RUN if [ "${INSTALL_IMAGICK}" = true ]; then \
    case "${PHP_VERSION}" in \
        8.1|8.2|8.3|8.4) \
            apt-get update -yqq && \
            apt-get install -y --no-install-recommends libmagickwand-dev && \
            pecl install -o -f imagick && \
            rm -rf /tmp/pear && \
            docker-php-ext-enable imagick && \
            apt-get clean && \
            rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
            ;; \
        *) \
            echo "WARNING: Imagick is not supported for PHP ${PHP_VERSION}; skipping." >&2 \
            ;; \
    esac \
;fi

# Exif
ARG INSTALL_EXIF=false
RUN if [ "${INSTALL_EXIF}" = true ]; then \
    docker-php-ext-install exif \
;fi

# GD
ARG INSTALL_GD=false
RUN if [ "${INSTALL_GD}" = true ]; then \
    docker-php-ext-install gd \
;fi

# Opcache
ARG INSTALL_OPCACHE=false
RUN if [ "${INSTALL_OPCACHE}" = true ]; then \
    docker-php-ext-install opcache \
;fi

# Copy opcache configuration
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Mysqli
ARG INSTALL_MYSQLI=false
RUN if [ "${INSTALL_MYSQLI}" = true ]; then \
    docker-php-ext-install mysqli \
;fi

# Tokenizer is built into PHP 8.1+
ARG INSTALL_TOKENIZER=false
RUN if [ "${INSTALL_TOKENIZER}" = true ]; then \
    echo "Tokenizer is built into PHP 8.1 and higher." \
;fi

# Intl
ARG INSTALL_INTL=false
RUN if [ "${INSTALL_INTL}" = true ]; then \
    apt-get update -yqq && \
    apt-get install -y --no-install-recommends libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
;fi

# LDAP
ARG INSTALL_LDAP=false
RUN if [ "${INSTALL_LDAP}" = true ]; then \
    apt-get update -yqq && \
    apt-get install -y --no-install-recommends libldap2-dev && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
;fi

# IonCube loader (PHP 8.1-8.4).
# Use Dockerfile-7.4 if you need IonCube on PHP 7.4.
ARG INSTALL_IONCUBE=false
RUN if [ "${INSTALL_IONCUBE}" = true ]; then \
    case "${PHP_VERSION}" in \
        8.1|8.2|8.3|8.4) \
            cd /tmp && \
            curl -Lo ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
            tar -xvzf ioncube.tar.gz && \
            mkdir -p "$(php-config --extension-dir)" && \
            mv ioncube/ioncube_loader_lin_${PHP_VERSION}.so "$(php-config --extension-dir)/ioncube_loader_lin_${PHP_VERSION}.so" && \
            echo "zend_extension=$(php-config --extension-dir)/ioncube_loader_lin_${PHP_VERSION}.so" > "/usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_${PHP_VERSION}.ini" && \
            rm -Rf ioncube.tar.gz ioncube \
            ;; \
        *) \
            echo "WARNING: IonCube is not supported for PHP ${PHP_VERSION}; skipping." >&2 \
            ;; \
    esac \
;fi

# WKHtmlToPDF
ARG INSTALL_WKHTMLTOPDF=false
RUN if [ "${INSTALL_WKHTMLTOPDF}" = true ]; then \
    cd /tmp && \
    curl -Lo wkhtmltopdf.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb && \
    apt-get update -yqq && \
    apt-get install -y --no-install-recommends ./wkhtmltopdf.deb xvfb && \
    rm -f wkhtmltopdf.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
;fi

# Calendar
ARG INSTALL_CALENDAR=false
RUN if [ "${INSTALL_CALENDAR}" = true ]; then \
    docker-php-ext-install calendar \
;fi

# --------------------------------------------------------------------------
# Final Touch
# --------------------------------------------------------------------------

COPY ./docker.pool.conf /usr/local/etc/php-fpm.d/

RUN usermod -u 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
