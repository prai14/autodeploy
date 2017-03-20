instanceid=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
memtotal=`free -m | grep 'Mem' | tr -s ' ' | cut -d ' ' -f 2`
memfree=`free -m | grep 'buffers/cache' | tr -s ' ' | cut -d ' ' -f 4`
let "memused=100-memfree*100/memtotal"
aws cloudwatch put-metric-data  --metric-name "FreeMemoryMBytes" --namespace "System/Linux" --dimensions "InstanceId=$instanceid" --value "$memfree" --unit "Megabytes"
aws cloudwatch put-metric-data --metric-name "UsedMemoryPercent" --namespace "System/Linux" --dimensions "InstanceId=$instanceid" --value "$memused" --unit "Percent"

