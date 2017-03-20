LC_NAME=$1
USER_DATA_SCRIPT_FILE_PATH=$2
aws autoscaling create-launch-configuration \
--launch-configuration-name $LC_NAME \
--image-id ami-cc47d5f5 \
--key-name guangleiKeyPair_Chn \
--security-groups sg-ca1c0da8 \
--instance-type t2.micro \
--instance-monitoring Enabled=value \
--iam-instance-profile test-role \
--user-data "`cat $USER_DATA_SCRIPT_FILE_PATH`" \
--profile china
