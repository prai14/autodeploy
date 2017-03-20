aws ec2 create-key-pair --key-name <new.pem>  --output text --query 'KeyMaterial'> <new.pem>
chmod 600 <new.pem>
ssh-keygen -f <new.pem>  -y|ssh -y -i <old.pem> ec2-user@<ip address> "cat > .ssh/authorized_keys"
