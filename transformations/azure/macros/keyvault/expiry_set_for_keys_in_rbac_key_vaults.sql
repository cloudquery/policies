{% macro keyvault_expiry_set_for_keys_in_rbac_key_vaults(framework, check_id) %}
  {{ return(adapter.dispatch('keyvault_expiry_set_for_keys_in_rbac_key_vaults')(framework, check_id)) }}
{% endmacro %}

{% macro default__keyvault_expiry_set_for_keys_in_rbac_key_vaults(framework, check_id) %}{% endmacro %}

{% macro postgres__keyvault_expiry_set_for_keys_in_rbac_key_vaults(framework, check_id) %}
SELECT 
       akvk.kid                                                          AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the Expiration Date is set for all Keys in RBAC Key Vaults (Automated)' AS title,
       akv.subscription_id                                              AS subscription_id,
       CASE
           WHEN (akv.properties -> 'attributes'->>'enabled')::boolean = TRUE
            AND (akv.properties -> 'attributes'->>'exp') IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                              AS status
FROM azure_keyvault_keyvaults akv
    JOIN azure_keyvault_keys akvk
      ON akv._cq_id = akvk._cq_parent_id
    WHERE (akv.properties ->> 'enableRbacAuthorization')::boolean IS NOT distinct from TRUE
{% endmacro %}

{% macro snowflake__keyvault_expiry_set_for_keys_in_rbac_key_vaults(framework, check_id) %}
SELECT        
        akvk.kid                                                          AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the Expiration Date is set for all Keys in RBAC Key Vaults (Automated)' AS title,
       akv.subscription_id                                              AS subscription_id,
       CASE
           WHEN (akv.properties:attributes:enabled)::boolean = TRUE
            AND (akv.properties:attributes:exp) IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                              AS status
FROM azure_keyvault_keyvaults akv
    JOIN azure_keyvault_keys akvk
      ON akv._cq_id = akvk._cq_parent_id
      where akv.properties:enableRbacAuthorization::boolean = TRUE
{% endmacro %}

{% macro bigquery__keyvault_expiry_set_for_keys_in_rbac_key_vaults(framework, check_id) %}
SELECT        
        akvk.kid                                                          AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the Expiration Date is set for all Keys in RBAC Key Vaults (Automated)' AS title,
       akv.subscription_id                                              AS subscription_id,
       CASE
           WHEN CAST( JSON_VALUE(akv.properties.attributes.enabled) AS BOOL) = TRUE
            AND JSON_VALUE(akv.properties.attributes.exp) IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                              AS status
FROM {{ full_table_name("azure_keyvault_keyvaults") }}  akv
    JOIN {{ full_table_name("azure_keyvault_keys") }} akvk
      ON akv._cq_id = akvk._cq_parent_id
      where CAST( JSON_VALUE(akv.properties.enableRbacAuthorization) AS BOOL) = TRUE
{% endmacro %}