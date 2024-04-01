import boto3
from datetime import datetime, timedelta

def lambda_handler(event, context):
    # Initialize the AWS clients
    cloudwatch = boto3.client('cloudwatch')
    ec2 = boto3.client('ec2')
    rds = boto3.client('rds')
    body = ""

    start_time = (datetime.utcnow() - timedelta(days=int(event["days_before"]), hours=int(event["hours_before"]), minutes=int(event["minutes_before"]), seconds=int(event["seconds_before"]))).isoformat()
    end_time = datetime.utcnow().isoformat()

    # Get the list of EC2 instances
    ec2_instances = ec2.describe_instances()
    
    # Get the list of RDS instances
    rds_instances = rds.describe_db_instances()

    # Monitor EC2 instances
    for reservation in ec2_instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            instance_state = instance['State']['Name']
            if instance_state == 'stopped':
                body += f"EC2 Instance {instance_id} is currently stopped\n"
                print(f"EC2 Instance {instance_id} is currently stopped")
            else:
                # Get CPU utilization metrics for the last 1 hour
                response = cloudwatch.get_metric_statistics(
                    Namespace='AWS/EC2',
                    MetricName='CPUUtilization',
                    Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
                    StartTime=start_time,
                    EndTime=end_time,
                    Period=3600,
                    Statistics=['Average']
                )

                # Check if CPU utilization is below a certain threshold
                if response['Datapoints']:
                    average_cpu_utilization = response['Datapoints'][0]['Average']
                    if average_cpu_utilization < event['cpu_instance_threshold']:
                        body += f"EC2 Instance {instance_id} is underutilized with average CPU utilization of {average_cpu_utilization}%\n"
                        print(f"EC2 Instance {instance_id} is underutilized with average CPU utilization of {average_cpu_utilization}%")

    # Monitor RDS instances
    for db_instance in rds_instances['DBInstances']:
        db_instance_identifier = db_instance['DBInstanceIdentifier']
        db_instance_state = db_instance['DBInstanceStatus']
        if db_instance_state == 'stopped':
            print(f"RDS Instance {db_instance_identifier} is currently stopped")
        else:
            # Get CPU utilization metrics for the last 1 hour
            response = cloudwatch.get_metric_statistics(
                Namespace='AWS/RDS',
                MetricName='CPUUtilization',
                Dimensions=[{'Name': 'DBInstanceIdentifier', 'Value': db_instance_identifier}],
                StartTime=start_time,
                EndTime=end_time,
                Period=3600,
                Statistics=['Average']
            )

            # Check if CPU utilization is below a certain threshold
            if response['Datapoints']:
                average_cpu_utilization = response['Datapoints'][0]['Average']
                if average_cpu_utilization < event['cpu_rds_threshold']:
                    body += f"RDS Instance {db_instance_identifier} is underutilized with average CPU utilization of {average_cpu_utilization}%\n"
                    print(f"RDS Instance {db_instance_identifier} is underutilized with average CPU utilization of {average_cpu_utilization}%")

    return {
        'statusCode': 200,
        'body': body
    }
