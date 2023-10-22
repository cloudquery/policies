{% macro sql_db_instance_with_public_ip(framework, check_id) %}
    select DISTINCT
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As execution_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud SQL database instances do not have public IPs (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                    WHEN
                                    gsi.database_version LIKE 'SQLSERVER%'
                                AND gsiia->>'type' = 'PRIMARY' OR gsi.backend_type != 'SECOND_GEN'
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_sql_instances gsi, JSONB_ARRAY_ELEMENTS(gsi.ip_addresses) AS gsiia
{% endmacro %}