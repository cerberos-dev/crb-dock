# Spring Digital Docker (SprDock)
Our own Docker setup.

## Installation guide
1. `git clone https://github.com/Spring-Digital/sprdock.git`.
2. Copy `.env.example` to `.env`.
3. Edit `.env` to fit local environment.
4. Start containers: `docker-compose up -d {nginx} {apache2} {mysql}`.

## NGINX setup
1. Go to `nginx/sites` copy an example config to a `<project-name>.conf file.`
2. Edit the config file to fit the project.
3. Adjust your local host file (For example: `/etc/hosts`).
4. Stop the NGINX container: `docker-compose stop nginx`.
5. Start the NGINX container to sync `.conf` files: `docker-compose up -d nginx`.

## Apache2 setup
1. Go to `apache2/sites` copy an example config to a `<project-name>.conf file.`
2. Edit the config file to fit the project.
3. Adjust your local host file (For example: `/etc/hosts`).
4. Stop the Apache2 container: `docker-compose stop apache2`.
5. Start the Apache2 container to sync `.conf` files: `docker-compose up -d apache2`.

## Switching PHP-FPM versions
1. Make sure all containers are down (`docker ps` should give no results).
2. Change your `.env` file to the desired version (currently supporting 5.6, 7.1 and 7.2. See example file for more info).
3. Rebuild the php-fpm container: `docker-compose build php-fpm`.
4. Now you can use `SprDock` as usual with the desired PHP version.

## Using IonCube Loader
<sup>IonCube Loader is used to decode protected PHP code. [Read more on the ioncube loader website](https://www.ioncube.com/loaders.php).</sup>
1. Make sure all containers are down (`docker ps` should give no results)
2. Change the `PHP_FPM_INSTALL_IONCUBE` setting to true
3. Rebuild the php-fpm container (`$ docker-compose build php-fpm` on commandline)
4. When the build is complete you can bring the containers up again like usual

## Use ElasticSearch
1. Run the ElasticSearch Container: `docker-compose up -d elasticsearch`
2. Open your browser and visit the localhost on port 9200: http://localhost:9200

<sup>The default username is `user` and the default password is `changeme`.</sup>

## Install ElasticSearch Plugin(s)
1. Install ElasticSearch plugin(s): `docker-compose exec elasticsearch /usr/share/elasticsearch/bin/plugin install {plugin-name}`
2. Restart ElasticSearch container: `docker-compose restart elasticsearch`

# Notes
## docker-compose up
There is no need to up the `workspace` or the `php` container because they are linked to the webserver (NGINX / Apache2) and database containers.

## DNS and SprDock
Make resolving hosts easier by using DNSMASQ (works on OSX / Linux) we're going to give an description regarding the OSX install

Using a terminal client browse to: `/tools` and run: `./setupDNS.sh`

<sup>It will request sudo access so make sure you know your password.</sup>
