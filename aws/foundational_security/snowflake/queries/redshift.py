
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
    'Connections to Amazon Redshift clusters should be encrypted in transit' as title,
    account_id,
    arn as resource_id,
    'fail' as status -- TODO FIXME
from aws_redshift_clusters as rsc

where exists(select 1
                    from aws_redshift_cluster_parameter_groups as rscpg
    inner join aws_redshift_cluster_parameters as rscp
        on
            rscpg.cluster_arn = rscp.cluster_arn
    where rsc.arn = rscpg.cluster_arn
        and (
            rscp.parameter_name = 'require_ssl' and rscp.parameter_value = 'false'
        )
        or (
            rscp.parameter_name = 'require_ssl' and rscp.parameter_value is null
        )
        or not exists((select 1
            from aws_redshift_cluster_parameters
            where cluster_arn = rscpg.cluster_arn
                and parameter_name = 'require_ssl'))
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
