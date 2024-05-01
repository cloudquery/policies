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

{% macro bigquery__stopped_more_than_30_days_ago_instances(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Stopped EC2 instances should be removed after a specified time period' as title,
  account_id,
  instance_id as resource_id,
  case when
      JSON_VALUE(state.Name) = 'stopped'
      and DATETIME_DIFF(CURRENT_DATETIME(), DATETIME(state_transition_reason_time), DAY) > 30
      then 'fail'
      else 'pass'
  end AS status
FROM {{ full_table_name("aws_ec2_instances") }}
{% endmacro %}

{% macro athena__stopped_more_than_30_days_ago_instances(framework, check_id) %}
select
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'Stopped EC2 instances should be removed after a specified time period' as title,
  account_id,
  instance_id as resource_id,
  case when
    JSON_EXTRACT_SCALAR(state, '$.Name') = 'stopped' -- Assuming 'state' is a JSON column
    AND date_diff('day', from_iso8601_timestamp(CAST(state_transition_reason_time AS varchar)), current_date) > 30
  then 'fail'
  else 'pass'
  end AS status
from aws_ec2_instances
{% endmacro %}
