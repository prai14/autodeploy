#!/usr/bin/expect -f

set IP [lindex $argv 0]

spawn ssh -i /app/pem/kp_management.pem ec2-user@$IP "sh /home/ec2-user/build-user-keypair"
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"
           exp_continue
       }
}
