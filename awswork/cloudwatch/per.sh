aws cloudwatch get-metric-statistics --metric-name WriteIOPS --start-time 2016-12-07T00:00:00  --end-time 2016-12-07T00:10:00 --period 60 --namespace AWS/RDS --statistics Average Maximum Minimum  --dimensions Name=DBInstanceIdentifier,Value=yc-db-internetds-life-xqyhb-db01 --query Datapoints[].[Timestamp,Maximum,Minimum,Average] --output text|sort -t ',' -k 1

