{% macro authorization_custom_roles(framework, check_id) %}

SELECT 
       mc.id                                                                               AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'External accounts with owner permissions should be removed from your subscription' AS title,
       mc.subscription_id                                                                  AS subscription_id,
       CASE
           WHEN (properties ->> 'enableRBAC')::boolean IS distinct from TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                             AS status
FROM azure_containerservice_managed_clusters AS mc
         INNER JOIN azure_subscription_subscriptions AS sub ON sub.id = mc.subscription_id
{% endmacro %}