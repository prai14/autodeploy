sudo echo "-----ip-----"
sudo ifconfig -a |grep "10.219"
sudo echo "-----swap-----"
sudo free -m |grep -i swap
sudo echo "-----df-h-----"
sudo df -h
sudo echo "-----fdisk-l-----"
sudo fdisk -l |grep xvdb
sudo echo "-----pvs-----"
sudo pvs
sudo echo "-----lvs-----"
sudo lvs
sudo echo "-----vgs-----"
sudo vgs
sudo echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
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
sudo echo "----ls -lrt fstab-----"
sudo ls -lrt /etc/fstab
sudo echo "----chmod 777 fstab-----"
sudo chmod 777 /etc/fstab
sudo echo "-----add fstab-----"
sudo echo "/dev/vgapp/lvapp  /app          ext4    defaults        1 2 " >> /etc/fstab
sudo echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
sudo echo "-----dd-----"
sudo dd if=/dev/zero of=/app/swapfile bs=1M count=8192
sudo echo "-----mkswap-----"
sudo mkswap /app/swapfile
sudo echo "-----swapon-----"
sudo swapon /app/swapfile
sudo echo "-----fstab-----"
sudo echo "/app/swapfile swap swap defaults 0 0" >> /etc/fstab
sudo echo "----chmod 644 fstab-----"
sudo chmod 644 /etc/fstab
sudo echo "----ls -lrt fstab-----"
sudo ls -lrt /etc/fstab
sudo echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
sudo echo "-----ip-----"
sudo ifconfig -a |grep "10.219"
sudo echo "-----swap-----"
sudo free -m |grep -i swap
sudo echo "-----df-h-----"
sudo df -h
sudo echo "-----fdisk-l-----"
sudo fdisk -l |grep xvdb
sudo echo "-----pvs-----"
sudo pvs
sudo echo "-----lvs-----"
sudo lvs
sudo echo "-----vgs-----"
sudo vgs
