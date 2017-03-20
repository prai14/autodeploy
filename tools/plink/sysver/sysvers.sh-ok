v0=`ifconfig -a|grep "Link encap"|awk '{print $1}'|grep bond0|grep -v "bond0:1"|grep -v "bond0:2"|grep -v "bond0:3"`
v1=`cat /etc/sysconfig/network-scripts/ifcfg-eth0|grep IPADDR`
v2=`cd /etc/sysconfig/network-scripts/;ls ifcfg-eth*|grep eth1`
if [ "${v2}" != "" ] ;then
    v3=`cat /etc/sysconfig/network-scripts/ifcfg-eth1|grep IPADDR`
fi
if [ "${v0}" = "bond0" ] ;then
echo "`ifconfig bond0|grep inet|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
`hostname` 
`cat /etc/redhat-release` 
`uname -a|awk '{print $3}'`
`uname -a|awk '{print $12}'`"|awk '{printf P$0;P="|"}END{print""}'
else
    if [ "${v1}" != "" ] ;then
echo "`ifconfig eth0|grep inet|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
`hostname` 
`cat /etc/redhat-release` 
`uname -a|awk '{print $3}'`
`uname -a|awk '{print $12}'`"|awk '{printf P$0;P="|"}END{print""}'
    fi
    if [ "${v3}" != "" ] && [ "${v1}" = "" ] ;then
echo "`ifconfig eth1|grep inet|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
`hostname` 
`cat /etc/redhat-release` 
`uname -a|awk '{print $3}'`
`uname -a|awk '{print $12}'`"|awk '{printf P$0;P="|"}END{print""}'
    fi
    if [ "${v3}" = "" ] && [ "${v1}" = "" ] ;then
echo "`ifconfig eth2|grep inet|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
`hostname` 
`cat /etc/redhat-release` 
`uname -a|awk '{print $3}'`
`uname -a|awk '{print $12}'`"|awk '{printf P$0;P="|"}END{print""}'
    fi
fi
