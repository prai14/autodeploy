#!/bin/bash
instance_id=$(aws ec2 run-instances --user-data file://UserData.txt --cli-input-json file://arguments.json --query 'Instances[*].InstanceId' --output text)
aws ec2 create-tags --resources $instance_id  --tags 'Key=Company,Value=GoldenWind' 'Key=Application,Value=demo-web.com' 'Key=Name,Value=hands-on-demo' 'Key=stopinator,Value=terminate'
