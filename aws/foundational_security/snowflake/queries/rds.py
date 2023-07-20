INSTANCES_SHOULD_PROHIBIT_PUBLIC_ACCESS = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS DB instances should prohibit public access, determined by the PubliclyAccessible configuration' as title,
    account_id,
    arn AS resource_id,
    case when publicly_accessible = TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""


INSTANCES_SHOULD_HAVE_DELETION_PROTECTION_ENABLED = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS DB instances should have deletion protection enabled' as title,
    account_id,
    arn AS resource_id,
    case when deletion_protection != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

CLUSTER_SNAPSHOTS_AND_DATABASE_SNAPSHOTS_SHOULD_BE_ENCRYPTED_AT_REST = """
insert into aws_policy_results
(
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted != TRUE then 'fail' else 'pass' end as status
from aws_rds_cluster_snapshots
)
union
(
    select
        %s as execution_time,
        %s as framework,
        %s as check_id,
        'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
        account_id,
        arn AS resource_id,
        case when encrypted != TRUE then 'fail' else 'pass' end as status
    from aws_rds_db_snapshots
)
"""

INSTANCES_SHOULD_HAVE_ECNRYPTION_AT_REST_ENABLED = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS DB instances should have encryption at rest enabled' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""
INSTANCES_SHOULD_BE_CONFIGURED_WITH_MULTIPLE_AZS = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS DB instances should be configured with multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

ENHANCED_MONITORING_SHOULD_BE_CONFIGURED_FOR_INSTANCES_AND_CLUSTERS = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'Enhanced monitoring should be configured for RDS DB instances and clusters' as title,
    account_id,
    arn AS resource_id,
    case when enhanced_monitoring_resource_arn is null then 'fail' else 'pass' end as status
from aws_rds_instances
"""

CLUSTERS_SHOULD_HAVE_DELETION_PROTECTION_ENABLED = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS clusters should have deletion protection enabled' as title,
    account_id,
    arn AS resource_id,
    case when deletion_protection != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
"""

DATABASE_LOGGING_SHOULD_BE_ENABLED = """
INSERT INTO aws_policy_results
SELECT
    %s AS execution_time,
    %s AS framework,
    %s AS check_id,
    'Database logging should be enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN enabled_cloudwatch_logs_exports IS NULL THEN 'fail'
        WHEN engine IN ('aurora', 'aurora-mysql', 'mariadb', 'mysql') 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('audit', 'error', 'general', 'slowquery'))) THEN 'fail'
        WHEN engine LIKE '%%postgres%%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('postgresql', 'upgrade'))) THEN 'fail'
        WHEN engine LIKE '%%oracle%%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('alert', 'audit', 'trace', 'listener'))) THEN 'fail'
        WHEN engine LIKE '%%sqlserver%%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('error', 'agent'))) THEN 'fail'
        ELSE 'pass' 
    END AS status
FROM aws_rds_instances;
"""

IAM_AUTHENTICATION_SHOULD_BE_CONFIGURED_FOR_RDS_CLUSTERS = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'IAM authentication should be configured for RDS clusters' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
"""

IAM_AUTHENTICATION_SHOULD_BE_CONFIGURED_FOR_RDS_INSTANCES = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'IAM authentication should be configured for RDS instances' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

RDS_AUTOMATIC_MINOR_VERSION_UPGRADES_SHOULD_BE_ENABLED = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS automatic minor version upgrades should be enabled' as title,
    account_id,
    arn AS resource_id,
    case when auto_minor_version_upgrade != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

AMAZON_AURORA_CLUSTERS_SHOULD_HAVE_BACKTRACKING_ENABLED = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'Amazon Aurora clusters should have backtracking enabled' as title,
    account_id,
    arn AS resource_id,
    case when backtrack_window is null then 'fail' else 'pass' end as status
from aws_rds_clusters
where
    engine in ('aurora', 'aurora-mysql', 'mysql')
"""

CLUSTERS_SHOULD_BE_CONFIGURED_FOR_MULTIPLE_AVAILABILITY_ZONES = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS DB clusters should be configured for multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
"""

CLUSTERS_SHOULD_BE_CONFIGURED_TO_COPY_TAGS_TO_SNAPSHOTS = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS DB clusters should be configured to copy tags to snapshots' as title,
    account_id,
    arn AS resource_id,
    case when copy_tags_to_snapshot != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
"""

INSTANCES_SHOULD_BE_CONFIGURED_TO_COPY_TAGS_TO_SNAPSHOTS = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS DB instances should be configured to copy tags to snapshots' as title,
    account_id,
    arn AS resource_id,
    case when copy_tags_to_snapshot != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
"""

INSTANCES_SHOULD_BE_DEPLOYED_IN_A_VPC = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'RDS instances should be deployed in a VPC' as title,
    account_id,
    arn AS resource_id,
    case when db_subnet_group:VpcId is null then 'fail' else 'pass' end as status
from aws_rds_instances
"""

DATABASES_AND_CLUSTERS_SHOULD_NOT_USE_DATABASE_ENGINE_DEFAULT_PORT = """
INSERT INTO aws_policy_results
(
    SELECT
    %s AS execution_time,
    %s AS framework,
    %s AS check_id,
    'RDS databases and clusters should not use a database engine default port' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN
        (engine IN ('aurora', 'aurora-mysql', 'mysql') AND port = 3306) OR (engine LIKE '%%postgres%%' AND port = 5432)
    THEN 'fail' ELSE 'pass' END AS status
    FROM aws_rds_clusters
)
UNION ALL
(
    SELECT
    %s AS execution_time,
    %s AS framework,
    %s AS check_id,
    'RDS databases and clusters should not use a database engine default port' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN
        (
            engine IN ('aurora', 'aurora-mysql', 'mariadb', 'mysql')
            AND db_instance_port = 3306
        )
        OR (engine LIKE '%%postgres%%' AND db_instance_port = 5432)
        OR (engine LIKE '%%oracle%%' AND db_instance_port = 1521)
        OR (engine LIKE '%%sqlserver%%' AND db_instance_port = 1433)
    THEN 'fail' ELSE 'pass' END AS status
    FROM aws_rds_instances
);
"""