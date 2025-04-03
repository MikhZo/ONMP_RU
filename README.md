ONMP = Opkg + Nginx + MySQL + PHP. 
===

Скрипт для установки в один клик ONNMP на прошивку Entware

В настоящее время успешно протестированы на Padavan, LEDE и Merlin / Keenetic

`php-fpm` и `mysqld` Если запуск не удался, вы должны создать swap

nginx ONMP настроен на прослушивание порта 80, поэтому если у Вас установлен Web-интерфейс 
Luci и, соответственно, сервер uhttpd, слушающий порт 81 (по умолчанию - 80), то его 
следует перенести на другой порт.
Делается это просто, надо отредактировать файл /etc/config/uhttpd :

в строке
list listen_http
замените 81 на 80, сохраните и рестартуйте uhttpd:

/etc/init.d/uhttpd restart



```
$ onmp open 
# Выберите 7
```

## Пояснение

ONMP: Opkg + Nginx + MySQL + PHP

Это скрипт написан в Linux Shell, и может быстро собрать среду Nginx / MySQL / PHP для маршрутизаторов, 
управляемых пакетом opkg, и создать несколько полезных программ для веб-сайтов с установкой в один клик.

```
ONMP - Установка в один клик со следующими встроенными программами：
(1) phpMyAdmin (Инструмент управления БД)
(2) WordPress (Наиболее широко используемая CMS)
(3) Owncloud (Классическое частное облако)
(4) Nextcloud (Новая работа команды Owncloud, красивый и мощный персональный облачный диск)
(5) h5ai (Отличный каталог файлов)
(6) Lychee (Красивый, простой в использовании веб-альбом)
(7) Kodexplorer (Can Daoyun aka Mango Cloud Онлайн менеджер документов)
(8) Typecho (Легкая программа для блогов с открытым исходным кодом)
(9) Z-Blog (Маленький, быстрый PHP блоггер)
(10) DzzOffice (Офисная платформа с открытым исходным кодом)
```

Все пакеты устанавливаются через opkg и все видно в скрипте, так что не стесняйтесь использовать

## Инструкции

[wiki](https://github.com/xzhih/ONMP/wiki) на китайском
[wiki](https://github.com/MikhZo/ONMP_RU/wiki) на русском

[Блог](https://zhih.me) не доступен

## Руководство по установке

### 1. Установка Entware

Entware - это репозиторий программного обеспечения для сетевых хранилищ, маршрутизаторов и других встроенных устройств.
Доступно более 2500 пакетов для разных платформ. Пакеты Entware - это полные версии программ / команд, встречающихся 
в распространенных дистрибутивах Linux.

Установка Entware на LEDE

Установка Entware на Merlin

Установка Entware на Padavan

Установка Entware на Keenetic

Различные прошивки предполагают разные способы установки, определите свой способ (нужно знать свою прошивку 😂)

[LEDE & Entware](https://github.com/MikhZo/ONMP_RU/wiki/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-Entware-%D0%BD%D0%B0-LEDE)

[Merlin & Entware](https://github.com/MikhZo/ONMP_RU/wiki/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-Entware-%D0%BD%D0%B0-Merlin)

[Padavan & Entware](https://github.com/MikhZo/ONMP_RU/wiki/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-Entware-%D0%BD%D0%B0-Padavan)

[Keenetic & Entware](https://github.com/MikhZo/ONMP_RU/wiki/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-Entware-%D0%BD%D0%B0-Keenetic)


### 2. Установка ONMP

Команда в один клик, копировать -> вставить -> выполнить

```
 $ sh -c "$(curl -kfsSl https://raw.githubusercontent.com/MikhZo/ONMP_RU/blob/master/oneclick-ru.sh)"
```

Если вы получаете ошибки, вы можете следовать приведенным ниже этапам и выполнять команды по установке шаг за шагом.

```
# Войдите в каталог для подключения entware
  cd /opt && opkg install wget unzip 

# Скачивание пакета - НУЖНО!
wget --no-check-certificate -O /opt/onmp.zip https://github.com/MikhZo/ONMP_RU/archive/refs/heads/master.zip

# Распаковка
unzip /opt/onmp.zip
mv /opt/ONMP-master /opt/onmp
cd /opt/onmp

# Установка разрешений
chmod +x ./onmp.sh 

# Исполнение
./onmp.sh 
```

Если вы правильно запустите скрипт , появится следующий сценарий.

![Установка](https://i.loli.net/2018/03/03/5a99ac096c6a1.png)

При обычной установке, если есть ошибка, появится сообщение об ошибке.
Согласно оперативной операции, большая часть полученных в настоящее время
отзывов связана с сетью, поскольку источник entware находится за границей,
и их менеджер сказал, что они уже получили DDOS из Азии, поэтому Поток здесь
ограничен, а скорость ниже. В этом случае вы можете пойти на шоу,
и все будет хорошо, когда вы вернетесь.

Результатом успешной установки является это:

![Успешная установка](https://i.loli.net/2018/03/03/5a99aeda756ac.png)


Если вы видите то же, что и на картинке выше, то поздравляю, вы успешно
установили ONMP, можете пользоваться.

## Обновить скрипт

Та же команда, что была установлена, выберите 2 для обновления.

## Подробное руководство ONMP

**Основные команды:**

```
Управление: onmp open
Пуск, остановка, перезапуск: onmp start|stop|restart
Посмотреть список сайтов: onmp list 
```

**Основной пакет команд управления：**

```
Команды управления Nginx
onmp nginx start|restart|stop

Команды управления MySQL
onmp mysql start|restart|stop

Команды управления PHP
onmp php start|restart|stop

Команды управления Redis
onmp redis start|restart|stop
```

**Установите пароль базы данных:**

Введите `onmp open`, после выбора 3 вам будет предложено `Enter password:` 
В настоящее время вам необходимо ввести пароль текущей базы данных, например, 
первоначально установленный пароль базы данных - 123456,，Если пароль верен 
после Enter вам будет предложено ввести новый пароль, который вы хотите
установить.
После нажатия клавиши Enter вам будет 
Это очень простое расположение, но многие люди говорят, что не могут сменить
пароль, на самом деле они не увидели подсказку и не ввели старый пароль,
поэтому я написал ясно.


## Прочее

Парсер https://github.com/WuSiYu/PHP-Probe



root@MIMIK:/opt/onmp# onmp nginx stop
Nginx gracefully stopped.
root@MIMIK:/opt/onmp# onmp nginx start
Nginx started.
root@MIMIK:/opt/onmp# onmp mysql stop
root@MIMIK:/opt/onmp# onmp mysql start
root@MIMIK:/opt/onmp# onmp php stop
 Checking php-fpm...              alive.
 Shutting down php-fpm...              done.
root@MIMIK:/opt/onmp# onmp php start
 Starting php-fpm...              done.

   PHP MyAdmin
 Явно прописать в opt/etc/php.ini

 после extension_dir=/opt/lib/php

 extension=mysqlnd.so
extension=pdo_mysql.so
extension=mysqli.so

Явно прописать в /opt/wwwroot/phpMyAdmin/config.inc.php
$cfg['Servers'][$i]['host'] = 127.0.0.1; (вместо localhost

После входа в ваш экземпляр phpMyAdmin вы получите сообщение об ошибке:

# 1231 - Переменная 'lc_messages' не может быть установлена в значение 'ru_RU'
Решение:
Это сообщение об ошибке вызвано неверным языковым кодом - в приведенном выше
примере MySQL не понимает ru_RU языковой код.

Самым простым решением для этого является установка phpMyAdmin на фиксированный
язык. Чтобы сделать это, добавьте эту строку в вашу конфигурацию config.inc.php

$cfg['Lang'] = 'en';
Вы можете добавить это почти в любом месте файла, но я рекомендую добавить его
после  $cfg['blowfish_secret'] строки.

Если после этого сообщение об ошибке не исчезнет, убедитесь, что в   config.inc.php
нет другой строки     $cfg [ 'Lang' ]

Если порт открыт это означает, что какая либо программа (например сервис)
использует его для связи с другой программой через интернет или в локальной
системе. Чтобы посмотреть какие порты открыты в вашей системе Linux можно
использовать команду netstat. В выводе будут показаны все сервисы и
прослушиваемые ими порты и ip адреса.

netstat -ntulp

Здесь:

-l или --listening - посмотреть только прослушиваемые порты
-p или --program - показать имя программы и ее PID
-t или --tcpпоказать tcp порты
-u или --udp показать udp порты
-n или --numeric показывать ip адреса в числовом виде

Вы также можете использовать команду grep, чтобы узнать, какое приложение прослушивает конкретный порт, например:

netstat -lntup | grep "nginx"

В качестве альтернативы вы можете указать порт и найти приложение:

netstat -lntup | grep ":80"

(если OpenWRT долго работает, grep может не отображать информацию, тогда
нужно перезагрузить роутер)




Утилита lsof позволяет посмотреть все открытые в системе соединения,
в том числе и сетевые, для этого нужно использовать опцию i.

lsof -i

(Скорее всего, не установлена, поэтому:
opkg update
opkg install lsof
)

Аналогично:
 lsof -i | grep 80
 (lsof -i | grep "nginx" ?)

Чтобы узнать, какое приложение прослушивается на определенном порту, запустите
lsof в таком виде:

lsof -i :80


ss — еще один полезный инструмент для отображения информации о сокетах.
Он в своём использовании похож на netstat. Следующая команда выведет все порты,
прослушивающие соединения TCP и UDP в числовом формате.

ss -lntu
 (opkg install ss)



 Nmap — мощный и популярный инструмент для исследования сети
и сканирования портов. Чтобы установить nmap в вашу систему, используйте
opkg install nmap или opkg install nmap-ssl

Чтобы «отсканировать» все открытые/прослушивающие порты в вашей Linux-системе,
выполните следующую команду (она займет ОЧЕНЬ! много времени для своего
выполнения!!!).

nmap -n -PN -sT -sU -p- localhost

Очень полезно проверить себя снаружи:
сначала узнаем внешний ip адрес, для надежности воспользуемся онлайн сервисом:

 wget -O - -q icanhazip.com

178.93.149.50

Дальше запускаем сканирование:

 nmap 178.93.149.50





 Создайте файл date.php в папке /opt/wwwroot/default/
touch /opt/wwwroot/default/date.php

и добавьте в него нижеприведенные строки
PHP код:
<?php
$melbdate = date("l, d F Y h:i a",time()+(1*60));
print ("$melbdate");
?>

  Изменить права доступа к файлу
chmod 755 /opt/wwwroot/default/date.php

Посмотрите текущую дату и время: http://192.168.1.1:81/date.php


Nextcloud

504 Gateway Time-out
nginx/1.15.8


location ~ .php$ { } :
proxy_connect_timeout 600;
proxy_send_timeout 600;
proxy_read_timeout 600;
send_timeout 600;
fastcgi_read_timeout 300;
fastcgi_buffers 8 128k;
fastcgi_buffer_size 256k;
