{% macro redis_replication_groups_encrypted_in_transit(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'ElastiCache for Redis replication groups should be encrypted in transit' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN transit_encryption_enabled = 'false' OR transit_encryption_enabled IS NULL THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_replication_groups
{% endmacro %}