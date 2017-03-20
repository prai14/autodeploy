####delete temp file
rm -rf filenhds10.2.0
rm -rf filenhds11.2.0
rm -rf filehds10.2.0
rm -rf filehds11.2.0
rm -rf filehds
####storage multipath
#sm=`ps -ef|grep -iE "(dlmmgr|multipathd)"|grep -v grep|awk '{print $8}'`  ####redhat sm(dlmmgr/HDS|multipathd/nonHDS)
sm=`ps -ef|grep -iE "dlmmgr"|grep -v grep |awk '{print $8}'`
if [ "${sm}" != "" ] ;then
    ####HDS storage
    storh1=`cd /opt/DynamicLinkManager/bin;./dlnkmgr view -lu|grep Product|awk -F":" '{print $2}'|xargs`
    storh2=`cd /opt/DynamicLinkManager/bin;./dlnkmgr view -lu|grep SerialNumber|awk -F":" '{print $2}'|xargs`
    storh3=`cd /opt/DynamicLinkManager/bin;./dlnkmgr view -lu|grep sddlm|awk '{print $2}'`
    for i in ${storh3}
    do
        storh4=`fdisk -l|grep "Disk /dev/${i}:"|awk -F"," '{print $1}'|awk '{print $3$4}'`
echo "${i}
${storh4}"|awk '{printf P$0;P="|"}END{print""}'
    done
    storh5=`fdisk -l|grep -iE "Disk /dev/sddlm"|awk -F"," '{print $1}'|awk '{print $3$4}'`
    for i in ${storh5}
    do
        vaa=`echo ${i: -2}`
        sum=`echo ${i}|awk -F"${vaa}" '{print $1}'`
        case "${vaa}" in 
            TB)
            vaaT=`echo "scale=0;${sum}*1024"|bc`
            vaatl=`echo ${vaaT}`
            ;;
            GB)
            vaaG=`echo "scale=0;${sum}"|bc`
            vaatl=`echo ${vaaG}`
            ;;
            MB)
            vaaM=`echo "scale=2;${sum}/1024"|bc`
            vaaM1=`echo "0"${vaaM}`
            vaatl=`echo ${vaaM1}`
            ;;
        esac
        echo ${vaatl}
    done | awk '{sum += $1};END {print sum}' >>filehds
    storh6=`cat filehds`
    ####Oracle version
    dbver=`su - oracle -c "sqlplus -H|grep "Release""|awk '{print $3}'|grep "10.2.0"`
    dbasm=`ps -ef|grep pmon|grep -v grep|awk '{print $8}'|grep asm`
    if [ "${dbver}" != "" ] ;then
        ####Release 10.2.0
        if [ "${dbasm}" != "" ] ;then
            ####hdisk asm administration
            storused=`su - oracle -c "export ORACLE_SID=+ASM1;asmcmd -p lsdg"|grep -i mounted|awk '{print $8}'|awk '{sum += $1};END {print sum}'`
            storfree=`su - oracle -c "export ORACLE_SID=+ASM1;asmcmd -p lsdg"|grep -i mounted|awk '{print $9}'|awk '{sum += $1};END {print sum}'`
            storused1=`echo "scale=0;${storused}/1024"|bc`
            storfree1=`echo "scale=0;${storfree}/1024"|bc`
echo ""HDS "${storh1}
${storh2}
"Release "${dbver}
"oracle asm administration"
${storh6}"G"
${storused1}"G"
${storfree1}"G""|awk '{printf P$0;P="|"}END{print""}'
        else
            ####hdisk file administration
            storused0=`vgs|grep -vE "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"|grep -v Attr|awk '{print $6}'`
            storused1=`vgs|grep -vE "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"|grep -v Attr|awk '{print $7}'`
            ####dbtotal capacity
            for i in ${storused0}
            do
                vaa=`echo ${i: -1}`
                sum=`echo ${i}|awk -F"${vaa}" '{print $1}'`
                case "${vaa}" in 
                    T)
                    vaaT=`echo "scale=0;${sum}*1024"|bc`
                    vaatl=`echo ${vaaT}`
                    ;;
                    G)
                    vaaG=`echo "scale=0;${sum}"|bc`
                    vaatl=`echo ${vaaG}`
                    ;;
                    M)
                    vaaM=`echo "scale=2;${sum}/1024"|bc`
                    vaaM1=`echo "0"${vaaM}`
                    vaatl=`echo ${vaaM1}`
                    ;;
                esac
                echo ${vaatl}
            done | awk '{sum += $1};END {print sum}' >>filehds10.2.0
            ####free capacity
            for i in ${storused1}
            do
                vaa=`echo ${i: -1}`
                sum=`echo ${i}|awk -F"${vaa}" '{print $1}'`
                case "${vaa}" in 
                    T)
                    vaaT=`echo "scale=0;${sum}*1024"|bc`
                    vaatl=`echo ${vaaT}`
                    ;;
                    G)
                    vaaG=`echo "scale=0;${sum}"|bc`
                    vaatl=`echo ${vaaG}`
                    ;;
                    M)
                    vaaM=`echo "scale=2;${sum}/1024"|bc`
                    vaaM1=`echo "0"${vaaM}`
                    vaatl=`echo ${vaaM1}`
                    ;;
                esac
                echo ${vaatl}
            done | awk '{sum += $1};END {print sum}' >>filehds10.2.0
            dbtc=`cat filehds10.2.0|xargs|awk '{print $1}'`
            dbfc=`cat filehds10.2.0|xargs|awk '{print $2}'`
echo ""HDS "${storh1}
${storh2}
"Release "${dbver}
"file system administration"
${storh6}"G"
${dbtc}"G"
${dbfc}"G""|awk '{printf P$0;P="|"}END{print""}'
        fi
    else
        ####Release 11.2.0
        dbver=`su - oracle -c "sqlplus -H|grep "Release""|awk '{print $3}'|grep "11.2.0"`
        dbasm=`ps -ef|grep pmon|grep -v grep|awk '{print $8}'|grep asm`
        if [ "${dbasm}" != "" ] ;then
            ####hdisk asm administration
            storused=`su - grid -c "asmcmd -p lsdg"|grep -i mounted|awk '{print $7}'|awk '{sum += $1};END {print sum}'`
            storfree=`su - grid -c "asmcmd -p lsdg"|grep -i mounted|awk '{print $8}'|awk '{sum += $1};END {print sum}'`
            storused1=`echo "scale=0;${storused}/1024"|bc`
            storfree1=`echo "scale=0;${storfree}/1024"|bc`
echo ""HDS "${storh1}
${storh2}
"Release "${dbver}
"oracle asm administration"
${storh6}"G"
${storused1}"G"
${storfree1}"G""|awk '{printf P$0;P="|"}END{print""}'
        else
            ####hdisk file administration
            storused0=`vgs|grep -vE "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"|grep -v Attr|awk '{print $6}'`
            storused1=`vgs|grep -vE "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"|grep -v Attr|awk '{print $7}'`
            ####dbtotal capacity
            for i in ${storused0}
            do
                vaa=`echo ${i: -1}`
                sum=`echo ${i}|awk -F"${vaa}" '{print $1}'`
                case "${vaa}" in 
                    T)
                    vaaT=`echo "scale=0;${sum}*1024"|bc`
                    vaatl=`echo ${vaaT}`
                    ;;
                    G)
                    vaaG=`echo "scale=0;${sum}"|bc`
                    vaatl=`echo ${vaaG}`
                    ;;
                    M)
                    vaaM=`echo "scale=2;${sum}/1024"|bc`
                    vaaM1=`echo "0"${vaaM}`
                    vaatl=`echo ${vaaM1}`
                    ;;
                esac
                echo ${vaatl}
            done | awk '{sum += $1};END {print sum}' >>filehds11.2.0
            ####free capacity
            for i in ${storused1}
            do
                vaa=`echo ${i: -1}`
                sum=`echo ${i}|awk -F"${vaa}" '{print $1}'`
                case "${vaa}" in 
                    T)
                    vaaT=`echo "scale=0;${sum}*1024"|bc`
                    vaatl=`echo ${vaaT}`
                    ;;
                    G)
                    vaaG=`echo "scale=0;${sum}"|bc`
                    vaatl=`echo ${vaaG}`
                    ;;
                    M)
                    vaaM=`echo "scale=2;${sum}/1024"|bc`
                    vaaM1=`echo "0"${vaaM}`
                    vaatl=`echo ${vaaM1}`
                    ;;
                esac
                echo ${vaatl}
            done | awk '{sum += $1};END {print sum}' >>filehds11.2.0
            dbtc=`cat filehds11.2.0|xargs|awk '{print $1}'`
            dbfc=`cat filehds11.2.0|xargs|awk '{print $2}'`
echo ""HDS "${storh1}
${storh2}
"Release "${dbver}
"file system administration"
${storh6}"G"
${dbtc}"G"
${dbfc}"G""|awk '{printf P$0;P="|"}END{print""}'
        fi
    fi
else
######################################################################################################################
    ####non HDS storage
    stor1=`multipath -ll|grep -iE "(asm|mpath)"|awk '{print $1}'`
    stor2=`multipath -ll|grep -iE "(asm|mpath)"|awk '{print $4}'|awk -F "," '{print $1}'|uniq`
    for i in ${stor1}
    do
        stor3=`multipath -ll ${i}|grep -i "Size="|awk -F "=" '{print $2}'|awk -F "G" '{print $1}'`
echo "${i}
${stor3}"G""|awk '{printf P$0;P="|"}END{print""}'
    done
    st4=`multipath -ll|grep -i "size="|awk -F"=" '{print $2}'|awk -F "G" '{print $1}'|awk '{sum += $1};END {print sum}'`
    ####Oracle version
    dbver=`su - oracle -c "sqlplus -H|grep "Release""|awk '{print $3}'|grep "10.2.0"`
    dbasm=`ps -ef|grep pmon|grep -v grep|awk '{print $8}'|grep asm`
    if [ "${dbver}" != "" ] ;then
        ####Release 10.2.0
        if [ "${dbasm}" != "" ] ;then
            ####hdisk asm administration
            storused=`su - oracle -c "export ORACLE_SID=+ASM1;asmcmd -p lsdg"|grep -i mounted|awk '{print $8}'|awk '{sum += $1};END {print sum}'`
            storfree=`su - oracle -c "export ORACLE_SID=+ASM1;asmcmd -p lsdg"|grep -i mounted|awk '{print $9}'|awk '{sum += $1};END {print sum}'`
            storused1=`echo "scale=0;${storused}/1024"|bc`
            storfree1=`echo "scale=0;${storfree}/1024"|bc`
echo "${stor2}
"Release "${dbver}
"oracle asm administration"
${st4}"G"
${storused1}"G"
${storfree1}"G""|awk '{printf P$0;P="|"}END{print""}'
        else
            ####hdisk file administration
            storused0=`vgs|grep -vE "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"|grep -v Attr|awk '{print $6}'`
            storused1=`vgs|grep -vE "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"|grep -v Attr|awk '{print $7}'`
            ####dbtotal capacity
            for i in ${storused0}
            do
                vaa=`echo ${i: -1}`
                sum=`echo ${i}|awk -F"${vaa}" '{print $1}'`
                case "${vaa}" in 
                    T)
                    vaaT=`echo "scale=0;${sum}*1024"|bc`
                    vaatl=`echo ${vaaT}`
                    ;;
                    G)
                    vaaG=`echo "scale=0;${sum}"|bc`
                    vaatl=`echo ${vaaG}`
                    ;;
                    M)
                    vaaM=`echo "scale=2;${sum}/1024"|bc`
                    vaaM1=`echo "0"${vaaM}`
                    vaatl=`echo ${vaaM1}`
                    ;;
                esac
                echo ${vaatl}
            done | awk '{sum += $1};END {print sum}' >>filenhds10.2.0
            ####free capacity
            for i in ${storused1}
            do
                vaa=`echo ${i: -1}`
                sum=`echo ${i}|awk -F"${vaa}" '{print $1}'`
                case "${vaa}" in 
                    T)
                    vaaT=`echo "scale=0;${sum}*1024"|bc`
                    vaatl=`echo ${vaaT}`
                    ;;
                    G)
                    vaaG=`echo "scale=0;${sum}"|bc`
                    vaatl=`echo ${vaaG}`
                    ;;
                    M)
                    vaaM=`echo "scale=2;${sum}/1024"|bc`
                    vaaM1=`echo "0"${vaaM}`
                    vaatl=`echo ${vaaM1}`
                    ;;
                esac
                echo ${vaatl}
            done | awk '{sum += $1};END {print sum}' >>filenhds10.2.0
            dbtc=`cat filenhds10.2.0|xargs|awk '{print $1}'`
            dbfc=`cat filenhds10.2.0|xargs|awk '{print $2}'`
echo "${stor2}
"Release "${dbver}
"file system administration"
${st4}"G"
${dbtc}"G"
${dbfc}"G""|awk '{printf P$0;P="|"}END{print""}'
        fi
    else
        ####Release 11.2.0
        dbver=`su - oracle -c "sqlplus -H|grep "Release""|awk '{print $3}'|grep "11.2.0"`
        dbasm=`ps -ef|grep pmon|grep -v grep|awk '{print $8}'|grep asm`
        if [ "${dbasm}" != "" ] ;then
            ####hdisk asm administration
            storused=`su - grid -c "asmcmd -p lsdg"|grep -i mounted|awk '{print $7}'|awk '{sum += $1};END {print sum}'`
            storfree=`su - grid -c "asmcmd -p lsdg"|grep -i mounted|awk '{print $8}'|awk '{sum += $1};END {print sum}'`
            storused1=`echo "scale=0;${storused}/1024"|bc`
            storfree1=`echo "scale=0;${storfree}/1024"|bc`
echo "${stor2}
"Release "${dbver}
"oracle asm administration"
${st4}"G"
${storused1}"G"
${storfree1}"G""|awk '{printf P$0;P="|"}END{print""}'
        else
            ####hdisk file administration
            storused0=`vgs|grep -vE "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"|grep -v Attr|awk '{print $6}'`
            storused1=`vgs|grep -vE "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"|grep -v Attr|awk '{print $7}'`
            ####dbtotal capacity
            for i in ${storused0}
            do
                vaa=`echo ${i: -1}`
                sum=`echo ${i}|awk -F"${vaa}" '{print $1}'`
                case "${vaa}" in 
                    T)
                    vaaT=`echo "scale=0;${sum}*1024"|bc`
                    vaatl=`echo ${vaaT}`
                    ;;
                    G)
                    vaaG=`echo "scale=0;${sum}"|bc`
                    vaatl=`echo ${vaaG}`
                    ;;
                    M)
                    vaaM=`echo "scale=2;${sum}/1024"|bc`
                    vaaM1=`echo "0"${vaaM}`
                    vaatl=`echo ${vaaM1}`
                    ;;
                esac
                echo ${vaatl}
            done | awk '{sum += $1};END {print sum}' >>filenhds11.2.0
            ####free capacity
            for i in ${storused1}
            do
                vaa=`echo ${i: -1}`
                sum=`echo ${i}|awk -F"${vaa}" '{print $1}'`
                case "${vaa}" in 
                    T)
                    vaaT=`echo "scale=0;${sum}*1024"|bc`
                    vaatl=`echo ${vaaT}`
                    ;;
                    G)
                    vaaG=`echo "scale=0;${sum}"|bc`
                    vaatl=`echo ${vaaG}`
                    ;;
                    M)
                    vaaM=`echo "scale=2;${sum}/1024"|bc`
                    vaaM1=`echo "0"${vaaM}`
                    vaatl=`echo ${vaaM1}`
                    ;;
                esac
                echo ${vaatl}
            done | awk '{sum += $1};END {print sum}' >>filenhds11.2.0
            dbtc=`cat filenhds11.2.0|xargs|awk '{print $1}'`
            dbfc=`cat filenhds11.2.0|xargs|awk '{print $2}'`
echo "${stor2}
"Release "${dbver}
"file system administration"
${st4}"G"
${dbtc}"G"
${dbfc}"G""|awk '{printf P$0;P="|"}END{print""}'
        fi
    fi
fi
