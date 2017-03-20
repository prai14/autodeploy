y=`date +%F_%T|cut -b1-4`
m=`date +%F_%T|cut -b6-7`
d=`date +%F_%T|cut -b9-10`
mkdir /Image/credit2015fhy/downPic/${y}/no${m}${d}bak
cd /weblogic/NewSunYardFilePth/downPic
for i in `ls|grep -v A${y}${m}${d}` 
do
    #echo $i
    mv $i /Image/credit2015fhy/downPic/${y}/no${m}${d}bak/
done
