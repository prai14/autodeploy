sudo ssh -V
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo cp /etc/pam.d/sshd /etc/pam.d/sshd.bak
sudo rpm -Uvh  /home/ec2-user/openssh7.3/*.rpm
sudo mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
sudo rm -f /etc/ssh/ssh*key
sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
sudo ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
sudo ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key  -N '' -t ecdsa;
sudo ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
sudo chmod 600 /etc/ssh/ssh*key
sudo mv /etc/pam.d/sshd.bak  /etc/pam.d/sshd
sudo chkconfig sshd on
sudo service sshd restart
sudo ssh -V
sudo rm -rf /home/ec2-user/openssh7.3
