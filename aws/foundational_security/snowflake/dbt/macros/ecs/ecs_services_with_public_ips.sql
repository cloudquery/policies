{% macro ecs_services_with_public_ips(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon ECS services should not have public IP addresses assigned to them automatically' as title,
  account_id,
  arn as resource_id,
  case when
    network_configuration:AwsvpcConfiguration:AssignPublicIp is distinct from 'DISABLED'
    then 'fail'
    else 'pass'
  end as status
from aws_ecs_cluster_services
{% endmacro %}