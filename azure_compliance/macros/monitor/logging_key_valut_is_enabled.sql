{% macro monitor_logging_key_valut_is_enabled(framework, check_id) %}

WITH diagnosis_logs AS (
    SELECT
        amr._cq_sync_time,
        amds.subscription_id,
        amds.id || '/' || (coalesce(logs->>'category', logs->>'categoryGroup'))::text AS id,
        logs->>'category' IS DISTINCT FROM NULL AS hasCategory,
        (logs->'retentionPolicy'->>'days')::int >= 180 AS satisfyRetentionDays
    FROM azure_monitor_resources as amr
        LEFT JOIN azure_monitor_diagnostic_settings as amds ON amr._cq_id = amds._cq_parent_id,
        jsonb_array_elements(amds.properties->'logs') AS logs
    WHERE amr.type = 'Microsoft.KeyVault/vaults'
)
SELECT
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that logging for Azure Key Vault is ''Enabled''' AS title,
    subscription_id                                          AS subscription_id,
    id                                                       AS resource_id,
    CASE
        WHEN hasCategory AND satisfyRetentionDays
        THEN 'pass'
        ELSE 'fail'
    END                                                      AS status
FROM diagnosis_logs
{% endmacro %}