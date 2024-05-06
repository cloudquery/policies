{% macro cluster_endpoints_not_publicly_accessible(framework, check_id) %}
  {{ return(adapter.dispatch('cluster_endpoints_not_publicly_accessible')(framework, check_id)) }}
{% endmacro %}

{% macro default__cluster_endpoints_not_publicly_accessible(framework, check_id) %}{% endmacro %}

{% macro postgres__cluster_endpoints_not_publicly_accessible(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EKS cluster endpoints should not be publicly accessible' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN resources_vpc_config ->> 'endpointPublicAccess' = 'true' THEN 'fail'
        ELSE 'pass'
    END as status
FROM aws_eks_clusters
{% endmacro %}

{% macro snowflake__cluster_endpoints_not_publicly_accessible(framework, check_id) %}
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

{% macro bigquery__cluster_endpoints_not_publicly_accessible(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EKS cluster endpoints should not be publicly accessible' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN JSON_VALUE(resources_vpc_config.endpointPublicAccess) = 'true' THEN 'fail'
        ELSE 'pass'
    END as status
FROM {{ full_table_name("aws_eks_clusters") }}
{% endmacro %}

{% macro athena__cluster_endpoints_not_publicly_accessible(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EKS cluster endpoints should not be publicly accessible' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN json_extract_scalar(resources_vpc_config, '$.endpointPublicAccess') = 'true' THEN 'fail'
        ELSE 'pass'
    END as status
FROM aws_eks_clusters
{% endmacro %}