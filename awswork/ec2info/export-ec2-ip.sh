aws ec2 describe-instances --query 'Reservations[*].{Name:Instances[*].Tags[0].Value, IP:Instances[*].PrivateIpAddress}'
