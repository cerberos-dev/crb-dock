.PHONY: help build start stop restart down shell-ws shell-php shell-db logs status clean reset-db

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build or rebuild all services
	docker compose build

start: ## Start all services in the background
	docker compose up -d

stop: ## Stop all services
	docker compose stop

restart: ## Restart all services
	docker compose restart

down: ## Stop and remove containers, networks and volumes
	docker compose down

shell-ws: ## Open a shell in the workspace container
	docker compose exec workspace bash

shell-php: ## Open a shell in the php-fpm container
	docker compose exec php-fpm bash

shell-db: ## Open a MariaDB shell as root
	docker compose exec mariadb mariadb -u root -p'$$MYSQL_ROOT_PASSWORD'

logs: ## Follow logs for all services
	docker compose logs -f

status: ## Show running containers and their health
	docker compose ps

clean: ## Remove stopped containers, unused images and build cache
	docker compose down --remove-orphans
	docker system prune -f

reset-db: ## DESTROY the MariaDB data directory and recreate it on next start
	@echo "WARNING: This will delete all MariaDB data in ./data/mariadb"
	@read -p "Are you sure? [y/N] " confirm && [ "$$confirm" = "y" ] || exit 1
	docker compose stop mariadb
	rm -rf ./data/mariadb
	docker compose up -d mariadb

management: ## Start the optional Portainer management UI
	docker compose --profile management up -d
