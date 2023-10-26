{% macro storage_default_network_access_rule_is_deny(framework, check_id) %}

SELECT
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure default network access rule for Storage Accounts is set to deny' AS title,
    subscription_id                                                          AS subscription_id,
    id                                                                       AS resource_id,
    CASE
        WHEN properties->'networkAcls'->>'defaultAction' = 'Allow'
        THEN 'fail'
        ELSE 'pass'
    END                                                                      AS status
FROM azure_storage_accounts
{% endmacro %}