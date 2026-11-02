# AGENTS.md

Docker Compose local dev stack for PHP apps (a Laradock derivative). This repo
contains only the stack definition — no application code. Host source is mounted
into the containers at `/var/www` (see `APPLICATION` / `APPLICATION_LOCATION`).

## Setup
- `.env` is gitignored. Copy `.env.example` → `.env` before running anything;
  CI does exactly this in `.github/workflows/ci.yml`.
- `docker compose up -d` builds + starts the stack. The `Makefile` wraps common
  tasks: `make build|start|stop|down|logs|status`, `make shell-ws|shell-php|shell-db`.
- Validate the compose file without building: `docker compose config`.

## PHP version coupling (easy to break)
`PHP_VERSION` in `.env` must be a **dotted** version: `7.4`, `8.1`, `8.2`, `8.3`, `8.4`.
One value drives three things that must stay in sync:
1. `docker-compose.yml` selects the Dockerfile via `dockerfile: "Dockerfile-${PHP_VERSION}"`.
2. `docker-compose.yml` mounts `${PHP_FPM_PATH}${PHP_VERSION}.ini` → `php-fpm/php8.1.ini`.
3. `php-fpm/Dockerfile` does `FROM php:${PHP_VERSION}-fpm`.

Never use a non-dotted value (e.g. `81`) — it resolves to `php:81-fpm`, which doesn't exist.

`php-fpm/Dockerfile` is shared by 8.1–8.4 through symlinks (`Dockerfile-8.1` → `Dockerfile`);
`Dockerfile-7.4` is a separate real file (legacy). To add/remove a PHP version you must
add/remove the symlink **and** the matching `phpX.Y.ini`, plus update the CI matrix
(`.github/workflows/ci.yml`) and the version lists in `.env.example` / `README.md`.

## Per-version quirks (`php-fpm/Dockerfile`)
- IonCube only supported on 7.4 (legacy file) and 8.1; Swoole not on 7.4; Imagick not on 8.4.
- `Dockerfile-7.4` overrides apt sources to `archive.debian.org` (bullseye EOL) — keep this.

## Service gotchas
- nginx: site configs are auto-included from `nginx/sites/` by a wildcard include —
  drop a `.conf` there (copy `sample.conf.example`); there is no `sites-enabled` symlink step.
- nginx SSL: a self-signed cert is generated on first start by `nginx/startup.sh` into
  `nginx/ssl/` (`.crt`/`.key` are gitignored).
- MariaDB: `docker-entrypoint-initdb.d/*.sql` and the `MARIADB_*` env vars only apply on the
  **first** init of an empty data dir. Reset with `make reset-db` (deletes the data dir).
- Data dirs `DATA_SAVE_PATH` (`~/.crbdata`) and `logs/` are gitignored.

## CI / lint
- `.github/workflows/ci.yml`: `lint` runs shellcheck + `docker compose config`;
  `build` matrixes all PHP versions and does `sed -i 's/PHP_VERSION=.*/PHP_VERSION=${{ matrix.php-version }}/' .env`
  — matrix values must be dotted (`7.4`, `8.1`, …).
- There is no test suite in this repo (it's infrastructure); lint/validation is the CI above.
