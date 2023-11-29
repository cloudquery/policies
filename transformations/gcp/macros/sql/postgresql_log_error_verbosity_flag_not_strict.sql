{% macro sql_postgresql_log_error_verbosity_flag_not_strict(framework, check_id) %}
  {{ return(adapter.dispatch('sql_postgresql_log_error_verbosity_flag_not_strict')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_postgresql_log_error_verbosity_flag_not_strict(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_postgresql_log_error_verbosity_flag_not_strict(framework, check_id) %}
select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "log_error_verbosity" database flag for Cloud SQL PostgreSQL instance is set to "DEFAULT" or stricter (Manual)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'POSTGRES%'
                        AND (f->>'value' IS NULL
                        OR f->>'value' NOT IN ('default', 'terse'))
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi LEFT JOIN JSONB_ARRAY_ELEMENTS(gsi.settings->'databaseFlags') AS f ON f->>'name'='log_error_verbosity'
{% endmacro %}

{% macro snowflake__sql_postgresql_log_error_verbosity_flag_not_strict(framework, check_id) %}
WITH 
    instance_flags as (
    select
        f.value as value             
    FROM gcp_sql_instances gsi,
    LATERAL FLATTEN(input => gsi.settings:databaseFlags) AS f
    )
select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "log_error_verbosity" database flag for Cloud SQL PostgreSQL instance is set to "DEFAULT" or stricter (Manual)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'POSTGRES%'
                        AND (f.value:value IS NULL
                        OR f.value:value NOT IN ('default', 'terse'))
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi
    LEFT JOIN 
    instance_flags AS f ON f.value:name ='log_error_verbosity'
{% endmacro %}

{% macro bigquery__sql_postgresql_log_error_verbosity_flag_not_strict(framework, check_id) %}
WITH 
    instance_flags as (
    select
        f as value
    FROM {{ full_table_name("gcp_sql_instances") }} gsi,
    UNNEST(JSON_QUERY_ARRAY(settings.databaseFlags)) AS f
    )

select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "log_error_verbosity" database flag for Cloud SQL PostgreSQL instance is set to "DEFAULT" or stricter (Manual)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'POSTGRES%'
                        AND (f.value.value IS NULL
                        OR JSON_VALUE(f.value.value) NOT IN ('default', 'terse'))
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_sql_instances") }} gsi
    LEFT JOIN 
    instance_flags AS f ON JSON_VALUE(f.value.name) ='log_error_verbosity'
{% endmacro %}