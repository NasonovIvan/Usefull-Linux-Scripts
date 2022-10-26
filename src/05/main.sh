#!/bin/bash

num_param=${#}

if [ $num_param -ne 1 ]; then
	echo "Please, input only 1 parameter"
	exit 1
fi

if [ ! -d "$1" ]; then
	 echo "No such directory or path. Try again"
	 exit 1
fi

start_time=`date +%s.%N`

echo "Total number of folders (including all nested ones) = $(find ${1} -type d | wc -l)"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
echo "$(du ${1} -h | sort -hr | head -5 | nl | awk '{print $1, "-", $3"/,", $2}')"
echo "Total number of files = $(find ${1} -type f | wc -l)"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $(find ${1} -type f -name *.conf | wc -l)"
echo "Text files = $(find ${1} -type f -name *.txt | wc -l)"
echo "Executable files = "$(find ${1} -type f -regex ".*\.\(apk\|bat\|bin\|bin\|cgi\|cmd\|com\|cpp\|js\|jse\|exe\|gadget\|gtp\|hta\|jar\|msi\|msu\|pif\|ps1\|pwz\|scr\|thm\|vb\|vbe\|vbs\|wsf\)" | wc -l)
echo "Log files (with the extension .log) = $(find ${1} -type f -name *.log | wc -l)"
echo "Archive files = "$(find ${1} -type f -regex ".*\.\(7z\|arj\|bin\|cab\|cbr\|deb\|exe\|gz\|gzip\|jar\|one\|pak\|pkg\|ppt\|rar\|rpm\|sh\|sib\|sis\|sisx\|sit\|sitx\|spl\|tar\|tar-gz\|tgz\|xar\|zip\|zip\|zipx\)" | wc -l)
echo "Symbolic links = $(find ${1} -type l | wc -l)"

echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
count_p=$(find ${1} -type f | wc -l)
if [[ $count_p -ge 10 ]]; then
	count_p=10
fi
for (( i=1; i <= $count_p; i++ ))
do
	main_string="$(find ${1} -type f -exec du -h '{}' + | sort -hr | nl | head -$i | tail -1 | awk '{print $1" - "$3", "$2}')"
	echo -n $main_string
	filename="$(find ${1} -type f -exec du -h '{}' +  | sort -hr | head -$i | tail -1 | awk '{print $2}')"
	ext=$(echo $filename | grep -o "\.\w*$" | tr "." " ")
	echo ",$ext"
done
if [[ $count_p -eq 0 ]]; then
        echo "No such files in this directory"
fi

echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
count=$(find ${1} -type f -regex ".*\.\(apk\|bat\|bin\|bin\|cgi\|cmd\|com\|cpp\|js\|jse\|exe\|gadget\|gtp\|hta\|jar\|msi\|msu\|pif\|ps1\|pwz\|scr\|thm\|vb\|vbe\|vbs\|wsf\)" | wc -l)
if [[ $count -ge 10 ]]; then
	count=10
fi
for (( i=1; i <= $count; i++ ))
do
	main_string=$(find ${1} -type f -regex ".*\.\(apk\|bat\|bin\|bin\|cgi\|cmd\|com\|cpp\|js\|jse\|exe\|gadget\|gtp\|hta\|jar\|msi\|msu\|pif\|ps1\|pwz\|scr\|thm\|vb\|vbe\|vbs\|wsf\)" -exec du -h '{}' + | sort -hr | nl | head -$i | tail -1 | awk '{print $1" - "$3", "$2}')
	echo -n $main_string
	filename=$(find ${1} -type f -regex ".*\.\(apk\|bat\|bin\|bin\|cgi\|cmd\|com\|cpp\|js\|jse\|exe\|gadget\|gtp\|hta\|jar\|msi\|msu\|pif\|ps1\|pwz\|scr\|thm\|vb\|vbe\|vbs\|wsf\)" -exec du -h '{}' + | sort -hr | head -$i | tail -1 | awk '{print $2}' | md5sum | awk '{print $1}')
	echo ", $filename"
done
if [[ $count -eq 0 ]]; then
	echo "No executable files in this directory"
fi

end_time=`date +%s.%N`

runtime=$( echo "$end_time - $start_time" | bc -l )
if [ "$runtime" \< "1" ]; then
	runtime="0$runtime"
fi

echo "Script execution time (in seconds) = $runtime"
