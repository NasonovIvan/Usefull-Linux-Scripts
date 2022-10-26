#!/bin/bash

hostname=$(hostname)

timezone=$(timedatectl | grep "Time zone")
timezone=${timezone//Time zone:}
timezone=${timezone// /}
timezone=${timezone/"("/" "}
timezone=${timezone/")"/" "}
timezone=${timezone/","/" "}

user=$(whoami)

os=$(cat /etc/issue)
os=${os/"\n"/" "}
os=${os/"\l"/" "}

date=$(date +"%d %b %Y %T")

uptime=$(uptime -p)

uptime_sec=$(awk '{print $1}' /proc/uptime)

ip=$(hostname -I)

/sbin/ifconfig | awk '/netmask/{split($4, a, " "); print a[1]}' >> mask_file.txt
mask=$(awk '{print $1}' mask_file.txt | head -1)
rm mask_file.txt

gateway=$(ip -4 route show default | grep "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" -o | grep "" -m 1)

ram_total_kb=$(grep MemTotal /proc/meminfo)
ram_total_kb=${ram_total_kb//"MemTotal:"/}
ram_total_kb=${ram_total_kb//"kB"/}
ram_total_kb=${ram_total_kb//" "/}
ram_total=$(bc<<<"scale=3;$ram_total_kb/1048576")

ram_used_kb=$(vmstat -s | grep "used m")
ram_used_kb=${ram_used_kb//"used memory"/}
ram_used_kb=${ram_used_kb//"K"/}
ram_used_kb=${ram_used_kb//" "/}
gb_kb="1048576"
ram_used_gb=$(bc<<<"scale=3;$ram_used_kb/1048576")
if [ $ram_used_kb -lt $gb_kb ]
then
        ram_used="0$ram_used_gb"
else
        ram_used="$ram_used_gb"
fi

ram_free_kb=$(grep MemFree /proc/meminfo)
ram_free_kb=${ram_free_kb//"MemFree:"/}
ram_free_kb=${ram_free_kb//"kB"/}
ram_free_kb=${ram_free_kb//" "/}
ram_free=$(bc<<<"scale=3;$ram_free_kb/1048576")

space=$(df ~/ | grep '/$\|Filesystem' | tail -1 | awk '{print$2}')
space=${space//"G"/}
space=$(bc<<<"scale=2;$space/1024")

space_used=$(df ~/ | grep '/$\|Filesystem' | tail -1 | awk '{print$3}')
space_used=${space_used//"G"/}
space_used=$(bc<<<"scale=2;$space_used/1024")

space_free=$(df ~/ | grep '/$\|Filesystem' | tail -1 | awk '{print$4}')
space_free=${space_free//"G"/}
space_free=$(bc<<<"scale=2;$space_free/1024")

echo "HOSTNAME = $hostname"
echo "TIMEZONE = $timezone"
echo "USER = $user"
echo "OS = $os"
echo "DATE = $date"
echo "UPTIME = $uptime"
echo "UPTIME_SEC = $uptime_sec"
echo "IP = $ip"
echo "MASK = $mask"
echo "GATEWAY = $gateway"
echo "RAM_TOTAL = $ram_total GB"
echo "RAM_USED = $ram_used GB"
echo "RAM_FREE = $ram_free GB"
echo "SPACE_ROOT = $space MB"
echo "SPACE_ROOT_USED = $space_used MB"
echo "SPACE_ROOT_FREE = $space_free MB"
