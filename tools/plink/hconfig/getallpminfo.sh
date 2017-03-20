#Redhat4.4 CentOS4.4 up
if grep -q 'release 4' /etc/redhat-release ; then
    mySN=`dmidecode|grep -A5 'System Information'|grep 'Serial Number'|awk '{print $3}'|sed 's/^[ \t]*//g'|sed 's/[ \t]$//g'`
    myModel=`dmidecode|grep -A5 'System Information'|grep 'Product Name'|awk -F ":" '{print $2}'|grep -oP '(?<=\[)[^][]*(?=\])'`
    myType=`dmidecode|grep -A5 'System Information'|grep 'Product Name'|awk -F ":" '{print $2}'|cut -d '-' -f 1`
else
    mySN=`dmidecode -s system-serial-number|grep -v '#'`
    if echo "${mySN}" | grep -qiE "^NotSpecified|^None|^ToBeFilledByO.E.M.|O.E.M." ; then
        mySN=`dmidecode -s baseboard-serial-number`
    fi
    myModel=`dmidecode -s system-product-name|grep -v '#'|grep -oP '(?<=\[)[^][]*(?=\])'`
    if echo "${myModel}" | grep -qiE "^NotSpecified|^None|^ToBeFilledByO.E.M.|O.E.M." ; then
        myModel=`dmidecode -s baseboard-product-name`
    fi
    myType=`dmidecode -s system-product-name|grep -v '#'|cut -d '-' -f 1`
    if echo "${myType}" | grep -qiE "^NotSpecified|^None|^ToBeFilledByO.E.M.|O.E.M.|P9D" ; then
        myType=`dmidecode -s baseboard-product-name`
    fi
fi

echo "$mySN
$myModel
$myType"|awk '{printf P$0;P="|"}END{print""}'
