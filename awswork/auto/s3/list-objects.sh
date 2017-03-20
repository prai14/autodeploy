aws s3api list-objects --bucket awsu-pub --query 'Contents[?Size !=`500`].[Key,Size,LastModified]' --output json
