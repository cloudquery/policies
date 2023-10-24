{% macro clusters_should_use_container_insights(framework, check_id) %}
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
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
{% endmacro %}