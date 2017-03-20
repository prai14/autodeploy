# coding=utf8

import boto3
import sys
import os

ec2 = boto3.resource('ec2')

for status in ec2.meta.client.describe_instance_status()['InstanceStatuses']:

    print status
