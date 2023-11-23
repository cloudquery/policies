{% macro sql_sqlserver_user_connections_flag_not_set(framework, check_id) %}
  {{ return(adapter.dispatch('sql_sqlserver_user_connections_flag_not_set')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_sqlserver_user_connections_flag_not_set(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_sqlserver_user_connections_flag_not_set(framework, check_id) %}
select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
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

{% macro snowflake__sql_sqlserver_user_connections_flag_not_set(framework, check_id) %}
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
                'Ensure "user connections" database flag for Cloud SQL SQL Server instance is set as appropriate (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'SQLSERVER%'
                        AND f.value:value IS NULL
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi
    LEFT JOIN 
    instance_flags AS f ON f.value:name ='user connections'
{% endmacro %}

{% macro bigquery__sql_sqlserver_user_connections_flag_not_set(framework, check_id) %}
WITH 
    instance_flags as (
    select
        f as value
    FROM {{ full_table_name("gcp_sql_instances") }} gsi,
    UNNEST(JSON_QUERY_ARRAY(settings.databaseFlags)) AS f
    )

select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "user connections" database flag for Cloud SQL SQL Server instance is set as appropriate (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'SQLSERVER%'
                        AND f.value.value IS NULL
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_sql_instances") }} gsi
    LEFT JOIN 
    instance_flags AS f ON JSON_VALUE(f.value.name) ='user connections'
{% endmacro %}