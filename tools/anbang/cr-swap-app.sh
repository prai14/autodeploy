sudo echo "-----dd-----"
sudo dd if=/dev/zero of=/app/swapfile bs=1M count=8192
sudo echo "-----mkswap-----"
sudo mkswap /app/swapfile
sudo echo "-----swapon-----"
sudo swapon /app/swapfile
sudo echo "-----fstab-----"
sudo echo "/app/swapfile swap swap defaults 0 0" >> /etc/fstab
