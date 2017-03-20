import boto.ec2, os

region = os.environ.get('cn_north_1')

connection = boto.ec2.connect_to_region(region)

keypairs = connection.get_all_key_pairs()

for k in keypairs:
  if not k.name.startswith('qwik'):
    print "Deleting key pair", k.name
    connection.delete_key_pair(k.name)
