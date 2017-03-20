aws iam create-role --role-name Test-Role --assume-role-policy-document file://Test-Role-Trust-Policy.json
aws iam put-role-policy --role-name Test-Role --policy-name ExamplePolicy --policy-document file://AdminPolicy.json
aws iam create-instance-profile --instance-profile-name Webserver
aws iam add-role-to-instance-profile --role-name S3Access --instance-profile-name Webserver
