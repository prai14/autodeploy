#aws ec2 authorize-security-group-ingress --group-id sg-d1xxxxb4 
#--protocol tcp --port 22        --cidr 202.x.x.120/29  
#--protocol tcp --port 8080-8082 --cidr 10.10.0.0/16  
#--protocol tcp --port 80        --cidr 0.0.0.0/0
#--protocol tcp --port 9999      --source-group sg-xxxxxxxx

#sg_name="test_sg_app_internetds"

#get_sg_id ()
#{
#    aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupId]' --output text                                                --profile ids-aws --filters Name=group-name,Values="$sg_name"
#}

#echo $(get_sg_id $sg_name)

#aws ec2 authorize-security-group-ingress --group-id $(get_sg_id $sg_name)                                                          #--protocol tcp --port 8080-8082 --cidr 10.0.0.0/8  

#aws ec2 revoke-security-group-ingress --group-id $(get_sg_id $sg_name)                                                             #--protocol tcp --port 8080-8082 --cidr 10.0.0.0/8  

aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupId,GroupName]' --output text --profile abf-aws --filters Name=group-name,Values="sg_app_abfinance_lcb*"

aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupId,GroupName]' --output text --profile abf-aws --filters Name=group-name,Values="sg_app_abfinance_file*"
