{% macro redis_replication_groups_encrypted_at_rest(framework, check_id) %}
  {{ return(adapter.dispatch('redis_replication_groups_encrypted_at_rest')(framework, check_id)) }}
{% endmacro %}

{% macro default__redis_replication_groups_encrypted_at_rest(framework, check_id) %}{% endmacro %}

{% macro postgres__redis_replication_groups_encrypted_at_rest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN at_rest_encryption_enabled = 'true' THEN 'pass'
        ELSE 'fail'
    END as status
FROM 
    aws_elasticache_replication_groups
{% endmacro %}

{% macro snowflake__redis_replication_groups_encrypted_at_rest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN at_rest_encryption_enabled = 'true' THEN 'pass'
        ELSE 'fail'
    END as status
FROM 
    aws_elasticache_replication_groups
{% endmacro %}

{% macro bigquery__redis_replication_groups_encrypted_at_rest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN at_rest_encryption_enabled = true THEN 'pass'
        ELSE 'fail'
    END as status
FROM 
    {{ full_table_name("aws_elasticache_replication_groups") }}
{% endmacro %}

{% macro athena__redis_replication_groups_encrypted_at_rest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN at_rest_encryption_enabled = true THEN 'pass'
        ELSE 'fail'
    END as status
FROM 
    aws_elasticache_replication_groups
{% endmacro %}