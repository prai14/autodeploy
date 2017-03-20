file="/etc/redhat-release"
if [ -f "${file}" ] ;then
    vb=`cat /etc/profile|grep "Asia\/Shanghai"`
    if [ "${vb}" != "" ] ;then
        echo "Redhat TZ modified!!!"
        date
    else
        echo "Redhat TZ not modified!!!"
        date
        sudo sed -i '$a\TZ='Asia/Shanghai'; export TZ' /etc/profile
        sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    fi
else
    vv=`date|grep UTC`
    if [ "${vv}" != "" ] ;then
        echo "Amazon Linux TZ not modified!!!"
        date
        sudo sed -i '1s/UTC/\/usr\/share\/zoneinfo\/Asia\/Shanghai/' /etc/sysconfig/clock
        sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    else
        echo "Amazon Linux TZ modified!!!"
        date
    fi
fi
