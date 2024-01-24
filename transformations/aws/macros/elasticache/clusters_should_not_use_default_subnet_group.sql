{% macro clusters_should_not_use_default_subnet_group(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_not_use_default_subnet_group')(framework, check_id)) }}
{% endmacro %}

{% macro default__clusters_should_not_use_default_subnet_group(framework, check_id) %}{% endmacro %}

{% macro postgres__clusters_should_not_use_default_subnet_group(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache clusters should not use the default subnet group' as title, 
    account_id,
    arn as resource_id,
    CASE 
        WHEN cache_subnet_group_name = 'default' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_clusters 
{% endmacro %}

{% macro snowflake__clusters_should_not_use_default_subnet_group(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache clusters should not use the default subnet group' as title, 
    account_id,
    arn as resource_id,
    CASE 
        WHEN cache_subnet_group_name = 'default' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_clusters 
{% endmacro %}

{% macro bigquery__clusters_should_not_use_default_subnet_group(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache clusters should not use the default subnet group' as title, 
    account_id,
    arn as resource_id,
    CASE 
        WHEN cache_subnet_group_name = 'default' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    {{ full_table_name("aws_elasticache_clusters") }}
{% endmacro %}