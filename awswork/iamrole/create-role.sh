rolename="zcl_role"
cond=$(aws iam list-roles --output text --query 'Roles[].[RoleName]' |grep $rolename)
if [ "$cond" != "" ] ;then
    echo "====>first delete and then create the role $rolename"

    cond1=$(aws iam list-attached-role-policies --role-name $rolename --query 'AttachedPolicies[].[PolicyArn]' --output text)
    echo $cond1
    if [ "$cond1" != "" ] ;then
        for mpolicy in $cond1 
        do
            echo "====>detach the role managed policy $mpolicy"
            aws iam detach-role-policy --role-name $rolename --policy-arn $mpolicy
        done 
    fi
    
    cond2=$(aws iam list-role-policies --role-name $rolename --output text|awk '{print $2}')
    echo $cond2
    if [ "$cond2" != "" ] ;then
        for ipolicy in $cond2
        do
            echo "====>delete the role inline policy $ipolicy"
            aws iam delete-role-policy --role-name zcl_role --policy-name $ipolicy
        done 
    fi

    echo "====>delete the role $rolename"
    aws iam delete-role --role-name $rolename

    echo "====>create the role $rolename"
    aws iam create-role --role-name $rolename --assume-role-policy-document file://ec2-role-trust-policy.json
else
    echo "====>create the role $rolename"
    aws iam create-role --role-name $rolename --assume-role-policy-document file://ec2-role-trust-policy.json
fi
