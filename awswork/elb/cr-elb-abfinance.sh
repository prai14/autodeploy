##!/bin/sh

elbn="elb-95569-01"
pfile="abf-aws"
port="7080"
sn1="bp1_abfinance_dmz1"
sn2="bp1_abfinance_dmz2"
sgn="sg_elb_abfinance_95569"
cha="--output text --profile $pfile"

s1=$(aws ec2 describe-subnets --query 'Subnets[].[SubnetId]' --filter Name=tag:Name,Values="$sn1" $cha)
s2=$(aws ec2 describe-subnets --query 'Subnets[].[SubnetId]' --filter Name=tag:Name,Values="$sn2" $cha)

s3=$(aws ec2 describe-security-groups --query 'SecurityGroups[].[GroupId]' --filters Name=group-name,Values="$sgn" $cha)

c1=$(aws elb describe-load-balancers --load-balancer-name $elbn --query 'LoadBalancerDescriptions[].[DNSName]' $cha)

echo "$s1|$s2|$s3|$c1"

if [ "$c1" = "" ] ;then
    echo "creating the elb $elbn"
    aws elb create-load-balancer --load-balancer-name $elbn                                                                                                          --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=$port"                                            --subnets $s1 $s2 --security-groups $s3 $cha
else
    echo "the name of $elbn is created!"
fi
