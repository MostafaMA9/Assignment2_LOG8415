import subprocess
import boto3
import os
from dotenv import load_dotenv
from functions import *

# Install required Python packages
subprocess.check_call(['pip', 'install', '-r', 'requirements.txt'])

# Load AWS credentials from credentials.env
load_dotenv("credentials.env")
aws_access_key_id = os.environ["aws_access_key_id"]
aws_secret_access_key = os.environ["aws_secret_access_key"]
aws_session_token = os.environ["aws_session_token"]

# Define EC2 instance parameters
keyPairName = 'LOG8415E'
securityGroupName = 'LOG8415E_B2'

# Create an EC2 client
EC2 = boto3.client(
    'ec2',
    region_name="us-east-1",
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    aws_session_token=aws_session_token
)

# get vpc_id
vpc_id = EC2.describe_vpcs().get('Vpcs', [{}])[0].get('VpcId', '')
subnet = EC2.describe_subnets().get('Subnets', [{}])[0].get('SubnetId', '')

# create key pair and security group
print('Creating key pair...')
create_key_pair(EC2, keyPairName)
print('Creating security group...')
security_group = create_security_group(EC2, securityGroupName, vpc_id)

# Create 1 m4.large instances
instance_id = create_m4large_instance(EC2, keyPairName, securityGroupName, subnet)

input("Press Enter to delete everything...")

print("Terminating instance...")
terminate_instance(EC2, instance_id)

print("Deleting security group...")
delete_security_group(EC2, securityGroupName)

print("Deleting key pair...")
delete_key_pair(EC2, keyPairName)