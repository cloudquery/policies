{% macro iam_dataproc_clusters_encrypted_with_cmk(framework, check_id) %}
  {{ return(adapter.dispatch('iam_dataproc_clusters_encrypted_with_cmk')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_dataproc_clusters_encrypted_with_cmk(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_dataproc_clusters_encrypted_with_cmk(framework, check_id) %}
select distinct
        cluster_name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure that Dataproc Cluster is encrypted using Customer-Managed Encryption Key (Automated)'
        as title,
        project_id as project_id,
        case
            when
                config -> 'encryptionConfig' ->> 'gcePdKmsKeyName' is null
            then 'fail'
            else 'pass'
        end as status
    from gcp_dataproc_clusters 

{% endmacro %}

{% macro snowflake__iam_dataproc_clusters_encrypted_with_cmk(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure that Dataproc Cluster is encrypted using Customer-Managed Encryption Key (Automated)'
        as title,
        project_id as project_id,
        case
            when
                config:encryptionConfig.gcePdKmsKeyName is null
            then 'fail'
            else 'pass'
        end as status
    from gcp_dataproc_clusters 
    
{% endmacro %}

{% macro bigquery__iam_dataproc_clusters_encrypted_with_cmk(framework, check_id) %}
select distinct
        cluster_name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure that Dataproc Cluster is encrypted using Customer-Managed Encryption Key (Automated)'
        as title,
        project_id as project_id,
        case
            when
                json_extract(config,'$.encryption_config.gcePdKmsKeyName') is null
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_dataproc_clusters") }} 

{% endmacro %}