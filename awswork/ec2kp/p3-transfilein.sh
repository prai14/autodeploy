while read i 
do
   expect exec3-transback.sh $i
done < iplist
