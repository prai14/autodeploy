#!/usr/bin/expect -f

set IP [lindex $argv 0]    

spawn scp -i /app/pem/kp_management.pem -r /app/awswork/ec2ssh/openssh7.3 ec2-user@$IP:/home/ec2-user/
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"       
           exp_continue        
       }
}
