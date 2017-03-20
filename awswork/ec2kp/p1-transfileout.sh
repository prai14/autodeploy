while read i 
do
   expect exec1-scpfile.sh $i
done < iplistabfn
