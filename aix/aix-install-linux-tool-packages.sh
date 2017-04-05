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

#linux unzip/zip/bzip2/gzip package 
if [ ! -f "/usr/bin/unzip" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) unzip command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep unzip-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) unzip command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep unzip-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) unzip command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep unzip-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) unzip command installed!----------"
fi

if [ ! -f "/usr/bin/zip" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) zip command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep zip-|grep -v unzip-|grep -v gzip-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) zip command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep zip-|grep -v unzip-|grep -v gzip-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) zip command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep zip-|grep -v unzip-|grep -v gzip-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) zip command installed!----------"
fi

if [ ! -f "/usr/bin/bzip2" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) bzip2 command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep bzip2-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) bzip2 command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep bzip2-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) bzip2 command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep bzip2-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) bzip2 command installed!----------"
fi

if [ ! -f "/usr/bin/gzip" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) gzip command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep gzip-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) gzip command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep gzip-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) gzip command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep gzip-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) gzip command installed!----------"
fi

#linux lsof package
if [ ! -f "/usr/sbin/lsof" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) lsof command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep lsof-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) lsof command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep lsof-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) lsof command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep lsof-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) lsof command installed!----------"
fi

#linux curl package
if [ ! -f "/usr/bin/curl" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) curl command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep curl-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) curl command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep curl-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) curl command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep curl-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) curl command installed!----------"
fi

#linux wget package
if [ ! -f "/usr/bin/wget" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) wget command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep wget-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) wget command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep wget-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) wget command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep wget-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) wget command installed!----------"
fi

#linux python package
if [ ! -f "/usr/bin/python" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) python command installing!----------"
            cd /normal/aix53lt/python2.6;rpm -ivh $(ls|grep gdbm)
            cd /normal/aix53lt/python2.6;rpm -ivh $(ls|grep gettext-) $(ls|grep info-) $(ls|grep libiconv-)
            cd /normal/aix53lt/python2.6;rpm -ivh $(ls|grep readline-)
            cd /normal/aix53lt/python2.6;rpm -ivh $(ls|grep python-2) $(ls|grep python-d)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) python command installing!----------"
            cd /normal/aix61lt/python2.7;rpm -ivh $(ls|grep gdbm)
            cd /normal/aix61lt/python2.7;rpm -ivh $(ls|grep gettext-) $(ls|grep info-) $(ls|grep libiconv-)
            cd /normal/aix61lt/python2.7;rpm -ivh $(ls|grep readline-)
            cd /normal/aix61lt/python2.7;rpm -ivh $(ls|grep python-2) $(ls|grep python-d)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) python command installing!----------"
            cd /normal/aix61lt/python2.7;rpm -ivh $(ls|grep gdbm)
            cd /normal/aix61lt/python2.7;rpm -ivh $(ls|grep gettext-) $(ls|grep info-) $(ls|grep libiconv-)
            cd /normal/aix61lt/python2.7;rpm -ivh $(ls|grep readline-)
            cd /normal/aix61lt/python2.7;rpm -ivh $(ls|grep python-2) $(ls|grep python-d)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) python command installed!----------"
fi

#linux sed package
if [ ! -f "/usr/bin/sed" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) sed command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep sed-)
            mv /usr/bin/sed /usr/bin/sedbak
            ln -sf /opt/freeware/bin/sed /usr/bin/sed
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) sed command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep sed-)
            mv /usr/bin/sed /usr/bin/sedbak
            ln -sf /opt/freeware/bin/sed /usr/bin/sed
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) sed command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep sed-)
            mv /usr/bin/sed /usr/bin/sedbak
            ln -sf /opt/freeware/bin/sed /usr/bin/sed
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) sed command installed!----------"
fi


#linux expect package
if [ ! -f "/usr/bin/expect" ] ;then
    av0=$(oslevel -r|awk -F- '{print $1}')
    case $av0 in 
        5300)
            echo "-----------AIX$(oslevel -r) expect command installing!----------"
            cd /normal/aix53lt;rpm -ivh $(ls|grep tcl-)
            cd /normal/aix53lt;rpm -ivh $(ls|grep tk-)
            cd /normal/aix53lt;rpm -ivh $(ls|grep expect-)
            ;;
        6100)
            echo "-----------AIX$(oslevel -r) expect command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep tcl-)
            cd /normal/aix61lt;rpm -ivh $(ls|grep tk-)
            cd /normal/aix61lt;rpm -ivh $(ls|grep expect-)
            ;;
        7100)
            echo "-----------AIX$(oslevel -r) expect command installing!----------"
            cd /normal/aix61lt;rpm -ivh $(ls|grep tcl-)
            cd /normal/aix61lt;rpm -ivh $(ls|grep tk-)
            cd /normal/aix61lt;rpm -ivh $(ls|grep expect-)
            ;;
    esac
else
    echo "-----------AIX$(oslevel -r) expect command installed!----------"
fi

#nmon

#linux yum package

#linux rubby package
