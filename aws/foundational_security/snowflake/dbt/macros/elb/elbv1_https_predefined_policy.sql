{% macro elbv1_https_predefined_policy(framework, check_id) %}
insert into aws_policy_results
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Classic Load Balancers with HTTPS/SSL listeners should use a predefined security policy that has strong configuration' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    li.value:Listener:Protocol in ('HTTPS', 'SSL') and 'ELBSecurityPolicy-TLS-1-2-2017-01' NOT IN (po.value:OtherPolicies)
    then 'fail'
    else 'pass'
  end as status
from aws_elbv1_load_balancers lb, lateral flatten(input => parse_json(lb.listener_descriptions)) as li,
                                  lateral flatten(input => parse_json(lb.policies)) as po
{% endmacro %}