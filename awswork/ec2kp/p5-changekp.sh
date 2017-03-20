#ymd=`date +"%Y%m%d"`

while read i 
do
   expect exec5-changekp.sh $i
done < iplist
