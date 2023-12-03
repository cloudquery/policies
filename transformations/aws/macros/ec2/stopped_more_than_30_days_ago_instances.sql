{% macro stopped_more_than_30_days_ago_instances(framework, check_id) %}
  {{ return(adapter.dispatch('stopped_more_than_30_days_ago_instances')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__stopped_more_than_30_days_ago_instances(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Stopped EC2 instances should be removed after a specified time period' as title,
  account_id,
  instance_id as resource_id,
  case when
      state:Name = 'stopped'
      and TIMESTAMPDIFF('day', CURRENT_TIMESTAMP(), state_transition_reason_time) > 30
      then 'fail'
      else 'pass'
  end AS status
from aws_ec2_instances
{% endmacro %}

{% macro postgres__stopped_more_than_30_days_ago_instances(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Stopped EC2 instances should be removed after a specified time period' as title,
  account_id,
  instance_id as resource_id,
  case when
    state->>'Name' = 'stopped'
        AND NOW() - state_transition_reason_time > INTERVAL '30' DAY
    then 'fail'
    else 'pass'
  end
from aws_ec2_instances
{% endmacro %}

{% macro default__stopped_more_than_30_days_ago_instances(framework, check_id) %}{% endmacro %}
                    