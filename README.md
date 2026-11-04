# Cerberos Docker (crb-dock)

A Docker-based local development stack for PHP applications using Nginx, PHP-FPM,
MariaDB, Redis, and an optional management UI.

## Requirements

- Docker Engine 20.10+ with the Compose plugin
- Git
- (macOS only, optional) Homebrew for the dnsmasq helper script

## Quick start

1. Clone the repository:
   ```bash
   git clone https://github.com/cerberos-dev/crb-dock.git
   cd crb-dock
   ```

2. Copy the example environment file and adjust it to your machine:
   ```bash
   cp .env.example .env
   ```

3. Review the important variables in `.env`:
   - `APPLICATION` — path to your project code on the host.
   - `PHP_VERSION` — `7.4` (legacy WordPress), `8.1`, `8.2`, `8.3`, or `8.4`.
   - `MARIADB_*` — database name, user, and passwords (only used on first start).

4. Build and start the stack:
   ```bash
   docker compose up -d
   ```

   Or use the included Makefile:
   ```bash
   make start
   ```

5. Verify the services are healthy:
   ```bash
   docker compose ps
   ```

## Configuration reference

Key variables in `.env` (defaults shown are from `.env.example`):

| Variable | Default | Purpose |
| --- | --- | --- |
| `APPLICATION` | `${HOME}/code/` | Host path to your code, mounted at `APPLICATION_LOCATION` (`/var/www`). |
| `PHP_VERSION` | `8.4` | PHP-FPM version: `7.4`, `8.1`, `8.2`, `8.3`, `8.4`. |
| `DATA_SAVE_PATH` | `./data` | Host path for persistent data (MariaDB, Redis). |
| `DOCKER_HOST_IP` | `10.0.75.1` | Host IP injected as `dockerhost` in container `/etc/hosts`. |
| `NGINX_HOST_HTTP_PORT` / `NGINX_HOST_HTTPS_PORT` | `80` / `443` | Host ports mapped to nginx. |
| `REDIS_PORT` | `6379` | Host port mapped to Redis. |
| `MARIADB_PORT` | `3306` | Host port mapped to MariaDB. |
| `MARIADB_DATABASE` / `MARIADB_USER` / `MARIADB_PASSWORD` / `MARIADB_ROOT_PASSWORD` | `crb_dock` / `crb_dock` / … | DB credentials, applied only on first init. |
| `WORKSPACE_TIMEZONE` | `UTC+01:00` | Timezone for workspace/MariaDB containers. |
| `WORKSPACE_PUID` / `WORKSPACE_PGID` | `1000` | UID/GID inside the workspace — match your host user. |
| `PORTAINER_WEB_PORT` / `PORTAINER_API_PORT` | `9000` / `8000` | Portainer UI/API ports (management profile). |

## Daily commands

The included `Makefile` wraps the most common tasks:

```bash
make help        # show all commands
make build       # build or rebuild all services
make clean       # remove stopped containers, unused images and build cache
make start       # start the stack
make status      # show running containers and their health
make stop        # stop the stack
make restart     # restart all services
make down        # stop and remove containers
make logs        # follow logs
make shell-ws    # shell into the workspace container
make shell-php   # shell into the php-fpm container
make shell-db    # open a MariaDB root shell
make reset-db    # destroy and recreate the MariaDB data directory
```

## NGINX setup

1. Go to `nginx/sites/` and copy an example config:
   ```bash
   cp nginx/sites/sample.conf.example nginx/sites/my-project.conf
   ```

2. Edit the config to match your project (`server_name`, `root`, logs, etc.).

3. If you are not using a local DNS resolver, add the domain to your hosts file:
   ```
   127.0.0.1  my-project.localhost
   ```

4. Reload Nginx to pick up the new site:
   ```bash
   docker compose exec nginx nginx -s reload
   ```

A default self-signed certificate is generated on first start in `nginx/ssl/`.
It includes SANs for `crb-dock.localhost`, `crb-dock.local`, `crb-dock.crb`,
`localhost`, and `127.0.0.1`.

## Switching PHP-FPM versions

1. Stop all services:
   ```bash
   docker compose down
   ```

2. Change `PHP_VERSION` in `.env` to the desired version.

3. Rebuild the PHP-FPM image:
   ```bash
   docker compose build php-fpm
   ```

4. Start the stack again:
   ```bash
   docker compose up -d
   ```

## PHP 7.4 legacy support

PHP 7.4 is kept for older WordPress sites. It uses a dedicated legacy
Dockerfile (`php-fpm/Dockerfile-7.4`) because it requires a different base
image, older system libraries, and the mcrypt extension that is not supported
on modern PHP versions.

> PHP 7.4 reached end-of-life in November 2022. Only use it for maintenance
> of existing projects and avoid it for new work.

## Database backups and resets

Back up the database:

```bash
docker compose exec mariadb mariadb-dump -u root -p"$MARIADB_ROOT_PASSWORD" \
  "$MARIADB_DATABASE" > backup.sql
```

Restore a backup:

```bash
docker compose exec -T mariadb mariadb -u root -p"$MARIADB_ROOT_PASSWORD" \
  "$MARIADB_DATABASE" < backup.sql
```

Destroy and recreate the database (deletes the MariaDB data directory at
`${DATA_SAVE_PATH}/mariadb`, then restarts MariaDB to reinitialize it):

```bash
make reset-db
```

> The MariaDB environment variables only affect the **first** initialization
> of an empty data directory. Resetting the database is required to change them.

## DNS and `crb-dock`

For easier local domain resolution you can use the helper in `tools/setupDNS.sh`.
It is currently written for macOS + Homebrew dnsmasq.

On Linux you can instead:

- Edit `/etc/hosts` manually.
- Use a user-space DNS resolver such as `dnsmasq`.
- Use the `.localhost` TLD, which most modern browsers resolve to `127.0.0.1`.

## Optional management UI

Portainer is disabled by default. To start it:

```bash
make management
# or
docker compose --profile management up -d
```

Then open `http://localhost:9000`.

## Updating service images

Service images are pinned to tested versions in their Dockerfiles. To update,
change the tag in the relevant `Dockerfile`, rebuild, and verify:

```bash
docker compose build <service>
docker compose up -d
```

## Troubleshooting

- **Port 80/443 is already in use**: change `NGINX_HOST_HTTP_PORT` and
  `NGINX_HOST_HTTPS_PORT` in `.env` to higher ports such as `8080` and `8443`.

- **Permission errors in mounted volumes**: ensure `WORKSPACE_PUID` and
  `WORKSPACE_PGID` in `.env` match your host user (`id -u` and `id -g`).

- **Services fail health checks**: inspect logs with `make logs` and check that
  all required environment variables are set in `.env`.

- **Changes to `.env` are ignored for running containers**: most variables are
  only read at container creation. Recreate the container with
  `docker compose up -d --force-recreate <service>`.
