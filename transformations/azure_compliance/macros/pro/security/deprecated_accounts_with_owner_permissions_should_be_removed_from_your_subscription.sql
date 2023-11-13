{% macro security_deprecated_accounts_with_owner_permissions_should_be_removed_from_your_subscription(framework, check_id) %}

SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Deprecated accounts with owner permissions should be removed from your subscription' AS title,
       subscription_id                                                                       AS subscription_id,
       id                                                                                    AS resource_id,
       CASE
           WHEN a.code IS NULL
               THEN 'fail'
           ELSE 'pass'
           END                                                                               AS status
FROM azure_subscription_subscriptions s
         LEFT OUTER JOIN azure_security_assessments a
                         ON
                                     s.id = '/subscriptions/' || a.subscription_id
                                 AND a.name = 'e52064aa-6853-e252-a11e-dffc675689c2'
                                 AND (a.code IS NOT DISTINCT FROM 'NotApplicable'
                                 OR a.code IS NOT DISTINCT FROM 'Healthy'){% endmacro %}