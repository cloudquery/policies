{% macro bigquery_datasets_without_default_cmek(framework, check_id) %}
  {{ return(adapter.dispatch('bigquery_datasets_without_default_cmek')(framework, check_id)) }}
{% endmacro %}

{% macro default__bigquery_datasets_without_default_cmek(framework, check_id) %}{% endmacro %}

{% macro postgres__bigquery_datasets_without_default_cmek(framework, check_id) %}
select
    DISTINCT 
                d.id                                                                                   AS resource_id,
                d._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that all BigQuery Tables are encrypted with Customer-managed encryption key (CMEK) (Automated)' AS title,
                d.project_id                                                                           AS project_id,
                CASE
                WHEN
                        d.default_encryption_configuration->>'kmsKeyName' = ''
                        OR d.default_encryption_configuration->>'kmsKeyName' IS NULL -- TODO check if valid
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_bigquery_datasets d
{% endmacro %}

{% macro snowflake__bigquery_datasets_without_default_cmek(framework, check_id) %}
select
    DISTINCT 
                d.id                                                                                   AS resource_id,
                d._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that all BigQuery Tables are encrypted with Customer-managed encryption key (CMEK) (Automated)' AS title,
                d.project_id                                                                           AS project_id,
                CASE
                WHEN
                        d.default_encryption_configuration:kmsKeyName = ''
                        OR d.default_encryption_configuration:kmsKeyName IS NULL -- TODO check if valid
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_bigquery_datasets d
{% endmacro %}