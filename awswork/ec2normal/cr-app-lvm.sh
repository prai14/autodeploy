echo "-----create PV-----"
pvcreate /dev/xvdb
echo "-----create VG-----"
vgcreate vgapp /dev/xvdb
echo "-----create LV-----"
lvcreate -L 50G  -n lvapp  vgapp
echo "-----LV format-----"
mkfs.ext4 /dev/vgapp/lvapp
echo "-----create FS-----"
mkdir -p /app
echo "-----mount FS-----"
mount /dev/vgapp/lvapp  /app
echo "-----add fstab-----"
echo "/dev/vgapp/lvapp  /app          ext4    defaults        1 2 " >> /etc/fstab
