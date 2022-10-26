#!/bin/bash

num_param=$#

if [ $num_param -ne 0 ]; then
	echo "Please, run script without parameters"
	exit 1
fi

# default color: 2-red, 4-blue, 5-purple, 1-white

. color_file.conf

if [ "$column1_background" != "" ]; then
	if [ $column1_background -lt 1 ] || [ $column1_background -gt 6 ]; then
		echo "Please, input only 1, 2, 3, 4, 5, 6 parameters"
		exit 1
	fi
fi

if [ "$column1_font_color" != "" ]; then
        if [ $column1_font_color -lt 1 ] || [ $column1_font_color -gt 6 ]; then
                echo "Please, input only 1, 2, 3, 4, 5, 6 parameters"
                exit 1
        fi
fi

if [ "$column2_background" != "" ]; then
        if [ $column2_background -lt 1 ] || [ $column2_background -gt 6 ]; then
                echo "Please, input only 1, 2, 3, 4, 5, 6 parameters"
                exit 1
        fi
fi

if [ "$column2_font_color" != "" ]; then
        if [ $column2_font_color -lt 1 ] || [ $column2_font_color -gt 6 ]; then
                echo "Please, input only 1, 2, 3, 4, 5, 6 parameters"
                exit 1
	fi
fi

column1_back_default=0
column1_font_default=0
column2_back_default=0
column2_font_default=0

if [ "$column1_background" = "" ]; then
	column1_back_default=1
	column1_background=2
fi
if [ "$column1_font_color" = "" ]; then
	column1_font_default=1
        column1_font_color=4
fi
if [ "$column2_background" = "" ]; then
        column2_back_default=1
        column2_background=5
fi
if [ "$column2_font_color" = "" ]; then
        column2_font_default=1
        column2_font_color=1
fi

if [ $column1_background -eq $column1_font_color ] || [ $column2_background -eq $column2_font_color ]; then
        echo "Please, parameters 1_back, 1_font and 2_back, 2_font should be different. Try again"
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

if [[ $column1_background -eq 1 ]]; then color1='\033[47m'
elif [[ $column1_background -eq 2 ]]; then color1='\033[41m'
elif [[ $column1_background -eq 3 ]]; then color1='\033[42m'
elif [[ $column1_background -eq 4 ]]; then color1='\033[44m'
elif [[ $column1_background -eq 5 ]]; then color1='\033[45m'
elif [[ $column1_background -eq 6 ]]; then color1='\033[40m'
fi

if [[ $column2_background -eq 1 ]]; then color3='\033[47m'
elif [[ $column2_background -eq 2 ]]; then color3='\033[41m'
elif [[ $column2_background -eq 3 ]]; then color3='\033[42m'
elif [[ $column2_background -eq 4 ]]; then color3='\033[44m'
elif [[ $column2_background -eq 5 ]]; then color3='\033[45m'
elif [[ $column2_background -eq 6 ]]; then color3='\033[40m'
fi

if [[ $column1_font_color -eq 1 ]]; then color2='\033[0;37m'
elif [[ $column1_font_color -eq 2 ]]; then color2='\033[0;31m'
elif [[ $column1_font_color -eq 3 ]]; then color2='\033[0;32m'
elif [[ $column1_font_color -eq 4 ]]; then color2='\033[0;34m'
elif [[ $column1_font_color -eq 5 ]]; then color2='\033[0;35m'
elif [[ $column1_font_color -eq 6 ]]; then color2='\033[0;30m'
fi

if [[ $column2_font_color -eq 1 ]]; then color4='\033[0;37m'
elif [[ $column2_font_color -eq 2 ]]; then color4='\033[0;31m'
elif [[ $column2_font_color -eq 3 ]]; then color4='\033[0;32m'
elif [[ $column2_font_color -eq 4 ]]; then color4='\033[0;34m'
elif [[ $column2_font_color -eq 5 ]]; then color4='\033[0;35m'
elif [[ $column2_font_color -eq 6 ]]; then color4='\033[0;30m'
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

array_color=("white" "red" "green" "blue" "purple" "black")

echo ""

if [ $column1_back_default -eq 1 ]; then
	echo -e "Column 1 background = default (red)"
else
	echo -e "Column 1 background = $column1_background (${array_color[($column1_background - 1)]})"
fi
if [ $column1_font_default -eq 1 ]; then
        echo -e "Column 1 font color = default (blue)"
else
        echo -e "Column 1 font color = $column1_font_color (${array_color[($column1_font_color - 1)]})"
fi
if [ $column2_back_default -eq 1 ]; then
        echo -e "Column 2 background = default (purple)"
else
        echo -e "Column 2 background = $column2_background (${array_color[($column2_background - 1)]})"
fi
if [ $column2_font_default -eq 1 ]; then
        echo -e "Column 2 font color = default (white)"
else
        echo -e "Column 2 font color = $column2_font_color (${array_color[($column2_font_color - 1)]})"
fi

