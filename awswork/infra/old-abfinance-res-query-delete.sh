echo "--------------------------------------------"
echo "####1. switch between the AWS account"
echo "##ids-aws---->internet cloud core project"
echo "##abf-aws---->anbang finance project"
echo "##aml-aws---->anbang mobile learning project" 
echo "--------------------------------------------"

profile_dir="/app/awswork/infra"
profile_var="ids-aws"

sh $profile_dir/profile-trans.sh $profile_var 1>/dev/null 2>&1

echo "--------------------------------------------"
echo "AWS account has switched to $profile_var!"
echo "--------------------------------------------"

echo "####2. query the old resources"

echo "####2.1 EC2"

num_95569=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=*95569*"|wc -l)
echo "--------------------------------------------"
echo "95569 EC2 $num_95569 sets"
echo "--------------------------------------------"

aws ec2 describe-instances --output table --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=*95569*"

num_top20=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=*top20*"|wc -l)
echo "--------------------------------------------"
echo "top20 EC2 $num_top20 sets"
echo "--------------------------------------------"

aws ec2 describe-instances --output table --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=tag:Name,Values=*top20*"

num_abfinance=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=key-name,Values=abfinance_p*"|wc -l)
echo "--------------------------------------------"
echo "abfinance EC2 $num_abfinance sets"
echo "--------------------------------------------"

aws ec2 describe-instances --output table --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),InstanceId,PrivateIpAddress]' --filter "Name=key-name,Values=abfinance_p*"

num=`expr $num_95569 + $num_top20 + $num_abfinance`

echo "--------------------------------------------"
echo "anbang finance project EC2 total $num sets"
echo "--------------------------------------------"

echo "####2.2 RDS"

num_rds=$(aws rds describe-db-instances --output text --query 'DBInstances[].[DBInstanceIdentifier]'|egrep "abfinance|95569|top20"|wc -l)

echo "----------------------------------------------"
echo "anbang finance project RDS total $num_rds sets"
echo "----------------------------------------------"

echo "####2.3 Redis"

ec_95569=$(aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId]'|egrep "95569"|wc -l)
echo "--------------------------------------------"
echo "95569 Redis $ec_95569 sets"
echo "--------------------------------------------"

aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId]'|egrep "95569"

ec_abfinance=$(aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId]'|egrep "abfinance"|wc -l)
echo "--------------------------------------------"
echo "abfinance Redis $ec_abfinance sets"
echo "--------------------------------------------"

aws elasticache describe-cache-clusters --output text --query 'CacheClusters[].[CacheClusterId]'|egrep "abfinance"

ec_num=`expr $ec_95569 + $ec_abfinance`

echo "-----------------------------------------------"
echo "anbang finance project Redis total $ec_num sets"
echo "-----------------------------------------------"

echo "####2.4 elb & alb"

elb_95569=$(aws elb describe-load-balancers --output text --query 'LoadBalancerDescriptions[].[LoadBalancerName]'|grep "95569"|wc -l)
echo "--------------------------------------------"
echo "95569 elb $elb_95569 sets"
echo "--------------------------------------------"

aws elb describe-load-balancers --output text --query 'LoadBalancerDescriptions[].[LoadBalancerName]'|grep "95569"

alb_abfinance=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[].[LoadBalancerName]' --output text|wc -l)
echo "--------------------------------------------"
echo "abfinance alb $alb_abfinance sets"
echo "--------------------------------------------"

aws elbv2 describe-load-balancers --query 'LoadBalancers[].[LoadBalancerName]' --output text

echo "--------------------------------------------"
echo "####2.5 volume"

aws ec2 describe-volumes --query 'Volumes[].[VolumeId,Size,VolumeType]' --filters "Name=status,Values=available" --output table

echo "--------------------------------------------"
echo "####3. delete the old resources"
echo "--------------------------------------------"

echo "----------------the following free-------------"
echo "####2.6 keypair"
echo "####2.7 role"
echo "####2.8 user"
echo "####2.9 group"
echo "####2.10 secruity group"
echo "####2.11 subnet"
echo "####2.12 VPC"
echo "-----------------------------------------------"
