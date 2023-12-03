{% macro task_definitions_secure_networking(framework, check_id) %}
  {{ return(adapter.dispatch('task_definitions_secure_networking')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__task_definitions_secure_networking(framework, check_id) %}
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

{% macro postgres__task_definitions_secure_networking(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon ECS task definitions should have secure networking modes and user definitions' as title,
    account_id,
    arn as resource_id,
    case when
        network_mode = 'host'
        and (c->>'Privileged')::boolean is distinct from true
        and (c->>'User' = 'root' or c->>'User' is null)
    then 'fail'
    else 'pass'
    end as status
from aws_ecs_task_definitions, jsonb_array_elements(aws_ecs_task_definitions.container_definitions) as c
{% endmacro %}

{% macro default__task_definitions_secure_networking(framework, check_id) %}{% endmacro %}
                    