#aws ec2 create-image --instance-id i-1234567890abcdef0 --name "My server" --description "An AMI for my server" --block-device-mappings "[{\"DeviceName\": \"/dev/sdh\",\"Ebs\":{\"VolumeSize\":100}}]"

nval="abfinance_95569_app20"

ymd=`date +"%Y%m%d"`

v1=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[InstanceId]' --filter "Name=tag:Name,Values=$nval")

v2=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[PrivateIpAddress]' --filter "Name=tag:Name,Values=$nval")

echo "$v1||$v2||$ymd"

v3=$(aws ec2 describe-images --output text --query 'Images[].[Name]' --filter Name=name,Values="image-$v2-*")

if [ "$v3" = "" ] ;then
    echo "image name ==>$v3"
    aws ec2 create-image --instance-id $v1 --name "image-$v2-$ymd" --description "image-$v2-$ymd" --no-reboot
fi

aws ec2 describe-images --output text --query 'Images[].[ImageId,Name]' --filter Name=name,Values="image-$v2-*"

#aws ec2 deregister-image --image-id 
