# app.py
import subprocess
from functions import *
from dotenv import load_dotenv
import boto3
import time
import os

# Load AWS credentials from credentials.env
load_dotenv("credentials.env")
aws_access_key_id = os.environ["aws_access_key_id"]
aws_secret_access_key = os.environ["aws_secret_access_key"]
aws_session_token = os.environ["aws_session_token"]

# # Define EC2 instance parameters
keyPairName = 'mapreduce'
securityGroupName = 'mapreduce'

# # Create an EC2 client
EC2 = boto3.client(
    'ec2',
    region_name="us-east-1",
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    aws_session_token=aws_session_token
)

WAITER = EC2.get_waiter('instance_status_ok')

# get vpc_id
vpc_id = EC2.describe_vpcs().get('Vpcs', [{}])[0].get('VpcId', '')
subnet = EC2.describe_subnets().get('Subnets', [{}])[0].get('SubnetId', '')

# create key pair and security group
print('Creating key pair...')
create_key_pair(EC2, keyPairName)
print('Creating security group...')
security_group = create_security_group(EC2, securityGroupName, vpc_id)

# Create 1 m4.large instances
print("Creating instance...")
response = create_m4large_instance(EC2, keyPairName, security_group['GroupId'], subnet)
WAITER = EC2.get_waiter('instance_status_ok')
instance_id = response["Instances"][0]["InstanceId"]
WAITER.wait(InstanceIds=[instance_id])
print("Instance is running")


# # Get instance public IP
response = EC2.describe_instances(InstanceIds=[instance_id])
public_dns = response['Reservations'][0]['Instances'][0]['PublicDnsName']
print("public dns" ,public_dns)

# Set the desired permissions (600 in octal)
desired_permissions = 0o600
private_key_path = '/Users/mosi/Desktop/Polytechnique/Courses/Cloud/Assignment2_LOG8415/mapreduce.pem'
# Change the permissions of the private key file
os.chmod(private_key_path, desired_permissions)

subprocess.run([
    'ssh', '-i', f'{keyPairName}.pem', f'ubuntu@{public_dns}', 'bash', '-s'
], stdin=open('hadoop_spark_setup.sh'))

subprocess.run([
    'ssh', '-i', f'{keyPairName}.pem', f'ubuntu@{public_dns}', 'bash', '-s'
], stdin=open('mapreduce.sh'))


# os.system("ssh -o StrictHostKeyChecking=no -i " + keyPairName + ".pem ubuntu@" + public_dns + " 'bash -s' < ./mapreduce.sh")
# time.sleep(30)

input("Press Enter to delete everything...")

print("Terminating instance...")
terminate_instance(EC2, instance_id)
WAITER = EC2.get_waiter('instance_terminated')
WAITER.wait(InstanceIds=[instance_id])
print("Instance terminated")

print("Deleting security group...")
delete_security_group(EC2, securityGroupName)

print("Deleting key pair...")
delete_key_pair(EC2, keyPairName)

