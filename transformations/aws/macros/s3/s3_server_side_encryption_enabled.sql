{% macro s3_server_side_encryption_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('s3_server_side_encryption_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__s3_server_side_encryption_enabled(framework, check_id) %}
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

{% macro postgres__s3_server_side_encryption_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets should have server-side encryption enabled' as title,
    aws_s3_buckets.account_id,
    arn as resource_id,
    case when
        aws_s3_bucket_encryption_rules.bucket_arn is null
    then 'fail' else 'pass' end as status
from
    aws_s3_buckets
left join aws_s3_bucket_encryption_rules on aws_s3_bucket_encryption_rules.bucket_arn=aws_s3_buckets.arn

-- Note: This query doesn't validate if a bucket policy requires encryption for `put-object` requests
{% endmacro %}

{% macro default__s3_server_side_encryption_enabled(framework, check_id) %}{% endmacro %}

{% macro bigquery__s3_server_side_encryption_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets should have server-side encryption enabled' as title,
    aws_s3_buckets.account_id,
    arn as resource_id,
    case when
        aws_s3_bucket_encryption_rules.bucket_arn is null
    then 'fail' else 'pass' end as status
from
    {{ full_table_name("aws_s3_buckets") }}
left join {{ full_table_name("aws_s3_bucket_encryption_rules") }} on aws_s3_bucket_encryption_rules.bucket_arn=aws_s3_buckets.arn

-- Note: This query doesn't validate if a bucket policy requires encryption for `put-object` requests
{% endmacro %}

{% macro athena__s3_server_side_encryption_enabled(framework, check_id) %}
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