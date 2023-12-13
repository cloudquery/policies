{% macro clusters_should_run_on_supported_kuberneters_version(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_run_on_supported_kuberneters_version')(framework, check_id)) }}
{% endmacro %}

{% macro default__clusters_should_run_on_supported_kuberneters_version(framework, check_id) %}{% endmacro %}

{% macro postgres__clusters_should_run_on_supported_kuberneters_version(framework, check_id) %}
select
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

{% macro snowflake__clusters_should_run_on_supported_kuberneters_version(framework, check_id) %}
select
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