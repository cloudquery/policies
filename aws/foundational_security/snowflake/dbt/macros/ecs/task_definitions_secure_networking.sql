{% macro task_definitions_secure_networking(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
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
{% endmacro %}