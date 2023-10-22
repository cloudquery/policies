{% macro sql_db_instance_publicly_accessible(framework, check_id) %}
    select DISTINCT
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As execution_time,
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