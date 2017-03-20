dbmon=`ps -ef|grep pmon|grep -v grep|awk '{print $8}'`
echo ${dbmon}

vv=`cat /etc/redhat-release|grep Nahant`
if [ "${vv}" != "" ] ;then
    #vv1=`dmesg|grep lpfc`
    #echo ${vv1}
    #vv2=`ls /proc/scsi/lpfc/`
    #echo ${vv2}
    #vv3=`lsmod|grep qla`
    #echo ${vv3}
    #echo "+++++++++++"
    vv4=`ls /proc/scsi/qla2xxx/`
    if [ "${vv4}" != "" ] ;then
        for i in ${vv4}
        do
           vvw=`cat /proc/scsi/qla2xxx/${i}|grep -iE "scsi-qla(0|1)-adapter-port"|awk -F "=" '{print $2}'`
echo "${vv}
${i}
${vvw}"|awk '{printf P$0;P="|"}END{print""}'
        done
    fi
else
    vv5u=`cat /etc/redhat-release|grep -v Nahant`
    v0=`ls /sys/class/fc_host/`
    if [ "${v0}" != "" ] ;then
        for i in ${v0}
        do
           vw=`cat /sys/class/fc_host/${i}/port_name|awk -F "x" '{print $2}'`
echo "${vv5u}
${i}
${vw}"|awk '{printf P$0;P="|"}END{print""}'
        done
    fi
fi
