#!/bin/bash

INSTANCE_ID=$1
PROFILE_NAME=$2

if [ ! -n "$PROFILE_NAME" ]; then
    PROFILE_NAME=default
fi

LOG_DIR=logs/
LOG_FILE=${LOG_DIR}/tagging.log

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

get_volume_id ()
{
    aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --profile ${PROFILE_NAME} --output text --query "Reservations[0].Instances[0].BlockDeviceMappings[*].Ebs.VolumeId"
}

### Main ###
[ -d ${LOG_DIR} ] || mkdir -p ${LOG_DIR}

[ $# -lt 1 ] && usage

#   Tag the instance
aws ec2 create-tags --resources ${INSTANCE_ID} --tags file://ec2-tags.json --profile ${PROFILE_NAME}

[ $? -ne 0 ] && err_quit "Fail to create tags for instance."

echo -e "\nThe instance ${INSTANCE_ID} has been tagged.\n"

do_log "${INSTANCE_ID} is tagged."

#   Tag the volumes
VOL_IDs=$(get_volume_id ${INSTANCE_ID})

for VOL_ID in ${VOL_IDs}
do
    aws ec2 create-tags --resources ${VOL_ID} --tags Key=Backup,Value=False --profile ${PROFILE_NAME}

    [ $? -ne 0 ] && err_quit "Fail to create tags for volume."

    echo -e "\nThe volume ${VOL_ID} has been tagged.\n"

    do_log "${VOL_ID} is tagged."
done

exit 0
