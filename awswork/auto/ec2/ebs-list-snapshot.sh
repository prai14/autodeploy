aws ec2 describe-snapshots --filters "Name=volume-id,Values=vol-56e73b4f" --query 'Snapshots[*].SnapshotId'

