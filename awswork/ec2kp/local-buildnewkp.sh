IP=`ifconfig eth0|grep inet|grep -v inet6|awk '{print $2}'`
ymd=`date +"%Y%m%d"`
username="ec2-user"
dir="/app/login/"

rm -rf $username-$IP-$ymd.pem
aws ec2 delete-key-pair --key-name $dir$username-$IP-$ymd.pem

aws ec2 create-key-pair --key-name $dir$username-$IP-$ymd.pem --output text --query 'KeyMaterial' > $dir$username-$IP-$ymd.pem
chmod 600 $dir$username-$IP-$ymd.pem

#ssh-keygen -f <new.pem>  -y|ssh -y -i <old.pem> ec2-user@<ip address> "cat > .ssh/authorized_keys"
