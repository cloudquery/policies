{% macro redis_replication_groups_automatic_failover_enabled(framework, check_id) %}
insert into aws_policy_results
SELECT
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