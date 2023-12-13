{% macro clusters_should_use_container_insights(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_use_container_insights')(framework, check_id)) }}
{% endmacro %}

{% macro default__clusters_should_use_container_insights(framework, check_id) %}{% endmacro %}

{% macro postgres__clusters_should_use_container_insights(framework, check_id) %}
with settings as (
SELECT DISTINCT
  arn
FROM
  aws_ecs_clusters c,
	JSONB_ARRAY_ELEMENTS(settings) as f
WHERE
    f ->> 'Name' = 'containerInsights'
    AND
    f ->> 'Value' <> 'enabled'
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

{% macro snowflake__clusters_should_use_container_insights(framework, check_id) %}
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