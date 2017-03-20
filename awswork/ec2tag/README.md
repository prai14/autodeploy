#README & Helper file to create tags for EC2 instances and volumes for Anbang

#Usage 使用方法
./create-tags.sh [Instance ID] [AWS Credential Profile Name]

[Instance ID]：待标签的 EC2 实例ID
[AWS Credential Profile Name]: AWS 登录密钥配置文件，若未指定则采用默认配置文件

#Example usage 示例
./create-tags.sh i-80546db8 anbang

#标签配置文件
采用同级目录下的 ec2-tags.json 作为标签配置文件

#EC2 实例的标签定义
./ec2-tags.json
Name: EC2 实例名称
Project: 项目名称，取值为 internetds/abfinance/95569/top20
Tier: 层级，取值为 Web/App/DB/Middleware/NAT/NGINX
Environment: 部署环境，取值为 Prod/DAT/SIM/UAT/DEV/TEST
Contact: 负责单位，取值为 Infra/Operation/Sinnet
Creator: 创建者，取值为 zhouchunlin

#EBS 存储卷的标签定义
./volume-tags.json
Backup: 是否自动备份，取值为 True/False

