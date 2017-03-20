#!/usr/bin/expect -f

set username [lindex $argv 0] 
set IP [lindex $argv 1]    
set ymd [lindex $argv 2]

spawn scp -i /home/ec2-user/kp_management.pem /home/ec2-user/$username-$IP-$ymd.pem ec2-user@10.219.8.6:/app/login/
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"       
           exp_continue        
       }
}
