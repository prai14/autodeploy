##====>Adds or updates an inline policy document that is embedded in the specified IAM role.
rname="zcl_role"
ipolicy1="ExamplePolicy"
ipolicy2="CloudWatchFullAccess"

cond1=$(aws iam list-role-policies --role-name $rname --output text|grep $ipolicy1)
if [ "$cond1" != "" ] ;then
    echo "====>delete the role inline policy $ipolicy1"
    aws iam delete-role-policy --role-name $rname --policy-name $ipolicy1
    echo "====>put the role inline policy $ipolicy1"
    aws iam put-role-policy --role-name $rname --policy-name $ipolicy1 --policy-document file://inline-policy-$ipolicy1.json
else
    echo "====>put the role inline policy $ipolicy1"
    aws iam put-role-policy --role-name $rname --policy-name $ipolicy1 --policy-document file://inline-policy-$ipolicy1.json
fi

cond2=$(aws iam list-role-policies --role-name $rname --output text|grep $ipolicy2)
if [ "$cond2" != "" ] ;then
    echo "====>delete the role inline policy $ipolicy2"
    aws iam delete-role-policy --role-name $rname --policy-name $ipolicy2
    echo "====>put the role inline policy $ipolicy2"
    aws iam put-role-policy --role-name $rname --policy-name $ipolicy2 --policy-document file://inline-policy-$ipolicy2.json
else
    echo "====>put the role inline policy $ipolicy2"
    aws iam put-role-policy --role-name $rname --policy-name $ipolicy2 --policy-document file://inline-policy-$ipolicy2.json
fi
