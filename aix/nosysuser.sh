#for i in $(awk -F: '{print $1}' /etc/passwd|sed "s/$/:/g")
#do
#    cat /etc/passwd|grep "$i"|awk -F: '{print $1"====>"$6"====>"$7}'|grep -E "home|root"|grep -v guest
#    cat /etc/security/passwd|sed -n "/$i/{n;p}"|grep -v "\*"
#done
cat /normal/passwd.txt|grep -E "home|root"|awk -F: '{print $1"====>"$7}'|grep -v guest

echo "------------------------------ksh====>bash--------start---------------------------------"
sru=$(cat /normal/passwd.txt|grep -E "home|root"|awk -F: '{print $1}'|grep -v guest)
for user in $sru
do
    sed -i "/$user:/s/\/usr\/bin\/ksh/\/usr\/bin\/bash/g" /normal/passwd.txt
done
echo "------------------------------ksh====>bash--------end-----------------------------------"

cat /normal/passwd.txt|grep -E "home|root"|awk -F: '{print $1"====>"$7}'|grep -v guest
