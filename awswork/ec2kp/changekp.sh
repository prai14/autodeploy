ymd=`date +"%Y%m%d"`
IP=`/sbin/ifconfig eth0|grep "inet addr"|awk -F":" '{print $2}'|awk '{print $1}'`

cp -r -p /home/ec2-user/.ssh /home/ec2-user/ssh$ymd

ssh-keygen -f ec2-user-10.219.8.6-$ymd.pem -y > /home/ec2-user/.ssh/authorized_keys
