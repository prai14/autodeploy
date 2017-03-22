##====>Attaches the specified managed policy to the specified IAM role.
rname="zcl_role"
mpolicy="CloudWatchFullAccess"
mpolic1="AmazonS3FullAccess"
mpolic2="AdministratorAccess"
mpolic3="AmazonEC2FullAccess"
mpolic4="AmazonRDSFullAccess"
mpolic5="AWSConfigRole"
mpolic6="AmazonElastiCacheFullAccess"
mpolic7="CloudWatchReadOnlyAccess"
mpolic8="AmazonS3ReadOnlyAccess"
mpolic9="AmazonEC2ReadOnlyAccess"
mpoli10="AmazonRDSReadOnlyAccess"
mpoli11="AmazonElastiCacheReadOnlyAccess"

cond=$(aws iam list-attached-role-policies --role-name $rname --query 'AttachedPolicies[].[PolicyArn]' --output text|grep $mpolicy)
if [ "$cond" != "" ] ;then
    echo "====>first detach and then attach role managed policy"
    echo "====>detach role managed policy $mpolicy"
    aws iam detach-role-policy --role-name $rname --policy-arn $cond
    echo "====>attach role managed policy $mpolicy"
    aws iam attach-role-policy --role-name $rname --policy-arn arn:aws-cn:iam::aws:policy/$mpolicy
else
    echo "====>attach role managed policy $mpolicy"
    aws iam attach-role-policy --role-name $rname --policy-arn arn:aws-cn:iam::aws:policy/$mpolicy
fi
