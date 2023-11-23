{% macro storage_encrypt_with_cmk_for_activity_log(framework, check_id) %}
  {{ return(adapter.dispatch('storage_encrypt_with_cmk_for_activity_log')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_encrypt_with_cmk_for_activity_log(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_encrypt_with_cmk_for_activity_log(framework, check_id) %}
SELECT
    asa._cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure the storage account containing the container with activity logs is encrypted with BYOK (Use Your Own Key)' AS title,
    asa.subscription_id                                                                                                AS subscription_id,
    asa.id                                                                                                             AS resource_id,
    CASE
        WHEN asa.properties->'encryption'->>'keySource' = 'Microsoft.Keyvault'
         AND asa.properties->'encryption'->'keyvaultproperties' IS DISTINCT FROM NULL
        THEN 'pass'
        ELSE 'fail'
    END                                                                                                                AS status
FROM azure_storage_accounts asa
    JOIN azure_monitor_diagnostic_settings amds
        ON asa.id = amds.properties->>'storageAccountId'
WHERE amds.properties->>'storageAccountId' IS NOT NULL
{% endmacro %}

{% macro snowflake__storage_encrypt_with_cmk_for_activity_log(framework, check_id) %}
SELECT
    asa._cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure the storage account containing the container with activity logs is encrypted with BYOK (Use Your Own Key)' AS title,
    asa.subscription_id                                                                                                AS subscription_id,
    asa.id                                                                                                             AS resource_id,
    CASE
        WHEN asa.properties:encryption:keySource = 'Microsoft.Keyvault'
         AND asa.properties:encryption:keyvaultproperties IS DISTINCT FROM NULL
        THEN 'pass'
        ELSE 'fail'
    END                                                                                                                AS status
FROM azure_storage_accounts asa
    JOIN azure_monitor_diagnostic_settings amds
        ON asa.id = amds.properties:storageAccountId
WHERE amds.properties:storageAccountId IS NOT NULL
{% endmacro %}