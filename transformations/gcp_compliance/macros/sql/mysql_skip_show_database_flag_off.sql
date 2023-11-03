{% macro sql_mysql_skip_show_database_flag_off(framework, check_id) %}
    select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "skip_show_database" database flag for Cloud SQL Mysql instance is set to "on" (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'MYSQL%'
                        AND (f->>'value' IS NULL
                        OR f->>'value' != 'on')
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi LEFT JOIN JSONB_ARRAY_ELEMENTS(gsi.settings->'databaseFlags') AS f ON f->>'name'='skip_show_database'
{% endmacro %}