FROM php:8.2-cli

ARG UID=1000
ARG GID=1000
ARG NODE_VERSION=22.0.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    git \
    libpq-dev \
    libonig-dev \
    libssl-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libzip-dev \
    supervisor \
    && docker-php-ext-install -j$(nproc) \
        ctype \
        curl \
        dom \
        fileinfo \
        filter \
        hash \
        iconv \
        json \
        mbstring \
        openssl \
        pcre \
        phar \
        session \
        sockets \
        tokenizer \
        xml \
        pdo \
        pdo_pgsql \
        pcntl \
        gd \
        posix \
    && pecl install redis xdebug amqp \
    && docker-php-ext-enable redis xdebug amqp \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN if getent group ${GID}; then \
      useradd -m -u ${UID} -g ${GID} -s /bin/bash www; \
    else \
      groupadd -g ${GID} www && \
      useradd -m -u ${UID} -g www -s /bin/bash www; \
    fi

USER www

WORKDIR /var/www

ENTRYPOINT []
CMD ["bash"]

COPY ./docker/development/workspace/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./docker/development/workspace/supervisord.conf /etc/supervisor/supervisord.conf
RUN chmod +x /usr/local/bin/entrypoint.sh
