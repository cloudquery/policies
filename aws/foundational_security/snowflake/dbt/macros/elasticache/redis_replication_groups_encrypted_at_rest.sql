{% macro redis_replication_groups_encrypted_at_rest(framework, check_id) %}
insert into aws_policy_results
SELECT
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