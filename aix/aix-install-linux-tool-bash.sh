#/bin/sh

#----needs the system package preinstall below
#gcc
#gcc-c++
#libgcc
#libstdc++
#libstdc++-devel
#rpm

#linux tools for aix ftp address
#ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/

#linux rpm package 
if [ ! -f "/usr/bin/rpm" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) rpm command installing!----------"
            cd /normal/aix53lt;installp -avX $(ls|grep rpm-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) rpm command installing!----------"
            cd /normal/aix61lt;installp -avX $(ls|grep rpm-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) rpm command installing!----------"
            cd /normal/aix61lt;installp -avX $(ls|grep rpm-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) rpm command installed!----------"
fi

#linux bash package
#1.bash package install
if [ ! -f "/usr/bin/bash" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) bash command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep bash-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) bash command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep bash-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) bash command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep bash-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) bash command installed!----------"
fi

#2./etc/profile modification

cond1=$(cat /etc/profile | grep PS1)
if [ "$cond1" != "" ] ;then
    echo "PS1 installed in /etc/profile"
else
    echo "PS1='[$USER]@<$PWD>$'"        >> /etc/profile
    echo "if [ "$LOGNAME" = "root" ]"   >> /etc/profile
    echo "then"                         >> /etc/profile
    echo "    PS1='<$PWD>:[$USER]#'"    >> /etc/profile
    echo "    alias ll='ls -al'"        >> /etc/profile
    echo "fi"                           >> /etc/profile
fi

#3./etc/security/login.cfg modification

cond2=$(cat /etc/security/login.cfg | grep "/usr/bin/bash")
if [ "$cond2" != "" ] ;then
    echo "/usr/bin/bash added in shells = /bin/sh,/bin/bsh......"
    echo $cond2
else
    echo "/usr/bin/bash adding in shells = /bin/sh,/bin/bsh......"
    sed -i "s/shells = /shells = \/usr\/bin\/bash,/g" /etc/security/login.cfg
fi

#4./etc/passwd default shell modification
#super user;system user---->below system dir and passwd is * or null;regular user
cat /etc/passwd|grep -E "home|root"|awk -F: '{print $1"====>"$7}'|grep -v guest

echo "-------------ksh====>bash-----start--------------"
sru=$(cat /etc/passwd|grep -E "home|root"|awk -F: '{print $1}'|grep -v guest)
for user in $sru
do
    sed -i "/$user:/s/\/usr\/bin\/ksh/\/usr\/bin\/bash/g" /etc/passwd
done
echo "-------------ksh====>bash-----end----------------"

cat /etc/passwd|grep -E "home|root"|awk -F: '{print $1"====>"$7}'|grep -v guest
