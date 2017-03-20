####!/bin/sh

count=0
while read i
do
    var1=`echo $i|awk -F_ '{print $1}'`
    var2=`echo $i|awk -F_ '{print $2}'`
    var3=`echo $i|awk -F_ '{print $3}'`
    var4=`echo $i|awk -F_ '{print $4}'`
    var5=`echo $i|awk -F_ '{print $5}'`
    echo "$var1|$var2|$var3|$var4|$var5"
    profile_dir="/app/awswork/infra"
    profile_name="profile_trans.sh"

    #case var1 in
    #    internetds)
    #    sh $profile_dir/$profile_name ids-aws 1>/dev/null 2>&1
    #    ;;
    #    abfinance)
    #    sh $profile_dir/$profile_name abf-aws 1>/dev/null 2>&1
    #    ;;
    #    internetds)
    #    sh $profile_dir/$profile_name aml-aws 1>/dev/null 2>&1
    #    ;;
    #    *)
    #    ;;
    #esac

    var_check=$(aws ec2 describe-instances --output text --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value)]'                                --filter Name=tag:Name,Values="$i")
    if [ "$var_check" = "" ] ;then
        echo "the instance=>$i is absent!"
    else
        echo "the instance=>$i is created!"
    fi
    
    ####1. image
    

    ####from ami

    ####new create

    ####2. type

    ####3. vol

    ####4. kp

    ####5. sg
    ####6. subnet
    ####7. role
    ####8. profile
done < normal.aoi
