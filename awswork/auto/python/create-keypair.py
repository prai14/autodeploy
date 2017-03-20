#!/usr/bin/env python

import boto.ec2, os

#region = os.environ.get('EC2_REGION')

connection = boto.ec2.connect_to_region("cn-north-1")

key = connection.create_key_pair('beer')

print key.material
