dd if=/dev/zero of=/app/swapfile bs=1M count=8192
mkswap /app/swapfile
swapon /app/swapfile
echo "/app/swapfile swap swap defaults 0 0" >> /etc/fstab
