ymd=`date +"%Y%m%d"`

while read i 
do
   expect exec4-scpfile.sh $i $ymd
done < iplist
