{% macro alarm_delete_customer_cmk(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_delete_customer_cmk')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_delete_customer_cmk(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_delete_customer_cmk(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer created CMKs (Scored)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventSource = kms.amazonaws.com)%'
          AND pattern LIKE '%($.eventName=DisableKey)%'
          AND pattern LIKE '%($.eventName=ScheduleKeyDeletion)%' then 'pass'
      else 'fail'
    end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro bigquery__alarm_delete_customer_cmk(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer created CMKs (Scored)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventSource = kms.amazonaws.com)%'
          AND pattern LIKE '%($.eventName=DisableKey)%'
          AND pattern LIKE '%($.eventName=ScheduleKeyDeletion)%' then 'pass'
      else 'fail'
    end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro snowflake__alarm_delete_customer_cmk(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer created CMKs (Scored)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventSource = kms.amazonaws.com)%'
          AND pattern LIKE '%($.eventName=DisableKey)%'
          AND pattern LIKE '%($.eventName=ScheduleKeyDeletion)%' then 'pass'
      else 'fail'
    end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro athena__alarm_delete_customer_cmk(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer created CMKs (Scored)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventSource = kms.amazonaws.com)%'
          AND pattern LIKE '%($.eventName=DisableKey)%'
          AND pattern LIKE '%($.eventName=ScheduleKeyDeletion)%' then 'pass'
      else 'fail'
    end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}