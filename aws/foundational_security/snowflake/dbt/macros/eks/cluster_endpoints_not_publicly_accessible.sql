{% macro cluster_endpoints_not_publicly_accessible(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EKS cluster endpoints should not be publicly accessible' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN resources_vpc_config:endpointPublicAccess = 'true' THEN 'fail'
        ELSE 'pass'
    END as status
FROM aws_eks_clusters
{% endmacro %}