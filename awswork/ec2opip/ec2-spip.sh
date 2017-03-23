#!/bin/sh

#c3.large====>secondary-private-ip-address-count 9
#c3.xlarge===>secondary-private-ip-address-count 14

pfile="abf-aws"

in1="abfinance_waf01"
in2="abfinance_waf02"

cha="--output text --profile $pfile"

iid1=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId]' --filter "Name=tag:Name,Values=$in1" $cha)
iid2=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId]' --filter "Name=tag:Name,Values=$in2" $cha)

pip1=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[PrivateIpAddress]' --filter "Name=tag:Name,Values=$in1" $cha)
pip2=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[PrivateIpAddress]' --filter "Name=tag:Name,Values=$in2" $cha)

en1=$(aws ec2 describe-instances --query 'Reservations[].Instances[].NetworkInterfaces[].[NetworkInterfaceId]'                                                       --filters "Name=instance-id,Values=$iid1" $cha)
en2=$(aws ec2 describe-instances --query 'Reservations[].Instances[].NetworkInterfaces[].[NetworkInterfaceId]'                                                       --filters "Name=instance-id,Values=$iid2" $cha)

spc1=$(aws ec2 describe-instances                                                                                                          --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].[Primary,PrivateIpAddress]'                            --filters "Name=instance-id,Values=$iid1" $cha|grep False|wc -l)
spc2=$(aws ec2 describe-instances                                                                                                          --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].[Primary,PrivateIpAddress]'                            --filters "Name=instance-id,Values=$iid2" $cha|grep False|wc -l)

#echo "$iid1|$pip1|$en1|$spc1"
#echo "$iid2|$pip2|$en2|$spc2"

if [ "$spc1" -lt 9 ] ;then
    echo "assign secondary-private-ip-address-count $[9-$spc1] for $en1====>$pip1"
    aws ec2 assign-private-ip-addresses --network-interface-id $en1 --private-ip-addresses $pip1 $cha
    aws ec2 assign-private-ip-addresses --network-interface-id $en1 --secondary-private-ip-address-count $[9-$spc1] $cha
fi

if [ "$spc1" -lt 9 ] ;then
    echo "assign secondary-private-ip-address-count $[9-$spc2] for $en2====>$pip2"
    aws ec2 assign-private-ip-addresses --network-interface-id $en2 --private-ip-addresses $pip2 $cha
    aws ec2 assign-private-ip-addresses --network-interface-id $en2 --secondary-private-ip-address-count $[9-$spc2] $cha
fi

aws ec2 describe-instances --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].[Primary,PrivateIpAddress]'                            --filters "Name=instance-id,Values=$iid1" --output table --profile $pfile
aws ec2 describe-instances --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].[Primary,PrivateIpAddress]'                            --filters "Name=instance-id,Values=$iid2" --output table --profile $pfile

#aws ec2 assign-private-ip-addresses --network-interface-id eni-4cb39967 --private-ip-addresses 10.219.17.246 $cha
#aws ec2 assign-private-ip-addresses --network-interface-id eni-4cb39967  --secondary-private-ip-address-count $[9-$spc2] $cha
#aws ec2 assign-private-ip-addresses --network-interface-id eni-0e23e956 --private-ip-addresses 10.219.16.42 $cha
#aws ec2 assign-private-ip-addresses --network-interface-id eni-0e23e956  --secondary-private-ip-address-count $[9-$spc1] $cha
#aws ec2 describe-instances --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].[Primary,PrivateIpAddress]' --filters "Name=instance-id,Values=i-061100ef3944cdc9f" --output table
#aws ec2 describe-instances --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].[Primary,PrivateIpAddress]' --filters "Name=instance-id,Values=i-0ee80a69b4f45c60e" --output table
#aws ec2 unassign-private-ip-addresses --network-interface-id eni-e5aa89a3 --private-ip-addresses 10.0.0.82
