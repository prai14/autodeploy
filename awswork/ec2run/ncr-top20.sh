####20170223 top20
testkp=$(aws ec2 describe-key-pairs --filter Name=key-name,Values="test*" --output text|awk '{print $3}')


##
./launch-ec2.sh ami-8b3fe8e6 c3.xlarge 10/90 test_kp_abfinance test_sg_app_abfinance bt1_abfinance_ext1 role_test_abfinance abf-aws

./launch-ec2.sh ami-4a3dea27 c3.xlarge 10/500 test_kp_abfinance test_sg_db_abfinance bt1_abfinance_int1 role_test_abfinance abf-aws

./launch-ec2.sh ami-c03becad c3.xlarge 10/90 test_kp_abfinance test_sg_app_abfinance bt1_abfinance_ext1 role_test_abfinance abf-aws
