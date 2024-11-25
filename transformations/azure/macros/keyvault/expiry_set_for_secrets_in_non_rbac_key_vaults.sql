{% macro keyvault_expiry_set_for_secrets_in_non_rbac_key_vaults(framework, check_id) %}
  {{ return(adapter.dispatch('keyvault_expiry_set_for_secrets_in_non_rbac_key_vaults')(framework, check_id)) }}
{% endmacro %}

{% macro default__keyvault_expiry_set_for_secrets_in_non_rbac_key_vaults(framework, check_id) %}{% endmacro %}

{% macro postgres__keyvault_expiry_set_for_secrets_in_non_rbac_key_vaults(framework, check_id) %}
SELECT 
       akvs.id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the Expiration Date is set for all Secrets in RBAC Key Vaults (Automated)' AS title,
       akv.subscription_id                                                 AS subscription_id,
       CASE
           WHEN (akvs.attributes ->>'enabled')::boolean = TRUE
            AND (akvs.attributes ->>'exp') IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                                 AS status
FROM azure_keyvault_keyvaults akv
    JOIN azure_keyvault_secrets akvs
      ON akv._cq_id = akvs._cq_parent_id
      WHERE (akvs.attributes ->> 'enableRBAC')::boolean IS NOT distinct from FALSE
{% endmacro %}

{% macro snowflake__keyvault_expiry_set_for_secrets_in_non_rbac_key_vaults(framework, check_id) %}
SELECT  
       akvs.id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the Expiration Date is set for all Secrets in RBAC Key Vaults (Automated)' AS title,
       akv.subscription_id                                                 AS subscription_id,
       CASE
           WHEN (akvs..attributes:enabled)::boolean = TRUE
            AND (akvs.attributes:exp) IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                                 AS status
FROM azure_keyvault_keyvaults akv
    JOIN azure_keyvault_secrets akvs
      ON akv._cq_id = akvs._cq_parent_id
      where akvs.enableRBAC::boolean = FALSE
{% endmacro %}

{% macro bigquery__keyvault_expiry_set_for_secrets_in_non_rbac_key_vaults(framework, check_id) %}
SELECT  
       akvs.id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the Expiration Date is set for all Secrets in RBAC Key Vaults (Automated)' AS title,
       akv.subscription_id                                                 AS subscription_id,
       CASE
           WHEN CAST( JSON_VALUE(akvs.attributes.enabled) AS BOOL) = TRUE
            AND JSON_VALUE(akvs.attributes.exp) IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                                 AS status
FROM {{ full_table_name("azure_keyvault_keyvaults") }} akv
    JOIN {{ full_table_name("azure_keyvault_secrets") }} akvs
      ON akv._cq_id = akvs._cq_parent_id
      where CAST( JSON_VALUE(akvs.attributes.enableRBAC) AS BOOL) = FALSE
{% endmacro %}