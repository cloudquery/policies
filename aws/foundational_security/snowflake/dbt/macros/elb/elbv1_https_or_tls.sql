{% macro elbv1_https_or_tls(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Classic Load Balancer listeners should be configured with HTTPS or TLS termination' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    li.value:Listener:Protocol not in ('HTTPS', 'SSL')
    then 'fail'
    else 'pass'
  end as status
from aws_elbv1_load_balancers lb, lateral flatten(input => parse_json(lb.listener_descriptions)) as li
{% endmacro %}