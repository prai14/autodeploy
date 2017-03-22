#profile="abf-aws"
#hat="abfinance"

profile="ids-aws"
hat="internetds"

for i in `aws ec2 describe-security-groups --output text --query 'SecurityGroups[].[GroupId]' --filter Name=group-name,Values="*sg_*$hat*" --profile $profile`
do
    j=$(aws ec2 describe-security-groups --output text --query 'SecurityGroups[].[GroupName]' --filter Name=group-id,Values="$i" --profile $profile)
    echo "-----------------------------------------------------------------------"
    echo "$j====>$i"
    echo "-----------------------------------------------------------------------"
    aws ec2 describe-security-groups --group-id $i --output text --profile $profile --query 'SecurityGroups[].[IpPermissions[].[FromPort,IpProtocol,ToPort,join(`,`,IpRanges[].CidrIp),join(`,`,UserIdGroupPairs[].GroupId)]]'|column -t
done 
