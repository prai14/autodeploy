echo "###############################################################################################################################"
echo "####Redis resources delete!"

echo "-------------------------------------------------------------------------------------------------"
echo "95569 Redis needs deleting ----> listing below "
echo "-------------------------------------------------------------------------------------------------"
aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId,ReplicationGroupId]'|egrep "95569"

aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[ReplicationGroupId]'|egrep "95569"|uniq > 95569-redis.aoi

echo "-------------------------------------------------------------------------------------------------"
echo "abfinance Redis needs deleting ----> listing below "
echo "-------------------------------------------------------------------------------------------------"
aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId,ReplicationGroupId]'|egrep "abfinance"

aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[ReplicationGroupId]'|egrep "abfinance" |uniq > anfinance-redis.aoi

varx="95569-redis.aoi"
vary="anfinance-redis.aoi"

for redis_var in $varx $vary
do
while read i
do
    if [ "$i" != "" ] ;then
        echo "-----------------------------------------"
        echo "the redis $i is deleting ......"
        echo "-----------------------------------------"
        #aws elasticache delete-cache-cluster --cache-cluster-id $i
    else
        echo "-----------------------------------------"
        echo "the redis deleted or absent!"
        echo "-----------------------------------------"
    fi
done < $redis_var
done
