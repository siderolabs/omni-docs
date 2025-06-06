---
description: A guide on how to register AWS EC2 instances with Omni.
---

# Register an AWS EC2 Instance

### Set your AWS region <a href="#set-your-aws-region" id="set-your-aws-region"></a>

```
REGION="us-west-2"
```

### Creating the subnet <a href="#creating-the-subnet" id="creating-the-subnet"></a>

First, we need to know what VPC to create the subnet on, so let’s describe the VPCs in the region where we want to create the Omni machines.

```
aws ec2 describe-vpcs --region $REGION
```

Output:

```

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

Now, create a subnet on that VPC with a CIDR block that is within the CIDR block of the VPC. In the above example, as the VPC has a CIDR block of 172.31.0.0/16, we can use 172.31.128.0/20.

```
$ aws ec2 create-subnet \
    --vpc-id vpc-04ea926270c55d724 \
    --region us-west-2 \
    --cidr-block 172.31.128.0/20
```

Output:

```
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

### Create the Security Group <a href="#create-the-security-group" id="create-the-security-group"></a>

```bash
aws ec2 create-security-group \
    --region $REGION \
    --group-name omni-aws-sg \
    --description "Security Group for Omni EC2 instances"

```

Output

```
{   
     "GroupId": "sg-0b2073b72a3ca4b03"
}
```



Note the `GroupId` (`sg-0b2073b72a3ca4b03`).

Allow all internal traffic within the same security group, so that Kubernetes applications can talk to each other on different machines:

```bash
aws ec2 authorize-security-group-ingress \
    --region $REGION \
    --group-name omni-aws-sg \
    --protocol all \
    --port 0 \
    --source-group omni-aws-sg
```

### Creating the bootable AMI <a href="#creating-the-bootable-ami" id="creating-the-bootable-ami"></a>

To do so, log in to your Omni account, and, from the Omni overview page, select “Download Installation Media”. Select “AWS AMI (amd64)” or “AWS AMI (arm64)”, as appropriate for your desired EC2 instances. (Most are amd64.) Click “Download”, and the AMI will be downloaded to you local machine.

Extract the downloaded `aws-amd64.tar.gz` Then copy the `disk.raw` file to S3. We need to create a bucket, copy the image file to it, import it as a snapshot, then register an AMI image from it.

#### Create S3 bucket <a href="#create-s3-bucket" id="create-s3-bucket"></a>

```
REGION="us-west-2"
aws s3api create-bucket \
    --bucket <bucket name> \
    --create-bucket-configuration LocationConstraint=$REGION \
    --acl private
```

#### Copy image file to the bucket <a href="#copy-image-file-to-the-bucket" id="copy-image-file-to-the-bucket"></a>

```
aws s3 cp disk.raw s3://<bucket name>/omni-aws.raw
```

#### Import the image as a snapshot <a href="#import-the-image-as-a-snapshot" id="import-the-image-as-a-snapshot"></a>

```
aws ec2 import-snapshot \
    --region $REGION \
    --description "Omni AWS" \
    --disk-container "Format=raw,UserBucket={S3Bucket=<bucket name>,S3Key=omni-aws.raw}"

```

Output:

```
{
    "Description": "Omni AWS",
    "ImportTaskId": "import-snap-1234567890abcdef0",
    "SnapshotTaskDetail": {
        "Description": "Omni AWS",
        "DiskImageSize": "0.0",
        "Format": "RAW",
        "Progress": "3",
        "Status": "active",
        "StatusMessage": "pending"
        "UserBucket": {
            "S3Bucket": "<bucket name>",
            "S3Key": "omni-aws.raw"
        }
    }
}
```

Check the status of the import with:

```
aws ec2 describe-import-snapshot-tasks \
    --region $REGION \
    --import-task-ids
```

Output:

```json
While the import is in progress:
{
    "ImportSnapshotTasks": [
        {
            "Description": "Omni AWS",
            "ImportTaskId": "import-snap-1234567890abcdef0",
            "SnapshotTaskDetail": {
                "Description": "Omni AWS",
                "DiskImageSize": "705638400.0",
                "Format": "RAW",
                "Progress": "42",
                "Status": "active",
                "StatusMessage": "downloading/converting",
                "UserBucket": {
                    "S3Bucket": "<bucket name>",
                    "S3Key": "omni-aws.raw"
                }
            }
        }
    ]
}

Once completed:
{
    "ImportSnapshotTasks": [
        {
            "Description": "Omni AWS",
            "ImportTaskId": "import-snap-1234567890abcdef0",
            "SnapshotTaskDetail": {
                "DiskImageSize": 8589934592.0,
                "Format": "raw",
                "SnapshotId": "snap-056a7e086ecf7b452",
                "Status": "completed",
                "UserBucket": {
                    "S3Bucket": "<bucket name>",
                    "S3Key": "omni-aws.raw"
                }
            },
            "Tags": []
        }
    ]
}
```

Once the `Status` is `completed` note the `SnapshotId` (snap-056a7e086ecf7b452).

### Register the Image <a href="#register-the-image" id="register-the-image"></a>

```
aws ec2 register-image \
    --region $REGION \
    --block-device-mappings "DeviceName=/dev/xvda,VirtualName=talos,Ebs={DeleteOnTermination=true,SnapshotId=$SNAPSHOT,VolumeSize=8,VolumeType=gp2}" \
    --root-device-name /dev/xvda \
    --virtualization-type hvm \
    --architecture x86_64 \
    --ena-support \
    --name omni-aws-ami
```

Output:

```
{
    "ImageId": "ami-07961b424e87e827f"
}
```

Note the `ImageId` (`ami-07961b424e87e827f`).

### Create EC2 instances from the AMI <a href="#create-ec2-instances-from-the-ami" id="create-ec2-instances-from-the-ami"></a>

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
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=omni-aws-ami}]" \
    --instance-market-options '{"MarketType":"spot"}'
```
