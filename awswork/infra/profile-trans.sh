#!/bin/bash

if [ ! $# -eq 1 ]; then
    exit
fi

cred="$HOME/.aws/credentials" 
exp_dir="/app/autodeploy/awswork/infra"

v0=`grep "\[$1\]" $cred`
if [ "$v0" = "" ]; then
    exit
else
    aid=`sed -n "$(grep -n $1 $cred | tail -1 | cut -d : -f 1),+2p" $cred | grep "aws_access_key_id"`
    sid=`sed -n "$(grep -n $1 $cred | tail -1 | cut -d : -f 1),+2p" $cred | grep "aws_secret_access_key"`

    v1=`echo $aid | awk -F = '{print $2}'`
    v2=`echo $sid | awk -F = '{print $2}'`
    v3=`echo "cn-north-1"`
    v4=`echo "json"`

    expect ${exp_dir}/exp-profile-trans ${v1} ${v2} ${v3} ${v4}

    echo "-------------AWS Account profile----------------"
    echo "----------cat ~/.aws/config----------"
    cat ~/.aws/config
    echo "----------cat ~/.aws/credentials----------"
    cat ~/.aws/credentials
fi

account=$(aws ec2 describe-security-groups --query SecurityGroups[*].[OwnerId] --output text|uniq)

echo "----------------------------------------------------------"
echo "AWS account has switched to $1---->$account!"
echo "----------------------------------------------------------"
