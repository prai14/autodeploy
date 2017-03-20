####1 query snapshot
#instancename="mgmt_bastion01"
#instancename="abfinance_top20_ubuntu_app02"
#instancename="yc_internetds_health_bq_app01"
instancename="yc_internetds_health_bq_app03"
#instancename="igv-ec2-web02"

##from name ---->instanceid
instanceid=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=$instancename"|awk '{print $2}')

az=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[Placement.AvailabilityZone]' --filter "Name=tag:Name,Values=$instancename")

##from instanceid ----> root volumeid
rootvolid=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instanceid Name=attachment.device,Values="/dev/*da*" --output text --query 'Volumes[].[Attachments[].[Device,InstanceId,VolumeId]]'|awk '{print $3}')

device=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instanceid Name=attachment.device,Values="/dev/*da*" --output text --query 'Volumes[].[Attachments[].[Device,InstanceId,VolumeId]]'|awk '{print $1}')

voltype=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instanceid Name=attachment.device,Values="/dev/*da*" --output text --query 'Volumes[].[Iops,VolumeType]'|awk '{print $2}')

##from root volumeid ----> root volume snapshotid specical date in 2017-03-01
snapshotid=$(aws ec2 describe-snapshots --filters Name=volume-id,Values="$rootvolid" Name=start-time,Values="2017-03-08*" --profile default --output text --query 'Snapshots[].[OwnerId,SnapshotId,join(`,`,Tags[?Key==`InstanceName`].Value),join(`,`,Tags[?Key==`InstanceId`].Value)]'|awk '{print $2}')

ssidcount=$(aws ec2 describe-snapshots --filters Name=volume-id,Values="$rootvolid" Name=start-time,Values="2017-03-08*" --profile default --output text --query 'Snapshots[].[OwnerId,SnapshotId,join(`,`,Tags[?Key==`InstanceName`].Value),join(`,`,Tags[?Key==`InstanceId`].Value)]'|awk '{print $2}'|wc -l)

echo "$instancename|$instanceid|$az|$rootvolid|$voltype|$device|$ssidcount|$snapshotid"

####2 create new volume
## from snapshot create new volume

volcond=$(aws ec2 describe-volumes --filters "Name=snapshot-id,Values=$snapshotid" --output text --query 'Volumes[].[VolumeId]')
echo "volcond=$volcond"
#if [ $ssidcount -eq 1 ] && ["$volcond" = "" ] ;then
#    echo "create volume from $snapshotid"
    #aws ec2 create-volume --availability-zone $az --snapshot-id $snapshotid --volume-type $voltype
#else
#    echo "the snapshot $snapshotid is created!"
#fi

##from snapshotid ----> new volume volumeid
#volnew=$(aws ec2 describe-volumes --filters Name=snapshot-id,Values="$snapshotid" --output text --query 'Volumes[].[VolumeId]')

#echo "$volnew"

####3 stop the instance
#aws ec2 stop-instances --instance-ids $instanceid

####4 umount the root volume
#aws ec2 detach-volume --volume-id $rootvolid --instance-id $instanceid --device $device --force

####5 mount the new volume from the snapshot
#aws ec2 attach-volume --volume-id $volnew --instance-id $instanceid  --device $device

####6 start the instance
#aws ec2 start-instances --instance-ids $instanceid

####7 certificate
#ssh -i /app/awswork/infra/abfinance_top20.pem ubuntu@10.219.27.105 -vvv
