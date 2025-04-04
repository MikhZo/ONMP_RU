#!/bin/sh
# sh -c "$(curl -ksSL http://192.168.4.126:4000/lede-ent.sh)"
export PATH=/opt/bin:/opt/sbin:/sbin:/bin:/usr/sbin:/usr/bin$PATH

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
EOF

cd /tmp || exit

case $(uname -m) in
    *armv5*)
INST_URL="http://bin.entware.net/armv5sf-k3.2/installer/generic.sh"
;;
*armv7l*)
INST_URL="http://bin.entware.net/armv7sf-k3.2/installer/generic.sh"
;;
*aarch64*)
INST_URL="http://bin.entware.net/aarch64-k3.10/installer/generic.sh"
;;
*mips*)
INST_URL="http://bin.entware.net/mipselsf-k3.4/installer/generic.sh"
;;
x86_64)
INST_URL="http://bin.entware.net/x64-k3.2/installer/generic.sh"
;;
*)
echo "Извините, на вашу платформу не может быть установлена Entware"
exit 1
;;
esac

echo -e "Ниже приведена информация о вашем диске\n"
df -h
echo -e "\n"

i=1
for mounted in $(mount | grep -E "ext4" | grep -v "overlay" | cut -d" " -f3) ; do
    echo "[$i] --> $mounted"
    eval mounts$i="$mounted"
    i=$((i + 1))
done

if [ $i = "1" ] ; then
    echo -e "Не удается найти раздел Ext4, выход..."
    exit 1
fi

echo -e "\nНайдите указанный выше раздел Ext4"
echo -en "Введите номер раздела или введите 0 для выхода [0-$((i - 1))]: "
read -r partitionNumber
if [ "$partitionNumber" = "0" ] ; then
    echo -e "$INFO" - выход...
    exit 0
fi
if [ "$partitionNumber" -gt $((i - 1)) ] ; then
    echo -e "Номер раздела неверен - выход ..."
    exit 1
fi

eval entPartition=\$mounts"$partitionNumber"
echo -e "выбран $entPartition \n"

entFolder="$entPartition/opt"

if [ -d "$entFolder" ] ; then
  echo -e "Старый файл Entware был найден в этом разделе - выполняется резервное копирование ..."
  mv "$entFolder" "$entFolder-old_$(date +%F_%H-%M)"
  echo -e "Уже зарезервировано $entFolder-old_$(date +%F_%H-%M) \n"
fi

mkdir "$entFolder"

if [ -d /opt ] ; then
    rm -rf /opt
fi

ln -sf "$entFolder" /opt
echo -e "Создано новое мягкое соединение\n"
echo -e "Начните устанавливать Entware сейчас ..."

wget -qO - $INST_URL | sh

startup="/etc/rc.d/entware-startup.sh"

echo "ln -sf "$entFolder" /opt" > $startup
echo "/opt/etc/init.d/rc.unslung start" >> $startup
chmod 777 /etc/rc.d/entware-startup.sh

sed -e "/^.\ \/opt\/etc\/profile/d" -i /etc/profile
echo ". /opt/etc/profile" >> /etc/profile
source /etc/profile

if [[ "$(which opkg)" == "/opt/bin/opkg" ]]; then
    echo -e "\nУстановка прошла успешно. Перезапустите проверку, чтобы убедиться, что она вступит в силу.\n"
fi
