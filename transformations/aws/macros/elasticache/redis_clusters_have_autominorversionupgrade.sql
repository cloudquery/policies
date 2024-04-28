{% macro redis_clusters_have_autominorversionupgrade(framework, check_id) %}
  {{ return(adapter.dispatch('redis_clusters_have_autominorversionupgrade')(framework, check_id)) }}
{% endmacro %}

{% macro default__redis_clusters_have_autominorversionupgrade(framework, check_id) %}{% endmacro %}

{% macro postgres__redis_clusters_have_autominorversionupgrade(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Minor version upgrades should be automatically applied to ElastiCache for Redis cache clusters' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN auto_minor_version_upgrade = 'false' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_clusters
WHERE 
    engine = 'redis' 
{% endmacro %}

{% macro snowflake__redis_clusters_have_autominorversionupgrade(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Minor version upgrades should be automatically applied to ElastiCache for Redis cache clusters' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN auto_minor_version_upgrade = 'false' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_clusters
WHERE 
    engine = 'redis' 
{% endmacro %}

{% macro bigquery__redis_clusters_have_autominorversionupgrade(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Minor version upgrades should be automatically applied to ElastiCache for Redis cache clusters' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN auto_minor_version_upgrade = false THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    {{ full_table_name("aws_elasticache_clusters") }}
WHERE 
    engine = 'redis' 
{% endmacro %}

{% macro athena__redis_clusters_have_autominorversionupgrade(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Minor version upgrades should be automatically applied to ElastiCache for Redis cache clusters' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN auto_minor_version_upgrade = 'false' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_clusters
WHERE 
    engine = 'redis' 
{% endmacro %}