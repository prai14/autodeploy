##====>Attaches the specified managed policy to the specified IAM role.
rname="zcl_role"
policy="CloudWatchFullAccess"
cond=$(aws iam list-attached-role-policies --role-name $rname --query 'AttachedPolicies[].[PolicyArn]' --output text|grep $policy)
if [ "$cond" != "" ] ;then
    echo "====>first detach and then attach role managed policy"
    echo "====>detach role managed policy"
    aws iam detach-role-policy --role-name $rname --policy-arn $cond
    echo "====>attach role managed policy"
    aws iam attach-role-policy --role-name $rname --policy-arn arn:aws-cn:iam::aws:policy/CloudWatchFullAccess
else
    echo "====>attach role managed policy"
    aws iam attach-role-policy --role-name $rname --policy-arn arn:aws-cn:iam::aws:policy/CloudWatchFullAccess
fi
