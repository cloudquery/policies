{% macro storage_encrypt_with_cmk(framework, check_id) %}

SELECT
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure storage for critical data are encrypted with Customer Managed Key' AS title,
    subscription_id                                                            AS subscription_id,
    id                                                                         AS resource_id,
    CASE
        WHEN properties->'encryption'->>'keySource' = 'Microsoft.Keyvault'
         AND properties->'encryption'->'keyvaultproperties' IS DISTINCT FROM NULL
        THEN 'pass'
        ELSE 'fail'
    END                                                                        AS status
FROM azure_storage_accounts
{% endmacro %}