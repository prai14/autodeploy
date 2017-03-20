#README & Helper file to provison EC2 instances for Anbang

#Usage 使用方法
./launch-ec2.sh [Instance Name] [AMI ID] [Instance Type] [Volumes] [Key Pair] [Security Group Name] [Subnet Name] [IAM Profile Name] [AWS Credential Profile Name]

[Instance Name]：待创建的 EC2 实例名称
[AMI ID]：操作系统 AMI ID
[Instance Type]：实例类型
[Volumes]：EBS 卷的容量，格式为 root_volume_size/2nd_block_volume_size
[Key Pair]：密钥对名称
[Security Group Name]：安全组名称
[Subnet Name]：子网名称
[IAM Profile Name]: IAM 角色名称
[AWS Credential Profile Name]: Use default profile if not specified

#Example usage 示例
./launch-ec2.sh test_ec2 ami-fa875397 c3.xlarge 8/100 dsmiyao default bp1_abfinance_95569_int2 role_test_abfinance anbang

#AMI ID
ami-fa875397 (Default AMI: Amazon Linux AMI 2016.09.0 (HVM), SSD Volume Type) 
ami-6f62b702 (Microsoft Windows Server 2012 R2 Base (Chinese Simplified))

#VPC, Subnet & Security Group

10.219.64.0/18	vpc-175eaa73	bp1_internetds                                     
---------------------------------           -------------------------------------
|        DescribeSubnets        |           |      DescribeSecurityGroups       |
+-------------------------------+           +-----------------------------------+
|  bp1_internetds_life_ext1     |           |  sg_Mongo_internetds_opsmon       |
|  bp1_internetds_front_int2    |           |  sg_db_internetds_opsmon          |
|  bp1_internetds_opsmon_ext2   |           |  sg_app_internetds_datax          |
|  bp1_internetds_datax_int1    |           |  sg_db_internetds_epolicy         |
|  bp1_internetds_datax_int2    |           |  sg_app_internetds_opsmon         |
|  bp1_internetds_dmz2          |           |  sg_db_internetds_datax           |
|  bp1_internetds_epolicy_ext2  |           |  sg_nat_internetds                |
|  bp1_internetds_epolicy_ext1  |           |  sg_app_internetds_front_mq       |
|  bp1_internetds_life_int2     |           |  sg_app_internetds_front_zkp      |
|  bp1_internetds_epolicy_int2  |           |  sg_app_internetds_front_yyzc     |
|  bp1_internetds_dmz1          |           |  sg_app_internetds_front_dsjr     |
|  bp1_internetds_opsmon_int2   |           |  sg_nginx_internetds_nginx        |
|  bp1_internetds_health_int1   |           |  sg_db_internetds_life_bq         |
|  bp1_internetds_front_int1    |           |  sg_app_internetds_life_bq        |
|  bp1_internetds_health_ext1   |           |  sg_app_internetds_life_bdgl      |
|  bp1_internetds_opsmon_ext1   |           |  sg_db_internetds_front_yyzc      |
|  bp1_internetds_front_ext1    |           |  sg_db_internetds_life_xqyhb      |
|  bp1_internetds_life_int1     |           |  sg_app_internetds_life_xqyhb     |
|  bp1_internetds_health_ext2   |           |  sg_app_internetds_health_bq      |
|  bp1_internetds_front_ext2    |           |  sg_db_internetds_health_xqyhb    |
|  bp1_internetds_datax_ext2    |           |  sg_app_internetds_life_jsyq      |
|  bp1_internetds_health_int2   |           |  sg_db_internetds_life_bdgl       |
|  bp1_internetds_datax_ext1    |           |  sg_app_internetds_health_xqyhb   |
|  bp1_internetds_opsmon_int1   |           |  sg_cache_internetds_life_jsyq    |
|  bp1_internetds_epolicy_int1  |           |  sg_app_internetds_health_jsyq    |
|  bp1_internetds_life_ext2     |           |  sg_db_internetds_health_bdgl     |
+-------------------------------+           |  sg_app_internetds_epolicy        |
                                            |  sg_cache_internetds_health_jsyq  |
                                            |  sg_db_internetds_health_bq       |
                                            |  sg_app_internetds_health_bdgl    |
                                            |  default                          |
                                            +-----------------------------------+



#10.219.32.0/20	vpc-5a58ac3e	bt1_internetds
-------------------------                   ------------------------------------
|    DescribeSubnets    |                   |      DescribeSecurityGroups      |
+-----------------------+                   +----------------------------------+
|  bt1_internetds_ext1  |                   |  default                         |
|  bt1_internetds_ext2  |                   |  test_sg_app_internetds          |
|  bt1_internetds_dmz2  |                   |  test_sg_db_internetds           |
|  bt1_internetds_int2  |                   |  test_sg_mail_internetds         |
|  bt1_internetds_dmz1  |                   |  test_sg_nat_internetds          |
|  bt1_internetds_int1  |                   |  test_sg_nginx_internetds_nginx  |
+-----------------------+                   +----------------------------------+
                                        


10.219.16.0/20	vpc-b55fabd1	bp1_abfinance
------------------------------              ------------------------------------- 
|       DescribeSubnets      |              |      DescribeSecurityGroups       | 
+----------------------------+              +-----------------------------------+ 
|  bp1_abfinance_int1        |              |  default                          | 
|  bp1_abfinance_95569_int2  |              |  sg_app_abfinance_lcb_production  | 
|  bp1_abfinance_dmz1        |              |  sg_app_abfinance_lcb_sales       | 
|  bp1_abfinance_ext2        |              |  sg_app_abfinance_lcb_webview     | 
|  bp1_abfinance_95569_ext2  |              |  sg_db_abfinance_95569            | 
|  bp1_abfinance_int2        |              |  sg_cache_abfinance_95569         | 
|  bp1_abfinance_top20_ext2  |              |  sg_app_abfinance_top20           | 
|  bp1_abfinance_95569_int1  |              |  sg_cache_abfinance               | 
|  bp1_abfinance_top20_int2  |              |  sg_app_abfinance_fileshare       | 
|  bp1_abfinance_ext1        |              |  sg_app_abfinance_95569           | 
|  bp1_abfinance_top20_int1  |              |  sg_db_abfinance                  | 
|  bp1_abfinance_top20_ext1  |              |  sg_db_abfinance_top20            | 
|  bp1_abfinance_95569_ext1  |              |  sg_app_abfinance_lcb_admin       | 
|  bp1_abfinance_dmz2        |              |  launch-wizard-7                  | 
+----------------------------+              |  sg_nat_abfinance                 | 
                                            +-----------------------------------+ 

10.219.48.0/20	vpc-389f695c	bt1_abfinance
------------------------                    ------------------------
|    DescribeSubnets   |                    |DescribeSecurityGroups|
+----------------------+                    +----------------------+
|  bt1_abfinance_dmz1  |                    |  default             |
|  bt1_abfinance_int1  |                    +----------------------+
|  bt1_abfinance_ext2  |
|  bt1_abfinance_int2  |
|  bt1_abfinance_ext1  |
|  bt1_abfinance_dmz2  |
+--------------------

10.219.8.0/24	vpc-1758ac73	bp1_management
-------------------                         ------------------------
| DescribeSubnets |                         |DescribeSecurityGroups|
+-----------------+                         +----------------------+
|  bp1_mgmt_int1  |                         |  default             |
|  bp1_mgmt_ext2  |                         |  sg_mgmt_bastion     |
|  bp1_mgmt_dmz1  |                         +----------------------+
|  bp1_mgmt_ext1  |
|  bp1_mgmt_int2  |
|  bp1_mgmt_dmz2  |
+-----------------+



