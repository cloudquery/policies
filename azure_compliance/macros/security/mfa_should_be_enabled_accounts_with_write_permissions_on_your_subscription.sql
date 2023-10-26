{% macro security_mfa_should_be_enabled_accounts_with_write_permissions_on_your_subscription(framework, check_id) %}

SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'MFA should be enabled on accounts with write permissions on your subscription' AS title,
       subscription_id                                                             AS subscription_id,
       id                                                                           AS resource_id,
       CASE
           WHEN properties->'status'->>'code' IS DISTINCT FROM 'NotApplicable'
               AND properties->'status'->>'code' IS DISTINCT FROM 'Healthy'
               THEN 'fail'
           ELSE 'pass'
           END                                                                         AS status
FROM azure_security_assessments
WHERE name = '57e98606-6b1e-6193-0e3d-fe621387c16b'{% endmacro %}