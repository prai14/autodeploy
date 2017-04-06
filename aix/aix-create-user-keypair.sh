#/bin/sh

#USER0="root"
USER0="oracle"

IP=$(ifconfig -a|grep inet|grep -v inet6|grep -v "127."|awk '{print $2}'|head -1)

ymd=$(date +"%Y%m%d")

if [ "$USER0" = "root" ] ;then
    cond=$(cat /etc/passwd|grep "$USER0:"|awk -F: '{print $6}')
    if [ "$cond" = "/root" ] ;then
        cp /normal/create-user-keypair.expect $cond/create-user-keypair.expect
        su - $USER0 -c "expect create-user-keypair.expect $USER0 $IP $ymd"
        su - $USER0 -c "mv $USER0-$IP-$ymd $USER0-$IP-$ymd.pem"
        su - $USER0 -c "chmod 600 $USER0-$IP-$ymd.pem"
        su - $USER0 -c "touch $cond/.ssh/authorized_keys"
        su - $USER0 -c "cat $USER0-$IP-$ymd.pub > $cond/.ssh/authorized_keys"
        cp $cond/$USER0-$IP-$ymd.pem /normal/login/
        rm -rf $cond/$USER0-$IP-$ymd.p*
        rm -rf $cond/create-user-keypair.expect
    else
        cp /normal/create-user-keypair.expect /create-user-keypair.expect
        su - $USER0 -c "expect create-user-keypair.expect $USER0 $IP $ymd"
        su - $USER0 -c "mv $USER0-$IP-$ymd $USER0-$IP-$ymd.pem"
        su - $USER0 -c "chmod 600 $USER0-$IP-$ymd.pem"
        su - $USER0 -c "touch /.ssh/authorized_keys"
        su - $USER0 -c "cat $USER0-$IP-$ymd.pub > /.ssh/authorized_keys"
        cp $cond/$USER0-$IP-$ymd.pem /normal/login/
        rm -rf /$USER0-$IP-$ymd.p*
        rm -rf /create-user-keypair.expect
    fi
else
    udir=$(cat /etc/passwd|grep "$USER0:"|awk -F: '{print $6}')
    cp /normal/create-user-keypair.expect $udir/create-user-keypair.expect
    gid=$(su - $USER0 -c "id"|awk '{print $2}'|awk -F [\(\)] '{print $2}')
    chown $USER0:$gid $udir/create-user-keypair.expect
    su - $USER0 -c "expect create-user-keypair.expect $USER0 $IP $ymd"
    su - $USER0 -c "mv $USER0-$IP-$ymd $USER0-$IP-$ymd.pem"
    su - $USER0 -c "chmod 600 $USER0-$IP-$ymd.pem"
    su - $USER0 -c "touch $udir/.ssh/authorized_keys"
    su - $USER0 -c "cat $USER0-$IP-$ymd.pub > $udir/.ssh/authorized_keys"
    su - root   -c "cp $udir/$USER0-$IP-$ymd.pem /normal/login/"
    rm -rf $udir/$USER0-$IP-$ymd.p*
    rm -rf $udir/create-user-keypair.expect
fi
