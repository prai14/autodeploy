#!/usr/bin/expect -f

set username [lindex $argv 0]
set IP [lindex $argv 1]
set ymd [lindex $argv 2]

spawn ssh -i /app/login/$username-$IP-$ymd.pem $username@$IP " cat /etc/passwd|grep $username "
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"
           exp_continue
       }
}

spawn ssh -i /app/login/ec2-user-10.219.8.6-$ymd.pem ec2-user@$IP " cat /etc/passwd|grep ec2-user "
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"
           exp_continue
       }
}
