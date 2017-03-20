while read i 
do
   expect exec2-buildkp.sh $i
done < iplist
