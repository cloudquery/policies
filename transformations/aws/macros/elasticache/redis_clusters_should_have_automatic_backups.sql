{% macro redis_clusters_should_have_automatic_backups(framework, check_id) %}
  {{ return(adapter.dispatch('redis_clusters_should_have_automatic_backups')(framework, check_id)) }}
{% endmacro %}

{% macro default__redis_clusters_should_have_automatic_backups(framework, check_id) %}{% endmacro %}

{% macro postgres__redis_clusters_should_have_automatic_backups(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis clusters should have automatic backups scheduled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN (snapshot_retention_limit IS NULL OR snapshot_retention_limit < 1) THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_clusters
WHERE 
    engine = 'redis'
{% endmacro %}

{% macro snowflake__redis_clusters_should_have_automatic_backups(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis clusters should have automatic backups scheduled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN (snapshot_retention_limit IS NULL OR snapshot_retention_limit < 1) THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_clusters
WHERE 
    engine = 'redis' 
{% endmacro %}

{% macro bigquery__redis_clusters_should_have_automatic_backups(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis clusters should have automatic backups scheduled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN (snapshot_retention_limit IS NULL OR snapshot_retention_limit < 1) THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    {{ full_table_name("aws_elasticache_clusters") }}
WHERE 
    engine = 'redis' 
{% endmacro %}