#neptune.1
NEPTUNE_CLUSTER_ENCRYPTED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Neptune DB clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    case when
    storage_encrypted = true then 'pass'
    else 'fail'
    end as status
from 
    aws_neptune_clusters
"""

#neptune.2
NEPTUNE_CLUSTER_CLOUDWATCH_LOG_EXPORT_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Neptune DB clusters should publish audit logs to CloudWatch Logs' as title,
    account_id,
    arn as resource_id,
    case when
         ARRAY_CONTAINS('audit'::variant, ENABLED_CLOUDWATCH_LOGS_EXPORTS) then 'pass'
    else 'fail'
    end as status
from 
    aws_neptune_clusters
"""

#neptune.3
NEPTUNE_CLUSTER_SNAPSHOT_PUBLIC_PROHIBITED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Neptune DB cluster snapshots should not be public' as title,
    account_id,
    arn as resource_id,
    case when
    attributes[0]:AttributeName = 'restore' and ARRAY_CONTAINS('all'::variant, attributes[0]:AttributeValues) then 'fail'
    else 'pass'
    end as status
from 
    aws_neptune_cluster_snapshots
"""

#neptune.4
NEPTUNE_CLUSTER_DELETION_PROTECTION_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Neptune DB clusters should have deletion protection enabled' as title,
    account_id,
    arn as resource_id,
    case when
    deletion_protection = true then 'pass'
    else 'fail'
    end as status
from 
    aws_neptune_clusters
"""

#neptune.5
NEPTUNE_CLUSTER_BACKUP_RETENTION_CHECK = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Neptune DB clusters should have automated backups enabled' as title,
    account_id,
    arn as resource_id,
    case when
    backup_retention_period IS NULL
    OR backup_retention_period < 7
    then 'fail'
    else 'pass'
    end as status
from 
    aws_neptune_clusters
"""

#neptune.6
NEPTUNE_CLUSTER_SNAPSHOT_ENCRYPTED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Neptune DB cluster snapshots should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    case when
    storage_encrypted = true then 'pass'
    else 'fail'
    end as status
from 
    aws_neptune_cluster_snapshots
"""

#neptune.7
NEPTUNE_CLUSTER_IAM_DATABASE_AUTHENTICATION = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Neptune DB clusters should have IAM database authentication enabled' as title,
    account_id,
    arn as resource_id,
    case when
    iam_database_authentication_enabled = true then 'pass'
    else 'fail'
    end as status
from 
    aws_neptune_clusters
"""

#neptune.8
NEPTUNE_CLUSTER_COPY_TAGS_TO_SNAPSHOT_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Neptune DB clusters should be configured to copy tags to snapshots' as title,
    account_id,
    arn as resource_id,
    case when
     copy_tags_to_snapshot = true then 'pass'
     else 'fail'
     end as status
from 
    aws_neptune_clusters
"""