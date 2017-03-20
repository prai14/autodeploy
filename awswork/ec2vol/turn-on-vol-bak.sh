#!/bin/bash -
# Date: 2016-12-1
# Version 0.10

FALSE_BACKUP_FILE='false_backup_vol.txt'

(comm -23 <(aws ec2 describe-volumes --query 'Volumes[].VolumeId' --output text --filter Name=status,Values="in-use"| tr '\t' '\n'| sort) <(aws ec2 describe-volumes --query 'Volumes[].VolumeId' --filter Name=tag-key,Values="Backup" Name=tag-value,Values="True" Name=status,Values="in-use" --output text | tr '\t' '\n'| sort | uniq)) > $FALSE_BACKUP_FILE

# Loop over each line of the file and parse it.

cat $FALSE_BACKUP_FILE | while read line
do

    VOLUMEID=(`echo $line | awk -F\t '{print $1}'`)
        aws ec2 delete-tags --resources $VOLUMEID --tags Key=Backup
        aws ec2 create-tags --resources $VOLUMEID --tags Key=Backup,Value=True
        echo -e " => $VOLUMEID->Backup is turned on"

done

# Clean up
rm $FALSE_BACKUP_FILE
