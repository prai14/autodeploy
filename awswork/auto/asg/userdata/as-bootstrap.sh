#!/bin/sh
yum -y install httpd php mysql php-mysql
chkconfig httpd on
/etc/init.d/httpd start
cd /tmp
wget http://us-east-1-aws-training.s3.amazonaws.com/self-paced-lab-4/examplefiles-as.zip
unzip examplefiles-as.zip
mv examplefiles-as/* /var/www/html
