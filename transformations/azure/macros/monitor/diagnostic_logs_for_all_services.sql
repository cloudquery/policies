{% macro monitor_diagnostic_logs_for_all_services(framework, check_id) %}
  {{ return(adapter.dispatch('monitor_diagnostic_logs_for_all_services')(framework, check_id)) }}
{% endmacro %}

{% macro default__monitor_diagnostic_logs_for_all_services(framework, check_id) %}{% endmacro %}

{% macro postgres__monitor_diagnostic_logs_for_all_services(framework, check_id) %}
SELECT
    amr.id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Diagnostic Logs are enabled for all services which support it.' AS title,
    amr.subscription_id                                                          AS subscription_id,
    CASE
        WHEN amds.id IS DISTINCT FROM NULL
        THEN 'pass'
        ELSE 'fail'
    END                                                                          AS status
FROM azure_monitor_resources AS amr
    LEFT JOIN azure_monitor_diagnostic_settings AS amds
        ON amr._cq_id = amds._cq_parent_id
{% endmacro %}

{% macro snowflake__monitor_diagnostic_logs_for_all_services(framework, check_id) %}
SELECT
    amr.id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Diagnostic Logs are enabled for all services which support it.' AS title,
    amr.subscription_id                                                          AS subscription_id,
    CASE
        WHEN amds.id IS DISTINCT FROM NULL
        THEN 'pass'
        ELSE 'fail'
    END                                                                          AS status
FROM azure_monitor_resources AS amr
    LEFT JOIN azure_monitor_diagnostic_settings AS amds
        ON amr._cq_id = amds._cq_parent_id
{% endmacro %}

{% macro bigquery__monitor_diagnostic_logs_for_all_services(framework, check_id) %}
SELECT
    amr.id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Diagnostic Logs are enabled for all services which support it.' AS title,
    amr.subscription_id                                                          AS subscription_id,
    CASE
        WHEN amds.id IS DISTINCT FROM NULL
        THEN 'pass'
        ELSE 'fail'
    END                                                                          AS status
FROM {{ full_table_name("azure_monitor_resources") }} AS amr
    LEFT JOIN {{ full_table_name("azure_monitor_diagnostic_settings") }} AS amds
        ON amr._cq_id = amds._cq_parent_id
{% endmacro %}