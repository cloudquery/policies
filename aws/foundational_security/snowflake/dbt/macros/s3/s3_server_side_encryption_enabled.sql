{% macro s3_server_side_encryption_enabled(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should have server-side encryption enabled' as title,
    aws_s3_buckets.account_id,
    arn as resource_id,
    case when
        aws_s3_bucket_encryption_rules.bucket_arn is null
    then 'fail' else 'pass' end as status
from
    aws_s3_buckets
left join aws_s3_bucket_encryption_rules on aws_s3_bucket_encryption_rules.bucket_arn=aws_s3_buckets.arn
{% endmacro %}