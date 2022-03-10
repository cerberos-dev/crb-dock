# Cerberos Docker (crb-dock)
Our own Docker setup.

## Installation guide
1. `git clone https://github.com/cerberos-dev/crb-dock.git`.
2. Copy `.env.example` to `.env`.
3. Edit `.env` to fit local environment.
4. Start containers: `docker-compose up -d {nginx} {mariadb}`.

## NGINX setup
1. Go to `nginx/sites` copy an example config to a `<project-name>.conf file.`
2. Edit the config file to fit the project.
3. Adjust your local host file (For example: `/etc/hosts`).
4. Reload NGINX service: `docker exec -it crb_dock_nginx bash -c "nginx -s reload"`.

## Switching PHP-FPM versions
1. Make sure all containers are down (`docker ps` should give no results).
2. Change your `.env` file to the desired version (currently supporting 7.4 and 8.0. See example file for more info).
3. Rebuild the php-fpm container: `docker-compose build php-fpm`.
4. Now you can use `crb-dock` as usual with the desired PHP version.

## Using IonCube Loader
<sup>IonCube Loader is used to decode protected PHP code. [Read more on the ioncube loader website](https://www.ioncube.com/loaders.php).</sup>
1. Make sure all containers are down (`docker ps` should give no results)
2. Change the `PHP_FPM_INSTALL_IONCUBE` setting to true
3. Rebuild the php-fpm container (`$ docker-compose build php-fpm` on commandline)
4. When the build is complete you can bring the containers up again like usual

# Notes
## docker-compose up
There is no need to up the `workspace` or the `php` container because they are linked to the webserver (NGINX / Apache2) and database containers.

## DNS and crbDock
Make resolving hosts easier by using DNSMASQ (works on OSX / Linux) we're going to give an description regarding the OSX install

Using a terminal client browse to: `/tools` and run: `./setupDNS.sh`

<sup>It will request sudo access so make sure you know your password.</sup>
