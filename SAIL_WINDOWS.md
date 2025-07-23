# Laravel Sail sur Windows

Ce projet utilise Laravel Sail avec une configuration personnalisée pour Windows.

## 🚀 Démarrage rapide

### 1. Démarrer les conteneurs

```powershell
# Utiliser le script PowerShell personnalisé
.\sail.ps1 up -d

# Ou utiliser Composer
composer up-sail
```

### 2. Vérifier que tout fonctionne

```powershell
.\sail.ps1 ps
```

### 3. Exécuter les migrations

```powershell
.\sail.ps1 migrate
```

## 📋 Commandes disponibles

### Conteneurs

```powershell
.\sail.ps1 up -d          # Démarrer en arrière-plan
.\sail.ps1 down           # Arrêter les conteneurs
.\sail.ps1 restart        # Redémarrer
.\sail.ps1 ps             # État des conteneurs
.\sail.ps1 logs [service] # Logs
```

### Laravel

```powershell
.\sail.ps1 artisan migrate     # Migrations
.\sail.ps1 artisan seed        # Seeders
.\sail.ps1 artisan test        # Tests
.\sail.ps1 artisan tinker      # Tinker
```

### Dépendances

```powershell
.\sail.ps1 composer install    # Installer les dépendances PHP
.\sail.ps1 npm install         # Installer les dépendances Node.js
.\sail.ps1 npm run dev         # Compiler les assets
```

### Shell

```powershell
.\sail.ps1 shell              # Accéder au shell du conteneur
```

## 🔧 Services disponibles

-   **Laravel** : http://localhost (port 80)
-   **PostgreSQL** : localhost:5432
-   **Redis** : localhost:6379
-   **Meilisearch** : http://localhost:7700
-   **RabbitMQ** : http://localhost:15672
-   **Mailpit** : http://localhost:8025
-   **Soketi** : http://localhost:6001

## 📁 Structure Docker

```
docker/
├── 8.2/                    # Configuration PHP 8.2
│   ├── Dockerfile
│   ├── php.ini
│   ├── start-container
│   └── supervisord.conf
├── pgsql/                  # Configuration PostgreSQL
│   └── create-testing-database.sql
├── mysql/                  # Configuration MySQL
│   └── create-testing-database.sh
└── mariadb/                # Configuration MariaDB
    └── create-testing-database.sh
```

## 🔍 Résolution de problèmes

### Erreur WSL

Si vous obtenez une erreur WSL, utilisez directement Docker Compose :

```powershell
docker-compose up -d
```

### Permissions PowerShell

Si vous avez des problèmes d'exécution de scripts :

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Reconstruire les images

```powershell
.\sail.ps1 build
# ou
docker-compose build --no-cache
```

## 🌐 Variables d'environnement

Les variables importantes dans `.env` :

-   `WWWGROUP=1000` et `WWWUSER=1000` : Utilisateurs Docker
-   `DB_CONNECTION=pgsql` : Base de données PostgreSQL
-   `QUEUE_CONNECTION=rabbitmq` : Files d'attente RabbitMQ
-   `CACHE_STORE=redis` : Cache Redis
-   `BROADCAST_CONNECTION=pusher` : WebSockets avec Soketi

## 📝 Notes importantes

-   Ce projet utilise PHP 8.2 avec Laravel 12
-   Tous les services sont configurés pour fonctionner ensemble
-   Le script PowerShell remplace le script bash de Sail pour Windows
-   Les volumes sont optimisés pour les performances
-   Les healthchecks assurent que les services sont prêts avant de démarrer l'application
