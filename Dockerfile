# Étape 1 : base PHP-CLI (Debian) avec toutes les extensions nécessaires
FROM php:8.2-cli AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bash \
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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Créer un utilisateur non-root
RUN groupadd -g 1000 www && \
    useradd -u 1000 -g www -m www

WORKDIR /var/www/html

# Étape 2 : installer dépendances & builder JS
FROM base AS build

COPY . /var/www/html

RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist && \
    npm install && \
    npm run build

# Étape 3 : production (php-cli + supervisor)
FROM base AS production

COPY --from=build /var/www/html /var/www/html

# Copier la conf supervisord
COPY docker/supervisord.conf /etc/supervisor/supervisord.conf

# Ajuster les permissions
RUN chown -R www:www /var/www/html

USER www

EXPOSE 8000

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
