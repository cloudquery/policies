{% macro monitor_no_diagnostic_setting(framework, check_id) %}
  {{ return(adapter.dispatch('monitor_no_diagnostic_setting')(framework, check_id)) }}
{% endmacro %}

{% macro default__monitor_no_diagnostic_setting(framework, check_id) %}{% endmacro %}

{% macro postgres__monitor_no_diagnostic_setting(framework, check_id) %}
SELECT 
    amr.id                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that a ''Diagnostics Setting'' exists' AS title,
    amr.subscription_id                            AS subscription_id,
    CASE
        WHEN amds.properties IS NULL
        THEN 'fail'
        ELSE 'pass'
    END                                            AS status
FROM
    azure_monitor_resources AS amr
    LEFT JOIN azure_monitor_diagnostic_settings AS amds
        ON amr._cq_id = amds._cq_parent_id
{% endmacro %}

{% macro snowflake__monitor_no_diagnostic_setting(framework, check_id) %}
SELECT 
    amr.id                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that a ''Diagnostics Setting'' exists' AS title,
    amr.subscription_id                            AS subscription_id,
    CASE
        WHEN amds.properties IS NULL
        THEN 'fail'
        ELSE 'pass'
    END                                            AS status
FROM
    azure_monitor_resources AS amr
    LEFT JOIN azure_monitor_diagnostic_settings AS amds
        ON amr._cq_id = amds._cq_parent_id
{% endmacro %}

{% macro bigquery__monitor_no_diagnostic_setting(framework, check_id) %}
SELECT 
    amr.id                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that a "Diagnostics Setting" exists' AS title,
    amr.subscription_id                            AS subscription_id,
    CASE
        WHEN amds.properties IS NULL
        THEN 'fail'
        ELSE 'pass'
    END                                            AS status
FROM
    {{ full_table_name("azure_monitor_resources") }} AS amr
    LEFT JOIN {{ full_table_name("azure_monitor_diagnostic_settings") }} AS amds
        ON amr._cq_id = amds._cq_parent_id
{% endmacro %}