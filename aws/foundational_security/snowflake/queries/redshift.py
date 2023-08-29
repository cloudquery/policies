
CLUSTER_PUBLICLY_ACCESSIBLE = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon Redshift clusters should prohibit public access' as title,
    account_id,
    arn AS resource_id,
    case when publicly_accessible = TRUE then 'fail' else 'pass' end as status
from aws_redshift_clusters
"""

CLUSTERS_SHOULD_BE_ENCRYPTED_IN_TRANSIT = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
'Connections to Amazon Redshift clusters should be encrypted in transit' AS title,
  rsc.account_id,
  rsc.arn AS resource_id,
  'fail' AS status
FROM
  aws_redshift_clusters AS rsc
JOIN
  aws_redshift_cluster_parameter_groups AS rscpg ON rsc.arn = rscpg.cluster_arn
LEFT JOIN
  aws_redshift_cluster_parameters AS rscp ON rscpg.cluster_arn = rscp.cluster_arn
  AND rscp.parameter_name = 'require_ssl'
WHERE
  (rscp.parameter_value = 'false')
  OR (rscp.parameter_value IS NULL)
  OR NOT EXISTS (
    SELECT
      1
    FROM
      aws_redshift_cluster_parameters
    WHERE
      cluster_arn = rscpg.cluster_arn
      AND parameter_name = 'require_ssl'
 )
"""

CLUSTERS_SHOULD_HAVE_AUTOMATIC_SNAPSHOTS_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon Redshift clusters should have automatic snapshots enabled' as title,
    account_id,
    arn as resource_id,
    case when
        automated_snapshot_retention_period < 7 or automated_snapshot_retention_period is null
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
"""

CLUSTERS_SHOULD_HAVE_AUDIT_LOGGING_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon Redshift clusters should have audit logging enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN 
        IFNULL(logging_status:LoggingEnabled::STRING, 'false') != 'true'
    THEN 'fail' ELSE 'pass' END AS status
FROM aws_redshift_clusters
"""

CLUSTERS_SHOULD_HAVE_AUTOMATIC_UPGRADES_TO_MAJOR_VERSIONS_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon Redshift should have automatic upgrades to major versions enabled' as title,
    account_id,
    arn as resource_id,
    case when
        allow_version_upgrade is distinct from TRUE
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
"""

CLUSTERS_SHOULD_USE_ENHANCED_VPC_ROUTING = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon Redshift clusters should use enhanced VPC routing' as title,
    account_id,
    arn as resource_id,
    case when
        enhanced_vpc_routing is distinct from TRUE
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
"""

#Redshift.8
REDSHIFT_DEFAULT_ADMIN_CHECK = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon Redshift clusters should not use the default Admin username' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN master_username = 'awsuser' THEN 'fail'
    ELSE 'pass'
    END AS status
from aws_redshift_clusters
"""

#Redshift.9
REDSHIFT_DEFAULT_DB_NAME_CHECK = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Redshift clusters should not use the default database name' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN db_name = 'dev' THEN 'fail'
    ELSE 'pass'
    END AS status
from aws_redshift_clusters
"""

#Redshift.10
REDSHIFT_CLUSTER_KMS_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Redshift clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN encrypted AND kms_key_id is not null THEN 'pass'
    ELSE 'fail'
    END AS status
from aws_redshift_clusters
"""