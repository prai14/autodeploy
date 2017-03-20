########################################################################################################################
####delete temp file
rm -rf aixhdsfile
rm -rf aixhdsfile10.2.0
rm -rf aixhdsfile11.2.0
rm -rf aixhpfile
rm -rf aixhpfile10.2.0
rm -rf aixhpfile11.2.0
rm -rf aixemcfile
rm -rf aixemcfile10.2.0
rm -rf aixemcfile11.2.0

####storage type
stype=`ls /usr/DynamicLinkManager/bin/dlmmgr;ls /usr/lpp/3PARmpio/bin/3par_enfail.sh;ls /usr/sbin/powermt`
stypehds=`echo ${stype}|grep -iE "dlmmgr"`
stypehp=`echo ${stype}|grep -iE "3par_enfail.sh"`
stypeemc=`echo ${stype}|grep -iE "powermt"`

####HDS VSP/USP V&M/VSP G1000
if [ "${stypehds}" != "" ] ;then
    shdsdisk=`lsdev -Ccdisk|grep -i "Hitachi Disk Array"|awk '{print $1}'`             
    echo "-------------------"
    echo "map disks in system"
    echo "-------------------"
    for i in ${shdsdisk}
    do
        disksize=`getconf DISK_SIZE /dev/$i`
        echo "${i}
        ${disksize}"MB""|awk '{printf P$0;P="|"}END{print""}'|xargs
    done
    for i in ${shdsdisk}
    do
        disksize=`getconf DISK_SIZE /dev/$i`
        echo ${disksize}
    done | awk '{sum += $1};END {print sum}' >>aixhdsfile
    stotal0=`cat aixhdsfile`
    stotal=`echo "scale=0;${stotal0}/1024"|bc`

    ####host hba
    shbafcs=`lsdev -Ccadapter|grep fcs|awk '{print $1}'`
    echo "-------------------"
    echo "system all hba"
    echo "-------------------"
    for i in ${shbafcs}
    do
        shban=`lscfg -vpl ${i}|grep -i network |awk '{print $2}'|cut -c 21-36`
        shbal=`lscfg -vpl ${i}|grep -i "Hardware Location Code"|awk '{print $3}'|cut -c 21-36`
        echo "${i}
        ${shban}
        ${shbal}"|sed '2,$s/^/|/g'|xargs
    done

    ####storage used hba
    v0=`cd /usr/DynamicLinkManager/bin;./dlnkmgr view -hba|grep -vE "(HbaID|KAPL)"|awk '{print $2}'`
    echo "-------------------"
    echo "storage used hba"
    echo "-------------------"
    for i in ${v0}
    do
        v1=`echo ${i}|awk -F"." '{print $1}'`
        v2=`echo ${i}|awk -F"." '{print $2}'`
        v3=`echo "${v2}"-"${v1}"`
        v4=`lsdev -Ccadapter|grep fcs|grep "${v3}"|awk '{print $1"|"$3"|"$4}`
        echo ${v4}
    done

    ####storage used cha
    echo "-----------------------"
    echo "storage used ChaPort"
    echo "-----------------------"
    scha=`cd /usr/DynamicLinkManager/bin;./dlnkmgr view -cha|grep -vE "(ChaID|KAPL)"|awk '{print $2"|"$3"|"$4}'`
    echo "${scha}"

    ####basic total
    echo "------------------------------"
    echo "map;app configured;app free"
    echo "------------------------------"
    shdstype=`cd /usr/DynamicLinkManager/bin;./dlnkmgr view -lu|grep "Product"|awk -F":" '{print $2}'|xargs`
    shdssn=`cd /usr/DynamicLinkManager/bin;./dlnkmgr view -lu|grep "SerialNumber"|awk -F":" '{print $2}'|xargs`
    ####Oracle version
    dbver=`su - oracle -c "sqlplus -H|grep "Release""|awk '{print $3}'|grep "10.2.0"`
    dbasm=`ps -ef|grep pmon|grep -v grep|awk '{print $9}'|grep asm`
    dbasm0=`echo ${dbasm}|awk -F"_" '{print $3}'`
    if [ "${dbver}" != "" ] ;then
        ####Release 10.2.0
        if [ "${dbasm}" != "" ] ;then
            ####hdisk asm administration
            storused0=`su - oracle -c "export ORACLE_SID=${dbasm0};asmcmd -p lsdg"|grep -i mounted|awk '{print $8}'`
            storused=`echo ${storused0}|awk '{sum += $1};END {print sum}'`
            storfree0=`su - oracle -c "export ORACLE_SID=${dbasm0};asmcmd -p lsdg"|grep -i mounted|awk '{print $9}'`
            storfree=`echo ${storfree0}|awk '{sum += $1};END {print sum}'`
            storused1=`echo "scale=0;${storused}/1024"|bc`
            storfree1=`echo "scale=0;${storfree}/1024"|bc`
            echo ""HDS "${shdstype}
            ${shdssn}
            "Release "${dbver}
            "oracle asm administration"
            ${stotal}"G"
            ${storused1}"G"
            ${storfree1}"G""|sed '2,$s/^/|/g'|xargs
        else
            ####hdisk file administration
            storused0=`lsvg -o|grep -vE "(rootvg)"`
            ####dbtotal capacity
            for i in ${storused0}
            do  
                stotal1=`lsvg ${i}|grep -iE "(TOTAL PPs)"|awk -F":" '{print $3}'|awk '{print $2}'|awk -F"(" '{print $2}'`
                sfree1=`lsvg ${i}|grep -iE "(FREE PPs)"|awk -F":" '{print $3}'|awk '{print $2}'|awk -F"(" '{print $2}'`
                echo "${stotal1} ${sfree1}"
            done  >> aixhdsfile10.2.0
            stotal2=`cat aixhdsfile10.2.0|awk '{print $1}'|awk '{sum += $1};END {print sum}'`
            sfree2=`cat aixhdsfile10.2.0|awk '{print $2}'|awk '{sum += $1};END {print sum}'`
            dbtc=`echo "scale=0;${stotal2}/1024"|bc`
            dbfc=`echo "scale=0;${sfree2}/1024"|bc`
            echo ""HDS "${shdstype}
            ${shdssn}
            "Release "${dbver}
            "file system administration"
            ${stotal}"G"
            ${dbtc}"G"
            ${dbfc}"G""|sed '2,$s/^/|/g'|xargs
        fi
    else
        ####Release 11.2.0
        dbver=`su - oracle -c "sqlplus -H|grep "Release""|awk '{print $3}'|grep "11.2.0"`
        dbasm=`ps -ef|grep pmon|grep -v grep|awk '{print $9}'|grep asm`
        if [ "${dbasm}" != "" ] ;then
            ####hdisk asm administration
            storused=`su - grid -c "asmcmd -p lsdg"|grep -i mounted|awk '{print $7}'|awk '{sum += $1};END {print sum}'`
            storfree=`su - grid -c "asmcmd -p lsdg"|grep -i mounted|awk '{print $8}'|awk '{sum += $1};END {print sum}'`
            storused1=`echo "scale=0;${storused}/1024"|bc`
            storfree1=`echo "scale=0;${storfree}/1024"|bc`
            echo ""HDS "${shdstype}
            ${shdssn}
            "Release "${dbver}
            "oracle asm administration"
            ${stotal}"G"
            ${storused1}"G"
            ${storfree1}"G""|sed '2,$s/^/|/g'|xargs
        else
            ####hdisk file administration
            storused0=`lsvg -o|grep -vE "(rootvg)"`
            ####dbtotal capacity
            for i in ${storused0}
            do  
                stotal1=`lsvg ${i}|grep -iE "(TOTAL PPs)"|awk -F":" '{print $3}'|awk '{print $2}'|awk -F"(" '{print $2}'`
                sfree1=`lsvg ${i}|grep -iE "(FREE PPs)"|awk -F":" '{print $3}'|awk '{print $2}'|awk -F"(" '{print $2}'`
                echo "${stotal1} ${sfree1}"
            done  >> aixhdsfile11.2.0
            stotal2=`cat aixhdsfile11.2.0|awk '{print $1}'|awk '{sum += $1};END {print sum}'`
            sfree2=`cat aixhdsfile11.2.0|awk '{print $2}'|awk '{sum += $1};END {print sum}'`
            dbtc=`echo "scale=0;${stotal2}/1024"|bc`
            dbfc=`echo "scale=0;${sfree2}/1024"|bc`
            echo ""HDS "${shdstype}
            ${shdssn}
            "Release "${dbver}
            "file system administration"
            ${stotal}"G"
            ${dbtc}"G"
            ${dbfc}"G""|sed '2,$s/^/|/g'|xargs
        fi
    fi
fi

####HP 3PAR######################################################################################################## 
if [ "${stypehp}" != "" ] ;then
    shpdisk=`lsdev -Ccdisk|grep -i "3PAR InServ Virtual Volume"|awk '{print $1}'`             
    echo "-------------------"
    echo "map disks in system"
    echo "-------------------"
    for i in ${shpdisk}
    do
        disksize=`getconf DISK_SIZE /dev/$i`
        echo "${i}
        ${disksize}"MB""|awk '{printf P$0;P="|"}END{print""}'|xargs
    done
    for i in ${shpdisk}
    do
        disksize=`getconf DISK_SIZE /dev/$i`
        echo ${disksize}
    done | awk '{sum += $1};END {print sum}' >>aixhpfile
    stotal0=`cat aixhpfile`
    stotal=`echo "scale=0;${stotal0}/1024"|bc`

    ####host hba
    shbafcs=`lsdev -Ccadapter|grep fcs|awk '{print $1}'`
    echo "-------------------"
    echo "system all hba"
    echo "-------------------"
    for i in ${shbafcs}
    do
        shban=`lscfg -vpl ${i}|grep -i network |awk '{print $2}'|cut -c 21-36`
        shbal=`lscfg -vpl ${i}|grep -i "Hardware Location Code"|awk '{print $3}'|cut -c 21-36`
        echo "${i}
        ${shban}
        ${shbal}"|sed '2,$s/^/|/g'|xargs
    done

    ####storage used hba
    rm -rf 3partmpfile
    v0=`lsdev -Ccdisk|awk '/3PAR InServ Virtual Volume/{print $1}'`
    echo "-------------------"
    echo "storage used hba"
    echo "-------------------"
    for i in ${v0}
    do
        v1=`lspath -l ${i}|awk '{print $3}'|uniq|xargs`
        echo ${v1}
    done > 3partmpfile
    v2=`cat 3partmpfile|uniq`
    for i in ${v2}
    do
        vv3=`echo ${i}|cut -c 6`
        v3=`echo "fcs"${vv3}`
        vhba=`lsdev -Ccadapter|grep fcs|grep "${v3}"|awk '{print $1"|"$3"|"$4}`
        echo ${vhba}
    done

    ####storage used cha
    echo "-----------------------"
    echo "storage used ChaPort"
    echo "-----------------------"
    #scha=`cd /usr/DynamicLinkManager/bin;./dlnkmgr view -cha|grep -vE "(ChaID|KAPL)"|awk '{print $2"|"$3"|"$4}'`
    #echo "${scha}"

    ####basic total
    echo "------------------------------"
    echo "map;app configured;app free"
    echo "------------------------------"
    shptype=`lsdev -Ccdisk|awk '/3PAR InServ Virtual Volume/{print $4}'|uniq`
    shpsn=``
    ####Oracle version
    dbver=`su - oracle -c "sqlplus -H|grep "Release""|awk '{print $3}'|grep "10.2.0"`
    dbasm=`ps -ef|grep pmon|grep -v grep|awk '{print $9}'|grep asm`
    dbasm0=`echo ${dbasm}|awk -F"_" '{print $3}'`
    if [ "${dbver}" != "" ] ;then
        ####Release 10.2.0
        if [ "${dbasm}" != "" ] ;then
            ####hdisk asm administration
            storused0=`su - oracle -c "export ORACLE_SID=${dbasm0};asmcmd -p lsdg"|grep -i mounted|awk '{print $8}'`
            storused=`echo ${storused0}|awk '{sum += $1};END {print sum}'`
            storfree0=`su - oracle -c "export ORACLE_SID=${dbasm0};asmcmd -p lsdg"|grep -i mounted|awk '{print $9}'`
            storfree=`echo ${storfree0}|awk '{sum += $1};END {print sum}'`
            storused1=`echo "scale=0;${storused}/1024"|bc`
            storfree1=`echo "scale=0;${storfree}/1024"|bc`
            echo ""HP "${shptype}
            ${shpsn}
            "Release "${dbver}
            "oracle asm administration"
            ${stotal}"G"
            ${storused1}"G"
            ${storfree1}"G""|sed '2,$s/^/|/g'|xargs
        else
            ####hdisk file administration
            storused0=`lsvg -o|grep -vE "(rootvg)"`
            ####dbtotal capacity
            for i in ${storused0}
            do  
                stotal1=`lsvg ${i}|grep -iE "(TOTAL PPs)"|awk -F":" '{print $3}'|awk '{print $2}'|awk -F"(" '{print $2}'`
                sfree1=`lsvg ${i}|grep -iE "(FREE PPs)"|awk -F":" '{print $3}'|awk '{print $2}'|awk -F"(" '{print $2}'`
                echo "${stotal1} ${sfree1}"
            done  >> aixhdsfile10.2.0
            stotal2=`cat aixhdsfile10.2.0|awk '{print $1}'|awk '{sum += $1};END {print sum}'`
            sfree2=`cat aixhdsfile10.2.0|awk '{print $2}'|awk '{sum += $1};END {print sum}'`
            dbtc=`echo "scale=0;${stotal2}/1024"|bc`
            dbfc=`echo "scale=0;${sfree2}/1024"|bc`
            echo ""HP "${shptype}
            ${shpsn}
            "Release "${dbver}
            "file system administration"
            ${stotal}"G"
            ${dbtc}"G"
            ${dbfc}"G""|sed '2,$s/^/|/g'|xargs
        fi
    else
        ####Release 11.2.0
        dbver=`su - oracle -c "sqlplus -H|grep "Release""|awk '{print $3}'|grep "11.2.0"`
        dbasm=`ps -ef|grep pmon|grep -v grep|awk '{print $9}'|grep asm`
        if [ "${dbasm}" != "" ] ;then
            ####hdisk asm administration
            storused=`su - grid -c "asmcmd -p lsdg"|grep -i mounted|awk '{print $7}'|awk '{sum += $1};END {print sum}'`
            storfree=`su - grid -c "asmcmd -p lsdg"|grep -i mounted|awk '{print $8}'|awk '{sum += $1};END {print sum}'`
            storused1=`echo "scale=0;${storused}/1024"|bc`
            storfree1=`echo "scale=0;${storfree}/1024"|bc`
            echo ""HP "${shptype}
            ${shpsn}
            "Release "${dbver}
            "oracle asm administration"
            ${stotal}"G"
            ${storused1}"G"
            ${storfree1}"G""|sed '2,$s/^/|/g'|xargs
        else
            ####hdisk file administration
            storused0=`lsvg -o|grep -vE "(rootvg)"`
            ####dbtotal capacity
            for i in ${storused0}
            do  
                stotal1=`lsvg ${i}|grep -iE "(TOTAL PPs)"|awk -F":" '{print $3}'|awk '{print $2}'|awk -F"(" '{print $2}'`
                sfree1=`lsvg ${i}|grep -iE "(FREE PPs)"|awk -F":" '{print $3}'|awk '{print $2}'|awk -F"(" '{print $2}'`
                echo "${stotal1} ${sfree1}"
            done  >> aixhdsfile11.2.0
            stotal2=`cat aixhdsfile11.2.0|awk '{print $1}'|awk '{sum += $1};END {print sum}'`
            sfree2=`cat aixhdsfile11.2.0|awk '{print $2}'|awk '{sum += $1};END {print sum}'`
            dbtc=`echo "scale=0;${stotal2}/1024"|bc`
            dbfc=`echo "scale=0;${sfree2}/1024"|bc`
            echo ""HP "${shptype}
            ${shpsn}
            "Release "${dbver}
            "file system administration"
            ${stotal}"G"
            ${dbtc}"G"
            ${dbfc}"G""|sed '2,$s/^/|/g'|xargs
        fi
    fi
fi

####EMC VMAX 10K 
if [ "${stypeemc}" != "" ] ;then
    semcdisk=`lsdev -Ccdisk|grep -i "PowerPath Device"|awk '{print $1}'`             
    for i in ${semcdisk}
    do
        disksize=`getconf DISK_SIZE /dev/$i`
echo "${i}
${disksize}"MB""|awk '{printf P$0;P="|"}END{print""}'
    done
fi
#######################################################################################################################
