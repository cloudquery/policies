{% macro s3_cross_region_replication(framework, check_id) %}
  {{ return(adapter.dispatch('s3_cross_region_replication')(framework, check_id)) }}
{% endmacro %}

{% macro default__s3_cross_region_replication(framework, check_id) %}{% endmacro %}

{% macro postgres__s3_cross_region_replication(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets with replication rules should be enabled' as title,
    aws_s3_buckets.account_id,
    aws_s3_buckets.arn as resource_id,
    case when
        aws_s3_bucket_replications.replication_configuration -> 'Rule' ->>'Status' is distinct from 'Enabled'
    then 'fail' else 'pass' end as status
from
    aws_s3_buckets
    inner join aws_s3_bucket_replications on aws_s3_buckets.arn = aws_s3_bucket_replications.bucket_arn
-- Note: This query doesn't validate that the destination bucket is actually in a different region
{% endmacro %}

{% macro bigquery__s3_cross_region_replication(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets with replication rules should be enabled' as title,
    aws_s3_buckets.account_id,
    aws_s3_buckets.arn as resource_id,
    case when
        JSON_VALUE(aws_s3_bucket_replications.replication_configuration.Rule.Status) is distinct from 'Enabled'
    then 'fail' else 'pass' end as status
from
     {{ full_table_name("aws_s3_buckets") }}
     inner join  {{ full_table_name("aws_s3_bucket_replications") }} on aws_s3_buckets.arn = aws_s3_bucket_replications.bucket_arn
{% endmacro %}

{% macro snowflake__s3_cross_region_replication(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets with replication rules should be enabled' as title,
    aws_s3_buckets.account_id,
    aws_s3_buckets.arn as resource_id,
    case when
        aws_s3_bucket_replications.replication_configuration:Rule:Status is distinct from 'Enabled'
    then 'fail' else 'pass' end as status
from
    aws_s3_buckets
    inner join aws_s3_bucket_replications on aws_s3_buckets.arn = aws_s3_bucket_replications.bucket_arn
-- Note: This query doesn't validate that the destination bucket is actually in a different region
{% endmacro %}

{% macro athena__s3_cross_region_replication(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets with replication rules should be enabled' as title,
    aws_s3_buckets.account_id,
    aws_s3_buckets.arn as resource_id,
    case when
        json_extract_scalar(aws_s3_bucket_replications.replication_configuration, '$.Rule.Status') is distinct from 'Enabled'
    then 'fail' else 'pass' end as status
from
    aws_s3_buckets
    inner join aws_s3_bucket_replications on aws_s3_buckets.arn = aws_s3_bucket_replications.bucket_arn
-- Note: This query doesn't validate that the destination bucket is actually in a different region
{% endmacro %}