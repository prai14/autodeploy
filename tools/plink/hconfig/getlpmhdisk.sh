#vgdisplay VolGroup00|grep "VG Size"|awk '{print $3}'|xargs
#vgdisplay|grep -v "open failed"|grep "VG Name"|grep -E "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"|awk '{print $3}'
vh0=`vgs|grep -E "(VolGroup00|VolGroup|sysvg|vg_host|VolGroup01|vg_bjcadevice)"`

if [ "${vh0}" != "" ] ;then
    vh1=`echo "${vh0}"|awk '{print $1}'`
    vh2=`echo "${vh0}"|awk '{print $6}'`
    vh3=`echo "${vh0}"|awk '{print $7}'`
    echo "${vh1}
${vh2}
${vh3}"|awk '{printf P$0;P="|"}END{print""}'
else
    vh4=`fdisk -l|grep "Disk /dev/sda:"`
    vh5=`echo ${vh4}|awk -F ":" '{print $1}'`
    vh6=`echo ${vh4}|awk '{print $3}'`
    echo "${vh5}
${vh6}"G"
"""|awk '{printf P$0;P="|"}END{print""}'
fi
