{% macro bigquery_tables_not_encrypted_with_cmek(framework, check_id) %}
  {{ return(adapter.dispatch('bigquery_tables_not_encrypted_with_cmek')(framework, check_id)) }}
{% endmacro %}

{% macro default__bigquery_tables_not_encrypted_with_cmek(framework, check_id) %}{% endmacro %}

{% macro postgres__bigquery_tables_not_encrypted_with_cmek(framework, check_id) %}
 select
    DISTINCT 
                d.id                                                                                   AS resource_id,
                d._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that a Default Customer-managed encryption key (CMEK) is specified for all BigQuery Data Sets (Automated)' AS title,
                d.project_id                                                                           AS project_id,
                CASE
                    WHEN
                                t.encryption_configuration->>'kmsKeyName' = '' OR
                                d.default_encryption_configuration->>'kmsKeyName' IS NULL -- TODO check if valid
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_bigquery_datasets d
    JOIN gcp_bigquery_tables t ON 
        d.dataset_reference->>'datasetId' = t.table_reference->>'datasetId' AND d.dataset_reference->>'projectId' = t.table_reference->>'projectId'
{% endmacro %}

{% macro snowflake__bigquery_tables_not_encrypted_with_cmek(framework, check_id) %}
 select
    DISTINCT 
                d.id                                                                                   AS resource_id,
                d._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that a Default Customer-managed encryption key (CMEK) is specified for all BigQuery Data Sets (Automated)' AS title,
                d.project_id                                                                           AS project_id,
                CASE
                    WHEN
                                t.encryption_configuration:kmsKeyName = '' OR
                                d.default_encryption_configuration:kmsKeyName IS NULL -- TODO check if valid
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_bigquery_datasets d
    JOIN gcp_bigquery_tables t ON
        d.dataset_reference:datasetId = t.table_reference:datasetId AND d.dataset_reference:projectId = t.table_reference:projectId
{% endmacro %}

{% macro bigquery__bigquery_tables_not_encrypted_with_cmek(framework, check_id) %}
  select
    DISTINCT 
                d.id                                                                                   AS resource_id,
                d._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that a Default Customer-managed encryption key (CMEK) is specified for all BigQuery Data Sets (Automated)' AS title,
                d.project_id                                                                           AS project_id,
                CASE
                    WHEN
                                JSON_VALUE(t.encryption_configuration.kmsKeyName) = '' OR
                                d.default_encryption_configuration.kmsKeyName IS NULL -- TODO check if valid
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM {{ full_table_name("gcp_bigquery_datasets") }} d
    JOIN {{ full_table_name("gcp_bigquery_tables") }} t ON
        JSON_VALUE(d.dataset_reference.datasetId) = JSON_VALUE(t.table_reference.datasetId) AND JSON_VALUE(d.dataset_reference.projectId) = JSON_VALUE(t.table_reference.projectId)
{% endmacro %}