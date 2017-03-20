#!/bin/bash

#get_redis_list gets a list of available redis clusters that are tagged to backup
get_redis_list() {
  #creates a list of all redis clusters that match the selection string from above
  redis_cluster_list=$(aws elasticache describe-cache-clusters --profile $profile_name --output text --query 'CacheClusters[*].CacheClusterId' 2>&1)
  #takes the output of the previous command
  redis_cluster_list_result=$(echo $?)
  if [[ $redis_cluster_list_result -gt 0 ]]; then
    echo -e "An error occurred when running ec2-describe-cache-clusters. The error returned is below:\n$redis_cluster_list_complete" 1>&2 ; exit 70
  fi
}

create_redis_snapshot_tags() {
  #snapshot tags holds all tags that need to be applied to a given snapshot - by aggregating tags we ensure that add-tags-to-resource is called only onece
  snapshot_tags="Key=CreatedBy,Value=redis-auto-backup"

  #if $purge_after_date_fe is true, then append $purge_after_date_fe to the variable $snapshot_tags
  if [[ -n $purge_after_date_fe ]]; then
    snapshot_tags="$snapshot_tags Key=PurgeAfterFE,Value=$purge_after_date_fe Key=PurgeAllow,Value=true"
  fi

  #if $snapshot_tags is not zero length then set the tag on the snapshot using aws ec2 create-tags
  if [[ -n $snapshot_tags ]]; then
    echo "Tagging Snapshot $redis_cluster_snapshot_name with the following Tags: $snapshot_tags"
    tags_argument="--tags $snapshot_tags"
    redis_cluster_snapshot_create_tag_result="aws elasticache add-tags-to-resource --resource-name arn:aws-cn:elasticache:cn-north-1:$account_id:snapshot:$redis_cluster_snapshot_name $tags_argument --profile $profile_name 2>&1"
    echo $redis_cluster_snapshot_create_tag_result
  fi
}

#aws elasticache add-tags-to-resource --resource-name arn:aws-cn:elasticache:cn-north-1:484879136155:snapshot:sn-ec-ids-life-20161108-01 --tags Key=TimeCreated,Value=20161108 --profile anbang

get_date_binary() {
  #$(uname -o) (operating system) would be ideal, but OS X / Darwin does not support to -o option
  #$(uname) on OS X defaults to $(uname -s) and $(uname) on GNU/Linux defaults to $(uname -s)
  uname_result=$(uname)
  case $uname_result in
    Darwin) date_binary="posix" ;;
    FreeBSD) date_binary="posix" ;;
    Linux) date_binary="linux-gnu" ;;
    *) date_binary="unknown" ;;
  esac
}

get_purge_after_date_fe() {
case $purge_after_input in
  #any number of numbers followed by a letter "d" or "days" multiplied by 86400 (number of seconds in a day)
  [0-9]*d) purge_after_value_seconds=$(( ${purge_after_input%?} * 86400 )) ;;
  #any number of numbers followed by a letter "h" or "hours" multiplied by 3600 (number of seconds in an hour)
  [0-9]*h) purge_after_value_seconds=$(( ${purge_after_input%?} * 3600 )) ;;
  #any number of numbers followed by a letter "m" or "minutes" multiplied by 60 (number of seconds in a minute)
  [0-9]*m) purge_after_value_seconds=$(( ${purge_after_input%?} * 60 ));;
  #no trailing digits default is days - multiply by 86400 (number of minutes in a day)
  *) purge_after_value_seconds=$(( $purge_after_input * 86400 ));;
esac
#based on the date_binary variable, the case statement below will determine the method to use to determine "purge_after_days" in the future
case $date_binary in
  linux-gnu) echo $(date -d +${purge_after_value_seconds}sec -u +%s) ;;
  posix) echo $(date -v +${purge_after_value_seconds}S -u +%s) ;;
  *) echo $(date -d +${purge_after_value_seconds}sec -u +%s) ;;
esac
}

purge_redis_snapshots() {
  # snapshot_purge_allowed is a string containing the SnapshotIDs of snapshots
  # that contain a tag with the key value/pair PurgeAllow=true
  snapshot_purge_allowed=$(aws elasticache describe-snapshots --profile $profile_name --query 'Snapshots[*].SnapshotName')

  for snapshot_name_evaluated in $snapshot_purge_allowed; do
    #gets the "PurgeAfterFE" date which is in UTC with UNIX Time format (or xxxxxxxxxx / %s)
    purge_after_fe=$(aws elasticache describe-snapshots --profile $profile_name --snapshot-name $snapshot_name_evaluated | grep ^TAGS.*PurgeAfterFE | cut -f 3)
    #if purge_after_date is not set then we have a problem. Need to alert user.
    if [[ -z $purge_after_fe ]]; then
      #Alerts user to the fact that a Snapshot was found with PurgeAllow=true but with no PurgeAfterFE date.
      echo "Snapshot with the Snapshot name \"$snapshot_name_evaluated\" has the tag \"PurgeAllow=true\" but does not have a \"PurgeAfterFE=xxxxxxxxxx\" key/value pair. Unable to determine if $snapshot_name_evaluated should be purged." 1>&2
    else
      # if $purge_after_fe is less than $current_date then
      # PurgeAfterFE is earlier than the current date
      # and the snapshot can be safely purged
      if [[ $purge_after_fe < $current_date ]]; then
        echo "Snapshot \"$snapshot_name_evaluated\" with the PurgeAfterFE date of \"$purge_after_fe\" will be deleted."
#        redis_cluster_delete_snapshot_result=$(aws elasticache delete-snapshot --profile $profile_name --snapshot-name $snapshot_name_evaluated 2>&1)
      fi
    fi
  done
}

#date_binary allows a user to set the "date" binary that is installed on their system and, therefore, the options that will be given to the date binary to perform date calculations
account_id="484879136155"   #account id
date_binary=""
profile_name=default
purge_snapshots=false

while getopts :k:p:d opt; do
  case $opt in
#    s) selection_method="$OPTARG" ;;
#    c) cron_primer="$OPTARG" ;;
#    r) region="$OPTARG" ;;
    p) profile_name="$OPTARG" ;;
#    v) volumeid="$OPTARG" ;;
#    t) tag="$OPTARG" ;;
    k) purge_after_input="$OPTARG" ;;
#    n) name_tag_create=true ;;
#    h) hostname_tag_create=true ;;
    d) purge_snapshots=true ;;
#    u) user_tags=true ;;
    *) echo "Error with Options Input. Cause of failure is most likely that an unsupported parameter was passed or a parameter was passed without a corresponding option." 1>&2 ; exit 64 ;;
  esac
done

#sets date variable
current_date=$(date -u +%s)

#sets the PurgeAfterFE tag to the number of seconds that a snapshot should be retained
if [[ -n $purge_after_input ]]; then
  #if the date_binary is not set, call the get_date_binary function
  if [[ -z $date_binary ]]; then
    get_date_binary
  fi
  purge_after_date_fe=$(get_purge_after_date_fe)
  echo "Snapshots will be eligible for purging after the following date (the purge after date given in seconds from epoch): $purge_after_date_fe."
fi

get_redis_list

#the loop below is called once for each redis cluster in $redis_cluster_list - the currently selected redis cluster is passed in as "redis_cluster_id"
for redis_cluster_id in $redis_cluster_list; do
  redis_cluster_tag=$(aws elasticache list-tags-for-resource --resource-name arn:aws-cn:elasticache:cn-north-1:$account_id:cluster:$redis_cluster_id --profile $profile_name --query 'TagList[0].Value' --output text 2>&1)

  if [[ "$redis_cluster_tag" = "True" ]]; then
  #if the tag name "Backup" has a value of "True", then create snapshot for the cluster
    redis_cluster_snapshot_name="sn-${redis_cluster_id}-$current_date"
    redis_cluster_snapshot_status=$(aws elasticache create-snapshot --cache-cluster-id $redis_cluster_id --snapshot-name $redis_cluster_snapshot_name --profile $profile_name --output json --query 'Snapshot.SnapshotStatus' 2>&1)

    if [[ $? != 0 ]]; then
        echo -e "An error occurred when running elasticache-create-snapshot. The error returned is below:\n$elasticache_create_snapshot_result" 1>&2 ; exit 70
    fi
    echo -e "Snapshot $redis_cluster_snapshot_name has been created with the status: $redis_cluster_snapshot_status\n"
    create_redis_snapshot_tags
  fi
done

#if purge_snapshots is true, then run purge_redis_snapshots function
if $purge_snapshots; then
  echo "Snapshot Purging is Starting Now."
  purge_redis_snapshots
fi
