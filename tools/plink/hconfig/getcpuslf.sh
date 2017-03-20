v=`uname -r|grep -i xen`
if [ "${v}" != "" ] ;then
    vv0=`cat /proc/cpuinfo |grep "processor"|wc -l`
    echo "${vv0}"  
else
    vp0=`cat /proc/cpuinfo |grep "physical id"|sort|uniq|wc -l`  
    vp1=`cat /proc/cpuinfo |grep "cores"|uniq|cut -f2 -d: |tr -d " "`
    vp2=`cat /proc/cpuinfo |grep "processor"|wc -l`
    vp3=`dmidecode |grep HTT|uniq|awk -F"[()]" '{print $2}' `
    vp4=`cat /proc/cpuinfo |grep name| cut -f2 -d: |uniq|xargs`
    vp5=`dmidecode |grep "Core Count"|uniq|cut -f2 -d: |xargs`

    if [ "${vp0}" -gt 4 ] ;then
        vp0=`dmidecode |grep "Node 1 Socket"|wc -l`
    fi

    if [ "${vp5}" != "" ] ;then
        vp1=`dmidecode |grep "Core Count"|uniq|cut -f2 -d: |xargs`
    fi

    if [ "${vp3}" != "" ] ;then
        vp3="HTT"
    fi

    echo "${vp0}  
    ${vp1}  
    ${vp2}  
    ${vp3}  
    ${vp4}"|awk '{printf P$0;P="|"}END{print""}'
fi
