#!/bin/bash

#INSTANCE_NAME=$1
AMI_ID=$1
INSTANCE_TYPE=$2
DISK=$3
KEYPAIR_NAME=$4
SG_NAME=$5
SUBNET_NAME=$6
ROLE_NAME=$7
PROFILE_NAME=$8

if [ ! -n "$PROFILE_NAME" ]; then
    PROFILE_NAME=default
fi

LOG_DIR=logs/
LOG_FILE=${LOG_DIR}/launch.log

do_log()
{
        echo "`date +"%Y/%m/%d %T"`: $1" >> ${LOG_FILE}
}

err_quit()
{

        MSG="ERR: $1"

        do_log "$MSG"

        echo $MSG
        exit 1
}

usage()
{
    cat README.md
        exit 1
}

get_sg_id ()
{
    aws ec2 describe-security-groups --profile ${PROFILE_NAME} --query 'SecurityGroups[*].[GroupId]' --output text --filters "Name=group-name,Values=$1" "Name=vpc-id,Values=${VPC_ID}"
}

get_vpc_id()
{
        aws ec2 describe-subnets --profile ${PROFILE_NAME} --filters Name=tag:Name,Values=$1 --query 'Subnets[*].[VpcId]' --output text
}

get_subnet_id ()
{
#    PROFILE_NAME=$2
        aws ec2 describe-subnets --profile ${PROFILE_NAME} --filters Name=tag:Name,Values=$1 --query 'Subnets[*].[SubnetId]' --output text
}

get_volume_id ()
{
    aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --profile ${PROFILE_NAME} --output text --query "Reservations[0].Instances[0].BlockDeviceMappings[*].Ebs.VolumeId"
}

make_block_mapping_file()
{
        # TODO: Support only up to two devices this time, DISK allocation format:  root_disk_size/data_disk_size

        AMI_ID=$1
        ROOT_DISK_SIZE=$(echo $2|cut -d/ -f1)
        DATA_DISK_SIZE=$(echo $2|cut -d/ -f2|cut -d: -f1)
        DATA_SNAPSHOT_ID=$(echo $2|cut -d/ -f2|cut -d: -f2)

        DIR=block_device_map

        [ -d $DIR ] || mkdir -p $DIR

        ROOT_SNAPSHOT_ID=$(aws ec2 describe-images --profile ${PROFILE_NAME} --query Images[].BlockDeviceMappings[0].[Ebs.SnapshotId] --filters Name=image-id,Values=${AMI_ID} --output text)

        [ "_${ROOT_SNAPSHOT_ID}" = "_" ] && err_quit "Empty root snapshot id for image ${AMI_ID}"

        DST="$DIR/${ROOT_DISK_SIZE}-${DATA_DISK_SIZE}.json"

        ## TODO
echo "[
  {
    \"DeviceName\": \"/dev/xvda\",
    \"Ebs\": {
      \"DeleteOnTermination\": true,
      \"SnapshotId\": \"${ROOT_SNAPSHOT_ID}\",
      \"VolumeSize\": ${ROOT_DISK_SIZE},
      \"VolumeType\": \"gp2\"
        }
  } " > $DST

        if [ ${DATA_DISK_SIZE} -gt 0 ]; then
echo "  ,{
    \"DeviceName\": \"/dev/sdb\",
    \"Ebs\": {
      \"DeleteOnTermination\": true,
      \"VolumeType\": \"gp2\",
      \"VolumeSize\": ${DATA_DISK_SIZE} " >> $DST
#     \"Encrypted\": false" >> $DST


echo "    }
  } " >> $DST
        fi

echo "] "  >> $DST

        echo $DST
}

### Main ###
[ -d ${LOG_DIR} ] || mkdir -p ${LOG_DIR}

[ $# -lt 7 ] && usage

SUBNET_ID=$(get_subnet_id ${SUBNET_NAME})
[ "${SUBNET_ID}" = "" ] && err_quit "Launch Instance failed: Invalid subnet"

VPC_ID=$(get_vpc_id ${SUBNET_NAME})
[ "${VPC_ID}" = "" ] && err_quit "Launch Instance failed: Invalid subnet"

SG_ID=$(get_sg_id ${SG_NAME})
[ "${SG_ID}" = "" ] && err_quit "Launch Instance failed: Invalid security group"

# Making block device mapping file
DEVICE_MAPPING_FILE=$(make_block_mapping_file ${AMI_ID} $DISK)

CMD="aws ec2 run-instances --image-id ${AMI_ID} --instance-type ${INSTANCE_TYPE} --key-name ${KEYPAIR_NAME} --security-group-ids ${SG_ID} --subnet-id ${SUBNET_ID} --iam-instance-profile Name=${ROLE_NAME} --block-device-mappings file://${DEVICE_MAPPING_FILE} --monitoring Enabled=true --disable-api-termination --profile ${PROFILE_NAME}"

#echo $CMD

INSTANCE_ID=`$CMD | grep InstanceId | cut -d\" -f4`

aws ec2 create-tags --resources ${INSTANCE_ID} --tags file://ec2-tags.json --profile ${PROFILE_NAME}

[ $? -ne 0 ] && err_quit "Launch Instance failed: $CMD"

echo -e "\nLaunching the instance ${INSTANCE_ID}...done. \n"

do_log "Launching ${INSTANCE_ID}: $CMD"

#   Tag the volumes
VOL_IDs=$(get_volume_id ${INSTANCE_ID})

for VOL_ID in ${VOL_IDs}
do
    aws ec2 create-tags --resources ${VOL_ID} --tags file://volume-tags.json --profile ${PROFILE_NAME}

    [ $? -ne 0 ] && err_quit "Fail to create tags for volume."

#    echo -e "\nThe volume ${VOL_ID} has been tagged.\n"

    do_log "${VOL_ID} is tagged."
done

echo -e "\nTagging the instance and volumes...done. \n"

aws cloudwatch put-metric-alarm --alarm-name ec2_auto-recovery_${INSTANCE_ID} --alarm-description "EC2 Auto Recovery" --metric-name StatusCheckFailed --namespace AWS/EC2 --statistic Maximum --period 60 --threshold 1 --comparison-operator GreaterThanOrEqualToThreshold --dimensions  Name=InstanceId,Value=${INSTANCE_ID} --evaluation-periods 2 --alarm-actions arn:aws-cn:automate:cn-north-1:ec2:recover --profile ${PROFILE_NAME}

echo -e "\nEnabling EC2 Auto Recovery...done. \n"

exit 0

#aws cloudwatch put-metric-alarm --alarm-name awsec2-i-b61a2e0e-High-Status-Check-Failed-System --metric-name StatusCheckFailed_System --namespace AWS/EC2 --statistic Maximum --period 60 --evaluation-periods 2 --threshold 1 --comparison-operator GreaterThanOrEqualToThreshold --dimensions "Name=InstanceId,Value=i-b61a2e0e" --alarm-actions arn:aws-cn:automate:cn-north-1:ec2:recover arn:aws-cn:sns:cn-north-1:484879136155:AutoRecovery --profile anbang

#aws cloudwatch describe-alarms-for-metric --metric-name StatusCheckFailed_System --namespace AWS/EC2 --dimensions Name=InstanceId,Value=i-79b59bc1 --profile anbang
