instance_list=$(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text)
for instance_id in $instance_list; do
  aws cloudwatch put-metric-alarm \
  --alarm-name ec2_auto-recovery_${instance_id} \
  --alarm-description "EC2 Auto Recovery" \
  --metric-name StatusCheckFailed \
  --namespace AWS/EC2 \
  --statistic Maximum \
  --period 60 \
  --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold  \
  --dimensions  Name=InstanceId,Value=${instance_id} \
  --evaluation-periods 1 \
  --alarm-actions arn:aws-cn:automate:cn-north-1:ec2:recover
done
