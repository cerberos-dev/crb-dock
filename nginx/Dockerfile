FROM nginx:alpine

MAINTAINER Spring Digital <development@springdigital.nl>

ADD nginx.conf /etc/nginx/

ARG PHP_UPSTREAM=php-fpm

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && apk add --no-cache openssl \
    && adduser -D -H -u 1000 -s /bin/bash -Gwww-data www-data \
    && rm /etc/nginx/conf.d/default.conf \
    && echo "upstream php-upstream { server ${PHP_UPSTREAM}:9000; }" > /etc/nginx/conf.d/upstream.conf

CMD ["nginx"]

EXPOSE 80 443
