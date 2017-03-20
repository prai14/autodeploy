echo "###########################################################################################################################"
echo "####elb & alb resources delete!"

#varm="95569-elb.aoi"
#varn="anfinance-alb.aoi"
#varo="target-group-alb.aoi"
####20170306
varm=`cat delete-95569-elb-20170306.aoi`

for i in $varm
do 
    check=$(aws elb describe-load-balancers --load-balancer-name --output text --query 'LoadBalancerDescriptions[].[LoadBalancerName,DNSName]'|grep "$i")

    if [ "$check" != "" ] ;then
        echo "-----------------------------------------"
        echo "the elb $i is deleting ......"
        echo "-----------------------------------------"
        aws elb delete-load-balancer --load-balancer-name $i
    else
        echo "-----------------------------------------"
        echo "the elb deleted!"
        echo "-----------------------------------------"
    fi
done

#for alb-var in $varn 
#do
#while read i j
#do
#    if [ "$i" != "" ] ;then
#        echo "-----------------------------------------"
#        echo "the alb $i is deleting ......"
#        echo "-----------------------------------------"
#        #aws elbv2 delete-load-balancer --load-balancer-arn $j
#    else
#        echo "-----------------------------------------"
#        echo "the alb deleted!"
#        echo "-----------------------------------------"
#    fi
#done < $alb-var
#done

#for tg-alb-var in $varo 
#do
#while read i j
#do
#    if [ "$i" != "" ] ;then
#        echo "-----------------------------------------"
#        echo "the alb $i target groups is deleting ......"
#        echo "-----------------------------------------"
#        aws elbv2 delete-target-group --target-group-arn $j
#    else
#        echo "-----------------------------------------"
#        echo "the alb target groups deleted!"
#        echo "-----------------------------------------"
#    fi
#done < $tg-alb-var
#done
