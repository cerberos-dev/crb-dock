FROM phusion/baseimage:latest

MAINTAINER Cerberos <development@cerberos.dev>

COPY run-certbot.sh /root/certbot/run-certbot.sh

RUN apt-get update
RUN apt-get install -y letsencrypt

ENTRYPOINT bash -c "bash /root/certbot/run-certbot.sh && sleep infinity"
