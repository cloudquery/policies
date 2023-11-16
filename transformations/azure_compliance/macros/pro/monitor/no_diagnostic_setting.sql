{% macro monitor_no_diagnostic_setting(framework, check_id) %}

SELECT 
    amr._cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that a ''Diagnostics Setting'' exists' AS title,
    amr.subscription_id                            AS subscription_id,
    amr.id                                         AS resource_id,
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