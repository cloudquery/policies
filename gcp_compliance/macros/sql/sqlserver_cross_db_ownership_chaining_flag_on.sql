{% macro sql_sqlserver_cross_db_ownership_chaining_flag_on(framework, check_id) %}
    select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As execution_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the "cross db ownership chaining" database flag for Cloud SQL SQL Server instance is set to "off" (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'SQLSERVER%'
                        AND (f->>'value' IS NULL
                        OR f->>'value' != 'off')
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi LEFT JOIN JSONB_ARRAY_ELEMENTS(gsi.settings->'databaseFlags') AS f ON f->>'name'='cross db ownership chaining'
{% endmacro %}