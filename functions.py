# INSTANCE

def create_m4large_instance(client, keyPair, securityGroupId, subnetId):
    print('Creating 1 instance of m4.large...')
    response = client.run_instances(

        ImageId='ami-08c40ec9ead489470',
        InstanceType='m4.large',
        KeyName=keyPair,
        UserData=open('hadoop_spark_setup.sh').read(),
        SubnetId=subnetId,
        SecurityGroupIds=[
            securityGroupId,
        ],
        MaxCount=1,
        MinCount=1,
        Monitoring={   
            'Enabled': True
        },
        TagSpecifications=[
            {
                'ResourceType': 'instance',
                'Tags': [
                    {
                        'Key': 'Name',
                        'Value': 'instance_map_reduce'
                    },
                ]
            },
        ],
    )
    return response["Instances"][0]["InstanceId"]

def terminate_instance(client, instanceId):
    print('terminating instance:')
    print(instanceId)
    client.terminate_instances(InstanceIds=([instanceId]))

# KEY PAIR

def create_key_pair(ec2_client, key_pair_name):
    try:
        key_pair = ec2_client.create_key_pair(KeyName=key_pair_name)
        # Save the PEM file locally
        with open(f'{key_pair_name}.pem', 'w') as pem_file:
            pem_file.write(key_pair['KeyMaterial'])
        print(f'Key pair {key_pair_name} created and PEM file saved as {key_pair_name}.pem')
    except ec2_client.exceptions.ClientError as e:
        if 'KeyPair' in str(e):
            print(f'Key pair {key_pair_name} already exists.')
        else:
            raise
    
    return key_pair['KeyName']

def delete_key_pair(ec2_client,  key_pair_name):

    try:
        ec2_client.delete_key_pair(KeyName=key_pair_name)
        print(f'Deleted key pair: {key_pair_name}')
    except ec2_client.exceptions.ClientError as e:
        if 'does not exist' in str(e):
            print(f'Key pair {key_pair_name} does not exist.')
        else:
            raise

# SECURITY GROUP

def create_security_group(ec2_client, security_group_name, vpc_id):
    try:
        security_group = ec2_client.create_security_group(
            Description='LOG8415 Security Group',
            GroupName=security_group_name,
            VpcId=vpc_id
        )

        response = ec2_client.describe_security_groups(
        GroupNames=[security_group_name]
        )
        security_group_id = response['SecurityGroups'][0]['GroupId']

        # Add inbound rules to allow SSH (port 22) and Spark Master Web UI (port 8080) traffic
        ec2_client.authorize_security_group_ingress(
            GroupId=security_group_id,
            IpPermissions=[
                {
                    'IpProtocol': 'tcp',
                    'FromPort': 22,  # SSH port
                    'ToPort': 22,    # SSH port
                    'IpRanges': [{'CidrIp': '0.0.0.0/0'}]  # Allow Spark from any IP
                },
                {
                    'IpProtocol': 'tcp',
                    'FromPort': 8080,  # Spark Master port
                    'ToPort': 8080,    # Spark Master port
                    'IpRanges': [{'CidrIp': '0.0.0.0/0'}]  
                },          
            ]
        )

    except ec2_client.exceptions.ClientError as e:
        if 'already exists' in str(e):
            print(f'Security group {security_group_name} already exists.')
        else:
            raise

    return security_group

def delete_security_group(ec2_client, security_group_name):
    try:
        ec2_client.delete_security_group(GroupName=security_group_name)
        print(f'Deleted security group: {security_group_name}')
    except ec2_client.exceptions.ClientError as e:
        if 'does not exist' in str(e):
            print(f'Security group {security_group_name} does not exist.')
        else:
            raise