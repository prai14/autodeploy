cat user20160119.log|awk '{if(NR%2!=0)ORS="|";else ORS="\n";print}' > user20160119.txt
