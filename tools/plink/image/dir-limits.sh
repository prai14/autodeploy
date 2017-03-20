dir=`df -hP|column -t|grep -v Filesystem|grep NewSunYardFilePth|awk '{print $5}'|cut -d '%' -f 1`

if [ $dir -gt 75 ]; then

    echo "Error"

fi
