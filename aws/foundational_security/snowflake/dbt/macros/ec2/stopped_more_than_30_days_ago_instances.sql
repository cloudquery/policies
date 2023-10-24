{% macro stopped_more_than_30_days_ago_instances(framework, check_id) %}
insert into aws_policy_results
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
from aws_ec2_instances;
{% endmacro %}