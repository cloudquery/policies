{% macro sql_sqlserver_user_connections_flag_not_set(framework, check_id) %}
    select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As execution_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "user connections" database flag for Cloud SQL SQL Server instance is set as appropriate (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                                gsi.database_version LIKE 'SQLSERVER%'
                            AND f->>'value' IS NULL
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi LEFT JOIN JSONB_ARRAY_ELEMENTS(gsi.settings->'databaseFlags') AS f ON f->>'name'='user connections'
{% endmacro %}