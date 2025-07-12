#!/bin/bash
composer install --no-interaction --prefer-dist --optimize-autoloader
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
