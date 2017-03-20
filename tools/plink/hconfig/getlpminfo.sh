#SN/Model/Type
#Redhat4.4 CentOS4.4 up
if grep -q 'release 4' /etc/redhat-release ; then
    mySN=`dmidecode|grep -A5 'System Information'|grep 'Serial Number'|awk '{print $3}'|sed 's/^[ \t]*//g'|sed 's/[ \t]$//g'`
    myModel=`dmidecode|grep -A5 'System Information'|grep 'Product Name'|awk -F ":" '{print $2}'|grep -oP '(?<=\[)[^][]*(?=\])'`
    myType=`dmidecode|grep -A5 'System Information'|grep 'Product Name'|awk -F ":" '{print $2}'|cut -d '-' -f 1|xargs`
else
    mySN=`dmidecode -s system-serial-number|grep -v '#'`
    if echo "${mySN}" | grep -qiE "^NotSpecified|^None|^ToBeFilledByO.E.M.|O.E.M." ; then
        mySN=`dmidecode -s baseboard-serial-number`
    fi
    myModel=`dmidecode -s system-product-name|grep -v '#'|grep -oP '(?<=\[)[^][]*(?=\])'`
    if echo "${myModel}" | grep -qiE "^NotSpecified|^None|^ToBeFilledByO.E.M.|O.E.M." ; then
        myModel=`dmidecode -s baseboard-product-name`
    fi
    myType=`dmidecode -s system-product-name|grep -v '#'|cut -d '-' -f 1|xargs`
    if echo "${myType}" | grep -qiE "^NotSpecified|^None|^ToBeFilledByO.E.M.|O.E.M.|P9D" ; then
        myType=`dmidecode -s baseboard-product-name|xargs`
    fi
fi

#CPU
v0=`cat /proc/cpuinfo |grep "physical id"|sort|uniq|wc -l`  
v1=`cat /proc/cpuinfo |grep "cores"|uniq|cut -f2 -d: |tr -d " "`
v2=`cat /proc/cpuinfo |grep "processor"|wc -l`
v3=`dmidecode |grep HTT|uniq|awk -F"[()]" '{print $2}' `
v4=`cat /proc/cpuinfo |grep name| cut -f2 -d: |uniq|xargs`
v5=`dmidecode |grep "Core Count"|uniq|cut -f2 -d: |xargs`
v6=`echo ${myType}|grep x3650`
v7=`echo ${v4}|grep E5504`
v8=`echo "4"`
v9=`echo ${myType}|grep "eserver xSeries"`
va=`echo "2"`
vb=`echo ${myType}|grep "3850 M2"`
vc=`echo ${myType}|grep x3850`
vd=`echo ${myType}|grep "x3850 X5"`
ve=`echo ${v4}|grep E7502`
vf=`echo "System x3850 X5"`

if [ "${v0}" -gt 4 ] ;then
    v0=`dmidecode |grep -iE "Socket Designation: (Node|CPU)"|wc -l`
fi

if [ "${v5}" != "" ] ;then
    v1=`dmidecode |grep "Core Count"|uniq|cut -f2 -d: |xargs`
fi

if [ "${v3}" != "" ] ;then
    v3="HTT"
fi

if [ "${v6}" != "" ] && [ "${v0}" -gt 2 ] ;then
    v0=`dmidecode |grep -iE "Socket Designation: Node"|wc -l`
fi

if [ "${v6}" != "" ] && [ "${v7}" != "" ] ;then
    v1=`echo ${v8}`
fi

if [ "${v9}" != "" ] ;then
    v1=`echo ${va}`
fi

if [ "${vb}" != "" ] ;then
    v0=`dmidecode |grep -iE "Socket Designation: Node"|wc -l`
fi

if [ "${vc}" != "" ] && [ "${v1}" -eq 2 ] ;then
    v0=`dmidecode |grep -iE "Socket Designation: Node"|wc -l`
fi

if [ "${vd}" != "" ] && [ "${v0}" -eq 2 ] ;then
    v0=`dmidecode |grep -iE "Socket Designation: (Node|CPU)"|wc -l`
fi

if [ "${myType}" = "" ] ;then
    myType=`echo ${vf}`
fi

#memory
vg=`cat /proc/meminfo|grep MemTotal|awk -F":" '{print $2}'|awk '{print $1}'|xargs`
vg1=`echo "scale=0;${vg}/1024/1024"|bc`
vh=`free|grep -i mem|awk -F":" '{print $2}'|awk '{print $1}'`
vh1=`echo "scale=0;${vh}/1024/1024"|bc`
vi=`dmidecode|grep -P -A5 "Memory\s+Device"|grep Size|grep -v Range|wc -l`
vj=`dmidecode|grep -P -A5 "Memory\s+Device"|grep Size|grep -v Range|grep -v "No Module Installed"|wc -l`
vm=`dmidecode|grep -P -A5 "Memory\s+Device"|grep Size|grep -v Range|grep -v "No Module Installed"|awk '{sum += $2};END {print sum}'`
vm1=`echo "scale=0;${vm}/1024"|bc`
vk=`dmidecode|grep -P 'Maximum\s+Capacity'|awk '{print $3}'`
vl=`dmidecode|grep -A16 "Memory Device"|grep 'Speed'`

#hdisk
vhd0=`vgs|grep -E "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"`

if [ "${vhd0}" != "" ] ;then
    vhd1=`echo "${vhd0}"|awk '{print $1}'`
    vhd2=`echo "${vhd0}"|awk '{print $6}'`
    vhd3=`echo "${vhd0}"|awk '{print $7}'`
echo "$mySN
$myModel
$myType
${v0}  
${v1}  
${v2}  
${v3}  
${v4}
${vg1}
${vh1}
${vi}
${vj}
${vm1}
${vhd1}
${vhd2}
${vhd3}"|awk '{printf P$0;P="|"}END{print""}'
else
    vhd4=`fdisk -l|grep "Disk /dev/sda:"`
    vhd5=`echo ${vhd4}|awk -F ":" '{print $1}'`
    vhd6=`echo ${vhd4}|awk '{print $3}'`
echo "$mySN
$myModel
$myType
${v0}  
${v1}  
${v2}  
${v3}  
${v4}
${vg1}
${vh1}
${vi}
${vj}
${vm1}
${vhd5}
${vhd6}"G"
"""|awk '{printf P$0;P="|"}END{print""}'
fi
