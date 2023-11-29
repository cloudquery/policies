{% macro sql_sqlserver_contained_database_authentication_flag_on(framework, check_id) %}
  {{ return(adapter.dispatch('sql_sqlserver_contained_database_authentication_flag_on')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_sqlserver_contained_database_authentication_flag_on(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_sqlserver_contained_database_authentication_flag_on(framework, check_id) %}
select
                gsi.name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the "contained database authentication" database flag for Cloud SQL on the SQL Server instance is set to "off" (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'SQLSERVER%'
                        AND (f->>'value' IS NULL
                        OR f->>'value' != 'off')
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi LEFT JOIN JSONB_ARRAY_ELEMENTS(gsi.settings->'databaseFlags') AS f ON f->>'name'='contained database authentication'
{% endmacro %}

{% macro snowflake__sql_sqlserver_contained_database_authentication_flag_on(framework, check_id) %}
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
                'Ensure that the "contained database authentication" database flag for Cloud SQL on the SQL Server instance is set to "off" (Automated)'  AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'SQLSERVER%'
                        AND (f.value:value IS NULL
                             OR f.value:value != 'off')
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi
    LEFT JOIN 
    instance_flags AS f ON f.value:name ='contained database authentication'
{% endmacro %}

{% macro bigquery__sql_sqlserver_contained_database_authentication_flag_on(framework, check_id) %}
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
                'Ensure that the "contained database authentication" database flag for Cloud SQL on the SQL Server instance is set to "off" (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'SQLSERVER%'
                        AND (f.value.value IS NULL
                        OR JSON_VALUE(f.value.value) != 'off')
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_sql_instances") }} gsi
    LEFT JOIN 
    instance_flags AS f ON JSON_VALUE(f.value.name) ='contained database authentication'
{% endmacro %}

