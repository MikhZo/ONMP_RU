#!/bin/sh
# ONMP Установка в один клик
# @Author: xzhih
# @Date:   2018-03-19 04:44:09
# @Last Modified by:   MikhZo
# @Last Modified time: 2025-04-04 01:51:35
# sh -c "$(curl -kfsSL http://192.168.4.126:4000/oneclick.sh)"

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

Скрипт установки одним щелчком для веб-среды библиотеки
Entware,  подходит для  LEDE/OpenWRT,  Padavan,  Merlin
Keenetic и  других  прошивок.

Проект: https://github.com/MikhZo/ONMP-RU

Больше уроков: https://zhih.me (offline)

EOF

Install()
{
	rm -rf /opt/bin/onmp /opt/onmp
	mkdir -p /opt/onmp

    # Получение скрипта ONMP
    curl -kfsSL https://raw.githubusercontent.com/MikhZo/ONMP_RU/master/onmp_ru.sh > /opt/onmp/onmp.sh
    # curl -kfsSL http://192.168.4.126:4000/onmp.sh > /opt/onmp/onmp.sh
    chmod +x /opt/onmp/onmp.sh

    # Получение php файла парсера  
    curl -kfsSL https://raw.githubusercontent.com/MikhZo/PHP-Probe/master/tz_ru.php > /opt/onmp/tz.php

    /opt/onmp/onmp.sh
}

Update()
{
	rm -rf /opt/onmp/onmp.sh
	curl -kfsSL https://raw.githubusercontent.com/MikhZo/ONMP_RU/master/onmp_ru.sh > /opt/onmp/onmp.sh
	# curl -kfsSL http://192.168.4.126:4000/onmp.sh > /opt/onmp/onmp.sh
	chmod +x /opt/onmp/onmp.sh
	/opt/onmp/onmp.sh renewsh > /dev/null 2>&1
	echo "Обновление завершено"
}

start()
{
#
cat << EOF
(1) Начать установку
(2) Скрипт обновления
EOF

read -p "Пожалуйста, введите:" input
case $input in
	1) Install;;
	2) Update;;
	*) exit;;
esac

}

start
