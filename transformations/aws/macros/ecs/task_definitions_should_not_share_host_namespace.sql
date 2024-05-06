{% macro task_definitions_should_not_share_host_namespace(framework, check_id) %}
  {{ return(adapter.dispatch('task_definitions_should_not_share_host_namespace')(framework, check_id)) }}
{% endmacro %}

{% macro default__task_definitions_should_not_share_host_namespace(framework, check_id) %}{% endmacro %}

{% macro postgres__task_definitions_should_not_share_host_namespace(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
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
    status = 'ACTIVE'
{% endmacro %}

{% macro snowflake__task_definitions_should_not_share_host_namespace(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
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
    status = 'ACTIVE'
{% endmacro %}

{% macro bigquery__task_definitions_should_not_share_host_namespace(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'ECS task definitions should not share the hosts process namespace' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN pid_mode = 'host' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    {{ full_table_name("aws_ecs_task_definitions") }}
WHERE
    status = 'ACTIVE'
{% endmacro %}

{% macro athena__task_definitions_should_not_share_host_namespace(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
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
    status = 'ACTIVE'
{% endmacro %}