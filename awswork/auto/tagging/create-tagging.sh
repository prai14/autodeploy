export TIMESTAMP=`date`
aws ec2 create-tags --resources i-086c67a3 --tags "Key=LastSecurityCheckAt,Value=$TIMESTAMP"

