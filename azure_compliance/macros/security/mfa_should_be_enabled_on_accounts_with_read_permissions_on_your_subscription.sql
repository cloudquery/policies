{% macro security_mfa_should_be_enabled_on_accounts_with_read_permissions_on_your_subscription(framework, check_id) %}

SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'MFA should be enabled on accounts with owner permissions on your subscription' AS title,
       subscription_id                                                             AS subscription_id,
       id                                                                           AS resource_id,
       CASE
           WHEN properties->'status'->>'code' IS DISTINCT FROM 'NotApplicable'
               AND properties->'status'->>'code' IS DISTINCT FROM 'Healthy'
               THEN 'fail'
           ELSE 'pass'
           END                                                                         AS status
FROM azure_security_assessments
WHERE name = '151e82c5-5341-a74b-1eb0-bc38d2c84bb5'{% endmacro %}