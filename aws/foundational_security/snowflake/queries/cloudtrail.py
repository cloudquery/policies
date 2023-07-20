
ENABLED_ALL_REGIONS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Ensure CloudTrail is enabled in all regions' as title,
    aws_cloudtrail_trails.account_id,
    arn as resource_id,
    case
        when is_multi_region_trail = FALSE or (
                    is_multi_region_trail = TRUE and (
                        read_write_type != 'All' or include_management_events = FALSE
                )) then 'fail'
        else 'pass'
    end as status
from aws_cloudtrail_trails
inner join
    aws_cloudtrail_trail_event_selectors on
        aws_cloudtrail_trails.arn = aws_cloudtrail_trail_event_selectors.trail_arn
        and aws_cloudtrail_trails.region = aws_cloudtrail_trail_event_selectors.region
        and aws_cloudtrail_trails.account_id = aws_cloudtrail_trail_event_selectors.account_id
"""

LOGS_ENCRYPTED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudTrail should have encryption at rest enabled' as title,
    account_id,
    arn as resource_id,
    case
        when kms_key_id is NULL then 'fail'
        else 'pass'
    end as status
FROM aws_cloudtrail_trails
"""

LOGS_FILE_VALIDATION_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Ensure CloudTrail log file validation is enabled' as title,
    account_id,
    arn as resource_id,
    case
      when log_file_validation_enabled = false then 'fail'
      else 'pass'
    end as status
from aws_cloudtrail_trails
"""

INTEGRATED_WITH_CLOUDWATCH_LOGS = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
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
"""