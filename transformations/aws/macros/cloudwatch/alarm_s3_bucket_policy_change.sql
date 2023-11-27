{% macro alarm_s3_bucket_policy_change(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_s3_bucket_policy_change')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_s3_bucket_policy_change(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_s3_bucket_policy_change(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for S3 bucket policy changes (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case 
    when pattern NOT LIKE '%NOT%'
        AND pattern LIKE '%($.eventSource = s3.amazonaws.com)%'
        AND pattern LIKE '%($.eventName = PutBucketAcl)%'
        AND pattern LIKE '%($.eventName = PutBucketPolicy)%'
        AND pattern LIKE '%($.eventName = PutBucketCors)%'
        AND pattern LIKE '%($.eventName = PutBucketLifecycle)%'
        AND pattern LIKE '%($.eventName = PutBucketReplication)%'
        AND pattern LIKE '%($.eventName = DeleteBucketPolicy)%'
        AND pattern LIKE '%($.eventName = DeleteBucketCors)%'
        AND pattern LIKE '%($.eventName = DeleteBucketLifecycle)%'
        AND pattern LIKE '%($.eventName = DeleteBucketReplication)%' then 'pass'
    else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}
