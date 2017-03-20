username="cbs-cloud"
ymd=`date +"%Y%m%d"`

while read i 
do
   expect exec6-certificate.sh $username $i $ymd
done < iplist
