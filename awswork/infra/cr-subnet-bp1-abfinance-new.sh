vpcid=`aws ec2 describe-vpcs --output text --query 'Vpcs[].[VpcId]' --filter "Name=tag:Name,Values=bp1_abfinance"`
vpccidr=`aws ec2 describe-vpcs --output text --query 'Vpcs[].[CidrBlock]' --filter "Name=tag:Name,Values=bp1_abfinance"`
vpcname=`aws ec2 describe-vpcs --output text --filter "Name=tag:Name,Values=bp1_abfinance"|grep TAGS|awk '{print $3}'`
az1="cn-north-1a"
az2="cn-north-1b"

if [ "$vpcid" != "" ] ;then
    count=0
    while read i j 
    do
        count=`expr $count + 1`
        v1=`aws ec2 describe-subnets --output text --query 'Subnets[].[CidrBlock]' |grep "$i"`
        v2=`aws ec2 describe-subnets --output text --query 'Subnets[].[SubnetId]' --filter "Name=cidr-block,Values=$i"`
        v3=`cat bp1-abfinance-subnet-cidr.aoi|grep "$i"`
        if [ "$v1" = "" ] ;then
            if [ $(($count%2)) != 0 ] ;then
                if [ "$v3" != "" ] ;then
                    echo "the subnet $i|$count|$az1|$j is creating !"
                    aws ec2 create-subnet --vpc-id $vpcid --cidr-block $i --availability-zone $az1 
                    echo "the subnet $i|$count|$az1|$j TAGS is creating !"
                    v4=`aws ec2 describe-subnets --output text --query 'Subnets[].[SubnetId]' --filter "Name=cidr-block,Values=$i"`
                    aws ec2 create-tags --resources $V4 --tags Key=Name,Value=$j
                else
                    echo "the subnet $i|$count|$az1|$j not in the vpc $vpccidr|$vpcname !"
                fi
            else
                if [ "$v3" != "" ] ;then
                    echo "the subnet $i|$count|$az2|$j is creating !"
                    aws ec2 create-subnet --vpc-id $vpcid --cidr-block $i --availability-zone $az2 
                    echo "the subnet $i|$count|$az2|$j TAGS is creating !"
                    v5=`aws ec2 describe-subnets --output text --query 'Subnets[].[SubnetId]' --filter "Name=cidr-block,Values=$i"`
                    aws ec2 create-tags --resources $V5 --tags Key=Name,Value=$j
                else
                    echo "the subnet $i|$count|$az2|$j not in the vpc $vpccidr|$vpcname !"
                fi
            fi
        else
            if [ $(($count%2)) != 0 ] ;then
                echo "the subnet $v2|$v1|$az1|$j is created!"
            else
                echo "the subnet $v2|$v1|$az2|$j is created!"
            fi
        fi
    done < bp1-abfinance-subnet.txt
else
    echo "the vpc not created! the subnet in the vpc cannot created!"
fi
