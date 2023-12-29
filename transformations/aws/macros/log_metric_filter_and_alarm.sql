{% macro log_metric_filter_and_alarm(framework, check_id) %}
  {{ return(adapter.dispatch('log_metric_filter_and_alarm')()) }}
{% endmacro %}

{% macro default__log_metric_filter_and_alarm() %}{% endmacro %}

{% macro postgres__log_metric_filter_and_alarm() %}
with af as (
  select distinct a.arn, a.actions_enabled, a.alarm_actions, m->'MetricStat'->'Metric'->>'MetricName' as metric_name -- TODO check
  from aws_cloudwatch_alarms a, jsonb_array_elements(a.metrics) as m
),
tes as (
    select trail_arn from aws_cloudtrail_trail_event_selectors
    where exists(
        select * from jsonb_array_elements(event_selectors) as es
        where es ->>'ReadWriteType' = 'All' and (es->>'IncludeManagementEvents')::boolean = TRUE
    ) or exists(
        select * from jsonb_array_elements(advanced_event_selectors) as aes
        where not exists(select * from jsonb_array_elements(aes ->'FieldSelectors') as aes_fs where aes_fs ->>'Field' = 'readOnly')
    )
)
select
    t.account_id,
    t.region,
    t.cloud_watch_logs_log_group_arn,
    mf.filter_pattern as pattern
from aws_cloudtrail_trails t
inner join tes on t.arn = tes.trail_arn
inner join aws_cloudwatchlogs_metric_filters mf on mf.log_group_name = t.cloudwatch_logs_log_group_name
inner join af on mf.filter_name = af.metric_name
inner join aws_sns_subscriptions ss on ss.topic_arn = ANY(af.alarm_actions)
where t.is_multi_region_trail = TRUE
    and (t.status->>'IsLogging')::boolean = TRUE
    and ss.arn like 'aws:arn:%'
{% endmacro %}

{% macro bigquery__log_metric_filter_and_alarm() %}
with af as (
  select distinct a.arn, a.actions_enabled, ARRAY_TO_STRING(a.alarm_actions, ',') as alarm_actions, JSON_VALUE(m.MetricStat.Metric.MetricName) as metric_name
  from {{ full_table_name("aws_cloudwatch_alarms") }} a,
  UNNEST(JSON_QUERY_ARRAY(metrics)) as m
),
tes as (
    select trail_arn from {{ full_table_name("aws_cloudtrail_trail_event_selectors") }}
    where exists(
        select * from UNNEST(JSON_QUERY_ARRAY(event_selectors)) as es
        where JSON_VALUE(es.ReadWriteType) = 'All' and CAST( JSON_VALUE(es.IncludeManagementEvents) AS BOOL) = TRUE
    ) 
    or exists(
        select * from UNNEST(JSON_QUERY_ARRAY(advanced_event_selectors)) as aes
        where not exists (
        select * from UNNEST(JSON_QUERY_ARRAY(aes.FieldSelectors)) as aes_fs
          where JSON_VALUE(aes_fs.Field) = 'readOnly'
        )
      )
)
select
    t.account_id,
    t.region,
    t.cloud_watch_logs_log_group_arn,
    mf.filter_pattern as pattern
from {{ full_table_name("aws_cloudtrail_trails") }} t
inner join tes on t.arn = tes.trail_arn
inner join {{ full_table_name("aws_cloudwatchlogs_metric_filters") }} mf on mf.log_group_name = t.cloudwatch_logs_log_group_name
inner join af on mf.filter_name = af.metric_name
inner join {{ full_table_name("aws_sns_subscriptions") }} ss on ss.topic_arn in UNNEST(SPLIT(af.alarm_actions, ','))
where t.is_multi_region_trail = TRUE
    and CAST( JSON_VALUE(t.status.IsLogging) AS BOOL) = TRUE
    and ss.arn like 'aws:arn:%'
{% endmacro %}

{% macro snowflake__log_metric_filter_and_alarm() %}
with af as (
  select distinct a.arn, a.actions_enabled, a.alarm_actions, m.value:MetricStat:Metric:MetricName as metric_name -- TODO check
  from aws_cloudwatch_alarms a,
  LATERAL FLATTEN (metrics) as m
),
aes as (
select * from aws_cloudtrail_trail_event_selectors,
  LATERAL FLATTEN (advanced_event_selectors) as aes
),
tes as (
    select trail_arn from aws_cloudtrail_trail_event_selectors
    where exists(
        select * from 
      aws_cloudtrail_trail_event_selectors,
      LATERAL FLATTEN(event_selectors) as es
        where es.value:ReadWriteType = 'All' and (es.value:IncludeManagementEvents)::boolean = TRUE
    ) 
  or exists(
      select * from aes
       where not exists (
       select * from aes, LATERAL FLATTEN(value:FieldSelectors) as aes_fs
        where aes_fs.value:Field = 'readOnly'
       )
    )
)
select
    t.account_id,
    t.region,
    t.cloud_watch_logs_log_group_arn,
    mf.filter_pattern as pattern
from aws_cloudtrail_trails t
inner join tes on t.arn = tes.trail_arn
inner join aws_cloudwatchlogs_metric_filters mf on mf.log_group_name = t.cloudwatch_logs_log_group_name
inner join af on mf.filter_name = af.metric_name
inner join aws_sns_subscriptions ss on ARRAY_CONTAINS((ss.topic_arn)::variant, af.alarm_actions)
where t.is_multi_region_trail = TRUE
    and (t.status:IsLogging)::boolean = TRUE
    and ss.arn like 'aws:arn:%'
{% endmacro %}