{% macro sql_db_instance_with_public_ip(framework, check_id) %}
  {{ return(adapter.dispatch('sql_db_instance_with_public_ip')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_db_instance_with_public_ip(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_db_instance_with_public_ip(framework, check_id) %}
select DISTINCT
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
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

{% macro snowflake__sql_db_instance_with_public_ip(framework, check_id) %}
select DISTINCT
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud SQL database instances do not have public IPs (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                    WHEN
                                    gsi.database_version LIKE 'SQLSERVER%'
                                AND gsiia.value:type = 'PRIMARY' OR gsi.backend_type != 'SECOND_GEN'
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_sql_instances gsi,
    LATERAL FLATTEN(input => gsi.ip_addresses) AS gsiia
{% endmacro %}

{% macro bigquery__sql_db_instance_with_public_ip(framework, check_id) %}
select DISTINCT
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud SQL database instances do not have public IPs (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                    WHEN
                                    gsi.database_version LIKE 'SQLSERVER%'
                                AND JSON_VALUE(gsiia.type) = 'PRIMARY' OR gsi.backend_type != 'SECOND_GEN'
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM {{ full_table_name("gcp_sql_instances") }} gsi,
    UNNEST(JSON_QUERY_ARRAY(ip_addresses)) AS gsiia
{% endmacro %}