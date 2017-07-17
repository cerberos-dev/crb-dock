# You Are Docker (yadock)
Our own Docker setup.

# Installation guide
1. `$ git clone https://github.com/You-Are-Digital/yadock`
2. Copy env-example to .env
3. Edit .env to fit local environment
4. `$ docker-compose up -d {nginx} {apache2} {mysql}`

# Project setup
1. Go to  nginx->sites copy an example config to a \<project-name>.conf file
2. Edit the config file to fit the project
3. Adjust your local host file (For example: /etc/hosts)
4. `$ docker-compose stop nginx`
5. `$ docker-compose up -d nginx` (restarting container to sync all .conf files)

# Switching PHP-FPM versions
1. Make sure all containers are down. (docker ps should give no results)
2. Edit your .env file to the desired version. (currently supporting 7.1 and 5.6 directions on how to do that are in the example file)
3. Rebuild the php-fpm container (docker-compose build php-fpm on commandline)
4. Now you can use yadock as usual with the desired PHP version.

# Notes
## docker-compose up
There is no need to up the workspace or the php container because they are linked to the webserver and database containers.
