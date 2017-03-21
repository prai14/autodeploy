##====>Attaches the specified managed policy to the specified IAM role.
rname="zcl_role"
policy="CloudWatchFullAccess"
polic1="AmazonS3FullAccess"
polic2="AdministratorAccess"
polic3="AmazonEC2FullAccess"
polic4="AmazonRDSFullAccess"
polic5="AWSConfigRole"
polic6="AmazonElastiCacheFullAccess"
polic7="CloudWatchReadOnlyAccess"
polic8="AmazonS3ReadOnlyAccess"
polic9="AmazonEC2ReadOnlyAccess"
poli10="AmazonRDSReadOnlyAccess"
poli11="AmazonElastiCacheReadOnlyAccess"

cond=$(aws iam list-attached-role-policies --role-name $rname --query 'AttachedPolicies[].[PolicyArn]' --output text|grep $policy)
if [ "$cond" != "" ] ;then
    echo "====>first detach and then attach role managed policy"
    echo "====>detach role managed policy"
    aws iam detach-role-policy --role-name $rname --policy-arn $cond
    echo "====>attach role managed policy"
    aws iam attach-role-policy --role-name $rname --policy-arn arn:aws-cn:iam::aws:policy/$policy
else
    echo "====>attach role managed policy"
    aws iam attach-role-policy --role-name $rname --policy-arn arn:aws-cn:iam::aws:policy/$policy
fi
