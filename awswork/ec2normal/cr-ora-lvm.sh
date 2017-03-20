echo "-----create PV-----"
pvcreate /dev/xvdb
echo "-----create VG-----"
vgcreate vgoracle /dev/xvdb
echo "-----create LV-----"
lvcreate -L 50G  -n lvoracle  vgoracle
lvcreate -L 150G -n lvoradata vgoracle
lvcreate -L 100G -n lvarch    vgoracle
echo "-----LV format-----"
mkfs.ext4 /dev/vgoracle/lvoracle
mkfs.ext4 /dev/vgoracle/lvarch
mkfs.ext4 /dev/vgoracle/lvoradata
echo "-----create FS-----"
mkdir -p /oracle
mkdir -p /arch
mkdir -p /oradata
echo "-----mount FS-----"
mount /dev/vgoracle/lvoracle  /oracle
mount /dev/vgoracle/lvarch    /arch
mount /dev/vgoracle/lvoradata /oradata
echo "-----add fstab-----"
echo "/dev/vgoracle/lvoracle  /oracle          ext4    defaults        1 2 " >> /etc/fstab
echo "/dev/vgoracle/lvarch    /arch            ext4    defaults        1 2 " >> /etc/fstab
echo "/dev/vgoracle/lvoradata /oradata         ext4    defaults        1 2 " >> /etc/fstab
