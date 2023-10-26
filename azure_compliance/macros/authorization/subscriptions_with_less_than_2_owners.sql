{% macro authorization_subscriptions_with_less_than_2_owners(framework, check_id) %}
WITH owners_in_sub AS (SELECT a.subscription_id, COUNT(*) AS owners, d.id as id
                       FROM azure_authorization_role_assignments a
                                JOIN azure_authorization_role_definitions d ON a.properties ->> 'roleDefinitionId' = d.id
                       WHERE a.properties ->> 'roleName' = 'Owner'
                         AND a.properties ->> 'roleType' = 'BuiltInRole' -- todo check if it checks only role or permissions list as well
                       GROUP BY d.id, a.subscription_id)


SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'There should be more than one owner assigned to your subscription' AS title,
       subscription_id                                                    AS subscription_id,
       id                                                                 AS resource_id,
       CASE
           WHEN owners > 1
               THEN 'fail'
           ELSE 'pass'
           END                                                            AS status
FROM owners_in_sub{% endmacro %}