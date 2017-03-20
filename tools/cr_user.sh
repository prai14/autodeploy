if [ ! $# -eq 2 ]
then
    echo "  Usage:  sh cr_user.sh username password "
    echo "  username:  user name "
    echo "  password:  user login password "
    exit
fi

groupadd $1
useradd -g $1 -d /home/$1 $1
echo "$2" |passwd --stdin $1
