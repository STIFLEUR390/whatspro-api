@ -1,48 +1,93 @@
# Étape 1 : base PHP-FPM (Debian) avec toutes les extensions
FROM php:8.2-fpm AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bash nginx supervisor git curl zip unzip \
      libpng-dev libjpeg-dev libwebp-dev libxpm-dev libfreetype6-dev \
      libicu-dev libxml2-dev libonig-dev libzip-dev libpq-dev \
      pkg-config libssl-dev nodejs npm && \
      bash \
      nginx \
      supervisor \
      git \
      curl \
      zip \
      unzip \
      libpng-dev \
      libjpeg-dev \
      libwebp-dev \
      libxpm-dev \
      libfreetype6-dev \
      libicu-dev \
      libxml2-dev \
      libonig-dev \
      libzip-dev \
      libpq-dev \
      pkg-config \
      libssl-dev \
      nodejs \
      npm && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j"$(nproc)" \
      pdo pdo_mysql pdo_pgsql pcntl bcmath gd intl xml xmlwriter dom \
      mbstring zip opcache fileinfo phar sockets posix && \
      pdo \
      pdo_mysql \
      pdo_pgsql \
      pcntl \
      bcmath \
      gd \
      intl \
      xml \
      xmlwriter \
      dom \
      mbstring \
      zip \
      opcache \
      fileinfo \
      phar \
      sockets \
      posix && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN groupadd -g 1000 www && useradd -u 1000 -g www -m www
# Créer un utilisateur non-root
RUN groupadd -g 1000 www && \
    useradd -u 1000 -g www -m www

WORKDIR /var/www/html

# Étape build
# Étape 2 : installer dépendances & builder JS
FROM base AS build

COPY . /var/www/html

RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist && \
    npm install && npm run build
    npm install && \
    npm run build

# Étape production
# Étape 3 : production (php-fpm + nginx + supervisor)
FROM base AS production

COPY --from=build /var/www/html /var/www/html

COPY docker/nginx.conf /etc/nginx/nginx.conf
# Copier conf nginx & supervisord
COPY docker/nginx.conf      /etc/nginx/nginx.conf
COPY docker/supervisord.conf /etc/supervisor/supervisord.conf

# Ajuster les permissions
RUN chown -R www:www /var/www/html
RUN chmod -R 775 /var/www/html/storage

RUN mkdir -p /var/www/html/storage/logs && \
    touch /var/www/html/storage/logs/queue-worker.log && \
    chown -R www:www /var/www/html && \
    chmod -R 775 /var/www/html/storage
    chown -R www:www /var/www/html/storage

USER www

# Exposer HTTP et WebSocket SSL
EXPOSE 80 6001

# Démarrage unifié
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
