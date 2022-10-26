#!/bin/bash

num_param=$#

if [ $num_param -ne 4 ]; then
	echo "Input only 4 parameters"
	exit 1
fi

arr_param=$@

for param in $arr_param
do
	if [ $param -gt 6 ] || [ $param -lt 1 ]; then
		echo "Input only 1-6 parameters"
		exit 1
	fi
done

if [ $1 -eq $2 ] || [ $3 -eq $4 ]; then
	echo "Please, parameters 1,2 and 3,4 should be different. Try again"
	exit 1
fi

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

# 1 - white; 2 - red; 3 - green; 4 - blue; 5 - purple; 6 - black

if [[ $1 -eq 1 ]]; then color1='\033[47m'
elif [[ $1 -eq 2 ]]; then color1='\033[41m'
elif [[ $1 -eq 3 ]]; then color1='\033[42m'
elif [[ $1 -eq 4 ]]; then color1='\033[44m'
elif [[ $1 -eq 5 ]]; then color1='\033[45m'
elif [[ $1 -eq 6 ]]; then color1='\033[40m'
fi

if [[ $3 -eq 1 ]]; then color3='\033[47m'
elif [[ $3 -eq 2 ]]; then color3='\033[41m'
elif [[ $3 -eq 3 ]]; then color3='\033[42m'
elif [[ $3 -eq 4 ]]; then color3='\033[44m'
elif [[ $3 -eq 5 ]]; then color3='\033[45m'
elif [[ $3 -eq 6 ]]; then color3='\033[40m'
fi

if [[ $2 -eq 1 ]]; then color2='\033[0;37m'
elif [[ $2 -eq 2 ]]; then color2='\033[0;31m'
elif [[ $2 -eq 3 ]]; then color2='\033[0;32m'
elif [[ $2 -eq 4 ]]; then color2='\033[0;34m'
elif [[ $2 -eq 5 ]]; then color2='\033[0;35m'
elif [[ $2 -eq 6 ]]; then color2='\033[0;30m'
fi

if [[ $4 -eq 1 ]]; then color4='\033[0;37m'
elif [[ $4 -eq 2 ]]; then color4='\033[0;31m'
elif [[ $4 -eq 3 ]]; then color4='\033[0;32m'
elif [[ $4 -eq 4 ]]; then color4='\033[0;34m'
elif [[ $4 -eq 5 ]]; then color4='\033[0;35m'
elif [[ $4 -eq 6 ]]; then color4='\033[0;30m'
fi

color_reset='\033[0m'

echo -e "${color2}${color1}HOSTNAME${color_reset} = ${color4}${color3}$hostname${color_reset}"
echo -e "${color2}${color1}TIMEZONE${color_reset} = ${color4}${color3}$timezone${color_reset}"
echo -e "${color2}${color1}USER${color_reset} = ${color4}${color3}$user${color_reset}"
echo -e "${color2}${color1}OS${color_reset} = ${color4}${color3}$os${color_reset}"
echo -e "${color2}${color1}DATE${color_reset} = ${color4}${color3}$date${color_reset}"
echo -e "${color2}${color1}UPTIME${color_reset} = ${color4}${color3}$uptime${color_reset}"
echo -e "${color2}${color1}UPTIME_SEC${color_reset} = ${color4}${color3}$uptime_sec${color_reset}"
echo -e "${color2}${color1}IP${color_reset} = ${color4}${color3}$ip${color_reset}"
echo -e "${color2}${color1}MASK${color_reset} = ${color4}${color3}$mask${color_reset}"
echo -e "${color2}${color1}GATEWAY${color_reset} = ${color4}${color3}$gateway${color_reset}"
echo -e "${color2}${color1}RAM_TOTAL${color_reset} = ${color4}${color3}$ram_total GB${color_reset}"
echo -e "${color2}${color1}RAM_USED${color_reset} = ${color4}${color3}$ram_used GB${color_reset}"
echo -e "${color2}${color1}RAM_FREE${color_reset} = ${color4}${color3}$ram_free GB${color_reset}"
echo -e "${color2}${color1}SPACE_ROOT${color_reset} = ${color4}${color3}$space MB${color_reset}"
echo -e "${color2}${color1}SPACE_ROOT_USED${color_reset} = ${color4}${color3}$space_used MB${color_reset}"
echo -e "${color2}${color1}SPACE_ROOT_FREE${color_reset} = ${color4}${color3}$space_free MB${color_reset}"
