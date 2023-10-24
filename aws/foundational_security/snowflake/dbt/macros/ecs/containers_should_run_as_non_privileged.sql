{% macro containers_should_run_as_non_privileged(framework, check_id) %}
insert into 
    aws_policy_results 
with flat_containers as (
        SELECT
            arn,
            account_id,
            CASE
                WHEN container_definition.value:Privileged::BOOLEAN = TRUE THEN 1
                ELSE 0
            END AS status
        FROM
            aws_ecs_task_definitions,
            LATERAL FLATTEN(input => container_definitions) AS container_definition
        WHERE
            status = 'ACTIVE' -- Only consider active task definitions
    )
select
    DISTINCT 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'ECS containers should run as non-privileged' as title,
    arn as resource_id,
    account_id,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
FROM
    flat_containers
{% endmacro %}