{% macro log_metric_filter_and_alarm(framework, check_id) %}
  {{ return(adapter.dispatch('log_metric_filter_and_alarm')()) }}
{% endmacro %}

{% macro default__log_metric_filter_and_alarm() %}{% endmacro %}

{% macro postgres__log_metric_filter_and_alarm() %}
with af as (
  select distinct a.arn, a.actions_enabled, a.alarm_actions, m->'MetricStat'->'Metric'->>'MetricName' as metric_name -- TODO check
  from aws_cloudwatch_alarms a, jsonb_array_elements(a.metrics) as m
)
select
    t.account_id,
    t.region,
    t.cloud_watch_logs_log_group_arn,
    mf.filter_pattern as pattern
from aws_cloudtrail_trails t
inner join aws_cloudtrail_trail_event_selectors tes on t.arn = tes.trail_arn
inner join aws_cloudwatchlogs_metric_filters mf on mf.log_group_name = t.cloudwatch_logs_log_group_name
inner join af on mf.filter_name = af.metric_name
inner join aws_sns_subscriptions ss on ss.topic_arn = ANY(af.alarm_actions)
where t.is_multi_region_trail = TRUE
    and (t.status->>'IsLogging')::boolean = TRUE
    and tes.include_management_events = TRUE
    and tes.read_write_type = 'All'
    and ss.arn like 'aws:arn:%'
{% endmacro %}

{% macro bigquery__log_metric_filter_and_alarm() %}
with af as (
  select distinct a.arn, a.actions_enabled, ARRAY_TO_STRING(a.alarm_actions, ',') as alarm_actions, JSON_VALUE(m.MetricStat.Metric.MetricName) as metric_name -- TODO check
  from {{ full_table_name("aws_cloudwatch_alarms") }} a, UNNEST(JSON_QUERY_ARRAY(metrics)) as m
)
select
    t.account_id,
    t.region,
    t.cloud_watch_logs_log_group_arn,
    mf.filter_pattern as pattern
from {{ full_table_name("aws_cloudtrail_trails") }} t
inner join {{ full_table_name("aws_cloudtrail_trail_event_selectors") }} tes on t.arn = tes.trail_arn
inner join {{ full_table_name("aws_cloudwatchlogs_metric_filters") }} mf on mf.log_group_name = t.cloudwatch_logs_log_group_name
inner join af on mf.filter_name = af.metric_name
inner join {{ full_table_name("aws_sns_subscriptions") }} ss on ss.topic_arn in UNNEST(SPLIT(af.alarm_actions, ',')) 
where t.is_multi_region_trail = TRUE
    and CAST( JSON_VALUE(t.status.IsLogging) AS BOOL) = TRUE
    and tes.include_management_events = TRUE
    and tes.read_write_type = 'All'
    and ss.arn like 'aws:arn:%'
{% endmacro %}

{% macro snowflake__log_metric_filter_and_alarm() %}
WITH af AS (
  SELECT DISTINCT
    a.arn,
    a.actions_enabled,
    a.alarm_actions,
    m.value:MetricStat:Metric:MetricName AS metric_name
  FROM aws_cloudwatch_alarms a,
  LATERAL FLATTEN(input => a.metrics) AS m
)

SELECT
  t.account_id,
  t.region,
  t.cloud_watch_logs_log_group_arn,
  mf.filter_pattern AS pattern
FROM
  aws_cloudtrail_trails t
INNER JOIN
  aws_cloudtrail_trail_event_selectors tes ON t.arn = tes.trail_arn
INNER JOIN
  aws_cloudwatchlogs_metric_filters mf ON mf.log_group_name = t.cloudwatch_logs_log_group_name
INNER JOIN
  af ON mf.filter_name = af.metric_name
INNER JOIN LATERAL (
  SELECT arn, topic_arn
  FROM aws_sns_subscriptions ss
  WHERE ARRAY_CONTAINS(ss.topic_arn::variant, af.alarm_actions)
  LIMIT 1
) ss ON TRUE  
WHERE
  t.is_multi_region_trail = TRUE
  AND (t.status:IsLogging)::BOOLEAN = TRUE
  AND tes.include_management_events = TRUE
  AND tes.read_write_type = 'All'
  AND ss.arn LIKE 'aws:arn:%'
{% endmacro %}