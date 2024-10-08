{% macro sql_mysql_skip_show_database_flag_off(framework, check_id) %}
  {{ return(adapter.dispatch('sql_mysql_skip_show_database_flag_off')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_mysql_skip_show_database_flag_off(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_mysql_skip_show_database_flag_off(framework, check_id) %}
select
                gsi.name                                                                    AS resource_id,
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

{% macro snowflake__sql_mysql_skip_show_database_flag_off(framework, check_id) %}
 WITH 
    instance_flags as (
    select
        f.value as value             
    FROM gcp_sql_instances gsi,
    LATERAL FLATTEN(input => gsi.settings:databaseFlags) AS f
    )

select
                gsi.name                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "skip_show_database" database flag for Cloud SQL Mysql instance is set to "on" (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'MYSQL%'
                        AND (f.value:value IS NULL
                        OR f.value:value != 'on')
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_sql_instances gsi
    LEFT JOIN 
    instance_flags AS f ON f.value:name ='skip_show_database'
{% endmacro %}

{% macro bigquery__sql_mysql_skip_show_database_flag_off(framework, check_id) %}
 WITH 
    instance_flags as (
    select
        f as value             
    FROM {{ full_table_name("gcp_sql_instances") }} gsi,
    UNNEST(JSON_QUERY_ARRAY(settings.databaseFlags)) AS f
    )

select
                gsi.name                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "skip_show_database" database flag for Cloud SQL Mysql instance is set to "on" (Automated)' AS title,
                gsi.project_id                                                                AS project_id,
                CASE
                WHEN
                            gsi.database_version LIKE 'MYSQL%'
                        AND (f.value.value IS NULL
                        OR JSON_VALUE(f.value.value) != 'on')
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_sql_instances") }} gsi
    LEFT JOIN 
    instance_flags AS f ON JSON_VALUE(f.value.name) ='skip_show_database'
{% endmacro %}