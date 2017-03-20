aws s3api list-object-versions --bucket s3-demo-frank --query 'Versions[].{Key: Key, VersionId: VersionId}'
