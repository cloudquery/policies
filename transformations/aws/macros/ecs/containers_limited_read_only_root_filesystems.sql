{% macro containers_limited_read_only_root_filesystems(framework, check_id) %}
  {{ return(adapter.dispatch('containers_limited_read_only_root_filesystems')(framework, check_id)) }}
{% endmacro %}

{% macro default__containers_limited_read_only_root_filesystems(framework, check_id) %}{% endmacro %}

{% macro postgres__containers_limited_read_only_root_filesystems(framework, check_id) %}
with flat_containers as (
        SELECT
            arn,
            account_id,
            CASE
                WHEN (container_definition ->> 'readonlyRootFilesystem')::BOOLEAN = FALSE
                OR container_definition ->> 'readonlyRootFilesystem' IS NULL THEN 1
                ELSE 0
            END AS status
        FROM
            aws_ecs_task_definitions,
			JSONB_ARRAY_ELEMENTS(container_definitions) as container_definition
        WHERE
            status = 'ACTIVE'
    )
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'ECS containers should be limited to read-only access to root filesystems' as title,
    arn,
    account_id,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
from
    flat_containers
{% endmacro %}

{% macro snowflake__containers_limited_read_only_root_filesystems(framework, check_id) %}
with flat_containers as (
        SELECT
            arn,
            account_id,
            CASE
                WHEN container_definition.value:readonlyRootFilesystem::BOOLEAN = FALSE
                OR container_definition.value:readonlyRootFilesystem IS NULL THEN 1
                ELSE 0
            END AS status
        FROM
            aws_ecs_task_definitions,
            LATERAL FLATTEN(input => container_definitions) AS container_definition
        WHERE
            status = 'ACTIVE'
    )
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'ECS containers should be limited to read-only access to root filesystems' as title,
    arn,
    account_id,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
from
    flat_containers
{% endmacro %}