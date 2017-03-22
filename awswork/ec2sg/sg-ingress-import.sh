#aws ec2 authorize-security-group-ingress --group-id sg-d1xxxxb4 
#--protocol tcp --port 22        --cidr 202.x.x.120/29  
#--protocol tcp --port 8080-8082 --cidr 10.10.0.0/16  
#--protocol tcp --port 80        --cidr 0.0.0.0/0
#--protocol tcp --port 9999      --source-group sg-xxxxxxxx

#aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupId,GroupName]' --output text --profile abf-aws --filters Name=group-name,Values="sg_app_abfinance_lcb*"
#aws ec2 describe-security-groups --group-id sg-4b4ba42f --output table --query 'SecurityGroups[].[IpPermissions[].[FromPort,IpProtocol,ToPort,join(`,`,IpRanges[].CidrIp)]]'
#aws ec2 describe-security-groups --group-id sg-4b4ba42f --output text --query 'SecurityGroups[].[IpPermissions[].[FromPort,IpProtocol,ToPort,join(`,`,IpRanges[].CidrIp)]]'
#aws ec2 describe-security-groups --group-id sg-494ba42d --output text --query 'SecurityGroups[].[IpPermissions[].[FromPort,IpProtocol,ToPort,join(`,`,IpRanges[].CidrIp),join(`,`,UserIdGroupPairs[].GroupId)]]'|column -t

####
sgn="sg_zcl"
profile="abf-aws"
sgid=""

v1=$(aws ec2 describe-security-groups --query 'SecurityGroups[].[GroupId]' --output text --filter Name=group-name,Values="$sgn" --profile $profile)
if [ "$v1" != "" ] ;then
   aws ec2 authorize-security-group-ingress --group-id $v1 --protocol tcp --port 22        --cidr 0.0.0.0/0     --profile $profile
   aws ec2 authorize-security-group-ingress --group-id $v1 --protocol tcp --port 8080-8082 --cidr 10.0.0.0/8    --profile $profile
   aws ec2 authorize-security-group-ingress --group-id $v1 --protocol tcp --port 9999      --source-group $sgid --profile $profile
fi
