# Cerberos Docker (crb-dock)
Our own Docker setup.

## Installation guide
1. `git clone https://github.com/cerberos-dev/crb-dock.git`.
2. Copy `.env.example` to `.env`.
3. Edit `.env` to fit local environment.
4. Start containers: `docker-compose up -d`.

You can also start the containers and display debug information with: `docker-compose up`

## NGINX setup
1. Go to `nginx/sites` copy an example config to a `<project-name>.conf file.`
2. Edit the config file to fit the project.
3. When not using dnsmasq, adjust your local host file (for example: `/etc/hosts`).
4. Reload Nginx service: `docker exec -it crb_dock_nginx bash -c "nginx -s reload"`.

## Switching PHP-FPM versions
1. Make sure all containers are down (`docker ps` should give no results).
2. Change your `.env` file to the desired version (see example file for more info).
3. Rebuild the php-fpm container: `docker-compose build php-fpm`.
4. Now you can use `crb-dock` as usual with the desired PHP version.

# Notes
## DNS and `crb-dock`
Make resolving hosts easier by using Dnsmasq, setup script included in tools directory (macOS only).

### How-to run our dnsmasq setup script
<sup>It will request sudo access so make sure you know your password.</sup>
1. Enter the directory `tools`.
2. Run the `setupDNS.sh` script.
3. Enter sudo password to start/restart services.
4. Make sure all containers are up with `docker ps`.
5. Open a browser and navigate to `https://crb-dock.crb/` or `https://crb-dock.local/`


