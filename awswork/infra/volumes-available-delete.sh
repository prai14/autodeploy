echo "###############################################################################################################################"
echo "####Volumes resources delete!"

echo "-------------------------------------------------------------------------------------------------"
echo "abfinance volumes needs deleting ----> listing below "
echo "-------------------------------------------------------------------------------------------------"

aws ec2 describe-volumes --query 'Volumes[].[VolumeId,Size,VolumeType]' --filters "Name=status,Values=available" --output table

vol_num=$(aws ec2 describe-volumes --query 'Volumes[].[VolumeId]' --filters "Name=status,Values=available" --output text |wc -l )
echo "-------------------------------------------------------------------------------------------------"
echo "abfinance volumes available total $vol_num pieces"
echo "-------------------------------------------------------------------------------------------------"

aws ec2 describe-volumes --query 'Volumes[].[VolumeId]' --filters "Name=status,Values=available" --output text > volumes-ec2.aoi

while read i
do
    if [ "$i" != "" ] ;then
        echo "-----------------------------------------"
        echo "the volume $i deleting !"
        echo "-----------------------------------------"
        aws ec2 delete-volume --volume-id $i
    else
        echo "-----------------------------------------"
        echo "the volume $i deleted or absent !"
        echo "-----------------------------------------"
    fi
done < volumes-ec2.aoi
