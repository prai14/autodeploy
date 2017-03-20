#!/bin/bash
instance_id = $(aws ec2 run-instances --image-id ami-f239abcb --key-name demo-bjs --security-group-ids sg-2eb9a04c --instance-type t2.micro --subnet-id subnet-d77061b5 --query 'Instances[].InstanceId' --output text)
aws ec2 create-tags --resources $instance_id  --tags 'Key=Application,Value=web-demo'

