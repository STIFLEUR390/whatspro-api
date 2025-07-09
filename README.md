# WhatsPro API

Bienvenue dans le backend API de WhatsPro !

Ce projet est une application SaaS développée avec Laravel, dédiée à la création d'API pour l'application WhatsPro. WhatsPro permet de faire du marketing via WhatsApp et de gérer des chatbots pour automatiser et optimiser la communication avec vos clients.

## Fonctionnalités principales

-   Création et gestion d'API RESTful pour WhatsPro
-   Automatisation des campagnes marketing sur WhatsApp
-   Gestion avancée des chatbots pour répondre automatiquement aux messages
-   Outils d'analyse et de suivi des performances des campagnes
-   Sécurité et scalabilité grâce à Laravel

## À propos de WhatsPro

WhatsPro est une solution tout-en-un pour :

-   Envoyer des messages marketing ciblés sur WhatsApp
-   Automatiser les réponses grâce à des chatbots intelligents
-   Centraliser la gestion des conversations clients
-   Améliorer l'engagement et la satisfaction client

## Stack technique

-   **Framework** : Laravel (PHP 8.2+)
-   **Base de données** : MySQL (ou autre via configuration Laravel)
-   **Docker** : Supporté via Laravel Sail
-   **Tests** : PHPUnit

## Installation rapide

1. Clonez le dépôt :
    ```bash
    git clone <votre-url-repo>
    cd whatspro-api
    ```
2. Installez les dépendances :
    ```bash
    composer install
    npm install
    ```
3. Copiez le fichier d'environnement :
    ```bash
    cp .env.example .env
    ```
4. Générez la clé d'application :
    ```bash
    php artisan key:generate
    ```
5. Lancez les migrations :
    ```bash
    php artisan migrate
    ```
6. Démarrez le serveur de développement :
    ```bash
    php artisan serve
    ```

## Contribution

Les contributions sont les bienvenues ! Merci de consulter le guide de contribution de Laravel pour les bonnes pratiques.

## Licence

Ce projet est open-source sous licence [MIT](https://opensource.org/licenses/MIT).

---

Pour toute question ou suggestion, n'hésitez pas à ouvrir une issue ou à contacter l'équipe WhatsPro.
