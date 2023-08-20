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
insert into
    aws_policy_results
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
    status = 'ACTIVE'
"""

CONTAINERS_SHOULD_RUN_AS_NON_PRIVILEGED = """
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
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'ECS containers should run as non-privileged' as title,
    arn as resource_id,
    account_id,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
FROM
    flat_containers
"""

CONTAINERS_LIMITED_READ_ONLY_ROOT_FILESYSTEMS = """
insert into 
    aws_policy_results 
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
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'ECS containers should be limited to read-only access to root filesystems' as title,
    arn,
    account_id,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
from
    flat_containers
"""

SECRETS_SHOULD_NOT_BE_IN_ENVIRONMENT_VARIABLES = """
insert into 
    aws_policy_results
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
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Secrets should not be passed as container environment variables' as title,
    arn as resource_id,
    account_id,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
from
    flat_containers
"""


FARGATE_SHOULD_RUN_ON_LATEST_VERSION = """
insert into 
    aws_policy_results
SELECT 
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'ECS Fargate services should run on the latest Fargate platform version' as title,
  arn as resource_id,
  account_id,
  CASE
    WHEN platform_version is null OR platform_version = 'LATEST' THEN 'pass'
    WHEN (platform_family = 'LINUX' AND platform_version <> '1.4.0') 
      OR 
         (platform_family = 'WINDOWS' AND platform_version <> '1.0.0')
    THEN 'fail'
    ELSE 'pass'
    END as status
FROM
  aws_ecs_cluster_services
WHERE 
  launch_type = 'FARGATE' 
"""

CLUSTERS_SHOULD_USE_CONTAINER_INSIGHTS = """
insert into 
    aws_policy_results
with settings as (
SELECT DISTINCT
  arn
FROM
  aws_ecs_clusters c
  , LATERAL FLATTEN(input => c.settings) as f
WHERE
    f.value:Name::text = 'containerInsights'
    AND
    f.value:Value::text <> 'enabled'
  )
SELECT 
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'ECS clusters should use Container Insights' as title,
  c.arn as resource_id,
  c.account_id,
  CASE
    WHEN s.arn is not null THEN 'fail'
    ELSE 'pass'
    END as status
FROM
  aws_ecs_clusters c
LEFT JOIN
    settings s ON c.arn = s.arn
"""