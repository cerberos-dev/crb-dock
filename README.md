# You Are Docker (yadock)
Our own Docker setup.

## Installation guide
1. `$ git clone https://github.com/You-Are-Digital/yadock`
2. Copy env-example to .env
3. Edit .env to fit local environment
4. `$ docker-compose up -d {nginx} {apache2} {mysql}`

## Project setup
1. Go to  nginx->sites copy an example config to a \<project-name>.conf file
2. Edit the config file to fit the project
3. Adjust your local host file (For example: /etc/hosts)
4. `$ docker-compose stop nginx`
5. `$ docker-compose up -d nginx` (restarting container to sync all .conf files)

## Switching PHP-FPM versions
1. Make sure all containers are down. (`$ docker ps` should give no results)
2. Edit your .env file to the desired version. (currently supporting 7.2, 7.1 and 5.6. Directions on how to do that are in the example file)
3. Rebuild the php-fpm container (`$ docker-compose build php-fpm` on commandline)
4. Now you can use yadock as usual with the desired PHP version.

## Using IonCube Loader
IonCube Loader is used to decode protected PHP code.  
Read more on [the ioncube loader website](https://www.ioncube.com/loaders.php).  

1. Make sure all containers are down (`$ docker ps` should give no results)
2. Change the `PHP_FPM_INSTALL_IONCUBE` setting to true
3. Rebuild the php-fpm container (`$ docker-compose build php-fpm` on commandline)
4. When the build is complete you can bring the containers up again like usual`

## Use ElasticSearch
1. Run the ElasticSearch Container with the docker-compose up command:
`docker-compose up -d elasticsearch`
2. Open your browser and visit the localhost on port 9200: http://localhost:9200
The default username is user and the default password is changeme.

## Install ElasticSearch Plugin
1. Install an ElasticSearch plugin.
`docker-compose exec elasticsearch /usr/share/elasticsearch/bin/plugin install {plugin-name}`
2. Restart elasticsearch container
docker-compose restart elasticsearch

# Notes
## docker-compose up
There is no need to up the workspace or the php container because they are linked to the webserver and database containers.

## DNS and YADOCK
Make resolving hosts easier by using DNSMASQ (works on OSX / Linux) we're going to give an description regarding the OSX install

Using a terminal client browse to:
`yadock/tools`

and run:
`./setupDNS.sh`

It will request sudo access so make sure you know your password.