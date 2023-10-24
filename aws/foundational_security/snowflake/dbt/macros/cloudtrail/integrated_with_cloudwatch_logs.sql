{% macro integrated_with_cloudwatch_logs(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
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