USER0="root"

file="/etc/redhat-release"
if [ -f "${file}" ] ;then
    IP=`/usr/sbin/ifconfig eth0|grep inet|grep -v inet6|awk '{print $2}'`
else
    IP=`/sbin/ifconfig eth0|grep "inet addr"|awk -F":" '{print $2}'|awk '{print $1}'`
fi

ymd=`date +"%Y%m%d"`

if [ ! -x /usr/bin/expect ] ;then
    sudo yum -y install expect
fi

USER=`cat /etc/passwd|grep $USER0`
if [ -z $USER ] ;then
    echo "It is not $USER0"
    sudo adduser $USER0
fi

sudo cp -r /home/ec2-user/.ssh /$USER0/.ssh
#sudo cp /home/ec2-user/create-user-keypair /home/$USER0/create-user-keypair
#sudo chown -R $USER0:$USER0 /home/$USER0
sudo su - $USER0 -c "expect create-user-keypair $USER0 $IP $ymd"
sudo su - $USER0 -c "mv $USER0-$IP-$ymd $USER0-$IP-$ymd.pem"
sudo su - $USER0 -c "chmod 600 $USER0-$IP-$ymd.pem"
sudo su - $USER0 -c "cat $USER0-$IP-$ymd.pub > .ssh/authorized_keys"
sudo cp /home/$USER0/$USER0-$IP-$ymd.pem /home/ec2-user/$USER0-$IP-$ymd.pem
sudo chown ec2-user:ec2-user /home/ec2-user/$USER0-$IP-$ymd.pem
sudo su - $USER0 -c "rm -rf $USER0-$IP-$ymd.p* create-user-keypair"
