v0=`ls|grep txt|cut -d '.' -f 1`
#echo ${v0}
for i in ${v0}
do
    #v1=`echo ${i}|awk -F "-" '{print $1}'`
    #v2=`echo ${i}|awk -F "-" '{print $2}'`
    #v3=`echo ${i}|awk -F "-" '{print $3}'`
    v1=`echo ${i}|cut -d '-' -f 1`
    v2=`echo ${i}|cut -d '-' -f 2`
    v3=`echo ${i}|cut -d '-' -f 3`
    v4=`ls *.sh|grep ln${v1}${v2}${v3}`
    echo "v1="${v1}
    echo "v2="${v2}
    echo "v3="${v3}
    echo "i="${i}
    echo "v4="${v4}   
    if [ "${v4}" = "" ] ;then
        echo "rrrrr"
        sh 1.sh ${v1} ${v2} ${v3}
        echo "sssss"
    fi
done
