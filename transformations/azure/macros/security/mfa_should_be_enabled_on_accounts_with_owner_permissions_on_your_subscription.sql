{% macro security_mfa_should_be_enabled_on_accounts_with_owner_permissions_on_your_subscription(framework, check_id) %}

SELECT
       id                                                                           AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'MFA should be enabled on accounts with owner permissions on your subscription' AS title,
       subscription_id                                                             AS subscription_id,
       CASE
           WHEN properties->'status'->>'code' IS DISTINCT FROM 'NotApplicable'
               AND properties->'status'->>'code' IS DISTINCT FROM 'Healthy'
               THEN 'fail'
           ELSE 'pass'
           END                                                                         AS status
FROM azure_security_assessments
WHERE name = '94290b00-4d0c-d7b4-7cea-064a9554e681'
{% endmacro %}