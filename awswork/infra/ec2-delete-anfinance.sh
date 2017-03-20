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
            aws ec2 terminate-instances --instance-ids $v1 --output table
        else
            #aws ec2 modify-instance-attribute --instance-id $v1 --disable-api-termination
            #aws ec2 modify-instance-attribute --instance-id $v1 --no-disable-api-termination
            echo "---------------------------------------------------------------------------------------------"
            echo " EC2 $i|$v1|$v2 is terminating and deleting ......"
            echo "---------------------------------------------------------------------------------------------"
            aws ec2 terminate-instances --instance-ids $v1 --output table
        fi
    else
        echo "---------------------------------------------------------------------------------------------"
        echo " EC2 $i|$v1|$v2 is terminated and deleted ......"
        echo "---------------------------------------------------------------------------------------------"
    fi
done < $var
done
