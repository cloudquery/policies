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
        when b.logging_target_bucket is null or b.logging_target_prefix is null then 'fail'
        else 'pass'
    end as status
from aws_cloudtrail_trails t
inner join aws_s3_buckets b on t.s3_bucket_name = b.name
{% endmacro %}
