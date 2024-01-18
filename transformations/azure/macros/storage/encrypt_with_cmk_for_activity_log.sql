{% macro storage_encrypt_with_cmk_for_activity_log(framework, check_id) %}
  {{ return(adapter.dispatch('storage_encrypt_with_cmk_for_activity_log')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_encrypt_with_cmk_for_activity_log(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_encrypt_with_cmk_for_activity_log(framework, check_id) %}
SELECT
    asa.id                                                                                                             AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure the storage account containing the container with activity logs is encrypted with BYOK (Use Your Own Key)' AS title,
    asa.subscription_id                                                                                                AS subscription_id,
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
    asa.id                                                                                                             AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure the storage account containing the container with activity logs is encrypted with BYOK (Use Your Own Key)' AS title,
    asa.subscription_id                                                                                                AS subscription_id,
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

{% macro bigquery__storage_encrypt_with_cmk_for_activity_log(framework, check_id) %}
SELECT
    asa.id                                                                                                             AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure the storage account containing the container with activity logs is encrypted with BYOK (Use Your Own Key)' AS title,
    asa.subscription_id                                                                                                AS subscription_id,
    CASE
        WHEN JSON_VALUE(asa.properties.encryption.keySource) = 'Microsoft.Keyvault'
         AND JSON_VALUE(asa.properties.encryption.keyvaultproperties) IS DISTINCT FROM NULL
        THEN 'pass'
        ELSE 'fail'
    END                                                                                                                AS status
FROM {{ full_table_name("azure_storage_accounts") }} asa
    JOIN {{ full_table_name("azure_monitor_diagnostic_settings") }} amds
        ON asa.id = JSON_VALUE(amds.properties.storageAccountId)
WHERE JSON_VALUE(amds.properties.storageAccountId) IS NOT NULL
{% endmacro %}