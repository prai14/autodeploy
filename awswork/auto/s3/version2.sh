echo "upload new photo for Frank!!"
aws s3api put-object --bucket s3-demo-frank --content-type "image/jpeg" --key img/frank.jpg --body ./pic-new.jpeg
aws s3api list-object-versions --bucket s3-demo-frank

