{% macro keyvault_secrets_without_expiration_date(framework, check_id) %}
  {{ return(adapter.dispatch('keyvault_secrets_without_expiration_date')(framework, check_id)) }}
{% endmacro %}

{% macro default__keyvault_secrets_without_expiration_date(framework, check_id) %}{% endmacro %}

{% macro postgres__keyvault_secrets_without_expiration_date(framework, check_id) %}
SELECT 
       akvs.id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the expiration date is set on all Secrets (Automated)' AS title,
       akv.subscription_id                                                 AS subscription_id,
       CASE
           WHEN (akvs.properties -> 'attributes'->>'enabled')::boolean = TRUE
            AND (akvs.properties -> 'attributes'->>'exp') IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                                 AS status
FROM azure_keyvault_keyvault akv
    JOIN azure_keyvault_keyvault_secrets akvs
      ON akv._cq_id = akvs._cq_parent_id
{% endmacro %}

{% macro snowflake__keyvault_secrets_without_expiration_date(framework, check_id) %}
SELECT  
       akvs.id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the expiration date is set on all Secrets (Automated)' AS title,
       akv.subscription_id                                                 AS subscription_id,
       CASE
           WHEN (akvs.properties:attributes:enabled)::boolean = TRUE
            AND (akvs.properties:attributes:exp) IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                                 AS status
FROM azure_keyvault_keyvault akv
    JOIN azure_keyvault_keyvault_secrets akvs
      ON akv._cq_id = akvs._cq_parent_id
{% endmacro %}