if [ ! $# -eq 1 ]
then
    echo "  Usage:  sh cr_user.sh username "
    echo "  username:  user name "
    exit
fi

sudo ssh-keygen -t rsa -b 2048 -v -f $1
sudo chmod 600 $1
sudo mv $1 $1.pem

sudo cat $1.pub|ssh -y -i <old.pem> user@<ip address> "cat > .ssh/authorized_keys"
