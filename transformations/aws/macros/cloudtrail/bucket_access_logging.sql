{% macro bucket_access_logging(framework, check_id) %}
  {{ return(adapter.dispatch('bucket_access_logging')(framework, check_id)) }}
{% endmacro %}

{% macro default__bucket_access_logging(framework, check_id) %}{% endmacro %}

{% macro postgres__bucket_access_logging(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket' as title,
    t.account_id,
    t.arn as resource_id,
    case
        when l.logging_enabled is null then 'fail'
        when l.logging_enabled -> 'TargetBucket' is null then 'fail'
        when l.logging_enabled -> 'TargetPrefix' is null then 'fail'
        else 'pass'
    end as status
from aws_cloudtrail_trails t
inner join aws_s3_buckets b on t.s3_bucket_name = b.name
inner join aws_s3_bucket_loggings l on b.arn = l.bucket_arn
{% endmacro %}

{% macro bigquery__bucket_access_logging(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket' as title,
    t.account_id,
    t.arn as resource_id,
    case
        when l.logging_enabled is null then 'fail'
        when l.logging_enabled.TargetBucket is null then 'fail'
        when l.logging_enabled.TargetPrefix is null then 'fail'
        else 'pass'
    end as status
from {{ full_table_name("aws_cloudtrail_trails") }} t
inner join {{ full_table_name("aws_s3_buckets") }} b on t.s3_bucket_name = b.name
inner join {{ full_table_name("aws_s3_bucket_loggings") }} l on b.arn = l.bucket_arn
{% endmacro %}

{% macro snowflake__bucket_access_logging(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket' as title,
    t.account_id,
    t.arn as resource_id,
    case
        when l.logging_enabled is null then 'fail'
        when l.logging_enabled:TargetBucket is null then 'fail'
        when l.logging_enabled:TargetPrefix is null then 'fail'
        else 'pass'
    end as status
from aws_cloudtrail_trails t
inner join aws_s3_buckets b on t.s3_bucket_name = b.name
inner join aws_s3_bucket_loggings l on b.arn = l.bucket_arn
{% endmacro %}

{% macro athena__bucket_access_logging(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket' as title,
    t.account_id,
    t.arn as resource_id,
    case
        when l.logging_enabled is null then 'fail'
        when json_extract_scalar(l.logging_enabled, '$.TargetBucket') is null then 'fail'
        when json_extract_scalar(l.logging_enabled, '$.TargetPrefix') is null then 'fail'
        else 'pass'
    end as status
from aws_cloudtrail_trails t
inner join aws_s3_buckets b on t.s3_bucket_name = b.name
inner join aws_s3_bucket_loggings l on b.arn = l.bucket_arn
{% endmacro %}