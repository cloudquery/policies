{% macro secrets_should_not_be_in_environment_variables(framework, check_id) %}
with flat_containers AS (
SELECT 
    t.arn,
    t.account_id,
    CASE
        WHEN
          f.value:environment::text LIKE '%AWS_ACCESS_KEY_ID%' 
          OR
          f.value:environment::text LIKE '%AWS_SECRET_ACCESS_KEY%'
          OR
          f.value:environment::text LIKE  '%ECS_ENGINE_AUTH_DATA%'
        THEN '1'
        ELSE 0
    END as status
FROM 
    aws_ecs_task_definitions t,
    LATERAL FLATTEN(input => t.container_definitions) f
WHERE 
    t.status = 'ACTIVE')
    
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Secrets should not be passed as container environment variables' as title,
    arn as resource_id,
    account_id,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
from
    flat_containers
{% endmacro %}