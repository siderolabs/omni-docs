---
title: "Register an AWS EC2 Instance"
description: "A tutorial on registering an AWS EC2 instance with Omni."
date: 2022-10-29T15:35:30-07:00
draft: false
weight: 20
---

In this tutorial you will download an AWS image from the Omni portal, import the image as an AMI in AWS, create a VPC, create a subnet, create a security group, and register an AWS EC2 instance with Omni.

## Set your AWS region

In this tutorial, we will assume us-west-2, but you can set it to whatever AWS region you like:

```
REGION="us-west-2"
```

## Creating the subnet

First, we need to know what VPC to create the subnet on, so let's describe the VPCs in the region where we want to create the Omni machines.

```
$ aws ec2 describe-vpcs --region $REGION
{
    "Vpcs": [
        {
            "CidrBlock": "172.31.0.0/16",
            "DhcpOptionsId": "dopt-0238fea7541672af0",
            "State": "available",
            "VpcId": "vpc-04ea926270c55d724",
            "OwnerId": "753518523373",
            "InstanceTenancy": "default",
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-0e518f7ac9d02907d",
                    "CidrBlock": "172.31.0.0/16",
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ],
            "IsDefault": true
        }
    ]
}

```

Note the `VpcId` (`vpc-04ea926270c55d724`).

Now, create a subnet on that VPC with a CIDR block that is within the CIDR block of the VPC.
In the above example, as the VPC has a CIDR block of 172.31.0.0/16, we can use 172.31.128.0/20.

```
$ aws ec2 create-subnet \
    --vpc-id vpc-04ea926270c55d724 \
    --region us-west-2 \
    --cidr-block 172.31.128.0/20
{
    "Subnet": {
        "AvailabilityZone": "us-west-2c",
        "AvailabilityZoneId": "usw2-az3",
        "AvailableIpAddressCount": 4091,
        "CidrBlock": "172.31.192.0/20",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-04f4d6708a2c2fb0d",
        "VpcId": "vpc-04ea926270c55d724",
        "OwnerId": "753518523373",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "SubnetArn": "arn:aws:ec2:us-west-2:753518523373:subnet/subnet-04f4d6708a2c2fb0d",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```

Note the `SubnetID` (`subnet-04f4d6708a2c2fb0d`).

## Create the Security Group

```bash
$ aws ec2 create-security-group \
    --region $REGION \
    --group-name omni-aws-tutorial-sg \
    --description "Security Group for Omni EC2 instances"
{
    "GroupId": "sg-0b2073b72a3ca4b03"
}
```

Note the `GroupId` (`sg-0b2073b72a3ca4b03`).

Allow all internal traffic within the same security group, so that Kubernetes applications can talk to each other on different machines:

```bash
aws ec2 authorize-security-group-ingress \
    --region $REGION \
    --group-name omni-aws-tutorial-sg \
    --protocol all \
    --port 0 \
    --source-group omni-aws-tutorial-sg
```

## Creating the bootable AMI

To do so, log in to your Omni account, and, from the Omni overview page, select "Download Installation Media".
Select "AWS AMI (amd64)" or "AWS AMI (arm64)", as appropriate for your desired EC2 instances.
(Most are amd64.)
Click "Download", and the AMI will be downloaded to you local machine.

Extract the downloaded `aws-amd64.tar.gz`
Then copy the `disk.raw` file to S3.
We need to create a bucket, copy the image file to it, import it as a snapshot, then register an AMI image from it.

### Create S3 bucket

```
REGION="us-west-2"
aws s3api create-bucket \
    --bucket <bucket name> \
    --create-bucket-configuration LocationConstraint=$REGION \
    --acl private
```

### Copy image file to the bucket

```
aws s3 cp disk.raw s3://<bucket name>/omni-aws-tutorial.raw
```

### Import the image as a snapshot

```
$ aws ec2 import-snapshot \
    --region $REGION \
    --description "Omni AWS tutorial" \
    --disk-container "Format=raw,UserBucket={S3Bucket=<bucket name>,S3Key=omni-aws-tutorial.raw}"
{
    "Description": "Omni AWS tutorial",
    "ImportTaskId": "import-snap-1234567890abcdef0",
    "SnapshotTaskDetail": {
        "Description": "Omni AWS tutorial",
        "DiskImageSize": "0.0",
        "Format": "RAW",
        "Progress": "3",
        "Status": "active",
        "StatusMessage": "pending"
        "UserBucket": {
            "S3Bucket": "<bucket name>",
            "S3Key": "omni-aws-tutorial.raw"
        }
    }
}
```

Check the status of the import with:

```
$ aws ec2 describe-import-snapshot-tasks \
    --region $REGION \
    --import-task-ids
{
    "ImportSnapshotTasks": [
        {
            "Description": "Omni AWS tutorial",
            "ImportTaskId": "import-snap-1234567890abcdef0",
            "SnapshotTaskDetail": {
                "Description": "Omni AWS tutorial",
                "DiskImageSize": "705638400.0",
                "Format": "RAW",
                "Progress": "42",
                "Status": "active",
                "StatusMessage": "downloading/converting",
                "UserBucket": {
                    "S3Bucket": "<bucket name>",
                    "S3Key": "omni-aws-tutorial.raw"
                }
            }
        }
    ]
}
```

Once the `Status` is `completed` note the `SnapshotId` (`snap-0298efd6f5c8d5cff`).

## Register the Image

```
$ aws ec2 register-image \
    --region $REGION \
    --block-device-mappings "DeviceName=/dev/xvda,VirtualName=talos,Ebs={DeleteOnTermination=true,SnapshotId=$SNAPSHOT,VolumeSize=4,VolumeType=gp2}" \
    --root-device-name /dev/xvda \
    --virtualization-type hvm \
    --architecture x86_64 \
    --ena-support \
    --name omni-aws-tutorial-ami
{
    "ImageId": "ami-07961b424e87e827f"
}
```

Note the `ImageId` (`ami-07961b424e87e827f`).

## Create EC2 instances from the AMI

Now, using the AMI we created, along with the security group created above, provision EC2 instances:

```
 aws ec2 run-instances \
    --region  $REGION \
    --image-id ami-07961b424e87e827f \
    --count 1 \
    --instance-type t3.small   \
    --subnet-id subnet-0a7f5f87f62c301ea \
    --security-group-ids $SECURITY_GROUP   \
    --associate-public-ip-address \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=omni-aws-tutorial-ami}]" \
    --instance-market-options '{"MarketType":"spot"}'
```
