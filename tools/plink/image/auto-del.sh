y=`date +%F_%T|cut -b1-4`
m=`date +%F_%T|cut -b6-7`
d=`date +%F_%T|cut -b9-10`
cd /weblogic/NewSunYardFilePth/loadRar/downPic
for i in `ls|grep -v ${y}${m}${d}` 
do
    #echo $i
    rm -rf $i
done
