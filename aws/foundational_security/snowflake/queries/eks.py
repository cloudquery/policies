CLUSTER_ENDPOINTS_NOT_PUBLICLY_ACCESSIBLE = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'EKS cluster endpoints should not be publicly accessible' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN resources_vpc_config:endpointPublicAccess = 'true' THEN 'fail'
        ELSE 'pass'
    END as status
FROM aws_eks_clusters
"""

CLUSTERS_SHOULD_RUN_ON_SUPPORTED_KUBERNETERS_VERSION = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'EKS clusters should run on a supported Kubernetes version' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN version::float < 1.23 THEN 'fail'
        ELSE 'pass'
    END as status
FROM aws_eks_clusters
"""