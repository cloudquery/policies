{% macro sql_db_instance_publicly_accessible(framework, check_id) %}
  {{ return(adapter.dispatch('sql_db_instance_publicly_accessible')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_db_instance_publicly_accessible(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_db_instance_publicly_accessible(framework, check_id) %}
select DISTINCT
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud SQL database instances are not open to the world (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                    WHEN
                                gsi.database_version LIKE 'SQLSERVER%'
                            AND gsisican->>'value' = '0.0.0.0/0'
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
FROM gcp_sql_instances gsi, JSONB_ARRAY_ELEMENTS(gsi.settings->'ipConfiguration'->'authorizedNetworks') AS gsisican 
{% endmacro %}

{% macro snowflake__sql_db_instance_publicly_accessible(framework, check_id) %}
select DISTINCT
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud SQL database instances are not open to the world (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                    WHEN
                                gsi.database_version LIKE 'SQLSERVER%'
                            AND gsisican.value:value = '0.0.0.0/0'
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
FROM gcp_sql_instances gsi,
LATERAL FLATTEN(input => gsi.settings:ipConfiguration:authorizedNetworks) AS gsisican
{% endmacro %}