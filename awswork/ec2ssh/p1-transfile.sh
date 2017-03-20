while read i 
do
   expect update-scpfile.sh $i
done < iplist
