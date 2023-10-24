{% macro clusters_should_run_on_supported_kuberneters_version(framework, check_id) %}
insert into aws_policy_results
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EKS clusters should run on a supported Kubernetes version' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN version::float < 1.23 THEN 'fail'
        ELSE 'pass'
    END as status
FROM aws_eks_clusters
{% endmacro %}