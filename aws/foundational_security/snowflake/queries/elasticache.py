REDIS_CLUSTERS_SHOULD_HAVE_AUTOMATIC_BACKUPS = """
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
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
"""

REDIS_CLUSTERS_HAVE_AUTOMINORVERSIONUPGRADE = """
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
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
"""

REDIS_REPLICATION_GROUPS_AUTOMATIC_FAILOVER_ENABLED = """
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'ElastiCache for Redis replication groups should have automatic failover enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN automatic_failover <> 'enabled' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_replication_groups
"""

REDIS_REPLICATION_GROUPS_ENCRYPTED_AT_REST = """
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'ElastiCache for Redis replication groups should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN at_rest_encryption_enabled = 'true' THEN 'pass'
        ELSE 'fail'
    END as status
FROM 
    aws_elasticache_replication_groups
"""

REDIS_REPLICATION_GROUPS_ENCRYPTED_IN_TRANSIT = """
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'ElastiCache for Redis replication groups should be encrypted in transit' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN transit_encryption_enabled = 'false' OR transit_encryption_enabled IS NULL THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_replication_groups
"""

REDIS_REPLICATION_GROUPS_UNDER_VERSION_6_USE_AUTH = """
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
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
"""

CLUSTERS_SHOULD_NOT_USE_DEFAULT_SUBNET_GROUP = """
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'ElastiCache clusters should not use the default subnet group' as title, 
    account_id,
    arn as resource_id,
    CASE 
        WHEN cache_subnet_group_name = 'default' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_elasticache_clusters 
"""