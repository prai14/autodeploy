aws ec2 describe-instances --filter "Name=tag:Environment,Values=Demo" --query 'Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,State:State.Name,Application:Tags[?Key==`Application`] | [0].Value,Environment:Tags[?Key==`Environment`] | [0].Value}' --output table

