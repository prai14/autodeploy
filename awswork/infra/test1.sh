vpcid=`aws ec2 describe-vpcs --output text --query 'Vpcs[].[VpcId]' --filter "Name=tag:Name,Values=bp1_abfinance"`
#az1=`echo "cn-north-1a"`
#az2=`echo "cn-north-1b"`

az1="cn-north-1a"
az2="cn-north-1b"

echo $vpcid
cat bp1-abfinance-subnet.txt|awk '{print $1}' > bp1-abfinance-subnet-cidr-test1.txt 

echo "---------------------------------------------"
count=0
while read i
do
    count=`expr $count + 1`
    if [ $(($count%2)) != 0 ] ;then
        echo "$i|$count|$az1"
    else
        echo "$i|$count|$az2"
    fi
done < bp1-abfinance-subnet-cidr-test1.txt

echo "---------------------------------------------"

while read m n
do
    v2=`aws ec2 describe-subnets --output text --query 'Subnets[].[SubnetId]' --filter "Name=cidr-block,Values=$m"`
    echo "$v2|$n"
    #aws ec2 create-tags --resources $V2 --tags Key=Name,Value=$n
done < bp1-abfinance-subnet.txt

sed -n "$(grep -n abf-aws ~/.aws/credentials|tail -1|cut -d : -f 1),+2p" ~/.aws/credentials
