#!/usr/bin/expect -f

set IP [lindex $argv 0]    

spawn scp -i /app/awswork/infra/abfinance_bases.pem /app/awswork/ec2kp/create-user-keypair ec2-user@$IP:/home/ec2-user/
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"       
           exp_continue        
       }
}

spawn scp -i /app/awswork/infra/abfinance_bases.pem /app/awswork/ec2kp/build-user-keypair ec2-user@$IP:/home/ec2-user/
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"       
           exp_continue        
       }
}

spawn scp -i /app/awswork/infra/abfinance_bases.pem /app/pem/kp_management.pem ec2-user@$IP:/home/ec2-user/
expect {
       "*Are you sure you want to continue connecting*" {
           send "yes\r"       
           exp_continue        
       }
}

#spawn scp -i /app/awswork/infra/abfinance_bases /app/awswork/ec2kp/scpfiledown.sh ec2-user@$IP:/home/ec2-user/
#expect {
#       "*Are you sure you want to continue connecting*" {
#           send "yes\r"       
#           exp_continue        
#       }
#}

#spawn scp -i /app/awswork/infra/abfinance_bases /app/awswork/ec2kp/transfileback.sh ec2-user@$IP:/home/ec2-user/
#expect {
#       "*Are you sure you want to continue connecting*" {
#           send "yes\r"       
#           exp_continue        
#       }
#}
