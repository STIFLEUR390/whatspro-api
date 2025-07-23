#!/usr/bin/env pwsh

# Script PowerShell pour remplacer le script Sail bash sur Windows
# Utilisation: .\sail.ps1 [command]

param(
    [Parameter(Position=0)]
    [string]$Command = "up",

    [Parameter(Position=1)]
    [string[]]$Arguments = @()
)

# Fonction pour afficher l'aide
function Show-Help {
    Write-Host "Laravel Sail - Script PowerShell pour Windows" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\sail.ps1 [command] [options]" -ForegroundColor White
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Yellow
    Write-Host "  up                    Démarrer les conteneurs" -ForegroundColor White
    Write-Host "  up -d                 Démarrer les conteneurs en arrière-plan" -ForegroundColor White
    Write-Host "  down                  Arrêter les conteneurs" -ForegroundColor White
    Write-Host "  restart               Redémarrer les conteneurs" -ForegroundColor White
    Write-Host "  ps                    Afficher les conteneurs en cours" -ForegroundColor White
    Write-Host "  logs [service]        Afficher les logs" -ForegroundColor White
    Write-Host "  artisan [command]     Exécuter une commande Artisan" -ForegroundColor White
    Write-Host "  composer [command]    Exécuter une commande Composer" -ForegroundColor White
    Write-Host "  npm [command]         Exécuter une commande NPM" -ForegroundColor White
    Write-Host "  shell                 Accéder au shell du conteneur" -ForegroundColor White
    Write-Host "  build                 Reconstruire les images" -ForegroundColor White
    Write-Host "  migrate               Exécuter les migrations" -ForegroundColor White
    Write-Host "  seed                  Exécuter les seeders" -ForegroundColor White
    Write-Host "  test                  Exécuter les tests" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\sail.ps1 up -d" -ForegroundColor White
    Write-Host "  .\sail.ps1 artisan migrate" -ForegroundColor White
    Write-Host "  .\sail.ps1 composer install" -ForegroundColor White
    Write-Host "  .\sail.ps1 npm install" -ForegroundColor White
}

# Fonction pour vérifier si Docker est disponible
function Test-Docker {
    try {
        docker --version | Out-Null
        return $true
    }
    catch {
        Write-Host "❌ Docker n'est pas installé ou n'est pas accessible" -ForegroundColor Red
        Write-Host "Veuillez installer Docker Desktop et redémarrer votre terminal" -ForegroundColor Yellow
        return $false
    }
}

# Fonction pour exécuter une commande Docker Compose
function Invoke-DockerCompose {
    param(
        [string[]]$Args
    )

    $dockerArgs = @("compose") + $Args
    Write-Host "🐳 Exécution: docker $($dockerArgs -join ' ')" -ForegroundColor Cyan
    & docker $dockerArgs
}

# Fonction pour exécuter une commande dans le conteneur Laravel
function Invoke-ContainerCommand {
    param(
        [string[]]$Args
    )

    $dockerArgs = @("compose", "exec", "laravel.test") + $Args
    Write-Host "🐳 Exécution dans le conteneur: docker $($dockerArgs -join ' ')" -ForegroundColor Cyan
    & docker $dockerArgs
}

# Vérifier Docker
if (-not (Test-Docker)) {
    exit 1
}

# Traitement des commandes
switch ($Command.ToLower()) {
    "up" {
        if ($Arguments -contains "-d") {
            Invoke-DockerCompose @("up", "-d")
        } else {
            Invoke-DockerCompose @("up")
        }
    }
    "down" {
        Invoke-DockerCompose @("down")
    }
    "restart" {
        Invoke-DockerCompose @("restart")
    }
    "ps" {
        Invoke-DockerCompose @("ps")
    }
    "logs" {
        if ($Arguments.Count -gt 0) {
            Invoke-DockerCompose @("logs", $Arguments[0])
        } else {
            Invoke-DockerCompose @("logs")
        }
    }
    "artisan" {
        Invoke-ContainerCommand @("php", "artisan") + $Arguments
    }
    "composer" {
        Invoke-ContainerCommand @("composer") + $Arguments
    }
    "npm" {
        Invoke-ContainerCommand @("npm") + $Arguments
    }
    "shell" {
        Invoke-ContainerCommand @("bash")
    }
    "build" {
        Invoke-DockerCompose @("build")
    }
    "migrate" {
        Invoke-ContainerCommand @("php", "artisan", "migrate")
    }
    "seed" {
        Invoke-ContainerCommand @("php", "artisan", "db:seed")
    }
    "test" {
        Invoke-ContainerCommand @("php", "artisan", "test")
    }
    "help" {
        Show-Help
    }
    default {
        Write-Host "❌ Commande inconnue: $Command" -ForegroundColor Red
        Write-Host ""
        Show-Help
    }
}
