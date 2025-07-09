# Étape 1 : Image de base PHP avec FPM
FROM php:8.2-fpm-alpine AS base

# Installer les dépendances système et extensions PHP requises
RUN apk add --no-cache \
    bash \
    libpng \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxpm-dev \
    freetype-dev \
    icu-dev \
    libxml2-dev \
    oniguruma-dev \
    zip \
    unzip \
    git \
    curl \
    libzip-dev \
    libpq \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install \
        pdo \
        pdo_pgsql \
        pdo_mysql \
        bcmath \
        gd \
        intl \
        xml \
        mbstring \
        zip \
        opcache \
    && pecl install redis \
    && docker-php-ext-enable redis

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -g 1000 www && \
    adduser -D -G www -u 1000 www

WORKDIR /var/www/html

# Étape 2 : Copier le code source et installer les dépendances
FROM base AS build

COPY . /var/www/html

# Installer les dépendances PHP (production)
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Étape 3 : Image finale pour exécution
FROM base AS production

COPY --from=build /var/www/html /var/www/html

# Changer les permissions
RUN chown -R www:www /var/www/html

USER www

EXPOSE 9000

CMD ["php-fpm"]
