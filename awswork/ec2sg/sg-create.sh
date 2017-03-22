####!/bin/bash

sgn="sg_zcl"
vpcname="bp1_abfinance"
profile="abf-aws"

v1=$(aws ec2 describe-security-groups --query 'SecurityGroups[].[GroupName]' --output text --filter Name=group-name,Values="$sgn" --profile $profile)
v2=$(aws ec2 describe-security-groups --query 'SecurityGroups[].[GroupId]' --output text --filter Name=group-name,Values="$sgn" --profile $profile)
v3=$(aws ec2 describe-vpcs --output text --query 'Vpcs[].[VpcId]' --filter "Name=tag:Name,Values=$vpcname" --profile $profile)
v4=$(aws ec2 describe-vpcs --output text --query 'Vpcs[].[IsDefault]' --filter "Name=tag:Name,Values=$vpcname" --profile $profile)
if [ "$v1" != "" ] ;then
    echo "====>first delete and then create security group"
    echo "====>delete security group $sgn"

    if [ "$v4" = "True" ] ;then
        echo "====>delete default security group $sgn"
        aws ec2 delete-security-group  --group-name $sgn --profile $profile ##delete from    default VPC
    else
        echo "====>delete nondefault security group $sgn"
        aws ec2 delete-security-group  --group-id   $v2  --profile $profile ##delete from nondefault VPC
    fi

    echo "====>create security group $sgn"
    aws ec2 create-security-group --group-name $sgn --vpc-id $v3 --description "$vpcname" --profile $profile
else
    echo "====>create security group $sgn"
    aws ec2 create-security-group --group-name $sgn --vpc-id $v3 --description "$vpcname" --profile $profile
fi
