#!/bin/bash
#a=`awk '{print $1}' iplist.txt`
#y=`awk '!a[$1]++{print $2}' iplist.txt`
#z=`awk '!a[$1]++{print $3}' iplist.txt`
#num=`awk '{print $1}' iplist.txt|wc -l`
#echo "${a[@]}"
#echo "${y[@]}"
#echo "${z[@]}"
#echo ${num}

for i in `awk '{print $1}' iplist.txt`
do
    y=`awk /${i}/'{print $2}' iplist.txt`
    z=`awk /${i}/'{print $3}' iplist.txt`
    echo ${i}
    echo ${y}
    echo ${z}
    #./expect.sh ${i} ${y} ${z}
done
