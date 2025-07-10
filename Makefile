# Démarre les services Docker
up:
	docker compose up -d

# Reconstruit les containers
build:
	docker compose up -d --build

# Arrête les containers
down:
	docker compose down

# Affiche les logs
logs:
	docker compose logs -f

# Accède au container PHP pour exécuter Artisan
bash:
	docker compose exec app bash

# Lance les migrations
migrate:
	docker compose exec app php artisan migrate

# Vide le cache
clear:
	docker compose exec app php artisan optimize:clear

# Compile le front (vite ou mix)
npm:
	docker compose exec app npm run build

# Installe les dépendances
install:
	docker compose exec app composer install && docker compose exec app npm install

# Déploiement complet
deploy: build migrate npm
