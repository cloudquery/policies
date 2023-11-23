{% macro sql_db_instances_without_backups(framework, check_id) %}
  {{ return(adapter.dispatch('sql_db_instances_without_backups')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_db_instances_without_backups(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_db_instances_without_backups(framework, check_id) %}
select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud SQL database instances are configured with automated backups (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
           WHEN
                       gsi.database_version LIKE 'SQLSERVER%'
                   AND (gsi.settings->'backupConfiguration'->>'enabled')::boolean = FALSE
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_sql_instances gsi
{% endmacro %}

{% macro snowflake__sql_db_instances_without_backups(framework, check_id) %}
select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud SQL database instances are configured with automated backups (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
           WHEN
                       gsi.database_version LIKE 'SQLSERVER%'
                   AND (gsi.settings:backupConfiguration:enabled)::boolean = FALSE
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_sql_instances gsi
{% endmacro %}

{% macro bigquery__sql_db_instances_without_backups(framework, check_id) %}
select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud SQL database instances are configured with automated backups (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
           WHEN
                       gsi.database_version LIKE 'SQLSERVER%'
                   AND CAST( JSON_VALUE(gsi.settings.backupConfiguration.enabled) AS BOOL) = FALSE
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM {{ full_table_name("gcp_sql_instances") }} gsi
{% endmacro %}