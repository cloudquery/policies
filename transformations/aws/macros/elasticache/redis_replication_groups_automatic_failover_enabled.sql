{% macro redis_replication_groups_automatic_failover_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('redis_replication_groups_automatic_failover_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__redis_replication_groups_automatic_failover_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__redis_replication_groups_automatic_failover_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups should have automatic failover enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN automatic_failover <> 'enabled' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_replication_groups
{% endmacro %}

{% macro snowflake__redis_replication_groups_automatic_failover_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups should have automatic failover enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN automatic_failover <> 'enabled' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_replication_groups
{% endmacro %}

{% macro bigquery__redis_replication_groups_automatic_failover_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups should have automatic failover enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN automatic_failover <> 'enabled' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    {{ full_table_name("aws_elasticache_replication_groups") }}
{% endmacro %}

{% macro athena__redis_replication_groups_automatic_failover_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups should have automatic failover enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN automatic_failover <> 'enabled' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_replication_groups
{% endmacro %}