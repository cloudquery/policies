{% macro logging_sinks_not_configured_for_all_log_entries(framework, check_id) %}
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
    FROM {{ ref('found_sinks') }}
{% endmacro %}