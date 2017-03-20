aws ec2 create-key-pair --key-name abfinance_bases --output text --query 'KeyMaterial' > abfinance_bases.pem --profile "abfinance"
aws ec2 create-key-pair --key-name abfinance_95569 --output text --query 'KeyMaterial' > abfinance_95569.pem --profile "abfinance"
aws ec2 create-key-pair --key-name abfinance_top20 --output text --query 'KeyMaterial' > abfinance_top20.pem --profile "abfinance"
