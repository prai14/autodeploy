####bp1-internetds
aws ec2 create-vpc --cidr-block 10.219.64.0/18
####bt1-internetds
aws ec2 create-vpc --cidr-block 10.219.32.0/20
####bp1-management
aws ec2 create-vpc --cidr-block 10.219.8.0/24
####bp1-abfinance
aws ec2 create-vpc --cidr-block 10.219.16.0/20
####bt1-abfinance
aws ec2 create-vpc --cidr-block 10.219.48.0/20
####bp1-social
aws ec2 create-vpc --cidr-block 10.219.9.0/24
####bt1-social
aws ec2 create-vpc --cidr-block 10.219.10.0/24
