v0=$(df -hP|column -t|grep -v Filesystem|awk '{print $5}'|awk -F'%' '{print $1}')
if [ "${v0}" -gt "80" ]; then
    v1=$(df -hP|column -t|grep -v Filesystem|awk '{print $1"|"$5"|"$6}')
    echo ${v1}
fi
