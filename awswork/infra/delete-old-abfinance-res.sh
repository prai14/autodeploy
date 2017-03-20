####!/bin/bash

echo "-----------------------start------------------------------"

echo "####anbang finance old resoures delete!"

echo "###############################################################################################################################"
echo "####EC2 resources delete!"

echo "-------------------------------------------------------------------------------------------------"
echo "95569 EC2 needs terminating and deleting ----> listing below table"
echo "-------------------------------------------------------------------------------------------------"

aws ec2 describe-instances --output table --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=*95569*"

aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value)]' --filter "Name=tag:Name,Values=*95569*" > 95569-ec2.aoi

echo "-------------------------------------------------------------------------------------------------"
echo "top20 EC2 needs terminating and deleting ----> listing below table"
echo "-------------------------------------------------------------------------------------------------"

aws ec2 describe-instances --output table --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=*top20*"

aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value)]' --filter "Name=tag:Name,Values=*top20*" > top20-ec2.aoi

echo "-------------------------------------------------------------------------------------------------"
echo "abfinance EC2 needs terminating and deleting ----> listing below table"
echo "-------------------------------------------------------------------------------------------------"

aws ec2 describe-instances --output table --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=key-name,Values=abfinance_p*"

aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value)]' --filter "Name=key-name,Values=abfinance_p*" > abfinance-ec2.aoi

var1="95569-ec2.aoi"
var2="top20-ec2.aoi"
var3="abfinance-ec2.aoi"
var4="yc_internetds_life_xqyhb_8capp-ec2.aoi"

for var in $var1 $var2 $var3
#for var in $var4
do

while read i
do
    v1=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[InstanceId]' --filter "Name=tag:Name,Values=$i")
    v2=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[PrivateIpAddress]' --filter "Name=tag:Name,Values=$i")
    v3=$(aws ec2 describe-instance-attribute --instance-id $v1 --attribute disableApiTermination --output text                                             |grep -i DISABLEAPITERMINATION|awk '{print $2}')
    if [ "$v1" != "" ] ;then
        if [ "$v3" = "True" ] ;then
            echo "-------------------------------------------------------------------------------------------------"
            echo " EC2 $i have terminating and deleting guard! the instance attributes is $v3"
            echo "-------------------------------------------------------------------------------------------------"

            aws ec2 modify-instance-attribute --instance-id $v1 --no-disable-api-termination
            #aws ec2 modify-instance-attribute --instance-id $v1 --disable-api-termination
            
            v4=$(aws ec2 describe-instance-attribute --instance-id $v1 --attribute disableApiTermination --output text                                             |grep -i DISABLEAPITERMINATION|awk '{print $2}')

            echo "-------------------------------------------------------------------------------------------------"
            echo " EC2 $i have terminating and deleting no guard! the instance attributes is $v4"
            echo "-------------------------------------------------------------------------------------------------"
           
            echo "---------------------------------------------------------------------------------------------"
            echo " EC2 $i|$v1|$v2 is terminating and deleting ......"
            echo "---------------------------------------------------------------------------------------------"
            #aws ec2 terminate-instances --instance-ids $v1 --output table
        else
            #aws ec2 modify-instance-attribute --instance-id $v1 --disable-api-termination
            #aws ec2 modify-instance-attribute --instance-id $v1 --no-disable-api-termination
            echo "---------------------------------------------------------------------------------------------"
            echo " EC2 $i|$v1|$v2 is terminating and deleting ......"
            echo "---------------------------------------------------------------------------------------------"
            #aws ec2 terminate-instances --instance-ids $v1 --output table
        fi
    else
        echo "---------------------------------------------------------------------------------------------"
        echo " EC2 $i|$v1|$v2 is terminated and deleted ......"
        echo "---------------------------------------------------------------------------------------------"
    fi
done < $var
done

echo "###############################################################################################################################"
echo "####Redis resources delete!"

echo "-------------------------------------------------------------------------------------------------"
echo "95569 Redis needs deleting ----> listing below "
echo "-------------------------------------------------------------------------------------------------"
aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId]'|egrep "95569"

aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId]'|egrep "95569" > 95569-redis.aoi

echo "-------------------------------------------------------------------------------------------------"
echo "abfinance Redis needs deleting ----> listing below "
echo "-------------------------------------------------------------------------------------------------"
aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId]'|egrep "abfinance"

aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId]'|egrep "abfinance" > anfinance-redis.aoi

varx="95569-redis.aoi"
vary="anfinance-redis.aoi"

for redis-var in $varx $vary
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
        echo "the redis deleted!"
        echo "-----------------------------------------"
    fi
done < $redis-var
done

echo "###############################################################################################################################"
echo "####elb & alb resources delete!"

echo "-------------------------------------------------------------------------------------------------"
echo "95569 elb needs deleting ----> listing below "
echo "-------------------------------------------------------------------------------------------------"
aws elb describe-load-balancers --output text --query 'LoadBalancerDescriptions[].[LoadBalancerName]'|grep "95569"

aws elb describe-load-balancers --output text --query 'LoadBalancerDescriptions[].[LoadBalancerName]'|grep "95569" > 95569-elb.aoi

echo "-------------------------------------------------------------------------------------------------"
echo "abfinance alb needs deleting ----> listing below "
echo "-------------------------------------------------------------------------------------------------"
aws elbv2 describe-load-balancers --query 'LoadBalancers[].[LoadBalancerName,LoadBalancerArn]' --output text

aws elbv2 describe-load-balancers --query 'LoadBalancers[].[LoadBalancerName,LoadBalancerArn]' --output text > abfinance-alb.aoi

aws elbv2 describe-target-groups --output text --query 'TargetGroups[].[TargetGroupName,TargetGroupArn]'|egrep "abfinance"

aws elbv2 describe-target-groups --output text --query 'TargetGroups[].[TargetGroupName,TargetGroupArn]'|egrep "abfinance" > target-group-alb.aoi

varm="95569-elb.aoi"
varn="anfinance-alb.aoi"
varo="target-group-alb.aoi"

for elb-var in $varm 
do
while read i
do
    if [ "$i" != "" ] ;then
        echo "-----------------------------------------"
        echo "the elb $i is deleting ......"
        echo "-----------------------------------------"
        #aws elb delete-load-balancer --load-balancer-name $i
    else
        echo "-----------------------------------------"
        echo "the elb deleted!"
        echo "-----------------------------------------"
    fi
done < $elb-var

for alb-var in $varn 
do
while read i j
do
    if [ "$i" != "" ] ;then
        echo "-----------------------------------------"
        echo "the alb $i is deleting ......"
        echo "-----------------------------------------"
        #aws elbv2 delete-load-balancer --load-balancer-arn $j
    else
        echo "-----------------------------------------"
        echo "the alb deleted!"
        echo "-----------------------------------------"
    fi
done < $alb-var

for tg-alb-var in $varo 
do
while read i j
do
    if [ "$i" != "" ] ;then
        echo "-----------------------------------------"
        echo "the alb $i target groups is deleting ......"
        echo "-----------------------------------------"
        aws elbv2 delete-target-group --target-group-arn $j
    else
        echo "-----------------------------------------"
        echo "the alb target groups deleted!"
        echo "-----------------------------------------"
    fi
done < $tg-alb-var

echo "###############################################################################################################################"
echo "####Volumes resources delete!"

echo "-------------------------------------------------------------------------------------------------"
echo "abfinance volumes needs deleting ----> listing below "
echo "-------------------------------------------------------------------------------------------------"

aws ec2 describe-volumes --query 'Volumes[].[VolumeId,Size,VolumeType]' --filters "Name=status,Values=available" --output table

aws ec2 describe-volumes --query 'Volumes[].[VolumeId]' --filters "Name=status,Values=available" --output text > volumes-ec2.aoi

while read i
do
    if [ "$i" != "" ] ;then
        echo "-----------------------------------------"
        echo "the volume $i deleting !"
        echo "-----------------------------------------"
        #aws ec2 delete-volume --volume-id $i
    else
        echo "-----------------------------------------"
        echo "the volume $i deleted or absent !"
        echo "-----------------------------------------"
    fi
done < volumes-ec2.aoi
