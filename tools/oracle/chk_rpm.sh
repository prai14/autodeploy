while read i
do
echo "##########"
echo $i"---->"
echo "##########"
rpm -qa |grep $i
done<chk_rpm
