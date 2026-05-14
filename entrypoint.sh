#!/bin/bash
set -e

# Configure PHP-FPM to listen on a Unix socket instead of TCP port 9000
sed -i 's|^listen = .*|listen = /var/run/php-fpm.sock|' /usr/local/etc/php-fpm.d/www.conf
sed -i 's|^;listen.owner = .*|listen.owner = www-data|' /usr/local/etc/php-fpm.d/www.conf
sed -i 's|^;listen.group = .*|listen.group = www-data|' /usr/local/etc/php-fpm.d/www.conf
sed -i 's|^;listen.mode = .*|listen.mode = 0660|' /usr/local/etc/php-fpm.d/www.conf

echo "Starting PHP-FPM..."
php-fpm -F &
PHP_PID=$!

echo "Waiting for PHP-FPM to start..."
sleep 2

echo "Starting Nginx..."
nginx -g "daemon off;"

wait $PHP_PID