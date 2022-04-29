# --------------------------------------------------------------------------
# Image Setup
# --------------------------------------------------------------------------

FROM nginx:alpine

LABEL key="Cerberos <development@cerberos.dev>"

# --------------------------------------------------------------------------
# Mandatory Software's Installation
#
# If you're in China, or you need to change sources, will be set CHANGE_SOURCE to true in .env.
# --------------------------------------------------------------------------

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

ADD nginx.conf /etc/nginx/

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && apk add --no-cache openssl \
    && apk add --no-cache curl \
    && adduser -D -H -u 1000 -s /bin/bash -Gwww-data www-data \
    && rm /etc/nginx/conf.d/default.conf

# --------------------------------------------------------------------------
# Final Touch
# --------------------------------------------------------------------------

ARG PHP_UPSTREAM=php-fpm
ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000

RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf

ADD ./startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh
CMD ["/bin/bash", "/opt/startup.sh"]

EXPOSE 80 443

