sudo echo "-----create PV-----"
sudo pvcreate /dev/xvdb
sudo echo "-----create VG-----"
sudo vgcreate vgapp /dev/xvdb
sudo echo "-----create LV-----"
sudo lvcreate -L 50G  -n lvapp  vgapp
sudo echo "-----LV format-----"
sudo mkfs.ext4 /dev/vgapp/lvapp
sudo echo "-----create FS-----"
sudo mkdir -p /app
sudo echo "-----mount FS-----"
sudo mount /dev/vgapp/lvapp  /app
sudo echo "-----add fstab-----"
sudo echo "/dev/vgapp/lvapp  /app          ext4    defaults        1 2 " >> /etc/fstab
