{% macro fargate_should_run_on_latest_version(framework, check_id) %}
SELECT 
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
{% endmacro %}