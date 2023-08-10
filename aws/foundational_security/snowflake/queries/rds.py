#RDS.1
RDS_SNAPSHOTS_PUBLIC_PROHIBITED = """
INSERT INTO aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS snapshot should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN a.value:AttributeName = 'restore' and ARRAY_CONTAINS('all'::variant, a.value:AttributeValues) THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_rds_cluster_snapshots,
    LATERAL FLATTEN(ATTRIBUTES) a

UNION

SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS snapshot should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN a.value:AttributeName = 'restore' and ARRAY_CONTAINS('all'::variant, a.value:AttributeValues) THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_rds_db_snapshots,
    LATERAL FLATTEN(ATTRIBUTES) a;
"""


#RDS.2
INSTANCES_SHOULD_PROHIBIT_PUBLIC_ACCESS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS DB instances should prohibit public access, determined by the PubliclyAccessible configuration' as title,
    account_id,
    arn AS resource_id,
    case when publicly_accessible = TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

#RDS.8
INSTANCES_SHOULD_HAVE_DELETION_PROTECTION_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS DB instances should have deletion protection enabled' as title,
    account_id,
    arn AS resource_id,
    case when deletion_protection != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

#RDS.4
CLUSTER_SNAPSHOTS_AND_DATABASE_SNAPSHOTS_SHOULD_BE_ENCRYPTED_AT_REST = """
insert into aws_policy_results
(
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted != TRUE then 'fail' else 'pass' end as status
from aws_rds_cluster_snapshots
)
union
(
    select
        :1 as execution_time,
        :2 as framework,
        :3 as check_id,
        'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
        account_id,
        arn AS resource_id,
        case when encrypted != TRUE then 'fail' else 'pass' end as status
    from aws_rds_db_snapshots
)
"""

#RDS.3
INSTANCES_SHOULD_HAVE_ECNRYPTION_AT_REST_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS DB instances should have encryption at rest enabled' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""
#RDS.5
INSTANCES_SHOULD_BE_CONFIGURED_WITH_MULTIPLE_AZS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS DB instances should be configured with multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

#RDS.6
ENHANCED_MONITORING_SHOULD_BE_CONFIGURED_FOR_INSTANCES_AND_CLUSTERS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Enhanced monitoring should be configured for RDS DB instances and clusters' as title,
    account_id,
    arn AS resource_id,
    case when enhanced_monitoring_resource_arn is null then 'fail' else 'pass' end as status
from aws_rds_instances
"""

#RDS.7
CLUSTERS_SHOULD_HAVE_DELETION_PROTECTION_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS clusters should have deletion protection enabled' as title,
    account_id,
    arn AS resource_id,
    case when deletion_protection != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
"""

#RDS.9
DATABASE_LOGGING_SHOULD_BE_ENABLED = """
INSERT INTO aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Database logging should be enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN enabled_cloudwatch_logs_exports IS NULL THEN 'fail'
        WHEN engine IN ('aurora', 'aurora-mysql', 'mariadb', 'mysql') 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('audit', 'error', 'general', 'slowquery'))) THEN 'fail'
        WHEN engine LIKE '%postgres%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('postgresql', 'upgrade'))) THEN 'fail'
        WHEN engine LIKE '%oracle%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('alert', 'audit', 'trace', 'listener'))) THEN 'fail'
        WHEN engine LIKE '%sqlserver%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('error', 'agent'))) THEN 'fail'
        ELSE 'pass' 
    END AS status
FROM aws_rds_instances;
"""

#RDS.11
DB_INSTANCE_BACKUP_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS instances should have automatic backups enabled' as title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN backup_retention_period IS NULL
            OR backup_retention_period < 7 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_rds_instances
"""

#RDS.12
IAM_AUTHENTICATION_SHOULD_BE_CONFIGURED_FOR_RDS_CLUSTERS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'IAM authentication should be configured for RDS clusters' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
"""

#RDS.10
IAM_AUTHENTICATION_SHOULD_BE_CONFIGURED_FOR_RDS_INSTANCES = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'IAM authentication should be configured for RDS instances' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

#RDS.13
RDS_AUTOMATIC_MINOR_VERSION_UPGRADES_SHOULD_BE_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS automatic minor version upgrades should be enabled' as title,
    account_id,
    arn AS resource_id,
    case when auto_minor_version_upgrade != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

#RDS.14
AMAZON_AURORA_CLUSTERS_SHOULD_HAVE_BACKTRACKING_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon Aurora clusters should have backtracking enabled' as title,
    account_id,
    arn AS resource_id,
    case when backtrack_window is null then 'fail' else 'pass' end as status
from aws_rds_clusters
where
    engine in ('aurora', 'aurora-mysql', 'mysql')
"""

#RDS.15
CLUSTERS_SHOULD_BE_CONFIGURED_FOR_MULTIPLE_AVAILABILITY_ZONES = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS DB clusters should be configured for multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
"""

#RDS.16
CLUSTERS_SHOULD_BE_CONFIGURED_TO_COPY_TAGS_TO_SNAPSHOTS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS DB clusters should be configured to copy tags to snapshots' as title,
    account_id,
    arn AS resource_id,
    case when copy_tags_to_snapshot != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
"""

#RDS.17
INSTANCES_SHOULD_BE_CONFIGURED_TO_COPY_TAGS_TO_SNAPSHOTS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS DB instances should be configured to copy tags to snapshots' as title,
    account_id,
    arn AS resource_id,
    case when copy_tags_to_snapshot != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

#RDS.18
INSTANCES_SHOULD_BE_DEPLOYED_IN_A_VPC = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS instances should be deployed in a VPC' as title,
    account_id,
    arn AS resource_id,
    case when db_subnet_group:VpcId is null then 'fail' else 'pass' end as status
from aws_rds_instances
"""
#RDS.19
RDS_CLUSTER_EVENT_NOTIFICATIONS_CONFIGURED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'An RDS event notifications subscription should be configured for critical cluster events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            ARRAY_CONTAINS('maintenance'::variant, EVENT_CATEGORIES) AND
            ARRAY_CONTAINS('failure'::variant, EVENT_CATEGORIES)
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
WHERE source_type = 'db-cluster'
"""

#RDS.20
RDS_INSTANCE_EVENT_NOTIFICATIONS_CONFIGURED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'An RDS event notifications subscription should be configured for critical database instance events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN   
            ARRAY_CONTAINS('maintenance'::variant, EVENT_CATEGORIES) AND
            ARRAY_CONTAINS('configuration change'::variant, EVENT_CATEGORIES) AND
            ARRAY_CONTAINS('failure'::variant, EVENT_CATEGORIES)
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
WHERE
    source_type = 'db-instance'
"""

#RDS.21
RDS_PG_EVENT_NOTIFICATIONS_CONFIGURED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'An RDS event notifications subscription should be configured for critical database parameter group events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            ARRAY_CONTAINS('configuration change'::variant, EVENT_CATEGORIES) THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
where source_type = 'db-parameter-group'
"""

#RDS.22
RDS_SG_EVENT_NOTIFICATIONS_CONFIGURED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'An RDS event notifications subscription should be configured for critical database security group events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            ARRAY_CONTAINS('configuration change'::variant, EVENT_CATEGORIES) AND
            ARRAY_CONTAINS('failure'::variant, EVENT_CATEGORIES)
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
where source_type = 'db-security-group'
"""

#RDS.23
DATABASES_AND_CLUSTERS_SHOULD_NOT_USE_DATABASE_ENGINE_DEFAULT_PORT = """
INSERT INTO aws_policy_results
(
    SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS databases and clusters should not use a database engine default port' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN
        (engine IN ('aurora', 'aurora-mysql', 'mysql') AND port = 3306) OR (engine LIKE '%postgres%' AND port = 5432)
    THEN 'fail' ELSE 'pass' END AS status
    FROM aws_rds_clusters
)
UNION ALL
(
    SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS databases and clusters should not use a database engine default port' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN
        (
            engine IN ('aurora', 'aurora-mysql', 'mariadb', 'mysql')
            AND db_instance_port = 3306
        )
        OR (engine LIKE '%postgres%' AND db_instance_port = 5432)
        OR (engine LIKE '%oracle%' AND db_instance_port = 1521)
        OR (engine LIKE '%sqlserver%' AND db_instance_port = 1433)
    THEN 'fail' ELSE 'pass' END AS status
    FROM aws_rds_instances
);
"""

#RDS.24
RDS_CLUSTER_DEFAULT_ADMIN_CHECK = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS Database clusters should use a custom administrator username' as title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN master_username NOT IN ('admin', 'root', 'administrator', 'master', 'sa', 'awsuser') THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_clusters;
"""

#RDS.25
RDS_INSTANCE_DEFAULT_ADMIN_CHECK = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS database instances should use a custom administrator username' as title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN master_username NOT IN ('admin', 'root', 'administrator', 'master', 'sa', 'awsuser') THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_instances;
"""

#RDS.27
RDS_CLUSTER_ENCRYPTED_AT_REST = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'RDS DB clusters should be encrypted at rest' as title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN storage_encrypted THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_clusters;
"""

