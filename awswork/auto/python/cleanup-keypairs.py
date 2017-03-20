#!/usr/bin/env python

import boto.ec2, os

#region = os.environ.get("cn-north-1")

connection = boto.ec2.connect_to_region('cn-north-1')

keypairs = connection.get_all_key_pairs()

for k in keypairs:
  if k.name.startswith('qwik'):
    print "Deleting key pair", k.name
    connection.delete_key_pair(k.name)
