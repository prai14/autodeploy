aws ec2 describe-instances --query 'Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,State:State.Name,Application:Tags[?Key==`Application`] | [0].Value}'

