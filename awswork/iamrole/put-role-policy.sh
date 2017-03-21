##====>Adds or updates an inline policy document that is embedded in the specified IAM role.
aws iam put-role-policy --role-name zcl_role --policy-name ExamplePolicy --policy-document file://inline-policy-ExamplePolicy.json
aws iam put-role-policy --role-name zcl_role --policy-name CloudWatchFullAccess --policy-document file://inline-policy-CloudWatchFullAccess.json
