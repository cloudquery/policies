{% macro alarm_unauthorized_api(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_unauthorized_api')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_unauthorized_api(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_unauthorized_api(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for Management Console sign-in without MFA (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case when pattern NOT LIKE '%NOT%'
           AND pattern LIKE '%($.errorCode = "*UnauthorizedOperation")%'
           AND pattern LIKE '%($.errorCode = "AccessDenied*")%' then 'pass'
      else 'fail'
  end as status
from aws_compliance__log_metric_filter_and_alarm
{% endmacro %}
