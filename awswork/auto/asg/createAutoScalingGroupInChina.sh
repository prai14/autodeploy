# Example: 
# createAutoScalingGroupInChina.sh mgr-queen-asg-cn mgr-queen-lc-cn-v11 1 1 1 subnet-ab2335c9
ASG_NAME=$1
LC_NAME=$2
MIN_SIZE=$3
MAX_SIZE=$4
DC=$5
VZI=$6
aws autoscaling create-auto-scaling-group --auto-scaling-group-name $ASG_NAME \
--launch-configuration-name $LC_NAME \
--min-size $MIN_SIZE \
--max-size $MAX_SIZE \
--desired-capacity $DC \
--vpc-zone-identifier $VZI \
--profile china
