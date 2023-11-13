{% macro monitor_insufficient_diagnostic_capturing_settings(framework, check_id) %}

WITH diagnostic_settings AS (
    SELECT
        _cq_sync_time,
        subscription_id,
        id,
        (logs->>'enabled')::boolean AS enabled,
        logs->>'category' AS category
    FROM
        azure_monitor_subscription_diagnostic_settings a,
        jsonb_array_elements(properties->'logs') AS logs
),
required_settings AS (
    SELECT *
    FROM diagnostic_settings
    WHERE category IN ('Administrative', 'Alert', 'Policy', 'Security')
)
SELECT
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure Diagnostic Setting captures appropriate categories' AS title,
    subscription_id                                             AS subscription_id,
    id                                                          AS resource_id,
    CASE
        WHEN COUNT(id) = 4
        THEN 'pass'
        ELSE 'fail'
    END                                                         AS status
FROM required_settings
WHERE enabled
GROUP BY _cq_sync_time, subscription_id, id
{% endmacro %}