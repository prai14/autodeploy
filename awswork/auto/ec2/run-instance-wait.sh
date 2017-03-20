#!/bin/bash
instance_id=$(aws ec2 run-instances --image-id ami-f239abcb --instance-type \
t2.micro --query Reservations[].Instances[].InstanceId \
        --output text)
instance_state=$(aws ec2 describe-instances --instance-ids $instance_id \
        --query 'Reservations[].Instances[].State.Name')
while [ "$instance_state" != "running" ]
do
    sleep 1
    instance_state=$(aws ec2 describe-instances --instance-ids $instance_id \
	--query 'Reservations[].Instances[].State.Name')
done
