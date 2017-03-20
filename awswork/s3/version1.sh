
echo "list bucket in my account!"
aws s3 ls

echo "enable version on bucket s3-demo-frank!"

aws s3api put-bucket-versioning --bucket s3-demo-frank --versioning-configuration Status=Enabled
aws s3api get-bucket-versioning --bucket s3-demo-frank

echo "upload picture for Frank!"
aws s3api put-object --bucket s3-demo-frank --content-type "image/jpeg" --key img/frank.jpg --body ./pic.jpg
aws s3api list-objects --bucket s3-demo-frank

