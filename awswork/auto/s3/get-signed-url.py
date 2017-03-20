import boto
import boto.s3.connection
conn = boto.connect_s3('AKIAJY5L5VVT43XLQSMA','BmIkodiu+Mz6XmCDcWGadcFGQB9RCrJC/uzFU1A/')
bucket = conn.get_bucket('s3-demo-frank')
for key in bucket.list():
        print "{name}\t{size}\t{modified}".format(
                name = key.name,
                size = key.size,
                modified = key.last_modified,
                )
plans_key = bucket.get_key('superman.png')
plans_url = plans_key.generate_url(3600, query_auth=True, force_http=True)
print plans_url
