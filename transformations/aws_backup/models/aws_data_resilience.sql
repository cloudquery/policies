with
    backup_eligible_resources as (
        ({{backup_resource('aws_dynamodb_tables')}})
        union
        ({{backup_resource('aws_ec2_instances')}})
        union
        ({{backup_resource('aws_s3_buckets')}})
 )
select *
from backup_eligible_resources