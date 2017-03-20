####1 query snapshot
#instancename="mgmt_bastion01"
instancename="abfinance_top20_ubuntu_app02"

##from name ---->instanceid
get_instance_id ()
{
    aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=$instancename"|awk '{print $2}'
}

get_az ()
{
    aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[Placement.AvailabilityZone]' --filter "Name=tag:Name,Values=$instancename"
}

##from instanceid ----> root volumeid
get_rootvol_id ()
{
    aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$(get_instance_id () ${instancename}) Name=attachment.device,Values=/dev/sda1 --output text --query 'Volumes[].[Attachments[].[Device,InstanceId,VolumeId]]'|awk '{print $3}'
}

get_voltype ()
{
    aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$(get_instance_id () ${instancename}) Name=attachment.device,Values=/dev/sda1 --output text --query 'Volumes[].[Iops,VolumeType]'|awk '{print $2}'
}

get_iops ()
{
    aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$(get_instance_id () ${instancename}) Name=attachment.device,Values=/dev/sda1 --output text --query 'Volumes[].[Iops,VolumeType]'|awk '{print $1}')
}

##from root volumeid ----> root volume snapshotid specical date in 2017-02-10
#snapshotid=$(aws ec2 describe-snapshots --filters Name=volume-id,Values="vol-654176e0" Name=start-time,Values="2017-02-10*" --profile default --output text --query 'Snapshots[].[OwnerId,SnapshotId,join(`,`,Tags[?Key==`InstanceName`].Value),join(`,`,Tags[?Key==`InstanceId`].Value)]'|awk '{print $2}')

#rootvolid="vol-654176e0"
snapshotid=$(aws ec2 describe-snapshots --filters Name=volume-id,Values="$rootvolid" Name=start-time,Values="2017-02-20*" --profile default --output text --query 'Snapshots[].[OwnerId,SnapshotId,join(`,`,Tags[?Key==`InstanceName`].Value),join(`,`,Tags[?Key==`InstanceId`].Value)]'|awk '{print $2}')

echo "$instancename||$instanceid||$az||$rootvolid||$voltype||$voliops||$snapshotid"

####2 create new volume
## from snapshot create new volume

volcond=$(aws ec2 describe-volumes --filters Name=snapshot-id,Values=$snapshotid --output text --query 'Volumes[].[VolumeId]')
if [ "$volcond" = "" ] ;then
    aws ec2 create-volume --availability-zone $az --snapshot-id $snapshotid --volume-type $voltype --iops $voliops
else
    echo "the snapshot $snapshotid is created!"
fi

##from snapshotid ----> new volume volumeid
volnew=$(aws ec2 describe-volumes --filters Name=snapshot-id,Values=$snapshotid --output text --query 'Volumes[].[VolumeId]')

####3 stop the instance
aws ec2 stop-instances --instance-ids $instanceid

####4 umount the root volume
aws ec2 detach-volume --volume-id $rootvolid

####5 mount the new volume from the snapshot
aws ec2 attach-volume --volume-id $volnew --instance-id $instanceid  --device /dev/sda1

####6 start the instance
aws ec2 start-instances --instance-ids $instanceid

####7 certificate
ssh -i /app/awswork/infra/abfinance_top20.pem ubuntu@10.219.27.105 -vvv
