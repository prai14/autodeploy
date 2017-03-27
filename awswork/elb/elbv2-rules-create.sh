#!/bin/sh

pfile="abf-aws"
ctext="--output text --profile $pfile"
ctable="--output table --profile $pfile"
cjson="--profile $pfile"
loadn="alb-abfinance-lcb"

loadarn=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[].[LoadBalancerArn]' --names $loadn $ctext)

echo "---------------------------------------------------------------------------------------------------------------------------"
echo "$loadn====>$loadarn"
echo "---------------------------------------------------------------------------------------------------------------------------"
aws elbv2 describe-listeners --load-balancer-arn $loadarn --query 'Listeners[].[Protocol,LoadBalancerArn,Port,ListenerArn]' $cjson

listarn=$(aws elbv2 describe-listeners --load-balancer-arn $loadarn --query 'Listeners[].[ListenerArn]' $ctext) 

for listen in $listarn
do  
    prot=$(aws elbv2 describe-listeners --load-balancer-arn $loadarn --query 'Listeners[].[Protocol,Port,ListenerArn]' $ctext                                               |grep $listen|awk '{print $1}') 
    port=$(aws elbv2 describe-listeners --load-balancer-arn $loadarn --query 'Listeners[].[Protocol,Port,ListenerArn]' $ctext                                               |grep $listen|awk '{print $2}') 
    echo "------------------------------------------------------------------------------------------------------------------------"
    echo "$prot|$port|$listen"
    echo "------------------------------------------------------------------------------------------------------------------------"
    aws elbv2 describe-rules --listener-arn $listen --query 'Rules[].[RuleArn]' $cjson
done

listarn443=$(aws elbv2 describe-listeners --load-balancer-arn $loadarn --query 'Listeners[].[Protocol,Port,ListenerArn]' $ctext                                               |grep "HTTPS"|grep "443"|awk '{print $3}') 
listarne=$(aws elbv2 describe-listeners --load-balancer-arn $loadarn --query 'Listeners[].[Protocol,Port,ListenerArn]' $ctext                                               |grep "HTTPS"|grep "443") 
#aws elbv2 describe-rules --listener-arn $listarn443 --query 'Rules[].[RuleArn]' $cjson

echo "---------------------------------------------------------------------------------------------------------------------------"
echo "deleting the rules of ---->$listarne"
echo "---------------------------------------------------------------------------------------------------------------------------"
if [ "$listarn443" != "" ] ;then
    rules=$(aws elbv2 describe-rules --listener-arn $listarn443 --query 'Rules[].[RuleArn]' $ctext)
    for rule in $rules
    do
        echo "-----------------------------------------------------------------------------------------------------------------"
        echo "deleting the rule $rule"
        echo "-----------------------------------------------------------------------------------------------------------------"
        #aws elbv2 delete-rule --rule-arn $rule $cjson
    done
else
    echo "the rule is deleted or no installation." 
fi

listarn80=$(aws elbv2 describe-listeners --load-balancer-arn $loadarn --query 'Listeners[].[Protocol,Port,ListenerArn]' $ctext                                               |grep "HTTP"|grep "80"|awk '{print $3}') 
listarnc=$(aws elbv2 describe-listeners --load-balancer-arn $loadarn --query 'Listeners[].[Protocol,Port,ListenerArn]' $ctext                                               |grep "HTTP"|grep "80") 
#aws elbv2 describe-rules --listener-arn $listarn80 --query 'Rules[].[RuleArn]' $cjson

echo "---------------------------------------------------------------------------------------------------------------------------"
echo "deleting the rules of ---->$listarnc"
echo "---------------------------------------------------------------------------------------------------------------------------"
if [ "$listarn80" != "" ] ;then
    rules=$(aws elbv2 describe-rules --listener-arn $listarn80 --query 'Rules[].[RuleArn]' $ctext)
    for rule in $rules
    do
        echo "-----------------------------------------------------------------------------------------------------------------"
        echo "deleting the rule $rule"
        echo "-----------------------------------------------------------------------------------------------------------------"
        #aws elbv2 delete-rule --rule-arn $rule $cjson
    done
else
    echo "the rule is deleted or no installation." 
fi
