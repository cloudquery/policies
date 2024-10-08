{% macro redis_replication_groups_under_version_6_use_auth(framework, check_id) %}
  {{ return(adapter.dispatch('redis_replication_groups_under_version_6_use_auth')(framework, check_id)) }}
{% endmacro %}

{% macro default__redis_replication_groups_under_version_6_use_auth(framework, check_id) %}{% endmacro %}

{% macro postgres__redis_replication_groups_under_version_6_use_auth(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups before version 6.0 should use Redis AUTH' as title,
    r.account_id,
    r.arn as resource_id,
    CASE
        WHEN c.engine_version < '6.0' AND r.auth_token_enabled = 'false'THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_replication_groups r
JOIN 
    aws_elasticache_clusters c ON r.replication_group_id = c.replication_group_id
{% endmacro %}

{% macro snowflake__redis_replication_groups_under_version_6_use_auth(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups before version 6.0 should use Redis AUTH' as title,
    r.account_id,
    r.arn as resource_id,
    CASE
        WHEN c.engine_version < '6.0' AND r.auth_token_enabled = 'false' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_replication_groups r
JOIN 
    aws_elasticache_clusters c ON r.replication_group_id = c.replication_group_id
{% endmacro %}

{% macro bigquery__redis_replication_groups_under_version_6_use_auth(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups before version 6.0 should use Redis AUTH' as title,
    r.account_id,
    r.arn as resource_id,
    CASE
        WHEN CAST(c.engine_version AS float64) < 6.0 AND r.auth_token_enabled = false THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    {{ full_table_name("aws_elasticache_replication_groups") }} r
JOIN 
    {{ full_table_name("aws_elasticache_clusters") }} c 
    ON r.replication_group_id = c.replication_group_id
 {% endmacro %}

 {% macro athena__redis_replication_groups_under_version_6_use_auth(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups before version 6.0 should use Redis AUTH' as title,
    r.account_id,
    r.arn as resource_id,
    CASE
        WHEN c.engine_version < '6.0' AND r.auth_token_enabled = false THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_replication_groups r
JOIN 
    aws_elasticache_clusters c ON r.replication_group_id = c.replication_group_id
{% endmacro %}