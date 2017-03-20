#!/bin/bash

INSTANCE_NAME=$1
AMI_ID=$2
INSTANCE_TYPE=$3
DISK=$4
KEYPAIR_NAME=$5
SG_NAME=$6
SUBNET_NAME=$7
ROLE_NAME=$8
PROFILE_NAME=$9

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
    \"DeviceName\": \"/dev/sda1\",
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
      \"VolumeSize\": ${DATA_DISK_SIZE}, " >> $DST

	if [ "_${DATA_SNAPSHOT_ID}" = "_" ]; then
echo "    \"Encrypted\": false " >> $DST
	else
echo "    \"SnapshotId\": \"${DATA_SNAPSHOT_ID}\"" >> $DST
	fi


echo "    }
  } " >> $DST
	fi

echo "] "  >> $DST

	echo $DST
}

### Main ###
[ -d ${LOG_DIR} ] || mkdir -p ${LOG_DIR}

[ $# -lt 8 ] && usage

SUBNET_ID=$(get_subnet_id ${SUBNET_NAME})
VPC_ID=$(get_vpc_id ${SUBNET_NAME})
SG_ID=$(get_sg_id ${SG_NAME})
# Making block device mapping file
DEVICE_MAPPING_FILE=$(make_block_mapping_file ${AMI_ID} $DISK)

CMD="aws ec2 run-instances --image-id ${AMI_ID} --instance-type ${INSTANCE_TYPE} --key-name ${KEYPAIR_NAME} --security-group-ids ${SG_ID} --subnet-id ${SUBNET_ID} --iam-instance-profile Name=${ROLE_NAME} --block-device-mappings file://block-device.json --disable-api-termination --profile ${PROFILE_NAME}"

#echo $CMD

INSTANCE_ID=`$CMD | grep InstanceId | cut -d\" -f4`

aws ec2 create-tags --resources ${INSTANCE_ID} --tags Key=Name,Value=${INSTANCE_NAME} --profile ${PROFILE_NAME}

[ $? -ne 0 ] && err_quit "Launch Instance failed: $CMD"

echo -e "\nThe instance ${INSTANCE_ID} has been launched.\n"

do_log "Launching ${INSTANCE_ID}: $CMD"

exit 0

