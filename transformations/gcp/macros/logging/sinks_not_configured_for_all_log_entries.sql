{% macro logging_sinks_not_configured_for_all_log_entries(framework, check_id) %}
  {{ return(adapter.dispatch('logging_sinks_not_configured_for_all_log_entries')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_sinks_not_configured_for_all_log_entries(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_sinks_not_configured_for_all_log_entries(framework, check_id) %}
WITH found_sinks AS (
    SELECT _cq_sync_time, project_id, name, count(*) AS configured_sinks
                     FROM gcp_logging_sinks gls
                     WHERE gls.FILTER = ''
                     GROUP BY _cq_sync_time, project_id, name
)
select DISTINCT 
                "name"                                                                    AS resource_id,
                _cq_sync_time As sync_time, 
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that sinks are configured for all log entries (Automated)' AS title,
                "project_id"                                                                AS project_id,
                CASE
                WHEN
                    configured_sinks = 0
                    THEN 'fail'
                ELSE 'pass'
                END AS status 
    FROM found_sinks
{% endmacro %}

{% macro snowflake__logging_sinks_not_configured_for_all_log_entries(framework, check_id) %}
WITH found_sinks AS (
    SELECT _cq_sync_time, project_id, name, count(*) AS configured_sinks
                     FROM gcp_logging_sinks gls
                     WHERE gls.FILTER = ''
                     GROUP BY _cq_sync_time, project_id, name
)
select DISTINCT 
                name                                                                    AS resource_id,
                _cq_sync_time As sync_time, 
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that sinks are configured for all log entries (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    configured_sinks = 0
                    THEN 'fail'
                ELSE 'pass'
                END AS status 
    FROM found_sinks
{% endmacro %}

{% macro bigquery__logging_sinks_not_configured_for_all_log_entries(framework, check_id) %}
WITH found_sinks AS (
    SELECT _cq_sync_time, project_id, name, count(*) AS configured_sinks
                     FROM {{ full_table_name("gcp_logging_sinks") }} gls
                     WHERE gls.FILTER = ''
                     GROUP BY _cq_sync_time, project_id, name
)
select DISTINCT 
                name                                                                    AS resource_id,
                _cq_sync_time As sync_time, 
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that sinks are configured for all log entries (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    configured_sinks = 0
                    THEN 'fail'
                ELSE 'pass'
                END AS status 
    FROM found_sinks
{% endmacro %}
