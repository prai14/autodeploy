while read ip;do echo "$ip";sudo echo y|plink "ec2-user@$ip" -i "/app/ppk/kp_management.ppk" -m update-openssh.sh;done < iplist
