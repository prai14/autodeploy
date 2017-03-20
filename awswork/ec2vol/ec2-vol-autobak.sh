####!/bin/sh -

#case var in
#    ids-aws)
#    ;;
#    abf-aws)
#    ;;
#    aml-aws)
#    ;;
#    *)
#    ;;
#esac

profile_dir="/app/autodeploy/awswork/infra"
profile_name="profile-trans.sh"

baksh_dir="/app/autodeploy/awswork/ec2vol"
baksh_name="ec2-volumes-autobackup.sh"
baksh_para="-p -k 30 -u -s tag -t Backup,Values=True"
baksh_turn="turn-on-vol-bak.sh"
baklog_dir="/app/autodeploy/ec2log"

var1="ids-aws"
var2="abf-aws"
var3="aml-aws"

#for var in ${var3}
for var in ${var1} ${var2} ${var3}
do
    echo $var
    sh ${profile_dir}/${profile_name} ${var} 1>/dev/null 2>&1
    account=$(aws ec2 describe-security-groups --query SecurityGroups[*].[OwnerId] --output text|uniq)
    echo "-------------------------------"
    echo " ${var}<---->${account} "
    echo "-------------------------------"
    bash ${baksh_dir}/${baksh_turn}
    sh ${baksh_dir}/${baksh_name} ${baksh_para} > ${baklog_dir}/ec2vol-ab-${var}-${account}-`date +"%Y%m%d"`.log 2>&1 
done
