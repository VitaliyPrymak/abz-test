#!/bin/bash
# Скрипт для первинної налаштування EC2 інстансу з WordPress

# Записуємо логи у файл для налагодження
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Оновлюємо систему та встановлюємо залежності
apt-get update -y
apt-get upgrade -y
apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-xmlrpc \
    php-soap \
    php-intl \
    php-zip \
    php-redis \
    mysql-client \
    unzip \
    curl

# Завантажуємо та розпаковуємо WordPress
cd /var/www/html
rm -rf *
curl -O https://wordpress.org/latest.tar.gz
tar zxvf latest.tar.gz
mv wordpress/* . 
rm -rf wordpress latest.tar.gz

# Створюємо wp-config.php зі змінними оточення, переданими через Terraform
cat <<EOF > wp-config.php
<?php
define('DB_NAME', '${db_name}');
define('DB_USER', '${db_user}');
define('DB_PASSWORD', '${db_password}');
define('DB_HOST', '${db_host}');

define('WP_REDIS_HOST', '${redis_host}');
define('WP_REDIS_PORT', 6379);

\$table_prefix = 'wp_';
define('WP_DEBUG', false);

if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
    
require_once(ABSPATH . 'wp-settings.php');
EOF

# Встановлюємо плагін Redis Object Cache
curl -O https://downloads.wordpress.org/plugin/redis-cache.2.4.3.zip
unzip redis-cache.2.4.3.zip
mv redis-cache /var/www/html/wp-content/plugins/
rm redis-cache.2.4.3.zip

# Налаштовуємо права до файлів
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Перезапускаємо Apache
systemctl restart apache2

# Активуємо плагін Redis через WP-CLI (якщо встановлений)
if [ -f /usr/local/bin/wp ]; then
    wp plugin activate redis-cache --allow-root
    wp redis enable --allow-root
fi

# Додаткова оптимізація (опційно)
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
