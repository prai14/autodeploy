#!/bin/bash
ebs_volume_id=$(aws ec2 create-volume --size 1000 --iops 20000 --availability-zone cn-north-1a --volume-type io1 --query 'VolumeId' --output text)
sleep 20
aws ec2 create-tags --resources $ebs_volume_id  --tags 'Key=Name,Value=Demo_Ebs'
aws ec2 attach-volume --volume-id $ebs_volume_id --instance-id i-800bd4b8 --device /dev/xvdg
