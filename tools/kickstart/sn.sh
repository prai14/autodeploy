servsn=$(dmidecode -t system|grep -i "Serial Number"|awk -F":" '{print $2}'|xargs)
echo ${servsn}
