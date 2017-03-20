#[ec2-user@ip-10-219-8-6 ~]$ aws ec2 describe-instance-attribute --instance-id i-0cb10a1f0f1a1694d --attribute disableApiTermination --output text|grep -i DISABLEAPITERMINATION|awk '{print $2}'
#False
#[ec2-user@ip-10-219-8-6 ~]$ aws ec2 modify-instance-attribute --instance-id i-0cb10a1f0f1a1694d --disable-api-termination
#[ec2-user@ip-10-219-8-6 ~]$ aws ec2 describe-instance-attribute --instance-id i-0cb10a1f0f1a1694d --attribute disableApiTermination --output text|grep -i DISABLEAPITERMINATION|awk '{print $2}'
#True
#[ec2-user@ip-10-219-8-6 ~]$ aws ec2 modify-instance-attribute --instance-id i-0cb10a1f0f1a1694d --no-disable-api-termination
#[ec2-user@ip-10-219-8-6 ~]$ aws ec2 describe-instance-attribute --instance-id i-0cb10a1f0f1a1694d --attribute disableApiTermination --output text|grep -i DISABLEAPITERMINATION|awk '{print $2}'
#False
aws ec2 describe-vpcs --output table
#aws ec2 describe-availability-zones --output table
#aws ec2 describe-key-pairs --output table
#aws ec2 describe-security-groups --query SecurityGroups[*].[GroupName,GroupId,VpcId,Description,OwnerId] --output table
#aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,Placement.AvailabilityZone,State.Name,InstanceType,PrivateIpAddress]' --output table
#aws ec2 describe-tags --filters "Name=key,Values=Name" --output=table
#aws ec2 describe-tags --filters "Name=resource-type,Values=instance" "Name=key,Values=Name" --output  table
#aws ec2 describe-tags --filters "Name=resource-type,Values=instance" "Name=key,Values=Name" --output  text|sort -k 4|awk '{print $3" "$5}'
#aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,Placement.AvailabilityZone,State.Name,InstanceType,PrivateIpAddress]' --output text |sort -k 4|awk '{print $1" "$5}'
#aws ec2 describe-instances --output table --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,State.Name,PrivateIpAddress]'
#aws ec2 describe-volumes --query 'Volumes[*].[VolumeId, Attachments[0].InstanceId,VolumeType]'
#aws elb describe-load-balancers --query 'LoadBalancerDescriptions[].[LoadBalancerName,Instances]' --output text
#aws ec2 describe-instances --output table --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,State.Name,InstanceType,KeyName,PrivateIpAddress]'
#for i in `aws ec2 describe-instances --filters Name=tag:Name,Values=somepltf-* --query 'Reservations[].Instances[].BlockDeviceMappings[*].Ebs.VolumeId' --output text | xargs aws ec2 describe-volumes --query 'Volumes[].Size' --output text --volume-ids `; do echo $i; done | perl -ne ' $total += $_; END{print $total}'
#aws ec2 authorize-security-group-ingress --group-id sg-d1xxxxb4 
#--protocol tcp --port 22        --cidr 202.x.x.120/29  
#--protocol tcp --port 8080-8082 --cidr 10.10.0.0/16  
#--protocol tcp --port 80        --cidr 0.0.0.0/0
#--protocol tcp --port 9999      --source-group sg-xxxxxxxx
#aws ec2 describe-vpcs --output text --query 'Vpcs[].[VpcId]' --filter "Name=tag:Name,Values=bp1_abfinance"
#aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=key-name,Values=abfinance_bases"|wc -l
#aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=*95569*"|wc -l
#aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=*top20*"|wc -l
#aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=abfinance_*"|wc -l
#aws ec2 describe-volumes --query 'Volumes[].[join(`,`,Attachments[].InstanceId),Size,VolumeType]' --filters "Name=status,Values=in-use" --output table
#aws ec2 describe-volumes --query 'Volumes[].[join(`,`,Attachments[].InstanceId),Size,VolumeType]' --filters "Name=status,Values=in-use" --output text|sort -k 1
#aws ec2 describe-volumes --query 'Volumes[].[join(`,`,Attachments[].InstanceId),Size,VolumeType]' --filter Name=status,Values="in-use" --output table
#aws ec2 run-instances --image-id ami-7axxxx3f --count 1 --instance-type t1.micro --key-name MyTestCalifornia --security-group-ids sg-dxxxxbb4 --placement AvailabilityZone=us-west-1c --subnet-id subnet-5exxxx3b --block-device-mappings "[{\"DeviceName\": \"/dev/sdf\",\"Ebs\":{\"VolumeSize\":100}}]"  --user-data  "/sbin/mkfs.ext4 /dev/xvdf  && /bin/mount /dev/xvdf /home"

#./launch-ec2.sh ami-705c881d m4.large 100/200 kp_deploy sg_app_internetds_epolicy bp1_internetds_epolicy_ext1 role_epolicy ids-aws

#aws ec2 create-tags --resources i-3xxxxb6d --tags Key=Name,       Value=yc_internetds_epolicy_gzyq01 \
#                                                  Key=PROJECT,    Value=internetds \
#                                                  Key=Tier,       Value=App \
#                                                  Key=Environment,Value=Prod \
#                                                  Key=Contact,    Value=Infra \
#                                                  Key=Creator,    Value=zhouchunlin
