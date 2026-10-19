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
   - `PHP_VERSION` — `74`, `80`, `81`, `82`, `83`, or `84`.
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

## Daily commands

The included `Makefile` wraps the most common tasks:

```bash
make help        # show all commands
make build       # build or rebuild all services
make start       # start the stack
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

Destroy and recreate the database volume:

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
