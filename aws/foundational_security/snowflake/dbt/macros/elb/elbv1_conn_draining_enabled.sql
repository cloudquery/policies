{% macro elbv1_conn_draining_enabled(framework, check_id) %}
insert into aws_policy_results
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Classic Load Balancers should have connection draining enabled' as title,
  account_id,
  arn as resource_id,
  case when
    (attributes:ConnectionDraining:Enabled)::boolean is distinct from true
    then 'fail'
    else 'pass'
  end as status
from
    aws_elbv1_load_balancers
{% endmacro %}