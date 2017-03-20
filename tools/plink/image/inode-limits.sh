dir=`df -iP|column -t|grep -v Filesystem|grep NewSunYardFilePth|awk '{print $5}'|cut -d '%' -f 1`

if [ $dir -gt 50 ]; then

    echo "Error"

fi
