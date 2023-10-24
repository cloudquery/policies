{% macro redis_clusters_have_autominorversionupgrade(framework, check_id) %}
insert into aws_policy_results
SELECT
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