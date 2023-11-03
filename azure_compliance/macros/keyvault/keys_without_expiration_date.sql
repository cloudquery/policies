{% macro keyvault_keys_without_expiration_date(framework, check_id) %}

SELECT akv._cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the expiration date is set on all keys (Automated)' AS title,
       akv.subscription_id                                              AS subscription_id,
       akvk.id                                                          AS resource_id,
       CASE
           WHEN (akvk.properties -> 'attributes'->>'enabled')::boolean = TRUE
            AND (akvk.properties -> 'attributes'->>'exp') IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                              AS status
FROM azure_keyvault_keyvault akv
    JOIN azure_keyvault_keyvault_keys akvk
      ON akv._cq_id = akvk._cq_parent_id
{% endmacro %}