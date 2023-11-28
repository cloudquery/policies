{% macro alarm_actions_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_actions_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_actions_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_actions_disabled(framework, check_id) %}
select
       '{{framework}}'                as framework,
       '{{check_id}}'                 as check_id,
       'Disabled CloudWatch alarm' as title,
       account_id,
       arn                         as resource_id,
       'fail'                      as status
from aws_cloudwatch_alarms
where actions_enabled = false
   or array_length(alarm_actions, 1) = 0{% endmacro %}
