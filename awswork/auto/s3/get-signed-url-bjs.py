import boto
import boto.s3.connection
conn = boto.connect_s3('AKIAPTH5QQLUYX2UT2NQ','fsrbcW6wPPO3rtZ2GNGT4EkH+xTUH4jxOAINu8DE')
from boto.s3.connection import Location
print '\n'.join(i for i in dir(Location) if i[0].isupper())
bucket = conn.get_bucket('s3-demo-frank',location=Location.CNNorth1)
for key in bucket.list():
        print "{name}\t{size}\t{modified}".format(
                name = key.name,
                size = key.size,
                modified = key.last_modified,
                )
plans_key = bucket.get_key('frank.jpg')
plans_url = plans_key.generate_url(3600, query_auth=True, force_http=True)
print plans_url
