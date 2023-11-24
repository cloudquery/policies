{% macro sql_db_instance_without_ssl(framework, check_id) %}
  {{ return(adapter.dispatch('sql_db_instance_without_ssl')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_db_instance_without_ssl(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_db_instance_without_ssl(framework, check_id) %}
 select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the Cloud SQL database instance requires all incoming connections to use SSL (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'SQLSERVER%'
                        AND (gsi.settings->'ipConfiguration'->>'requireSsl')::boolean = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi
{% endmacro %}

{% macro snowflake__sql_db_instance_without_ssl(framework, check_id) %}
select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the Cloud SQL database instance requires all incoming connections to use SSL (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'SQLSERVER%'
                        AND (gsi.settings:ipConfiguration:requireSsl)::boolean = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi
{% endmacro %}