#!/bin/sh
# @Author: xzhih
# @Date:   2017-07-29 06:10:54
# @Last Modified by:   MikhZo
# @Last Modified time: 2025-04-04 02:50:26

# Список пакетов
pkglist="wget unzip grep sed tar ca-certificates coreutils-whoami php7 php7-cgi php7-cli php7-fastcgi php7-fpm php7-mod-mysqli php7-mod-pdo php7-mod-pdo-mysql nginx-extras mariadb-server mariadb-server-extra mariadb-client mariadb-client-extra"

phpmod="php7-mod-calendar php7-mod-ctype php7-mod-curl php7-mod-dom php7-mod-exif php7-mod-fileinfo php7-mod-ftp php7-mod-gd php7-mod-gettext php7-mod-gmp php7-mod-hash php7-mod-iconv php7-mod-intl php7-mod-json php7-mod-ldap php7-mod-session php7-mod-mbstring php7-mod-opcache php7-mod-openssl php7-mod-pcntl php7-mod-phar php7-pecl-redis php7-mod-session php7-mod-shmop php7-mod-simplexml php7-mod-snmp php7-mod-soap php7-mod-sockets php7-mod-sqlite3 php7-mod-sysvmsg php7-mod-sysvsem php7-mod-sysvshm php7-mod-tokenizer php7-mod-xml php7-mod-xmlreader php7-mod-xmlwriter php7-mod-zip php7-pecl-dio php7-pecl-http php7-pecl-libevent php7-pecl-propro php7-pecl-raphf redis snmpd snmp-mibs snmp-utils zoneinfo-core zoneinfo-asia"

# Последующие возможные дополнения (отсутствие поддержки источника)
# php7-mod-imagick imagemagick imagemagick-jpeg imagemagick-png imagemagick-tiff imagemagick-tools

# Веб-программа
# (1) phpMyAdmin (Инструмент управления БД)
url_phpMyAdmin="https://files.phpmyadmin.net/phpMyAdmin/5.2.2/phpMyAdmin-5.2.2-all-languages.zip"
# old url_phpMyAdmin="https://files.phpmyadmin.net/phpMyAdmin/4.8.3/phpMyAdmin-4.8.3-all-languages.zip"

# (2) WordPress (Наиболее широко используемая CMS)
# version 6.7.2	24.03.2025 / Рекомендуется PHP 7.4 или новее и MySQL 8.0 или MariaDB версии 10.5 или новее.
url_WordPress="https://ru.wordpress.org/wordpress-6.7.2-ru_RU.zip"
# old china url_WordPress="https://cn.wordpress.org/wordpress-4.9.4-zh_CN.zip"

# (3) Owncloud (Классическое частное облако)
url_Owncloud="https://download.owncloud.com/server/stable/owncloud-10.15.2.zip"
# url_Owncloud="https://download.owncloud.org/community/owncloud-10.0.10.zip"

# (4) Nextcloud (Новая работа команды Owncloud, красивый и мощный персональный облачный диск)
url_Nextcloud="https://download.nextcloud.com/server/releases/nextcloud-31.0.2.zip"
# url_Nextcloud="https://download.nextcloud.com/server/releases/nextcloud-13.0.6.zip"

# (5) h5ai (Отличный каталог файлов)
url_h5ai="https://github.com/lrsjng/h5ai/releases/download/v0.30.0/h5ai-0.30.0.zip"
# url_h5ai="https://release.larsjung.de/h5ai/h5ai-0.29.0.zip"

# (6) Lychee(Красивый, простой в использовании веб-альбом)
url_Lychee="https://github.com/LycheeOrg/Lychee/releases/download/v6.4.1/Lychee.zip"
# url_Lychee="https://github.com/electerious/Lychee/archive/master.zip"

# (7) Kodexplorer (Can Daoyun aka Mango Cloud Онлайн менеджер документов)
url_Kodexplorer="https://static.kodcloud.com/update/download/kodexplorer4.52.zip"
# url_Kodexplorer="http://static.kodcloud.com/update/download/kodexplorer4.36.zip"

# (8) Typecho (Легкая программа для блогов с открытым исходным кодом)
# Требования к среде установки: PHP 7.4 и выше, Любая БД MySQL/PostgreSQL/SQLite и расширениями PHP, CURL, mbstring или iconv
url_Typecho="https://github.com/typecho/typecho/releases/download/v1.2.1/typecho.zip"
# url_Typecho="http://typecho.org/downloads/1.1-17.10.30-release.tar.gz"

# (9) Z-Blog (Маленький, быстрый PHP блоггер)
#{"code":"40310002","msg":"region is forbidden"}
url_Zblog="https://update.zblogcn.com/zip/Z-BlogPHP_1_5_2_1935_Zero.zip"

# (10) DzzOffice (Офисная платформа с открытым исходным кодом)
url_DzzOffice="https://codeload.github.com/zyx0814/dzzoffice/zip/master"

# Переменные среды
get_env()
{
    # Получение имени пользователя
    if [[ $USER ]]; then
        username=$USER
    elif [[ -n $(whoami 2>/dev/null) ]]; then
        username=$(whoami 2>/dev/null)
    else
        username=$(cat /etc/passwd | sed "s/:/ /g" | awk 'NR==1'  | awk '{printf $1}')
    fi

    # Получение IP-адреса маршрутизатора
    localhost=$(ifconfig  | grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}' | awk 'NR==1')
    if [[ ! -n "$localhost" ]]; then
        localhost="IP вашего роутера"
    fi
}

##### Определение статуса пакета #####
install_check()
{
    notinstall=""
    for data in $pkglist ; do
        if [[ `epkg list-installed | grep $data | wc -l` -ne 0 ]];then
            echo "$data - установлено"
        else
            notinstall="$notinstall $data"
            echo "$data - установка..."
            epkg install $data
        fi
    done
}

# Установка PHP mod 
install_php_mod()
{
    notinstall=""
    for data in $phpmod ; do
        if [[ `epkg list-installed | grep $data | wc -l` -ne 0 ]];then
            echo "$data - установлено"
        else
            notinstall="$notinstall $data"
            echo "$data - установка..."
            epkg install $data
        fi
    done
}

############## Установочный пакет #############
install_onmp_ipk()
{
    epkg update

    # Установление статуса пакета
    install_check

    for i in 'seq 3'; do
        if [[ ${#notinstall} -gt 0 ]]; then
            install_check
        fi
    done

    if [[ ${#notinstall} -gt 0 ]]; then
        echo "Некоторые основные пакеты могут быть не установлены из-за отдельных проблем. Пожалуйста, держите каталог /opt/ достаточно чистым. Если это проблема сети - запустите глобальный VPN, затем снова выполните команду."
    else
        echo "--------------------------------------------"
        echo "|**** Пакет ONMP  полностью установлен ****|"
        echo "--------------------------------------------"
        echo "Независимо   от  того,   устанавливались  ли"
        echo "модули  PHP  (требуется  для приложений типа"
        echo "Nextcloud),  их  можно  установить  вручную."
#
read -p "Подтвердите [y/n]: " input
case $input in
    y) install_php_mod;;
n) echo "Если программа предложит вам установить плагин, можно использовать epkg, чтобы установить его самостоятельно.";;
*) echo "Вы ввели не y/n"
exit;;
esac 
        echo "Инициализация ONMP"
        init_onmp
        echo ""
    fi
}

################ Инициализация ONMP ###############
init_onmp()
{
    # Инициализация Каталога сайтов
    rm -rf /opt/wwwroot
    mkdir -p /opt/wwwroot/default
    chmod -R 777 /opt/tmp

    # Инициализация Nginx
    init_nginx > /dev/null 2>&1

    # Инициализация БД
    init_sql > /dev/null 2>&1

    # Инициализация PHP
    init_php > /dev/null 2>&1

    # Инициализация redis
    echo 'unixsocket /opt/var/run/redis.sock' >> /opt/etc/redis.conf
    echo 'unixsocketperm 777' >> /opt/etc/redis.conf 

    # 添加探针
    cp /opt/onmp/tz.php /opt/wwwroot/default -R
    add_vhost 81 default
    sed -e "s/.*\#php-fpm.*/    include \/opt\/etc\/nginx\/conf\/php-fpm.conf\;/g" -i /opt/etc/nginx/vhost/default.conf
    chmod -R 777 /opt/wwwroot/default

    # Старт ONMP
    set_onmp_sh
    onmp start
}

############### Инициализация Nginx ###############
init_nginx()
{
    get_env
    /opt/etc/init.d/S80nginx stop > /dev/null 2>&1
    rm -rf /opt/etc/nginx/vhost 
    rm -rf /opt/etc/nginx/conf
    mkdir -p /opt/etc/nginx/vhost
    mkdir -p /opt/etc/nginx/conf

# Инициализация файла конфигурации nginx
cat > "/opt/etc/nginx/nginx.conf" <<-\EOF
user theOne root;
pid /opt/var/run/nginx.pid;
worker_processes auto;

events {
    use epoll;
    multi_accept on;
    worker_connections 1024;
}

http {
    charset utf-8;
    include mime.types;
    default_type application/octet-stream;
    
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 60;
    
    client_max_body_size 2000m;
    client_body_temp_path /opt/tmp/;
    
    gzip on; 
    gzip_vary on;
    gzip_proxied any;
    gzip_min_length 1k;
    gzip_buffers 4 8k;
    gzip_comp_level 2;
    gzip_disable "msie6";
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript image/svg+xml;

    include /opt/etc/nginx/vhost/*.conf;
}
EOF

sed -e "s/theOne/$username/g" -i /opt/etc/nginx/nginx.conf

# Конфигурация Nginx для конкретной программы
nginx_special_conf

}

##### Конфигурация Nginx для конкретной программы #####
nginx_special_conf()
{
# php-fpm
cat > "/opt/etc/nginx/conf/php-fpm.conf" <<-\OOO
location ~ \.php(?:$|/) {
    fastcgi_split_path_info ^(.+\.php)(/.+)$; 
    fastcgi_pass unix:/opt/var/run/php7-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
}
OOO

# nextcloud
cat > "/opt/etc/nginx/conf/nextcloud.conf" <<-\OOO
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
add_header X-Robots-Tag none;
add_header X-Download-Options noopen;
add_header X-Permitted-Cross-Domain-Policies none;

location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
}
location = /.well-known/carddav {
    return 301 $scheme://$host/remote.php/dav;
}
location = /.well-known/caldav {
    return 301 $scheme://$host/remote.php/dav;
}

fastcgi_buffers 64 4K;
gzip on;
gzip_vary on;
gzip_comp_level 4;
gzip_min_length 256;
gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

location / {
    rewrite ^ /index.php$request_uri;
}
location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
    deny all;
}
location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
    deny all;
}

location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+)\.php(?:$|/) {
    fastcgi_split_path_info ^(.+?\.php)(/.*)$;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param PATH_INFO $fastcgi_path_info;
    fastcgi_param modHeadersAvailable true;
    fastcgi_param front_controller_active true;
    fastcgi_pass unix:/opt/var/run/php7-fpm.sock;
    fastcgi_intercept_errors on;
    fastcgi_request_buffering off;
}

location ~ ^/(?:updater|ocs-provider)(?:$|/) {
    try_files $uri/ =404;
    index index.php;
}

location ~ \.(?:css|js|woff|svg|gif)$ {
    try_files $uri /index.php$request_uri;
    add_header Cache-Control "public, max-age=15778463";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;
    access_log off;
}

location ~ \.(?:png|html|ttf|ico|jpg|jpeg)$ {
    try_files $uri /index.php$request_uri;
    access_log off;
}
OOO

# owncloud
cat > "/opt/etc/nginx/conf/owncloud.conf" <<-\OOO
add_header X-Content-Type-Options nosniff;
add_header X-Frame-Options "SAMEORIGIN";
add_header X-XSS-Protection "1; mode=block";
add_header X-Robots-Tag none;
add_header X-Download-Options noopen;
add_header X-Permitted-Cross-Domain-Policies none;

location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
}
location = /.well-known/carddav {
    return 301 $scheme://$host/remote.php/dav;
}
location = /.well-known/caldav {
    return 301 $scheme://$host/remote.php/dav;
}

gzip off;
fastcgi_buffers 8 4K; 
fastcgi_ignore_headers X-Accel-Buffering;
error_page 403 /core/templates/403.php;
error_page 404 /core/templates/404.php;

location / {
    rewrite ^ /index.php$uri;
}

location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
    return 404;
}
location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
    return 404;
}

location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+|core/templates/40[34])\.php(?:$|/) {
    fastcgi_split_path_info ^(.+\.php)(/.*)$;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param SCRIPT_NAME $fastcgi_script_name;
    fastcgi_param PATH_INFO $fastcgi_path_info;
    fastcgi_param modHeadersAvailable true;
    fastcgi_param front_controller_active true;
    fastcgi_read_timeout 180;
    fastcgi_pass unix:/opt/var/run/php7-fpm.sock;
    fastcgi_intercept_errors on;
    fastcgi_request_buffering on;
}

location ~ ^/(?:updater|ocs-provider)(?:$|/) {
    try_files $uri $uri/ =404;
    index index.php;
}

location ~ \.(?:css|js)$ {
    try_files $uri /index.php$uri$is_args$args;
    add_header Cache-Control "max-age=15778463";
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;
    access_log off;
}

location ~ \.(?:svg|gif|png|html|ttf|woff|ico|jpg|jpeg|map)$ {
    add_header Cache-Control "public, max-age=7200";
    try_files $uri /index.php$uri$is_args$args;
    access_log off;
}
OOO

# wordpress
cat > "/opt/etc/nginx/conf/wordpress.conf" <<-\OOO
location = /favicon.ico {
    log_not_found off;
    access_log off;
}
location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
}
location ~ /\. {
    deny all;
}
location ~ ^/wp-content/uploads/.*\.php$ {
    deny all;
}
location ~* /(?:uploads|files)/.*\.php$ {
    deny all;
}

location / {
    try_files $uri $uri/ /index.php?$args;
}

location ~ \.php$ {
    include fastcgi.conf;
    fastcgi_intercept_errors on;
    fastcgi_pass unix:/opt/var/run/php7-fpm.sock;
    fastcgi_buffers 16 16k;
    fastcgi_buffer_size 32k;
}

location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
    expires max;
    log_not_found off;
}
OOO

# typecho
cat > "/opt/etc/nginx/conf/typecho.conf" <<-\OOO
if (!-e $request_filename) {
        rewrite ^(.*)$ /index.php$1 last;
    }
OOO

}

############## Сброи /、Инициализация MySQL #############
init_sql()
{
    get_env
    /opt/etc/init.d/S70mysqld stop > /dev/null 2>&1
    sleep 10
    killall mysqld > /dev/null 2>&1
    rm -rf /opt/mysql
    rm -rf /opt/var/mysql
    mkdir -p /opt/etc/mysql/

# MySQL настройки
cat > "/opt/etc/mysql/my.cnf" <<-\MMM
[client-server]
port               = 3306
socket             = /opt/var/run/mysqld.sock

[mysqld]
user               = theOne
socket             = /opt/var/run/mysqld.sock
pid-file           = /opt/var/run/mysqld.pid
basedir            = /opt
lc_messages_dir    = /opt/share/mariadb
lc_messages        = en_US
innodb_use_native_aio = 0
datadir            = /opt/var/mysql/
tmpdir             = /opt/tmp/

skip-external-locking

bind-address       = 127.0.0.1

key_buffer_size    = 24M
max_allowed_packet = 24M
thread_stack       = 192K
thread_cache_size  = 8

[mysqldump]
quick
quote-names
max_allowed_packet = 24M

[mysql]
#no-auto-rehash

[isamchk]
key_buffer_size    = 24M

[mysqlhotcopy]
interactive-timeout
MMM

sed -e "s/theOne/$username/g" -i /opt/etc/mysql/my.cnf

chmod 644 /opt/etc/mysql/my.cnf

mkdir -p /opt/var/mysql

# Установка БД
/opt/bin/mysql_install_db --user=$username --basedir=/opt --datadir=/opt/var/mysql/
echo -e "\nИнициализация БД, подождите..."
sleep 20

# Первый запуск MySQL
/opt/etc/init.d/S70mysqld start
sleep 60

#  настройки пароля БД
mysqladmin -u root password 123456
echo -e "\033[41;37m Пользователь БД：root, Начальный пароль：123456 \033[0m"
onmp restart
}

############## PHP Инициализация  #############
init_php()
{
# PHP7 настройки 
/opt/etc/init.d/S79php7-fpm stop > /dev/null 2>&1

mkdir -p /opt/usr/php/tmp/
chmod -R 777 /opt/usr/php/tmp/

sed -e "/^doc_root/d" -i /opt/etc/php.ini
sed -e "s/.*memory_limit = .*/memory_limit = 128M/g" -i /opt/etc/php.ini
sed -e "s/.*output_buffering = .*/output_buffering = 4096/g" -i /opt/etc/php.ini
sed -e "s/.*post_max_size = .*/post_max_size = 8000M/g" -i /opt/etc/php.ini
sed -e "s/.*max_execution_time = .*/max_execution_time = 2000 /g" -i /opt/etc/php.ini
sed -e "s/.*upload_max_filesize.*/upload_max_filesize = 8000M/g" -i /opt/etc/php.ini
sed -e "s/.*listen.mode.*/listen.mode = 0666/g" -i /opt/etc/php7-fpm.d/www.conf

# PHP Файл конфигурации
cat >> "/opt/etc/php.ini" <<-\PHPINI
session.save_path = "/opt/usr/php/tmp/"
opcache.enable=1
opcache.enable_cli=1
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.memory_consumption=128
opcache.save_comments=1
opcache.revalidate_freq=60
opcache.fast_shutdown=1

mysqli.default_socket=/opt/var/run/mysqld.sock
pdo_mysql.default_socket=/opt/var/run/mysqld.sock
PHPINI

cat >> "/opt/etc/php7-fpm.d/www.conf" <<-\PHPFPM
env[HOSTNAME] = $HOSTNAME
env[PATH] = /opt/bin:/usr/local/bin:/usr/bin:/bin
env[TMP] = /opt/tmp
env[TMPDIR] = /opt/tmp
env[TEMP] = /opt/tmp
PHPFPM
}

############# Настройки пароля пользователя БД ############
set_passwd()
{
    /opt/etc/init.d/S70mysqld start
    sleep 3
    echo -e "\033[41;37m Начальный пароль：123456 \033[0m"
    mysqladmin -u root -p password
    onmp restart
}

################ Удаление ONMP ###############
remove_onmp()
{
    /opt/etc/init.d/S70mysqld stop > /dev/null 2>&1
    /opt/etc/init.d/S79php7-fpm stop > /dev/null 2>&1
    /opt/etc/init.d/S80nginx stop > /dev/null 2>&1
    /opt/etc/init.d/S70redis stop > /dev/null 2>&1
    killall -9 nginx mysqld php-fpm redis-server > /dev/null 2>&1
    for pkg in $pkglist; do
        epkg remove $pkg --force-depends
    done
    for mod in $phpmod; do
        epkg remove $mod --force-depends
    done
    rm -rf /opt/wwwroot
    rm -rf /opt/etc/nginx/vhost
    rm -rf /opt/bin/onmp
    rm -rf /opt/mysql
    rm -rf /opt/var/mysql
    rm -rf /opt/etc/nginx/
    rm -rf /opt/etc/php*
    rm -rf /opt/etc/mysql
    rm -rf /opt/etc/redis*
}

################ Генерация ONMP команд ###############
set_onmp_sh()
{
# Удаление
rm -rf /opt/bin/onmp

# запись файла
cat > "/opt/bin/onmp" <<-\EOF
#!/bin/sh

# Получение IP-адреса маршрутизатора
localhost=$(ifconfig | grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}' | awk 'NR==1')
if [[ ! -n "$localhost" ]]; then
    localhost="IP вашего роутера "
fi

vhost_list()
{
    echo "Список сайтов："
    logger -t "【ONMP】" "Список сайтов："
    for conf in /opt/etc/nginx/vhost/*;
    do
        path=$(cat $conf | awk 'NR==4' | awk '{print $2}' | sed 's/;//')
        port=$(cat $conf | awk 'NR==2' | awk '{print $2}' | sed 's/;//')
        echo "$path        $localhost:$port"
        logger -t "【ONMP】" "$path     $localhost:$port"
    done
    echo "Адресная строка в браузере：$localhost:81 Посмотреть зонд php"
}

onmp_restart()
{
    /opt/etc/init.d/S70mysqld stop > /dev/null 2>&1
    /opt/etc/init.d/S79php7-fpm stop > /dev/null 2>&1
    /opt/etc/init.d/S80nginx stop > /dev/null 2>&1
    killall -9 nginx mysqld php-fpm > /dev/null 2>&1
    sleep 3
    /opt/etc/init.d/S70mysqld start > /dev/null 2>&1
    /opt/etc/init.d/S79php7-fpm start > /dev/null 2>&1
    /opt/etc/init.d/S80nginx start > /dev/null 2>&1
    sleep 3
    num=0
    for PROC in 'nginx' 'php-fpm' 'mysqld'; do 
        if [ -n "`pidof $PROC`" ]; then
            echo $PROC "- Успешный запуск";
        else
            echo $PROC "- Ошибка запуска";
            num=`expr $num + 1`
        fi 
    done

    if [[ $num -gt 0 ]]; then
        echo "onmp- Ошибка запуска"
        logger -t "【ONMP】" "- Ошибка запуска"
    else
        echo "onmp - Старт"
        logger -t "【ONMP】" " - Старт"
        vhost_list
    fi
}

case $1 in
    open ) 
    /opt/onmp/onmp.sh
    ;;

    start )
    echo "onmp - Начало"
    logger -t "【ONMP】" " - Начало"
    onmp_restart
    ;;

    stop )
    echo "onmp - Остановка"
    logger -t "【ONMP】" " - Остановка"
    /opt/etc/init.d/S70mysqld stop > /dev/null 2>&1
    /opt/etc/init.d/S79php7-fpm stop > /dev/null 2>&1
    /opt/etc/init.d/S80nginx stop > /dev/null 2>&1
    echo "onmp - Остановлен"
    logger -t "【ONMP】" " - Остановлен"
    ;;

    restart )
    echo "onmp - Перезапуск"
    logger -t "【ONMP】" " - Перезапуск"
    onmp_restart
    ;;

    mysql )
    case $2 in
        start ) /opt/etc/init.d/S70mysqld start;;
        stop ) /opt/etc/init.d/S70mysqld stop;;
        restart ) /opt/etc/init.d/S70mysqld restart;;
        * ) echo "onmp mysqld start|restart|stop";;
    esac
    ;;

    php )
    case $2 in
        start ) /opt/etc/init.d/S79php7-fpm start;;
        stop ) /opt/etc/init.d/S79php7-fpm stop;;
        restart ) /opt/etc/init.d/S79php7-fpm restart;;
        * ) echo "onmp php start|restart|stop";;
    esac
    ;;

    nginx )
    case $2 in
        start ) /opt/etc/init.d/S80nginx start;;
        stop ) /opt/etc/init.d/S80nginx stop;;
        restart ) /opt/etc/init.d/S80nginx restart;;
        * ) echo "onmp nginx start|restart|stop";;
    esac
    ;;

    redis )
    case $2 in
        start ) /opt/etc/init.d/S70redis start;;
        stop ) /opt/etc/init.d/S70redis stop;;
        restart ) /opt/etc/init.d/S70redis restart;;
        * ) echo "onmp redis start|restart|stop";;
    esac
    ;;

    list )
    vhost_list
    ;;
    * )
#
cat << HHH
=================================
 ONMP Команды управления
 onmp open

 Старт Стоп Перезапуск
 onmp start|stop|restart

 Вид Список сайтов onmp list

 Nginx Команды управления
 onmp nginx start|restart|stop
 MySQL Команды управления
 onmp mysql start|restart|stop
 PHP Команды управления
 onmp php start|restart|stop
 Redis Команды управления
 onmp redis start|restart|stop
=================================
HHH
    ;;
esac
EOF

chmod +x /opt/bin/onmp
#
cat << HHH
=================================
 onmp Команды управления
 onmp open

 Старт Стоп Перезапуск
 onmp start|stop|restart

 Вид Список сайтов onmp list

 Nginx Команды управления
 onmp nginx start|restart|stop
 MySQL Команды управления
 onmp mysql start|restart|stop
 PHP Команды управления
 onmp php start|restart|stop
 Redis Команды управления
 onmp redis start|restart|stop
=================================
HHH

}

############### Установка программы сайта ##############
install_website()
{
    # Переменные среды
    get_env
    clear
    chmod -R 777 /opt/tmp
# Процедура выбора
cat << AAA
----------------------------------------
|******* Выберите веб-программу *******|
----------------------------------------
(1) phpMyAdmin (БД Управление инструмент)
(2) WordPress (Наиболее широко используемая CMS)
(3) Owncloud (Классическое частное облако)
(4) Nextcloud (Новая работа команды Owncloud, красивый и мощный персональный облачный диск)
(5) h5ai (Отличный каталог файлов)
(6) Lychee (Красивый, простой в использовании веб-альбом)
(7) Kodexplorer (Can Daoyun aka Mango Cloud Онлайн менеджер документов)
(8) Typecho (Легкая программа для блогов с открытым исходным кодом)
(9) Z-Blog (Маленький, быстрый PHP блоггер)
(10) DzzOffice (Офисная платформа с открытым исходным кодом)
(0) Выход
AAA
read -p "Выберите [0-11]: " input
case $input in
1) install_phpmyadmin;;
2) install_wordpress;;
3) install_owncloud;;
4) install_nextcloud;;
5) install_h5ai;;
6) install_lychee;;
7) install_kodexplorer;;
8) install_typecho;;
9) install_zblog;;
10) install_dzzoffice;;
0) exit;;
*) echo "Вы ввели не 0 ~ 10!"
break;;
esac
}

############### Установщик WEB программы ##############
web_installer()
{
    clear
    echo "----------------------------------------"
    echo "|***********  Установщик WEB программы  ***********|"
    echo "----------------------------------------"
    echo "Установка $name："

    # Получение настроек пользователя
    read -p "Введите порт (должен быть не используемым)[По умолчанию - пусто $port]: " nport
    if [[ $nport ]]; then
        port=$nport
    fi
    read -p "Введите каталог (По умолчанию - пусто $name): " webdir
    if [[ ! -n "$webdir" ]]; then
        webdir=$name
    fi

    # Проверка наличия каталога
    if [[ ! -d "/opt/wwwroot/$webdir" ]] ; then
        echo "Начало Установка..."
    else
        read -p "Каталог сайтов /opt/wwwroot/$webdir уже существует，удаление: [y/n(нижний регистр)]" ans
        case $ans in
            y ) rm -rf /opt/wwwroot/$webdir; echo "Удаление";;
n ) echo "Не удален";;
* ) echo "Нет такой опции"; exit;;
esac
fi

    # Скачивание и распаковка программы
    suffix="zip"
    if [[ -n "$istar" ]]; then
        suffix="tar"
    fi
    if [[ ! -d "/opt/wwwroot/$webdir" ]] ; then
        rm -rf /opt/etc/nginx/vhost/$webdir.conf
        if [[ ! -f /opt/wwwroot/$name.$suffix ]]; then
            rm -rf /opt/tmp/$name.$suffix
            wget --no-check-certificate -O /opt/tmp/$name.$suffix $filelink
            mv /opt/tmp/$name.* /opt/wwwroot/
        fi
        if [[ ! -f "/opt/wwwroot/$name.$suffix" ]]; then
            echo "Загрузка не удалась"
        else
            echo "Распаковка..."
            if [[ -n "$hookdir" ]]; then
                mkdir /opt/wwwroot/$hookdir
            fi

            if [[ -n "$istar" ]]; then
                tar zxf /opt/wwwroot/$name.$suffix -C /opt/wwwroot/$hookdir > /dev/null 2>&1
            else
                unzip /opt/wwwroot/$name.$suffix -d /opt/wwwroot/$hookdir > /dev/null 2>&1
            fi
            
            mv /opt/wwwroot/$dirname /opt/wwwroot/$webdir
            echo "Распаковка завершена..."
        fi
    fi

    # Проверка успешности распаковки
    if [[ ! -d "/opt/wwwroot/$webdir" ]] ; then
        echo "Установка не успешна"
        exit
    fi
}

# Установка Основная структура сценария
# install_webapp()
# {
#     # По умолчанию
#     filelink=""         # Ссылка для скачивания
#     name=""             # Наименование
#     dirname=""          # Имя каталога
#     port=               # Порт
#     hookdir=$dirname    # Некоторые программы не являются одним каталогом, используйте этот хук для решения
#     istar=true          # Является ли это архивом tar

#     # Запуск Установки программы
#     web_installer
#     echo "Настройка $name..."
#     # chmod -R 777 /opt/wwwroot/$webdir     # Настройка прав

#     # Добавление на виртуальный хост
#     add_vhost $port $webdir
#     sed -e "s/.*\#php-fpm.*/    include \/opt\/etc\/nginx\/conf\/php-fpm.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf         # Добавить публичную поддержку php-fpm
#     onmp restart >/dev/null 2>&1
#     echo "$name - полностью установлено"
#     echo "Введите адрес: $localhost:$port для получения доступа"
# }

############# Установка phpMyAdmin ############
install_phpmyadmin()
{
    # По умолчанию
    filelink=$url_phpMyAdmin
    name="phpMyAdmin"
    dirname="phpMyAdmin-*-languages"
    port=82

    # Выполнение установки программы
    web_installer 
    echo "Настройка $name..."
    cp /opt/wwwroot/$webdir/config.sample.inc.php /opt/wwwroot/$webdir/config.inc.php
    chmod 644 /opt/wwwroot/$webdir/config.inc.php
    mkdir -p /opt/wwwroot/$webdir/tmp
    chmod 777 /opt/wwwroot/$webdir/tmp
    sed -e "s/.*blowfish_secret.*/\$cfg['blowfish_secret'] = 'onmponmponmponmponmponmponmponmp';/g" -i /opt/wwwroot/$webdir/config.inc.php

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    sed -e "s/.*\#php-fpm.*/    include \/opt\/etc\/nginx\/conf\/php-fpm.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf
    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
    echo "phpMyaAdmin Пользователь, пароль - БД пользователь, пароль"
}

############# Установка WordPress ############
install_wordpress()
{
    # По умолчанию
    filelink=$url_WordPress
    name="WordPress"
    dirname="wordpress"
    port=83

    # Выполнение установки программы
    web_installer
    echo "Настройка $name..."
    chmod -R 777 /opt/wwwroot/$webdir

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    # WordPress Файл конфигурации php-fpm Нет необходимости во внешнем представлении
    sed -e "s/.*\#otherconf.*/    include \/opt\/etc\/nginx\/conf\/wordpress.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf
    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
    echo "Можно использовать phpMyaAdmin установить БД ，Затем пошагово просмотрите информацию об этом сайте."
}

############### Установка h5ai ##############
install_h5ai()
{
    # По умолчанию
    filelink=$url_h5ai
    name="h5ai"
    dirname="_h5ai"
    port=85
    hookdir=$dirname

    # Выполнение установки программы
    web_installer
    echo "Настройка $name..."
    cp /opt/wwwroot/$webdir/_h5ai/README.md /opt/wwwroot/$webdir/
    chmod -R 777 /opt/wwwroot/$webdir/

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    sed -e "s/.*\#php-fpm.*/    include \/opt\/etc\/nginx\/conf\/php-fpm.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf
    sed -e "s/.*\index index.html.*/    index  index.html  index.php  \/_h5ai\/public\/index.php;/g" -i /opt/etc/nginx/vhost/$webdir.conf
    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
    echo " Файл конфигурации /opt/wwwroot/$webdir/_h5ai/private/conf/options.json"
    echo "Вы можете получить больше возможностей, изменив его."
}

################ УстановкаLychee ##############
install_lychee()
{
    # По умолчанию
    filelink=$url_Lychee
    name="Lychee"
    dirname="Lychee-master"
    port=86

    # Выполнение установки программы
    web_installer
    echo "Настройка $name..."
    chmod -R 777 /opt/wwwroot/$webdir/uploads/ /opt/wwwroot/$webdir/data/

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    sed -e "s/.*\#php-fpm.*/    include \/opt\/etc\/nginx\/conf\/php-fpm.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf
    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
    echo "При первом открытии БД будет настроена, информация"
    echo "Адрес：127.0.0.1 самостоятельно настройте логин/пароль, по умолчанию: root 123456"
    echo "Следующее не может быть настроено, а затем создать пользователя на следующем шаге Можно использовать"
}

################# Установка Owncloud ###############
install_owncloud()
{
    # По умолчанию
    filelink=$url_Owncloud     
    name="Owncloud"         
    dirname="owncloud"      
    port=98

    # Выполнение установки программы 
    web_installer
    echo "Настройка $name..."
    chmod -R 777 /opt/wwwroot/$webdir 

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    # Owncloud Файл конфигурации php-fpm Нет необходимости во внешнем представлении
    sed -e "s/.*\#otherconf.*/    include \/opt\/etc\/nginx\/conf\/owncloud.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf

    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
    echo "При первом открытии пользователь БД будет настроен. Информация"
    echo "Адрес по умолчанию localhost, самостоятельно настройте логин/пароль, или по умолчанию: root 123456"
    echo "Установка, после этого вы можете нажать на три полосы в верхнем левом углу, чтобы ввести market. Установка мощных плагинов, таких, как предварительный просмотр изображений, видео и т. д."
    echo "Необходимо полностью настроить конфигурацию web，можно использовать onmp open выбор 10 настройки Redis"
}

################# Установка Nextcloud ##############
install_nextcloud()
{
    # По умолчанию
    filelink=$url_Nextcloud
    name="Nextcloud"
    dirname="nextcloud"
    port=99

    # Выполнение установки программы
    web_installer   
    echo "Настройка $name..."
    chmod -R 777 /opt/wwwroot/$webdir

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    # nextcloud Файл конфигурации php-fpm Нет необходимости во внешнем представлении
    sed -e "s/.*\#otherconf.*/    include \/opt\/etc\/nginx\/conf\/nextcloud.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf

    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
    echo "При первом открытии будет настроен пользователь БД. Информация"
    echo "Адрес по умолчанию localhost, самостоятельно настройте логин/пароль, или по умолчанию: root 123456"
    echo "Необходимо полностью настроить конфигурацию web，Можно использовать onmp open выбор 10 настройки Redis"
}

############## Установка kodexplorer Облако манго ##########
install_kodexplorer()
{
    # По умолчанию
    filelink=$url_Kodexplorer
    name="Kodexplorer"
    dirname="kodexplorer"
    port=88
    hookdir=$dirname

    # Выполнение установки программы 
    web_installer
    echo "Настройка $name..."
    chmod -R 777 /opt/wwwroot/$webdir

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    sed -e "s/.*\#php-fpm.*/    include \/opt\/etc\/nginx\/conf\/php-fpm.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf
    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
}

############# Установка Typecho ############
install_typecho()
{
    # По умолчанию
    filelink=$url_Typecho
    name="Typecho"
    dirname="build"
    port=90
    istar=true

    # Выполнение установки программы 
    web_installer
    echo "Настройка $name..."
    chmod -R 777 /opt/wwwroot/$webdir 

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    sed -e "s/.*\#php-fpm.*/    include \/opt\/etc\/nginx\/conf\/php-fpm.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf         # Добавить поддержку php-fpm
    sed -e "s/.*\#otherconf.*/    include \/opt\/etc\/nginx\/conf\/typecho.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf
    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
    echo "Можно использовать phpMyAdmin для установить БД ，Затем настройте сайт шаг за шагом на этом сайте. информация"
}

######## Установка Z-Blog ########
install_zblog()
{
    # По умолчанию
    filelink=$url_Zblog
    name="Zblog"
    dirname="Z-BlogPHP_1_5_1_1740_Zero"
    hookdir=$dirname
    port=91

    # Выполнение установки программы 
    web_installer
    echo "Настройка $name..."
    chmod -R 777 /opt/wwwroot/$webdir     # Установка прав

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    sed -e "s/.*\#php-fpm.*/    include \/opt\/etc\/nginx\/conf\/php-fpm.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf         # Добавить поддержку php-fpm
    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
}

######### Установка DzzOffice #########
install_dzzoffice()
{
    # По умолчанию
    filelink=$url_DzzOffice
    name="DzzOffice"
    dirname="dzzoffice-master"
    port=92

    # Выполнение установки программы 
    web_installer
    echo "Настройка $name..."
    chmod -R 777 /opt/wwwroot/$webdir     # Установка прав

    # Добавление на виртуальный хост
    add_vhost $port $webdir
    sed -e "s/.*\#php-fpm.*/    include \/opt\/etc\/nginx\/conf\/php-fpm.conf\;/g" -i /opt/etc/nginx/vhost/$webdir.conf         # Добавить поддержку php-fpm
    onmp restart >/dev/null 2>&1
    echo "$name - полностью установлено"
    echo "Введите адрес: $localhost:$port для получения доступа"
    echo "DzzOffice - Некоторые приложения не доступны автоматически на рынке приложений. Для установки обратитесь к официальному сайту для руководства"
}

############# Добавление на виртуальный хост #############
add_vhost()
{
# Запись файла
cat > "/opt/etc/nginx/vhost/$2.conf" <<-\EOF
server {
    listen 81;
    server_name localhost;
    root /opt/wwwroot/www/;
    index index.html index.htm index.php tz.php;
    #php-fpm
    #otherconf
}
EOF

sed -e "s/.*listen.*/    listen $1\;/g" -i /opt/etc/nginx/vhost/$2.conf
sed -e "s/.*\/opt\/wwwroot\/www\/.*/    root \/opt\/wwwroot\/$2\/\;/g" -i /opt/etc/nginx/vhost/$2.conf
}

############## Веб-сайт Управление ##############
web_manager()
{
    onmp stop > /dev/null 2>&1
    i=1
    for conf in /opt/etc/nginx/vhost/*;
    do
        path=$(cat $conf | awk 'NR==4' | awk '{print $2}' | sed 's/;//')
        echo "$i. $path"
        eval web_conf$i="$conf"
        eval web_file$i="$path"
        i=$((i + 1))
    done
    read -p "Выберите Удаление Веб-сайт：" webnum
    eval conf=\$web_conf"$webnum"
    eval file=\$web_file"$webnum"
    rm -rf "$conf"
    rm -rf "$file"
    onmp start > /dev/null 2>&1
    echo "Веб-сайт Удалени"
}

############## Swap ##############
set_swap()
{
    clear
# 
cat << SWAP
----------------------------------------
|**************** SWAP ****************|
----------------------------------------
(1) Открытый Swap
(2) Близкий Swap
(3) УдалениеSwap файла

SWAP

read -p "Выберите [1-3]: " input
case $input in
1) on_swap;;
2) swapoff /opt/.swap;;
3) del_swap;;
*) echo "В ввели не  1 ~ 3!"
break;;
esac 
}

#### Открытый Swap ####
on_swap()
{
    status=$(cat /proc/swaps |  awk 'NR==2')
    if [[ -n "$status" ]]; then
        echo "Swap включен"
    else
        if [[ ! -e "/opt/.swap" ]]; then
            echo "Идет Генерация swap файла，ждите..."
            dd if=/dev/zero of=/opt/.swap bs=1024 count=524288
            #  настройки SWAP файла
            mkswap /opt/.swap
            chmod 0600 /opt/.swap
        fi
        # Включение SWAP-раздела
        swapon /opt/.swap
        echo "Теперь вы можете использовать free команд Вид swap Включение"
    fi
}

####  Удаление Swap ####
del_swap()
{
    # Удаление SWAP-раздела
    swapoff /opt/.swap
    rm -rf /opt/.swap
}

############## Открытый  Redis ###############
redis()
{
    i=1
    for conf in /opt/etc/nginx/vhost/*;
    do
        path=$(cat $conf | awk 'NR==4' | awk '{print $2}' | sed 's/;//')
        echo "$i. $path"
        eval web_file$i="$path"
        i=$((i + 1))
    done
    read -p "Выберите NextCloud или OwnCloud из Установка каталог：" webnum
    eval file=\$web_file"$webnum"

#
echo "NC и OC Необходимо полностью настроить конфигурацию web，Можно использовать этот вариант Открытый  Redis"
read -p "Подтвердите Установка [Y/n]: " input
case $input in
    Y|y ) 
#
sed -e "/);/d" -i $file/config/config.php
cat >> "$file/config/config.php" <<-\EOF
'memcache.locking' => '\OC\Memcache\Redis',
'memcache.local' => '\OC\Memcache\Redis',
'redis' => array(
    'host' => '/opt/var/run/redis.sock',
    'port' => 0,
    ),
);
EOF
;;
* ) exit;;
esac 

onmp restart >/dev/null 2>&1
echo "Нет ошибок из при установке, перезапуск Redis"
echo "Redis Команды управления onmp redis start|restart|stop"
echo "Я буду управлять этим для вас первым."
onmp redis start

}

############## БД резервное копирование ##############
sql_backup()
{
# Варианты вывода
cat << EOF
БД резервное копирование
(1) Открытый 
(2) Близкий 
(0) Выход
EOF

read -p "Выберите : " input
case $input in
    1) sql_backup_on;;
2) sql_backup_off;;
0) exit;;
*) echo "Нет такой опции!"
exit;;
esac 
}

### БД резервное копирование Открытый  ###
sql_backup_on()
{
    if [[ ! -d "/opt/backup" ]]; then
        mkdir /opt/backup
    fi
    read -p "Введите имя пользователя БД: " sqlusr
    read -p "Введите пароль пользователя БД: " sqlpasswd

#  Удаление
rm -rf /opt/bin/sqlbackup

# Запись файла
cat > "/opt/bin/sqlbackup" <<-\EOF
#!/bin/sh
/opt/bin/mysqldump -uusername -puserpasswd -A > /opt/backup/sql_backup_$(date +%Y%m%d%H).sql
EOF
    
sed -e 's/username/'"$sqlusr"'/g' -i /opt/bin/sqlbackup
sed -e 's/userpasswd/'"$sqlpasswd"'/g' -i /opt/bin/sqlbackup

chmod +x /opt/bin/sqlbackup

echo "Создано успешно, вы можете использовать напрямую sqlbackup команд для резервного копирования. Также доступно управление на маршрутизаторе. Добавлено задание 1 */3 * * * /opt/bin/sqlbackup，резервное копирование каждые 3 часа"

}

### БД резервное копированиеБлизкий  ###
sql_backup_off()
{
    rm -rf /opt/bin/sqlbackup
    echo "Если вы используете автоматическое резервное копирование по расписанию, пожалуйста, удалите конфигурацию"
}

###########################################
############## Начало скрипта #############
###########################################
start()
{
# Варианты вывода
cat << EOF
      ___           ___           ___           ___    
     /  /\         /__/\         /__/\         /  /\   
    /  /::\        \  \:\       |  |::\       /  /::\  
   /  /:/\:\        \  \:\      |  |:|:\     /  /:/\:\ 
  /  /:/  \:\   _____\__\:\   __|__|:|\:\   /  /:/~/:/ 
 /__/:/ \__\:\ /__/::::::::\ /__/::::| \:\ /__/:/ /:/  
 \  \:\ /  /:/ \  \:\~~\~~\/ \  \:\~~\__\/ \  \:\/:/   
  \  \:\  /:/   \  \:\  ~~~   \  \:\        \  \::/    
   \  \:\/:/     \  \:\        \  \:\        \  \:\    
    \  \::/       \  \:\        \  \:\        \  \:\   
     \__\/         \__\/         \__\/         \__\/   

=======================================================

(1) УстановкаONMP
(2) Удаление ONMP
(3) Настройки пароля БД
(4) Сброс БД 
(5) БД резервное копирование
(6) Сбросить все (Удаление каталога сайтов, см. backup)
(7) Установка программы Веб-сайта
(8) Управление Веб-сайтом
(9) Открытый Swap
(10) Открытый Redis
(0) Выход

EOF

read -p "Выберите [0-9]: " input
case $input in
1) install_onmp_ipk;;
2) remove_onmp;;
3) set_passwd;;
4) init_sql;;
5) sql_backup;;
6) init_onmp;;
7) install_website;;
8) web_manager;;
9) set_swap;;
10) redis;;
0) exit;;
*) echo "В ввели не 0 ~ 10!"
exit;;
esac 
}

re_sh="renewsh"

if [ "$1" == "$re_sh" ]; then
    set_onmp_sh
    exit;
fi  

start
