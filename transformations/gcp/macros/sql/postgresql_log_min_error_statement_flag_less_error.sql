{% macro sql_postgresql_log_min_error_statement_flag_less_error(framework, check_id) %}
  {{ return(adapter.dispatch('sql_postgresql_log_min_error_statement_flag_less_error')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_postgresql_log_min_error_statement_flag_less_error(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_postgresql_log_min_error_statement_flag_less_error(framework, check_id) %}
select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the "log_min_messages" database flag for Cloud SQL PostgreSQL instance is set appropriately (Manual)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'POSTGRES%'
                        AND (f->>'value' IS NULL
                        OR f->>'value' NOT IN ('error', 'log', 'fatal', 'panic'))
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi LEFT JOIN JSONB_ARRAY_ELEMENTS(gsi.settings->'databaseFlags') AS f ON f->>'name'='log_min_error_statement'
{% endmacro %}

{% macro snowflake__sql_postgresql_log_min_error_statement_flag_less_error(framework, check_id) %}
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
                'Ensure that the "log_min_messages" database flag for Cloud SQL PostgreSQL instance is set appropriately (Manual)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'POSTGRES%'
                        AND (f.value:value IS NULL
                        OR f.value:value NOT IN ('error', 'log', 'fatal', 'panic'))
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi
    LEFT JOIN 
    instance_flags AS f ON f.value:name ='log_min_error_statement'
{% endmacro %}