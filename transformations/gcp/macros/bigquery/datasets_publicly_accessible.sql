{% macro bigquery_datasets_publicly_accessible(framework, check_id) %}
  {{ return(adapter.dispatch('bigquery_datasets_publicly_accessible')(framework, check_id)) }}
{% endmacro %}

{% macro default__bigquery_datasets_publicly_accessible(framework, check_id) %}{% endmacro %}

{% macro postgres__bigquery_datasets_publicly_accessible(framework, check_id) %}
select DISTINCT 
                d.id                                                                                   AS resource_id,
                d._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that BigQuery datasets are not anonymously or publicly accessible (Automated)' AS title,
                d.project_id                                                                           AS project_id,
                CASE
                    WHEN
                                a->>'role' = 'allUsers'
                            OR a->>'role' = 'allAuthenticatedUsers'
                        THEN 'fail'
                    ELSE 'pass'
                    END                                                                                AS status
FROM gcp_bigquery_datasets d, JSONB_ARRAY_ELEMENTS(d.access) AS a
{% endmacro %}

{% macro snowflake__bigquery_datasets_publicly_accessible(framework, check_id) %}
 select DISTINCT 
                d.id                                                                                   AS resource_id,
                d._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that BigQuery datasets are not anonymously or publicly accessible (Automated)' AS title,
                d.project_id                                                                           AS project_id,
                CASE
                    WHEN
                                a.value:role = 'allUsers'
                            OR a.value:role = 'allAuthenticatedUsers'
                        THEN 'fail'
                    ELSE 'pass'
                    END                                                                                AS status
FROM gcp_bigquery_datasets d,
LATERAL FLATTEN(input => d.access) AS a
{% endmacro %}