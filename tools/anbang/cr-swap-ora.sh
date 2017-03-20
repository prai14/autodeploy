dd if=/dev/zero of=/oracle/swapfile bs=1M count=24576
mkswap /oracle/swapfile
swapon /oracle/swapfile
echo "/oracle/swapfile swap swap defaults 0 0" >> /etc/fstab
