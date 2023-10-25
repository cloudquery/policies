{% macro alb_deletion_protection_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Application Load Balancer deletion protection should be enabled' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    lb.type = 'application' and (a.value)::boolean is distinct from true -- TODO check
   then 'fail'
   else 'pass'
  end as status
from aws_elbv2_load_balancers lb
         inner join
     aws_elbv2_load_balancer_attributes a on
                 a.load_balancer_arn = lb.arn AND a.key='deletion_protection.enabled'
{% endmacro %}