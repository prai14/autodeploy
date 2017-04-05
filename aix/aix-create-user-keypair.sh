#/bin/sh

#USER0="root"
USER0="oracle"

IP=$(ifconfig -a|grep inet|grep -v inet6|grep -v "127."|awk '{print $2}'|head -1)

ymd=$(date +"%Y%m%d")

if [ "$USER0" = "root" ] ;then
    cond=$(cat /etc/passwd|grep "$USER0:"|awk -F: '{print $6}')
    if [ "$cond" = "/root" ] ;then
        cp /normal/create-user-keypair.exp $cond/create-user-keypair.exp
        su - $USER0 -c "expect create-user-keypair.exp $USER0 $IP $ymd"
        su - $USER0 -c "mv $USER0-$IP-$ymd $USER0-$IP-$ymd.pem"
        su - $USER0 -c "chmod 600 $USER0-$IP-$ymd.pem"
        su - $USER0 -c "touch $cond/.ssh/authorized_keys"
        su - $USER0 -c "cat $USER0-$IP-$ymd.pub > $cond/.ssh/authorized_keys"
        cp $cond/$USER0-$IP-$ymd.pem /normal/login/
        rm -rf $cond/$USER0-$IP-$ymd.p*
        rm -rf $cond/create-user-keypair.exp
    else
        cp /normal/create-user-keypair.exp /create-user-keypair.exp
        su - $USER0 -c "expect create-user-keypair.exp $USER0 $IP $ymd"
        su - $USER0 -c "mv $USER0-$IP-$ymd $USER0-$IP-$ymd.pem"
        su - $USER0 -c "chmod 600 $USER0-$IP-$ymd.pem"
        su - $USER0 -c "touch /.ssh/authorized_keys"
        su - $USER0 -c "cat $USER0-$IP-$ymd.pub > /.ssh/authorized_keys"
        cp $cond/$USER0-$IP-$ymd.pem /normal/login/
        rm -rf /$USER0-$IP-$ymd.p*
        rm -rf /create-user-keypair.exp
    fi
else
    udir=$(cat /etc/passwd|grep "$USER0:"|awk -F: '{print $6}')
    cp /normal/create-user-keypair.exp $udir/create-user-keypair.exp
    gid=$(su - $USER0 -c "id"|awk '{print $2}'|awk -F [\(\)] '{print $2}')
    chown $USER0:$gid $udir/create-user-keypair.exp
    su - $USER0 -c "expect create-user-keypair.exp $USER0 $IP $ymd"
    su - $USER0 -c "mv $USER0-$IP-$ymd $USER0-$IP-$ymd.pem"
    su - $USER0 -c "chmod 600 $USER0-$IP-$ymd.pem"
    su - $USER0 -c "touch $udir/.ssh/authorized_keys"
    su - $USER0 -c "cat $USER0-$IP-$ymd.pub > $udir/.ssh/authorized_keys"
    su - root   -c "cp $udir/$USER0-$IP-$ymd.pem /normal/login/"
    rm -rf $udir/$USER0-$IP-$ymd.p*
    rm -rf $udir/create-user-keypair.exp
fi
