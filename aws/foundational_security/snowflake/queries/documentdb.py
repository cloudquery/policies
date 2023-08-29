
#DocumentDB.1
CLUSTERS_SHOULD_BE_ENCRYPTED_AT_REST = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon DocumentDB clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN storage_encrypted = false THEN 'fail'
        ELSE 'pass'
    END as status
FROM aws_docdb_clusters
"""

#DocumentDB.2
CLUSTERS_SHOULD_HAVE_7_DAYS_BACKUP_RETENTION = """
insert into aws_policy_results
SELECT 
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon DocumentDB clusters should have an adequate backup retention period' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN backup_retention_period >= 7 THEN 'pass'
        ELSE 'fail'
    END as status
FROM aws_docdb_clusters
"""