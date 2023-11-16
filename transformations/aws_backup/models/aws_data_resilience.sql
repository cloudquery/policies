with
    backup_eligible_resources as (
        ({{backup_resource('aws_dynamodb_tables', 'DynamoDB')}})
        union
        ({{backup_resource('aws_ec2_instances', 'EC2')}})
        union
        ({{backup_resource('aws_s3_buckets', 'S3')}})
 )
select *
from backup_eligible_resources