v0=`cat /proc/cpuinfo |grep "physical id"|sort|uniq|wc -l`  
v1=`cat /proc/cpuinfo |grep "cores"|uniq|cut -f2 -d: |tr -d " "`
v2=`cat /proc/cpuinfo |grep "processor"|wc -l`
v3=`dmidecode |grep HTT|uniq|awk -F"[()]" '{print $2}' `
v4=`cat /proc/cpuinfo |grep name| cut -f2 -d: |uniq|xargs`
v5=`dmidecode |grep "Core Count"|uniq|cut -f2 -d: |xargs`

if [ "${v0}" -gt 4 ] ;then
    v0=`dmidecode |grep "Node 1 Socket"|wc -l`
fi

if [ "${v5}" != "" ] ;then
    v1=`dmidecode |grep "Core Count"|uniq|cut -f2 -d: |xargs`
fi

if [ "${v3}" != "" ] ;then
    v3="HTT"
fi

echo "${v0}  
${v1}  
${v2}  
${v3}  
${v4}"|awk '{printf P$0;P="|"}END{print""}'
