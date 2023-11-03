{% macro integrated_with_cloudwatch_logs(framework, check_id) %}
  {{ return(adapter.dispatch('integrated_with_cloudwatch_logs')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__integrated_with_cloudwatch_logs(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'CloudTrail trails should be integrated with CloudWatch Logs' as title,
  account_id,
  arn as resource_id,
  CASE
    WHEN cloud_watch_logs_log_group_arn IS NULL
      OR TO_TIMESTAMP(status:LatestCloudWatchLogsDeliveryTime) < DATEADD('day', -1, CURRENT_TIMESTAMP())
    THEN 'fail'
    ELSE 'pass'
  END as status
FROM aws_cloudtrail_trails
{% endmacro %}

{% macro postgres__integrated_with_cloudwatch_logs(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CloudTrail trails should be integrated with CloudWatch Logs' as title,
    account_id,
    arn as resource_id,
    case
        when cloud_watch_logs_log_group_arn is null
            OR (status->>'LatestCloudWatchLogsDeliveryTime')::timestamp < (now() - '1 days'::INTERVAL)
        then 'fail'
        else 'pass'
    end as status
from aws_cloudtrail_trails
{% endmacro %}
