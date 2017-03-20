import boto3
import collections
import datetime
import csv
from time import gmtime, strftime
# import smtplib
# from email.MIMEMultipart import MIMEMultipart
# from email.MIMEBase import MIMEBase
# from email.MIMEText import MIMEText
# from email import Encoders
import os
import sys
import getopt
profile = ''
try:
    opts, args = getopt.getopt(sys.argv[1:], "p:")
except getopt.GetoptError as e:
    print (str(e))
    print("Usage: %s -p profile_name" % sys.argv[0])
    sys.exit(2)
# print 'Argument List:', str(sys.argv)
for opt, arg in opts:
    if opt == '-p':
        profile = str(arg)
#        print 'profile is "', profile
try:
    session = boto3.session.Session(profile_name=profile)
except:
    print("Profile %s does not exist!" % profile)
    print("Usage: %s -p profile_name. for example: %s -p default" %
          (sys.argv[0], sys.argv[0]))
    sys.exit(2)
# EC2 connection beginning
ec = session.client('ec2')
ec2 = session.resource('ec2')
# S3 connection beginning
# s3 = boto3.resource('s3')
# get to the curren date
date_fmt = strftime("%Y_%m_%d", gmtime())
# Give your file path
filepath = './PUC_AWS_Resources_' + profile + '_' + date_fmt + '.csv'
# Give your filename
filename = 'PUC_AWS_Resources_' + profile + '_' + date_fmt + '.csv'
csv_file = open(filepath, 'w+')
# Get your owner ID
reservations = ec.describe_instances().get('Reservations', [])
account_ids = reservations[0]['OwnerId']

# boto3 library ec2 API describe region page
# http://boto3.readthedocs.org/en/latest/reference/services/ec2.html#EC2.Client.describe_regions
regions = ec.describe_regions().get('Regions', [])
Instancename = ""
instance_contact = ""
instance_tier = ""
instance_project = ""
instance_creator = ""
instance_security_group = ""
instance_environment = ""
instance_public_ip_address = ""
instance_private_ip_address = ""
instance_keyname = ""


for region in regions:
    reg = region['RegionName']
    regname = 'REGION :' + reg
    # EC2 connection beginning
    ec2con = session.client('ec2', region_name=reg)
    # boto3 library ec2 API describe instance page
    # http://boto3.readthedocs.org/en/latest/reference/services/ec2.html#EC2.Client.describe_instances
    reservations = ec2con.describe_instances().get(
        'Reservations', []
    )
    instances = sum(
        [
            [i for i in r['Instances']]
            for r in reservations
        ], [])
    instanceslist = len(instances)
    if instanceslist > 0:
        csv_file.write("%s,%s,%s,%s,%s,%s\n" % ('', '', '', '', '', ''))
        csv_file.write("%s,%s\n" % ('EC2 INSTANCE', regname))
        csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % ('InstanceID', 'Instance_State',
                                                                              'InstanceName', 'Instance_Type', 'LaunchTime', 'Instance_Placement', 'VPC_Id', 'Contact', 'Environment', 'Project', 'Creator', 'Tier', 'Private IP Address', 'Public IP Address', 'Security Group', 'Key Name'))
        csv_file.flush()

    for instance in instances:
        state = instance['State']['Name']
        try:
            Instancename = instance['KeyName']
        except:
            Instancename = ""
        instancetype = ""
        if state == 'running':
            instanceid = instance['InstanceId']
            instancetype = instance['InstanceType']
            launchtime = instance['LaunchTime']
            Placement = instance['Placement']['AvailabilityZone']
            try:
                instance_keyname = instance['KeyName']
            except:
                instance_keyname = ""
            VpcId = instance['VpcId']
            instance_public_ip_address = ""
            if instance['PublicDnsName'] != "":
                instance_public_ip_address = instance['PublicIpAddress']
            instance_private_ip_address = instance['PrivateIpAddress']
            try:
                sg = instance['SecurityGroups'][0]
            except:
                instance_security_group = ""
            else:
                instance_security_group = ""
                for sg in instance['SecurityGroups']:
                    instance_security_group = instance_security_group + \
                        sg['GroupName'] + " "
            # instance_security_group = instance[
            #    'SecurityGroups'][0]['GroupName']
            try:
                tags = instance['Tags']
            except:
                Instancename = ""
                instance_contact = ""
                instance_tier = ""
                instance_project = ""
                instance_environment = ""
                instance_creator = ""
            else:
                for tags in instance['Tags']:
                    key = tags['Key']
                    if key == 'Name':
                        Instancename = tags['Value']
                    if key == 'Contact':
                        instance_contact = tags['Value']
                    if key == 'Tier':
                        instance_tier = tags['Value']
                    if key == 'Project':
                        instance_project = tags['Value']
                    if key == 'Environment':
                        instance_environment = tags['Value']
                    if key == 'Creator':
                        instance_creator = tags['Value']
            csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % (instanceid, state, Instancename, instancetype, launchtime, Placement, VpcId, instance_contact,
                                                                                  instance_environment, instance_project, instance_creator, instance_tier, instance_private_ip_address, instance_public_ip_address, instance_security_group, instance_keyname))
            csv_file.flush()
    instancetype = ""
    instance_keyname = ""
    for instance in instances:
        state = instance['State']['Name']
        if state == 'stopped':
            # for tags in instance['Tags']:
            #    Instancename = tags['Value']
            #    key = tags['Key']
            # if key == 'Name':
            #        instanceid = instance['InstanceId']
            #        instancetype = instance['InstanceType']
            #        launchtime = instance['LaunchTime']
            #        Placement = instance['Placement']['AvailabilityZone']
            #        VpcId = instance['VpcId']
            #        csv_file.write("%s,%s,%s,%s,%s,%s,%s\n" % (
            #            instanceid, state, Instancename, instancetype, launchtime, Placement, VpcId))
            #        csv_file.flush()
            instanceid = instance['InstanceId']
            instancetype = instance['InstanceType']
            launchtime = instance['LaunchTime']
            Placement = instance['Placement']['AvailabilityZone']
            instance_keyname = instance['KeyName']
            VpcId = instance['VpcId']
            if instance['PublicDnsName'] != "":
                instance_public_ip_address = instacne['PublicIpAddress']
            instance_private_ip_address = instance['PrivateIpAddress']
        #    try:
        #        sg = instance['SecurityGroups'][0]
        #    except:
        #        instance_security_group = ""
            # if len(instance['SecurityGroups']) > 0:
            try:
                sg = instance['SecurityGroups'][0]
            except:
                instance_security_group = ""
            else:
                instance_security_group = ""
                for sg in instance['SecurityGroups']:
                    instance_security_group = instance_security_group + \
                        sg['GroupName'] + " "
            try:
                tags = instance['Tags']
            except:
                Instancename = ""
                instance_contact = ""
                instance_tier = ""
                instance_project = ""
                instance_environment = ""
                instance_creator = ""
            else:
                for tags in instance['Tags']:
                    key = tags['Key']
                    if key == 'Name':
                        Instancename = tags['Value']
                    if key == 'Contact':
                        instance_contact = tags['Value']
                    if key == 'Tier':
                        instance_tier = tags['Value']
                    if key == 'Project':
                        instance_project = tags['Value']
                    if key == 'Environment':
                        instance_environment = tags['Value']
                    if key == 'Creator':
                        instance_creator = tags['Value']
            csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % (instanceid, state, Instancename, instancetype, launchtime, Placement, VpcId, instance_contact,
                                                                                  instance_environment, instance_project, instance_creator, instance_tier, instance_private_ip_address, instance_public_ip_address, instance_security_group, instance_keyname))
            csv_file.flush()
# boto3 library ec2 API describe volumes page
# http://boto3.readthedocs.org/en/latest/reference/services/ec2.html#EC2.Client.describe_volumes
ec2volumes = ec2con.describe_volumes().get('Volumes', [])
Backup = ""
Size = ""

used_volumes = sum(
    [
        [i for i in r['Attachments']]
        for r in ec2volumes
    ], [])
volumeslist = len(used_volumes)
if volumeslist > 0:
    csv_file.write("%s,%s,%s,%s\n" % ('', '', '', ''))
    csv_file.write("%s,%s\n" % ('In-Use EBS Volume', regname))
    csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" %
                   ('VolumeId', 'InstanceId', 'AttachTime', 'State', 'Size', 'InstanceName', 'IOPS', 'DeleteOnTermination', 'VolumeType', 'SnapShotId', 'Backup'))
    csv_file.flush()

    for volume in used_volumes:
        VolumeId = volume['VolumeId']
        InstanceId = volume['InstanceId']
        State = volume['State']
        AttachTime = volume['AttachTime']
        Backup = ""
        v = ec2.Volume(VolumeId)
        if v.tags is not None:
            for tag in v.tags:
                if tag["Key"] == 'Backup':
                    Backup = tag["Value"]
        Size = v.size
        IOPS = v.iops
        VolumeType = v.volume_type
        SnapShotId = v.snapshot_id
        attachments = v.attachments
        for attachment in attachments:
            if attachment["DeleteOnTermination"] != "":
                DeleteOnTermination = attachment["DeleteOnTermination"]
        # Size = volume['Size']
        Instance = ec2.Instance(InstanceId)
        for tags in Instance.tags:
            if tags["Key"] == 'Name':
                InstanceName = tags["Value"]
        csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" %
                       (VolumeId, InstanceId, AttachTime, State, Size, InstanceName, IOPS, DeleteOnTermination, VolumeType, SnapShotId, Backup))
        csv_file.flush()

 # list all unused volumes
csv_file.write("%s,%s,%s,%s\n" % ('', '', '', ''))
csv_file.write("%s,%s\n" % ('Avaiable EBS Volume', regname))
csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" %
               ('VolumeId', 'InstanceId', 'AttachTime', 'State', 'Size', 'InstanceName', 'IOPS', 'DeleteOnTermination', 'VolumeType', 'SnapShotId', 'Backup'))
csv_file.flush()
try:
    volume = ec2volumes[0]
except:
    VolumeId = ""
    InstanceId = ""
    AttachTime = ""
    State = ""
    Size = ""
    InstanceName = ""
    IOPS = ""
    VolumeType = ""
    SnapShotId = ""
    DeleteOnTermination = ""
    Backup = ""
else:
    for volume in ec2volumes:
        if volume["State"] == "available":
            VolumeId = volume["VolumeId"]
            InstanceId = ""
            AttachTime = ""
            State = volume["State"]
            Size = volume["Size"]
            InstanceName = ""
            IOPS = volume["Iops"]
            VolumeType = volume["VolumeType"]
            SnapShotId = volume["SnapshotId"]
            DeleteOnTermination = ""
            v = ec2.Volume(VolumeId)
            Backup = ""
            if v.tags is not None:
                for tag in v.tags:
                    if tag["Key"] == 'Backup':
                        Backup = tag["Value"]
csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" %
               (VolumeId, InstanceId, AttachTime, State, Size, InstanceName, IOPS, DeleteOnTermination, VolumeType, SnapShotId, Backup))
csv_file.flush()

# boto3 library ec2 API describe snapshots page
# http://boto3.readthedocs.org/en/latest/reference/services/ec2.html#EC2.Client.describe_snapshots
ec2snapshot = ec2con.describe_snapshots(
    OwnerIds=[account_ids, ],).get('Snapshots', [])
ec2snapshotlist = len(ec2snapshot)
if ec2snapshotlist > 0:
    csv_file.write("%s,%s,%s,%s\n" % ('', '', '', ''))
    csv_file.write("%s,%s\n" % ('EC2 SNAPSHOT', regname))
    csv_file.write("%s,%s,%s,%s\n" % (
        'SnapshotId', 'VolumeId', 'StartTime', 'VolumeSize'))
    csv_file.flush()
for snapshots in ec2snapshot:
    SnapshotId = snapshots['SnapshotId']
    VolumeId = snapshots['VolumeId']
    StartTime = snapshots['StartTime']
    VolumeSize = snapshots['VolumeSize']
    csv_file.write("%s,%s,%s,%s\n" %
                   (SnapshotId, VolumeId, StartTime, VolumeSize))
    csv_file.flush()

# boto3 library ec2 API describe addresses page
# http://boto3.readthedocs.org/en/latest/reference/services/ec2.html#EC2.Client.describe_addresses
addresses = ec2con.describe_addresses().get('Addresses', [])
addresseslist = len(addresses)
if addresseslist > 0:
    csv_file.write("%s,%s,%s,%s,%s\n" % ('', '', '', '', ''))
    csv_file.write("%s,%s\n" % ('EIPS INSTANCE', regname))
    csv_file.write("%s,%s,%s,%s\n" %
                   ('PublicIp', 'InstanceName', 'AllocationId', 'Domain'))
    csv_file.flush()
for address in addresses:
    PublicIp = address['PublicIp']
    AllocationId = address['AllocationId']
    Domain = address['Domain']
    try:
        InstanceId = address['InstanceId']
    except KeyError:
        InstanceName = ""
    else:
        Instance = ec2.Instance(InstanceId)
        InstanceName = ""
        for tags in Instance.tags:
            if tags["Key"] == 'Name':
                InstanceName = tags["Value"]
    csv_file.write("%s,%s,%s,%s\n" %
                   (PublicIp, InstanceName, AllocationId, Domain))
    csv_file.flush()

# RDS Connection beginning
rdscon = session.client('rds', region_name=reg)
# boto3 library RDS API describe db instances page
# http://boto3.readthedocs.org/en/latest/reference/services/rds.html#RDS.Client.describe_db_instances
rdb = rdscon.describe_db_instances().get('DBInstances', [])
rdblist = len(rdb)
if rdblist > 0:
    csv_file.write("%s,%s,%s,%s\n" % ('', '', '', ''))
    csv_file.write("%s,%s\n" % ('RDS INSTANCE', regname))
    csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % (
        'DBInstanceIdentifier', 'DBInstanceStatus', 'Engine', 'EngineVersion', 'MultiAZ', 'DBInstanceClass', 'AllocatedStorage', 'StorageType', 'Iops', 'DBInstanceEndpoint', 'BackupRetentionPeriod'))
    csv_file.flush()
for dbinstance in rdb:
    DBInstanceIdentifier = dbinstance['DBInstanceIdentifier']
    DBInstanceClass = dbinstance['DBInstanceClass']
    DBName = dbinstance['Engine']
    EngineVersion = dbinstance['EngineVersion']
    StorageType = dbinstance['StorageType']
    DBInstanceStatus = dbinstance['DBInstanceStatus']
    MultiAZ = dbinstance['MultiAZ']
    AllocatedStorage = dbinstance['AllocatedStorage']
    DBInstanceEndpoint = dbinstance['Endpoint'][
        'Address'] + ":" + str(dbinstance['Endpoint']['Port'])
    BackupRetentionPeriod = dbinstance['BackupRetentionPeriod']
    Iops = ""
    if StorageType != "gp2":
        Iops = str(dbinstance['Iops'])
    csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % (
        DBInstanceIdentifier, DBInstanceStatus, DBName, EngineVersion, str(MultiAZ), DBInstanceClass,  AllocatedStorage, StorageType, Iops, DBInstanceEndpoint, str(BackupRetentionPeriod)))
    csv_file.flush()

# ElastiCache Connection beginning
eccon = session.client('elasticache', region_name=reg)
# boto3 library ElatiCache API describe db instances page
# http://boto3.readthedocs.io/en/latest/reference/services/elasticache.html#ElastiCache.Client.describe_cache_clusters
cache = eccon.describe_cache_clusters().get('CacheClusters', [])
cachelist = len(cache)
if cachelist > 0:
    csv_file.write("%s,%s,%s,%s\n" % ('', '', '', ''))
    csv_file.write("%s,%s\n" % ('CACHE', regname))
    csv_file.write("%s,%s,%s,%s,%s\n" % (
        'CacheClusterId', 'CacheClusterStatus', 'Engine', 'EngineVersion', 'CacheNodeType'))
    csv_file.flush()
for cacheinstance in cache:
    CacheClusterId = cacheinstance['CacheClusterId']
    CacheNodeType = cacheinstance['CacheNodeType']
    CacheClusterStatus = cacheinstance['CacheClusterStatus']
    CacheEngine = cacheinstance['Engine']
    EngineVersion = cacheinstance['EngineVersion']
    csv_file.write("%s,%s,%s,%s,%s\n" % (
        CacheClusterId, CacheClusterStatus, CacheEngine, EngineVersion, CacheNodeType))
    csv_file.flush()

# Elb Connection beginning
elbcon = session.client('elb', region_name=reg)
# boto3 library ELB API describe db instances page
# http://boto3.readthedocs.org/en/latest/reference/services/elb.html#ElasticLoadBalancing.Client.describe_load_balancers
loadbalancer = elbcon.describe_load_balancers().get('LoadBalancerDescriptions', [])
loadbalancerlist = len(loadbalancer)
if loadbalancerlist > 0:
    csv_file.write("%s,%s,%s,%s\n" % ('', '', '', ''))
    csv_file.write("%s,%s\n" % ('ELB INSTANCE', regname))
    csv_file.write("%s,%s,%s\n" % ('LoadBalancerName', 'DNSName',
                                   'CanonicalHostedZoneNameID'))
    csv_file.flush()
for load in loadbalancer:
    LoadBalancerName = load['LoadBalancerName']
    DNSName = load['DNSName']
    CanonicalHostedZoneNameID = load['CanonicalHostedZoneNameID']
    csv_file.write("%s,%s,%s\n" % (
        LoadBalancerName, DNSName, CanonicalHostedZoneNameID))
    csv_file.flush()

# Elb v2 Connection beginning
elbcon = session.client('elbv2', region_name=reg)
# boto3 library ELB v2 API describe db instances page
# http://boto3.readthedocs.io/en/latest/reference/services/elbv2.html#ElasticLoadBalancingv2.Client.describe_load_balancers
loadbalancer = elbcon.describe_load_balancers().get('LoadBalancers', [])
loadbalancerlist = len(loadbalancer)
if loadbalancerlist > 0:
    csv_file.write("%s,%s,%s,%s\n" % ('', '', '', ''))
    csv_file.write("%s,%s\n" % ('ELBv2 INSTANCE', regname))
    csv_file.write("%s,%s,%s\n" % ('LoadBalancerName', 'DNSName',
                                   'CanonicalHostedZoneId'))
    csv_file.flush()
for load in loadbalancer:
    LoadBalancerName = load['LoadBalancerName']
    DNSName = load['DNSName']
    CanonicalHostedZoneId = load['CanonicalHostedZoneId']
    csv_file.write("%s,%s,%s\n" % (
        LoadBalancerName, DNSName, CanonicalHostedZoneId))
    csv_file.flush()

