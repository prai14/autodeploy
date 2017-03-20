while read i 
do
   expect exec7-delete.sh $i
done < iplist
