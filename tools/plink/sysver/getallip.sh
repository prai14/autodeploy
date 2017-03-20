echo "++++++++++++++++++++"
ifconfig -a|grep -E "Link|inet"|grep -v inet6|column -t|awk '{print $1 "|" $2}'|awk 'NR>1&&!/inet/{print ""}{printf $0" "}END{print ""}'|awk -F "|" '{print $1 "||" $3}'|grep addr|sed 's/||addr:/ /g'|column -t
echo "--------------------------------------------------------------------"
