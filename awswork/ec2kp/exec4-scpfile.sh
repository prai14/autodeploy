#!/usr/bin/expect -f

set IP [lindex $argv 0]    
set ymd [lindex $argv 1]    

spawn scp -i /app/pem/kp_management.pem /app/login/ec2-user-10.219.8.6-$ymd.pem ec2-user@$IP:/home/ec2-user/
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"       
           exp_continue        
       }
}

spawn scp -i /app/pem/kp_management.pem /app/awswork/ec2kp/changekp.sh ec2-user@$IP:/home/ec2-user/
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"       
           exp_continue        
       }
}
