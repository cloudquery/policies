TASK_DEFINITIONS_SECURE_NETWORKING = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon ECS task definitions should have secure networking modes and user definitions' as title,
    account_id,
    arn as resource_id,
    case when
        network_mode = 'host'
        and c.value:Privileged::boolean is distinct from true
        and (c.value:User = 'root' or c.value:User is null)
    then 'fail'
    else 'pass'
    end as status
from aws_ecs_task_definitions, lateral flatten(input => parse_json(aws_ecs_task_definitions.container_definitions)) as c
"""

ECS_SERVICES_WITH_PUBLIC_IPS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Amazon ECS services should not have public IP addresses assigned to them automatically' as title,
  account_id,
  arn as resource_id,
  case when
    network_configuration:AwsvpcConfiguration:AssignPublicIp is distinct from 'DISABLED'
    then 'fail'
    else 'pass'
  end as status
from aws_ecs_cluster_services
"""

TASK_DEFINITIONS_SHOULD_NOT_SHARE_HOST_NAMESPACE = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'ECS task definitions should not share the hosts process namespace' as title,
  account_id,
  arn as resource_id,
  CASE 
    WHEN pid_mode = 'host' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_ecs_task_definitions
WHERE
  status = 'ACTIVE';
"""