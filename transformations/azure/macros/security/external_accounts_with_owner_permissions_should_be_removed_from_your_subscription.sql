{% macro security_external_accounts_with_owner_permissions_should_be_removed_from_your_subscription(framework, check_id) %}

SELECT
       id                                                                                  AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'External accounts with owner permissions should be removed from your subscription' AS title,
       subscription_id                                                                     AS subscription_id,
       CASE
           WHEN a.properties->>'code' IS NULL
               THEN 'fail'
           ELSE 'pass'
           END                                                                             AS status
FROM azure_subscription_subscriptions s
         LEFT OUTER JOIN azure_security_assessments a
                         ON
                                     s.id = '/subscriptions/' || a.subscription_id
                                 AND a.name = 'c3b6ae71-f1f0-31b4-e6c1-d5951285d03d'
                                 AND (a.properties->>'code' IS NOT DISTINCT FROM 'NotApplicable'
                                 OR a.properties->>'code' IS NOT DISTINCT FROM 'Healthy'){% endmacro %}