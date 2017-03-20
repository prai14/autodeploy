####internetds 
USER0="cbs-cloud"

IP=`/sbin/ifconfig eth0|grep "inet addr"|awk -F":" '{print $2}'|awk '{print $1}'`
ymd=`date +"%Y%m%d"`

expect /home/ec2-user/scpfiledown.sh $USER0 $IP $ymd
